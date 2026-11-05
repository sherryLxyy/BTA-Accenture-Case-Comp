/* ============================================================
   WS3 - Finalists for the four-client recommendation

   Two corrections applied here, both found by the first pass.

   1. 1,232 projects have no client_id. They are Pending projects that
      have not been assigned to a client yet. Because their
      performance_status is also NULL, they scored as perfectly clean
      and a NULL client row appeared at the top of the growth list
      with USD 187,440 million approved. The client view must exclude
      them. That leaves 3,768 projects and USD 555,119 million, 74.8%
      of approved value, which is the honest scope of any client-level
      statement.

   2. The materiality floor of USD 5,000 million sits above the 90th
      percentile of USD 2,333 and selects 19 clients, 46.6% of the
      book. That is kept: it concentrates the shortlist without
      losing coverage.

   Scores are recomputed after the NULL exclusion so percentiles are
   measured against the 400 real clients only.
   ============================================================ */


/* ------------------------------------------------------------
   Step 1. Rebuild the scored table on real clients only.
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

    PERCENT_RANK() OVER (ORDER BY ecl_usd_mm)                       AS pr_ecl,
    PERCENT_RANK() OVER (ORDER BY (past_due_projects + watchlist_projects) * 1.0
                                / GREATEST(project_count, 1))       AS pr_impaired,
    PERCENT_RANK() OVER (ORDER BY worst_risk_rating)                AS pr_risk,
    PERCENT_RANK() OVER (ORDER BY undisbursed_usd_mm)               AS pr_undisbursed,
    PERCENT_RANK() OVER (ORDER BY dropped_projects * 1.0
                                / GREATEST(project_count, 1))       AS pr_dropped,

    PERCENT_RANK() OVER (ORDER BY (past_due_projects + exited_at_loss_projects
                                   + dropped_projects) * 1.0
                                / GREATEST(project_count, 1) DESC)  AS pr_clean,
    PERCENT_RANK() OVER (ORDER BY disbursed_usd_mm
                                / NULLIF(approved_usd_mm, 0))       AS pr_deployment,
    PERCENT_RANK() OVER (ORDER BY worst_risk_rating DESC)           AS pr_lowrisk,
    PERCENT_RANK() OVER (ORDER BY project_count, last_approval_year) AS pr_depth,
    PERCENT_RANK() OVER (ORDER BY approved_usd_mm)                  AS pr_size
  FROM ifc.analytics.client_portfolio c
  WHERE client_id IS NOT NULL
    AND approved_usd_mm > 0
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
   Step 2. Scope check. Confirms what the client view does and does
   not cover before any recommendation is made on top of it.
   ------------------------------------------------------------ */
SELECT
  CASE WHEN client_id IS NULL
       THEN 'No client assigned (Pending)'
       ELSE 'Client assigned' END                                AS scope,
  COUNT(*)                                                        AS projects,
  ROUND(SUM(total_approved_usd_mm), 2)                            AS approved_usd_mm,
  ROUND(100.0 * SUM(total_approved_usd_mm)
        / SUM(SUM(total_approved_usd_mm)) OVER (), 1)             AS pct_of_approved
FROM ifc.curated.portfolio
GROUP BY 1
ORDER BY approved_usd_mm DESC;


/* ------------------------------------------------------------
   Step 3. NEGATIVE finalists. Eight rows, ordered by attention
   score, with the loss figure visible so the choice can be made on
   both quality and money at once.
   ------------------------------------------------------------ */
SELECT
  client_id,
  client_name,
  project_count,
  ROUND(approved_usd_mm, 0)      AS approved,
  ROUND(disbursed_usd_mm, 0)     AS disbursed,
  ROUND(undisbursed_usd_mm, 0)   AS undisbursed,
  ROUND(ecl_usd_mm, 0)           AS ecl,
  past_due_projects              AS past_due,
  watchlist_projects             AS watch,
  exited_at_loss_projects        AS loss_exits,
  impaired_pct,
  adverse_pct,
  worst_risk_rating              AS risk,
  attention_score
FROM ifc.analytics.client_score
WHERE approved_usd_mm >= 5000
ORDER BY attention_score DESC
LIMIT 8;


/* ------------------------------------------------------------
   Step 4. POSITIVE finalists. All clients above the floor with a
   completely clean record, not truncated - there are only a few and
   the count itself is part of the finding.
   ------------------------------------------------------------ */
SELECT
  client_id,
  client_name,
  project_count,
  ROUND(approved_usd_mm, 0)      AS approved,
  ROUND(disbursed_usd_mm, 0)     AS disbursed,
  ROUND(undisbursed_usd_mm, 0)   AS undisbursed,
  disbursed_pct,
  performing_projects            AS performing,
  completed_projects             AS completed,
  worst_risk_rating              AS risk,
  first_approval_year,
  last_approval_year,
  industry_count,
  growth_score
FROM ifc.analytics.client_score
WHERE approved_usd_mm >= 5000
  AND past_due_projects = 0
  AND exited_at_loss_projects = 0
  AND watchlist_projects = 0
ORDER BY growth_score DESC;


/* ------------------------------------------------------------
   Step 5. How thin is the clean cohort? Makes the scarcity of
   investable large clients explicit instead of implied.
   ------------------------------------------------------------ */
SELECT
  COUNT(*)                                                          AS large_clients,
  SUM(CASE WHEN watchlist_projects = 0
            AND past_due_projects = 0
            AND exited_at_loss_projects = 0 THEN 1 ELSE 0 END)      AS fully_clean,
  SUM(CASE WHEN past_due_projects > 0 THEN 1 ELSE 0 END)            AS with_past_due,
  SUM(CASE WHEN watchlist_projects > 0 THEN 1 ELSE 0 END)           AS with_watchlist,
  ROUND(SUM(CASE WHEN watchlist_projects = 0
                  AND past_due_projects = 0
                  AND exited_at_loss_projects = 0
                 THEN approved_usd_mm ELSE 0 END), 0)               AS clean_approved,
  ROUND(SUM(approved_usd_mm), 0)                                    AS total_approved
FROM ifc.analytics.client_score
WHERE approved_usd_mm >= 5000;
