/* ============================================================
   Q1 window reconciliation

   Two documents now report Q1 and they disagree:
     - 01_ws1_results.md  totals USD 58,320.4 million
     - README A-01        states USD 52.4 billion

   The difference is almost certainly the date window, not the data.
   WS1 answers were changed to measure "last 5 years" from the snapshot
   (MAX(as_of_date) = 2026-06-30) so results do not move every January.
   The assumptions register was written against a calendar-year window.

   This query puts four candidate windows side by side, with and without
   Dropped projects, so one row matches 52,400 and the disagreement ends
   with a number rather than an opinion.
   ============================================================ */

WITH p AS (
  SELECT
    *,
    MAX(as_of_date) OVER () AS snap
  FROM ifc.curated.portfolio
),
flagged AS (
  SELECT
    *,
    (approval_date >  add_months(snap, -60) AND approval_date <= snap) AS w_snapshot,
    (YEAR(approval_date) BETWEEN 2021 AND 2025)                        AS w_cal_2021_2025,
    (YEAR(approval_date) BETWEEN 2021 AND 2026)                        AS w_cal_2021_2026,
    (approval_year >= YEAR(CURRENT_DATE()) - 5)                        AS w_old_rule,
    (status = 'Dropped')                                               AS is_dropped
  FROM p
)
SELECT
  'A. snapshot, 60 months back from 2026-06-30'                     AS window_label,
  SUM(CASE WHEN w_snapshot THEN 1 ELSE 0 END)                       AS projects_all,
  ROUND(SUM(CASE WHEN w_snapshot THEN loan_usd_mm ELSE 0 END), 1)   AS loan_all,
  SUM(CASE WHEN w_snapshot AND NOT is_dropped THEN 1 ELSE 0 END)    AS projects_excl_dropped,
  ROUND(SUM(CASE WHEN w_snapshot AND NOT is_dropped
                 THEN loan_usd_mm ELSE 0 END), 1)                   AS loan_excl_dropped,
  ROUND(SUM(CASE WHEN w_snapshot
                 THEN total_approved_usd_mm ELSE 0 END), 1)         AS approved_all
FROM flagged

UNION ALL

SELECT
  'B. calendar years 2021 to 2025',
  SUM(CASE WHEN w_cal_2021_2025 THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN w_cal_2021_2025 THEN loan_usd_mm ELSE 0 END), 1),
  SUM(CASE WHEN w_cal_2021_2025 AND NOT is_dropped THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN w_cal_2021_2025 AND NOT is_dropped
                 THEN loan_usd_mm ELSE 0 END), 1),
  ROUND(SUM(CASE WHEN w_cal_2021_2025
                 THEN total_approved_usd_mm ELSE 0 END), 1)
FROM flagged

UNION ALL

SELECT
  'C. calendar years 2021 to 2026',
  SUM(CASE WHEN w_cal_2021_2026 THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN w_cal_2021_2026 THEN loan_usd_mm ELSE 0 END), 1),
  SUM(CASE WHEN w_cal_2021_2026 AND NOT is_dropped THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN w_cal_2021_2026 AND NOT is_dropped
                 THEN loan_usd_mm ELSE 0 END), 1),
  ROUND(SUM(CASE WHEN w_cal_2021_2026
                 THEN total_approved_usd_mm ELSE 0 END), 1)
FROM flagged

UNION ALL

SELECT
  'D. old rule, approval_year >= YEAR(today) - 5',
  SUM(CASE WHEN w_old_rule THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN w_old_rule THEN loan_usd_mm ELSE 0 END), 1),
  SUM(CASE WHEN w_old_rule AND NOT is_dropped THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN w_old_rule AND NOT is_dropped
                 THEN loan_usd_mm ELSE 0 END), 1),
  ROUND(SUM(CASE WHEN w_old_rule
                 THEN total_approved_usd_mm ELSE 0 END), 1)
FROM flagged;


/* ------------------------------------------------------------
   Boundary detail. Shows exactly where the two windows diverge:
   the first half of 2021 is inside the calendar window and outside
   the snapshot window, and the second half of 2026 is the reverse.
   This is the paragraph that explains the 59 billion gap in the
   write-up, if that is what it turns out to be.
   ------------------------------------------------------------ */
SELECT
  CASE
    WHEN approval_date < DATE'2021-07-01'
      THEN '1. 2021 H1 - in calendar window, out of snapshot window'
    WHEN approval_date > DATE'2026-06-30'
      THEN '2. 2026 H2 - out of both, data ends 2026-06-30'
    ELSE '3. inside both windows'
  END                                                         AS bucket,
  COUNT(*)                                                    AS projects,
  ROUND(SUM(loan_usd_mm), 1)                                  AS loan_usd_mm,
  ROUND(SUM(total_approved_usd_mm), 1)                        AS approved_usd_mm
FROM ifc.curated.portfolio
WHERE YEAR(approval_date) BETWEEN 2021 AND 2026
GROUP BY 1
ORDER BY 1;
