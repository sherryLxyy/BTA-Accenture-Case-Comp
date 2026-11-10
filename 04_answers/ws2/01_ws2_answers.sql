/* ============================================================
   WS2 - Integrated Portfolio View
   Two questions carried over from the last Board risk review.

   Source definition (Case Brief, p.4):
     Q1  Which Category A projects are currently Past Due or on the
         Watchlist, who are the clients, and how much was approved
         for each?
     Q2  How much of IFC's disbursed capital is tied up in these
         projects, and how much should IFC set aside to cover
         potential losses on those that are Past Due?

   ECL model (Case Brief, p.4):
     Past Due projects are treated as in default.
     Expected credit loss = 60% of their disbursed amount.
     Watchlist projects are NOT in default, so their provision is
     zero - they are reported for exposure, not for provisioning.

   Scope note
     "These projects" in Q2 refers back to the population defined in
     Q1: Category A AND (Past Due OR Watchlist). The Category A
     filter is part of the question, not an optional cut. Running the
     same numbers without it answers a different question and will
     overstate both the exposure and the provision.

   All amounts are USD millions, as stored.
   ============================================================ */


/* ------------------------------------------------------------
   WS2-Q1. The register: every Category A project currently Past
           Due or on the Watchlist, with its client and approved
           amount.

   Q1 asks for the APPROVED amount per project, not disbursed.
   Disbursed appears in Q2 and is carried here only so the two
   questions reconcile on one screen.
   ------------------------------------------------------------ */
SELECT
  performance_status,
  client_id,
  client_name,
  project_name,
  country,
  region,
  internal_risk_rating,
  risk_band,
  total_approved_usd_mm,
  disbursed_usd_mm,
  days_since_review,
  as_of_date
FROM ifc.curated.portfolio
WHERE environmental_category = 'A'
  AND performance_status IN ('Past Due', 'Watchlist')
ORDER BY performance_status, total_approved_usd_mm DESC;


/* ------------------------------------------------------------
   WS2-Q1 summary. Same population, aggregated - how many
           projects, how many distinct clients, how much approved.
   ------------------------------------------------------------ */
SELECT
  performance_status,
  COUNT(*)                                    AS projects,
  COUNT(DISTINCT client_id)                   AS clients,
  ROUND(SUM(total_approved_usd_mm), 2)        AS approved_usd_mm
FROM ifc.curated.portfolio
WHERE environmental_category = 'A'
  AND performance_status IN ('Past Due', 'Watchlist')
GROUP BY performance_status
ORDER BY performance_status;


/* ------------------------------------------------------------
   WS2-Q2. Capital tied up and the provision to set aside.

   disbursed_capital_tied_up_usd_mm  = all Category A projects that
                                       are Past Due or Watchlist
   past_due_disbursed_usd_mm         = the subset actually in default
   ecl_usd_mm                        = 60% of that subset only
   ------------------------------------------------------------ */
SELECT
  COUNT(*)                                                          AS projects,
  COUNT(DISTINCT client_id)                                         AS clients,
  ROUND(SUM(total_approved_usd_mm), 2)                              AS approved_usd_mm,
  ROUND(SUM(disbursed_usd_mm), 2)                                   AS disbursed_capital_tied_up_usd_mm,
  ROUND(SUM(CASE WHEN performance_status = 'Past Due'
                 THEN disbursed_usd_mm ELSE 0 END), 2)              AS past_due_disbursed_usd_mm,
  ROUND(SUM(CASE WHEN performance_status = 'Watchlist'
                 THEN disbursed_usd_mm ELSE 0 END), 2)              AS watchlist_disbursed_usd_mm,
  ROUND(0.6 * SUM(CASE WHEN performance_status = 'Past Due'
                       THEN disbursed_usd_mm ELSE 0 END), 2)        AS ecl_usd_mm
FROM ifc.curated.portfolio
WHERE environmental_category = 'A'
  AND performance_status IN ('Past Due', 'Watchlist');


/* ------------------------------------------------------------
   WS2-Q2 breakdown. Same numbers per status, so the reader can see
   that the provision comes from one status only.
   ------------------------------------------------------------ */
SELECT
  performance_status,
  COUNT(*)                                                  AS projects,
  COUNT(DISTINCT client_id)                                 AS clients,
  ROUND(SUM(total_approved_usd_mm), 2)                      AS approved_usd_mm,
  ROUND(SUM(disbursed_usd_mm), 2)                           AS disbursed_usd_mm,
  ROUND(SUM(CASE WHEN performance_status = 'Past Due'
                 THEN disbursed_usd_mm ELSE 0 END) * 0.6, 2) AS ecl_usd_mm
FROM ifc.curated.portfolio
WHERE environmental_category = 'A'
  AND performance_status IN ('Past Due', 'Watchlist')
GROUP BY performance_status
ORDER BY performance_status;


/* ------------------------------------------------------------
   RECONCILIATION against the Risk Calculator tool.

   The tool groups by performance_status and provisions 60% of Past
   Due disbursed only, zero for Watchlist. That logic is correct.

   Outcome: the tool reports 35 Past Due and 60 Watchlist projects,
   5,519.53 and 5,927.99 disbursed, and a 3,311.72 provision. Those
   figures match the Category A population, not this unfiltered
   block. The unfiltered population is 255 projects and 29,509.43
   disbursed, so the tool is correctly scoped to Category A.

   Tool output (as reported):
     Past Due   35 projects   5,519.53 disbursed   3,311.72 ECL
     Watchlist  60 projects   5,927.99 disbursed       0.00 ECL
   ------------------------------------------------------------ */
SELECT
  performance_status,
  COUNT(*)                                                  AS projects,
  ROUND(SUM(disbursed_usd_mm), 2)                           AS disbursed_usd_mm,
  ROUND(SUM(CASE WHEN performance_status = 'Past Due'
                 THEN disbursed_usd_mm ELSE 0 END) * 0.6, 2) AS ecl_usd_mm
FROM ifc.curated.portfolio
WHERE performance_status IN ('Past Due', 'Watchlist')
GROUP BY performance_status
ORDER BY performance_status;


/* ------------------------------------------------------------
   SENSITIVITY. The same provision on two populations, side by side.
   This makes the cost of dropping the Category A filter explicit
   instead of leaving it as an opinion.
   ------------------------------------------------------------ */
SELECT
  'Category A only (question scope)'                            AS population,
  COUNT(*)                                                      AS projects,
  ROUND(SUM(disbursed_usd_mm), 2)                               AS disbursed_usd_mm,
  ROUND(0.6 * SUM(CASE WHEN performance_status = 'Past Due'
                       THEN disbursed_usd_mm ELSE 0 END), 2)    AS ecl_usd_mm
FROM ifc.curated.portfolio
WHERE environmental_category = 'A'
  AND performance_status IN ('Past Due', 'Watchlist')
UNION ALL
SELECT
  'All projects (no category filter)',
  COUNT(*),
  ROUND(SUM(disbursed_usd_mm), 2),
  ROUND(0.6 * SUM(CASE WHEN performance_status = 'Past Due'
                       THEN disbursed_usd_mm ELSE 0 END), 2)
FROM ifc.curated.portfolio
WHERE performance_status IN ('Past Due', 'Watchlist');
