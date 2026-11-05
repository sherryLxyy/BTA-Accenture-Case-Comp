/* ============================================================
   WS3 - Decision Support
   Client relationship analytics feeding the four-client recommendation.

   Requirement (Case Brief, p.4):
     Analyse IFC's client relationships and surface the clients that
     stand out, positively AND negatively, with the evidence behind
     each. Then recommend two clients to continue investing in and
     two whose exposure should be reduced or placed under review,
     quantifying the exposure affected by each recommendation,
     including undisbursed commitments.

   Design notes
   - One row per client. client_id is the only safe grouping key:
     project_number has 1,126 duplicated values across unrelated
     projects and must not be used.
   - Undisbursed commitment = approved minus disbursed. Pending
     projects have no disbursed amount, so they carry the full
     approved amount as an open commitment. That is deliberate:
     money promised but not yet paid out is exposure.
   - Scores are percentile ranks, not hand-picked thresholds. A
     reader can see where a client sits relative to the whole book
     without knowing the distribution in advance.
   ============================================================ */


/* ------------------------------------------------------------
   Step 1. Build the client-level table.
   Everything downstream reads this, so the definition lives in one
   place and can be audited.
   ------------------------------------------------------------ */
CREATE OR REPLACE TABLE ifc.analytics.client_portfolio AS
SELECT
  client_id,
  MAX(client_name)                                                        AS client_name,

  -- size
  COUNT(*)                                                                AS project_count,
  ROUND(SUM(total_approved_usd_mm), 2)                                    AS approved_usd_mm,
  ROUND(SUM(COALESCE(disbursed_usd_mm, 0)), 2)                            AS disbursed_usd_mm,
  ROUND(SUM(total_approved_usd_mm)
        - SUM(COALESCE(disbursed_usd_mm, 0)), 2)                          AS undisbursed_usd_mm,
  ROUND(100.0 * SUM(COALESCE(disbursed_usd_mm, 0))
        / NULLIF(SUM(total_approved_usd_mm), 0), 1)                       AS disbursed_pct,

  -- lifecycle
  SUM(CASE WHEN status = 'Active'  THEN 1 ELSE 0 END)                     AS active_projects,
  SUM(CASE WHEN status = 'Closed'  THEN 1 ELSE 0 END)                     AS closed_projects,
  SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END)                     AS pending_projects,
  SUM(CASE WHEN status = 'Dropped' THEN 1 ELSE 0 END)                     AS dropped_projects,
  MIN(approval_year)                                                      AS first_approval_year,
  MAX(approval_year)                                                      AS last_approval_year,

  -- performance
  SUM(CASE WHEN performance_status = 'Performing'       THEN 1 ELSE 0 END) AS performing_projects,
  SUM(CASE WHEN performance_status = 'Completed'        THEN 1 ELSE 0 END) AS completed_projects,
  SUM(CASE WHEN performance_status = 'Watchlist'        THEN 1 ELSE 0 END) AS watchlist_projects,
  SUM(CASE WHEN performance_status = 'Past Due'         THEN 1 ELSE 0 END) AS past_due_projects,
  SUM(CASE WHEN performance_status = 'Exited at a loss' THEN 1 ELSE 0 END) AS exited_at_loss_projects,
  ROUND(SUM(CASE WHEN performance_status = 'Past Due'
                 THEN COALESCE(disbursed_usd_mm, 0) ELSE 0 END), 2)       AS past_due_disbursed_usd_mm,
  ROUND(0.6 * SUM(CASE WHEN performance_status = 'Past Due'
                       THEN COALESCE(disbursed_usd_mm, 0) ELSE 0 END), 2) AS ecl_usd_mm,

  -- risk and breadth
  ROUND(AVG(internal_risk_rating), 2)                                     AS avg_risk_rating,
  MAX(internal_risk_rating)                                               AS worst_risk_rating,
  COUNT(DISTINCT region)                                                  AS region_count,
  COUNT(DISTINCT industry)                                                AS industry_count,
  COUNT(DISTINCT product_line)                                            AS product_count,
  ROUND(AVG(days_since_review), 0)                                        AS avg_days_since_review
FROM ifc.curated.portfolio
GROUP BY client_id;


/* ------------------------------------------------------------
   Step 2. The book at a glance. Sanity check before ranking:
   399 clients expected, and the totals must equal the portfolio.
   ------------------------------------------------------------ */
SELECT
  COUNT(*)                                  AS clients,
  SUM(project_count)                        AS projects,
  ROUND(SUM(approved_usd_mm), 2)            AS approved_usd_mm,
  ROUND(SUM(disbursed_usd_mm), 2)           AS disbursed_usd_mm,
  ROUND(SUM(undisbursed_usd_mm), 2)         AS undisbursed_usd_mm,
  ROUND(SUM(ecl_usd_mm), 2)                 AS ecl_usd_mm,
  SUM(past_due_projects)                    AS clients_with_past_due
FROM ifc.analytics.client_portfolio;


