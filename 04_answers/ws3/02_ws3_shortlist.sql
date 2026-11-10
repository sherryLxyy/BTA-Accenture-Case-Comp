/* ============================================================
   WS3 - Shortlist for the four-client recommendation

   Why this file exists
   The first ranking pass ranked on quality alone. Quality scores
   reward small, tidy relationships: a client with three fully
   disbursed projects outranks a client with USD 15 billion committed
   across a hundred. That is the right ranking for a risk officer
   reviewing every relationship, and the wrong ranking for a Board
   recommendation, where every name has to be material.

   So the order of operations is:
     1. score every client on quality (percentile ranks, no thresholds)
     2. apply a materiality floor
     3. rank the survivors

   The floor is USD 5,000 million approved, about 2.7x the book average
   of USD 1,856 million, and covers roughly the top decile of clients.
   Block A shows the distribution so the choice of floor is auditable
   rather than asserted.
   ============================================================ */


/* ------------------------------------------------------------
   Step 1. Persist the scored client table.

   Scores are computed on the FULL book, before any materiality
   filter. Filtering first would rescale every percentile and make
   the number move whenever the floor changes.
   ------------------------------------------------------------ */
CREATE OR REPLACE TABLE ifc.analytics.client_score AS
WITH scored AS (
  SELECT
    c.*,
    ROUND(100.0 * (past_due_projects + watchlist_projects)
          / GREATEST(project_count, 1), 1)                          AS impaired_pct,
    ROUND(100.0 * dropped_projects
          / GREATEST(project_count, 1), 1)                          AS dropped_pct,
    ROUND(100.0 * (past_due_projects + watchlist_projects
                   + exited_at_loss_projects)
          / GREATEST(project_count, 1), 1)                          AS adverse_pct,

    -- attention drivers, higher = worse
    PERCENT_RANK() OVER (ORDER BY ecl_usd_mm)                       AS pr_ecl,
    PERCENT_RANK() OVER (ORDER BY (past_due_projects + watchlist_projects) * 1.0
                                / GREATEST(project_count, 1))       AS pr_impaired,
    PERCENT_RANK() OVER (ORDER BY worst_risk_rating)                AS pr_risk,
    PERCENT_RANK() OVER (ORDER BY undisbursed_usd_mm)               AS pr_undisbursed,
    PERCENT_RANK() OVER (ORDER BY dropped_projects * 1.0
                                / GREATEST(project_count, 1))       AS pr_dropped,

    -- growth drivers, higher = better
    PERCENT_RANK() OVER (ORDER BY (past_due_projects + exited_at_loss_projects
                                   + dropped_projects) * 1.0
                                / GREATEST(project_count, 1) DESC)  AS pr_clean,
    PERCENT_RANK() OVER (ORDER BY disbursed_usd_mm
                                / NULLIF(approved_usd_mm, 0))       AS pr_deployment,
    PERCENT_RANK() OVER (ORDER BY worst_risk_rating DESC)           AS pr_lowrisk,
    PERCENT_RANK() OVER (ORDER BY project_count, last_approval_year) AS pr_depth,

    -- context only, not part of either score
    PERCENT_RANK() OVER (ORDER BY approved_usd_mm)                  AS pr_size
  FROM ifc.analytics.client_portfolio c
  WHERE approved_usd_mm > 0
)
SELECT
  *,
  ROUND(100 * (0.30 * pr_ecl
             + 0.25 * pr_impaired
             + 0.20 * pr_risk
             + 0.15 * pr_undisbursed
             + 0.10 * pr_dropped), 1)                               AS attention_score,
  ROUND(100 * (0.35 * pr_clean
             + 0.25 * pr_deployment
             + 0.20 * pr_lowrisk
             + 0.20 * pr_depth), 1)                                 AS growth_score
FROM scored;


/* ------------------------------------------------------------
   Step 2. Materiality distribution. Justifies the USD 5,000 million
   floor instead of picking one by feel.
   ------------------------------------------------------------ */
SELECT
  COUNT(*)                                                              AS clients,
  ROUND(SUM(approved_usd_mm) / COUNT(*), 0)                             AS mean_approved,
  ROUND(PERCENTILE_APPROX(approved_usd_mm, 0.50), 0)                    AS median_approved,
  ROUND(PERCENTILE_APPROX(approved_usd_mm, 0.90), 0)                    AS p90_approved,
  SUM(CASE WHEN approved_usd_mm >= 5000 THEN 1 ELSE 0 END)              AS clients_over_5000,
  ROUND(SUM(CASE WHEN approved_usd_mm >= 5000
                 THEN approved_usd_mm ELSE 0 END), 0)                   AS approved_in_large_clients,
  ROUND(100.0 * SUM(CASE WHEN approved_usd_mm >= 5000
                         THEN approved_usd_mm ELSE 0 END)
        / SUM(approved_usd_mm), 1)                                      AS pct_of_book
FROM ifc.analytics.client_score;


/* ------------------------------------------------------------
   Step 3. NEGATIVE shortlist - who to reduce or place under review.

   Every column here is part of the argument. If a client tops this
   list, the evidence is on the same row.
   ------------------------------------------------------------ */
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
  exited_at_loss_projects,
  dropped_projects,
  impaired_pct,
  adverse_pct,
  worst_risk_rating,
  ROUND(avg_days_since_review, 0)          AS avg_days_since_review,
  attention_score
FROM ifc.analytics.client_score
WHERE approved_usd_mm >= 5000
ORDER BY attention_score DESC, ecl_usd_mm DESC
LIMIT 12;


/* ------------------------------------------------------------
   Step 4. POSITIVE shortlist - who to keep investing in.

   Requires a clean record: no Past Due and no loss exit. A client
   that has already lost money is not a growth story, however large.
   ------------------------------------------------------------ */
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
  watchlist_projects,
  worst_risk_rating,
  first_approval_year,
  last_approval_year,
  region_count,
  industry_count,
  growth_score
FROM ifc.analytics.client_score
WHERE approved_usd_mm >= 5000
  AND past_due_projects = 0
  AND exited_at_loss_projects = 0
ORDER BY growth_score DESC, approved_usd_mm DESC
LIMIT 12;


/* ------------------------------------------------------------
   Step 5. The caveat behind the USD 445,891 million undisbursed
   figure. Pending projects have never disbursed anything, so they
   carry their full approved amount as an open commitment. Only the
   Active and Closed rows are a true deployment gap.
   ------------------------------------------------------------ */
SELECT
  CASE WHEN status = 'Pending'
       THEN 'Pending - not yet board approved'
       ELSE 'Active and Closed - in execution' END                AS bucket,
  COUNT(*)                                                        AS projects,
  ROUND(SUM(total_approved_usd_mm), 2)                            AS approved_usd_mm,
  ROUND(SUM(COALESCE(disbursed_usd_mm, 0)), 2)                    AS disbursed_usd_mm,
  ROUND(SUM(total_approved_usd_mm)
        - SUM(COALESCE(disbursed_usd_mm, 0)), 2)                  AS undisbursed_usd_mm
FROM ifc.curated.portfolio
GROUP BY 1
ORDER BY approved_usd_mm DESC;