/* ------------------------------------------------------------
   Step 3. NEGATIVE screen. Which clients warrant attention?

   Five drivers, each converted to a percentile so no single raw
   magnitude dominates:
     ecl              0.30  actual expected loss already accrued
     impaired_share   0.25  share of the client's book on Watchlist
                            or Past Due, so size alone cannot carry a
                            client into this list
     worst_risk       0.20  supervisor rating, 6 is highest risk
     undisbursed      0.15  committed but undeployed capital, the
                            exposure the Board asked to see in full
     dropped_share    0.10  delivery record
   ------------------------------------------------------------ */
WITH scored AS (
  SELECT
    c.*,
    ROUND(100.0 * (past_due_projects + watchlist_projects)
          / GREATEST(project_count, 1), 1)                    AS impaired_pct,
    ROUND(100.0 * dropped_projects
          / GREATEST(project_count, 1), 1)                    AS dropped_pct,
    PERCENT_RANK() OVER (ORDER BY ecl_usd_mm)                 AS pr_ecl,
    PERCENT_RANK() OVER (ORDER BY (past_due_projects + watchlist_projects) * 1.0
                                / GREATEST(project_count, 1)) AS pr_impaired,
    PERCENT_RANK() OVER (ORDER BY worst_risk_rating)          AS pr_risk,
    PERCENT_RANK() OVER (ORDER BY undisbursed_usd_mm)         AS pr_undisbursed,
    PERCENT_RANK() OVER (ORDER BY dropped_projects * 1.0
                                / GREATEST(project_count, 1)) AS pr_dropped
  FROM ifc.analytics.client_portfolio c
  WHERE project_count >= 2 AND approved_usd_mm > 0
)
SELECT
  client_id,
  client_name,
  project_count,
  approved_usd_mm,
  disbursed_usd_mm,
  undisbursed_usd_mm,
  ecl_usd_mm,
  past_due_projects,
  watchlist_projects,
  impaired_pct,
  worst_risk_rating,
  dropped_pct,
  ROUND(100 * (0.30 * pr_ecl
             + 0.25 * pr_impaired
             + 0.20 * pr_risk
             + 0.15 * pr_undisbursed
             + 0.10 * pr_dropped), 1)                         AS attention_score
FROM scored
ORDER BY attention_score DESC, ecl_usd_mm DESC
LIMIT 20;


/* ------------------------------------------------------------
   Step 4. POSITIVE screen. Which clients deserve more capital?

   A client is a good place to add capital when the evidence says
   the relationship is working, not when it is merely large:
     clean record       0.35  no Past Due, no loss exits, no drops
     deployment         0.25  disbursed share, money is being used
     low risk           0.20  worst rating, inverted
     relationship depth 0.20  project count and years as a client
   ------------------------------------------------------------ */
WITH scored AS (
  SELECT
    c.*,
    PERCENT_RANK() OVER (
      ORDER BY (past_due_projects + exited_at_loss_projects + dropped_projects) * 1.0
             / GREATEST(project_count, 1) DESC)                   AS pr_clean,
    PERCENT_RANK() OVER (ORDER BY COALESCE(disbursed_usd_mm, 0)
                               / NULLIF(approved_usd_mm, 0))       AS pr_deployment,
    PERCENT_RANK() OVER (ORDER BY worst_risk_rating DESC)          AS pr_lowrisk,
    PERCENT_RANK() OVER (ORDER BY project_count, last_approval_year) AS pr_depth
  FROM ifc.analytics.client_portfolio c
  WHERE project_count >= 3
    AND approved_usd_mm >= 100
    AND past_due_projects = 0
)
SELECT
  client_id,
  client_name,
  project_count,
  approved_usd_mm,
  disbursed_usd_mm,
  undisbursed_usd_mm,
  disbursed_pct,
  performing_projects,
  completed_projects,
  worst_risk_rating,
  first_approval_year,
  last_approval_year,
  region_count,
  industry_count,
  ROUND(100 * (0.35 * pr_clean
             + 0.25 * pr_deployment
             + 0.20 * pr_lowrisk
             + 0.20 * pr_depth), 1)                            AS growth_score
FROM scored
ORDER BY growth_score DESC, approved_usd_mm DESC
LIMIT 20;


/* ------------------------------------------------------------
   Step 5. Evidence pack. Replace the client_id literal with each
   shortlisted client to produce the audit trail behind the
   recommendation: every project that contributes to the verdict.
   ------------------------------------------------------------ */
SELECT
  client_id,
  client_name,
  project_name,
  country,
  region,
  industry,
  status,
  performance_status,
  internal_risk_rating,
  total_approved_usd_mm,
  disbursed_usd_mm,
  COALESCE(disbursed_usd_mm, 0) * -1 + total_approved_usd_mm AS undisbursed_usd_mm,
  approval_year,
  days_since_review
FROM ifc.curated.portfolio
WHERE client_id = 'REPLACE_WITH_CLIENT_ID'
ORDER BY total_approved_usd_mm DESC;
