/* ============================================================
   WS1 — Baseline Analytics: 30 portfolio questions
   Standard SQL reference answers, run against ifc.curated.portfolio

   Conventions
   - All amounts are USD millions.
   - project_number is never used: 1,126 values are shared by
     unrelated projects.
   - "Last 5 years" runs from the snapshot, not from today.
   - total_approved_usd_mm is used for approved amounts; the four
     product columns are never summed to rebuild a total.

   Each block is independent and safe to run on its own.
   ============================================================ */


/* ------------------------------------------------------------
   Q1. Total IFC loan investment by region, projects approved
       in the last 5 years.
   Assumption: Dropped projects are included -- they were approved
   by the Board, so they belong in an approval-based measure.
   ------------------------------------------------------------ */
SELECT
  region,
  ROUND(SUM(loan_usd_mm), 1) AS total_loan_usd_mm
FROM ifc.curated.portfolio
WHERE approval_date >  add_months((SELECT MAX(as_of_date)
                                  FROM ifc.curated.portfolio), -60)
  AND approval_date <= (SELECT MAX(as_of_date)
                        FROM ifc.curated.portfolio)
GROUP BY region
ORDER BY total_loan_usd_mm DESC;


/* ------------------------------------------------------------
   Q2. Top 10 projects by total IFC investment as approved by
       the Board.
   ------------------------------------------------------------ */
SELECT
  project_name,
  country,
  region,
  status,
  total_approved_usd_mm
FROM ifc.curated.portfolio
ORDER BY total_approved_usd_mm DESC
LIMIT 10;


/* ------------------------------------------------------------
   Q3. Equity vs Loan investment across industries, excluding
       Dropped projects.
   ------------------------------------------------------------ */
SELECT
  industry,
  ROUND(SUM(loan_usd_mm), 1)   AS loan_usd_mm,
  ROUND(SUM(equity_usd_mm), 1) AS equity_usd_mm,
  ROUND(SUM(loan_usd_mm) / NULLIF(SUM(equity_usd_mm), 0), 2) AS loan_to_equity
FROM ifc.curated.portfolio
WHERE status <> 'Dropped'
GROUP BY industry
ORDER BY loan_usd_mm DESC;


/* ------------------------------------------------------------
   Q4. Countries with more than USD 1,000 million of IFC loan investment
       across Active and Closed projects.
   Note: the column is in USD millions, so the threshold is 1000,
   not 1e9.
   ------------------------------------------------------------ */
SELECT
  country,
  ROUND(SUM(loan_usd_mm), 1) AS total_loan_usd_mm
FROM ifc.curated.portfolio
WHERE status IN ('Active', 'Closed')
GROUP BY country
HAVING SUM(loan_usd_mm) > 1000
ORDER BY total_loan_usd_mm DESC;


/* ------------------------------------------------------------
   Q5. Trend of IFC approved investment year over year.
   All statuses are included -- the measure is Board approval, and
   a project was approved regardless of what happened later.
   2026 is a partial year and must be read as such.
   ------------------------------------------------------------ */
SELECT
  approval_year,
  COUNT(*)                                             AS projects,
  ROUND(SUM(total_approved_usd_mm), 1)                 AS approved_usd_mm,
  ROUND(SUM(total_approved_usd_mm)
        - LAG(SUM(total_approved_usd_mm)) OVER (ORDER BY approval_year), 1) AS yoy_change_usd_mm
FROM ifc.curated.portfolio
WHERE approval_year IS NOT NULL
GROUP BY approval_year
ORDER BY approval_year;


/* ------------------------------------------------------------
   Q6. Top performing regions by committed investment.
   Assumption: "committed" = agreements signed and not later
   dropped. Pending projects have no signed date and are excluded
   by construction.
   ------------------------------------------------------------ */
SELECT
  region,
  COUNT(*)                                  AS committed_projects,
  ROUND(SUM(total_approved_usd_mm), 1)      AS committed_usd_mm
FROM ifc.curated.portfolio
WHERE signed_date IS NOT NULL
  AND status <> 'Dropped'
GROUP BY region
ORDER BY committed_usd_mm DESC;


/* ------------------------------------------------------------
   Q7. Top 10 countries by number of Active projects.
   ------------------------------------------------------------ */
SELECT
  country,
  COUNT(*) AS active_projects
FROM ifc.curated.portfolio
WHERE status = 'Active'
GROUP BY country
ORDER BY active_projects DESC, country
LIMIT 10;


/* ------------------------------------------------------------
   Q8. Investment split across the four products for
       East Asia & Pacific, excluding Dropped projects.
   ------------------------------------------------------------ */
SELECT
  ROUND(SUM(loan_usd_mm), 1)      AS loan_usd_mm,
  ROUND(SUM(equity_usd_mm), 1)    AS equity_usd_mm,
  ROUND(SUM(guarantee_usd_mm), 1) AS guarantee_usd_mm,
  ROUND(SUM(risk_mgmt_usd_mm), 1) AS risk_mgmt_usd_mm,
  ROUND(SUM(loan_usd_mm) + SUM(equity_usd_mm)
      + SUM(guarantee_usd_mm) + SUM(risk_mgmt_usd_mm), 1) AS total_usd_mm,
  COUNT(*)                        AS projects
FROM ifc.curated.portfolio
WHERE region = 'East Asia & Pacific'
  AND status <> 'Dropped';


/* ------------------------------------------------------------
   Q9. Ten WB country codes with the longest average time between
       approval and signing, minimum 10 signed projects.
   ------------------------------------------------------------ */
SELECT
  wb_country_code,
  COUNT(*)                             AS signed_projects,
  ROUND(AVG(days_approval_to_sign), 1) AS avg_days_approval_to_sign
FROM ifc.curated.portfolio
WHERE days_approval_to_sign IS NOT NULL
GROUP BY wb_country_code
HAVING COUNT(*) >= 10
ORDER BY avg_days_approval_to_sign DESC
LIMIT 10;


/* ------------------------------------------------------------
   Q10. Per industry: projects approved and projects first
        invested, each year 2020-2025.
   Approved and invested are two different date columns, so they
   are counted separately and re-joined on a year spine. Counting
   invested projects by approval_year would answer a different
   question.
   ------------------------------------------------------------ */
WITH years AS (
  SELECT explode(sequence(2020, 2025)) AS year
),
industries AS (
  SELECT DISTINCT industry FROM ifc.curated.portfolio WHERE industry IS NOT NULL
),
approved AS (
  SELECT industry, approval_year AS year, COUNT(*) AS approved_projects
  FROM ifc.curated.portfolio
  WHERE approval_year BETWEEN 2020 AND 2025
  GROUP BY industry, approval_year
),
invested AS (
  SELECT industry, invested_year AS year, COUNT(*) AS first_invested_projects
  FROM ifc.curated.portfolio
  WHERE invested_year BETWEEN 2020 AND 2025
  GROUP BY industry, invested_year
)
SELECT
  i.industry,
  y.year,
  COALESCE(a.approved_projects, 0)       AS approved_projects,
  COALESCE(v.first_invested_projects, 0) AS first_invested_projects
FROM industries i
CROSS JOIN years y
LEFT JOIN approved a ON a.industry = i.industry AND a.year = y.year
LEFT JOIN invested v ON v.industry = i.industry AND v.year = y.year
ORDER BY i.industry, y.year;


/* ------------------------------------------------------------
   Q11. Average time between approval, signing and investment,
        by region.
   COUNT(col) is used rather than COUNT(*) so the denominator is
   the number of projects that actually have both dates.
   ------------------------------------------------------------ */
SELECT
  region,
  COUNT(days_approval_to_sign)            AS projects_approved_and_signed,
  ROUND(AVG(days_approval_to_sign), 1)    AS avg_days_approval_to_sign,
  COUNT(days_sign_to_invest)              AS projects_signed_and_invested,
  ROUND(AVG(days_sign_to_invest), 1)      AS avg_days_sign_to_invest
FROM ifc.curated.portfolio
GROUP BY region
ORDER BY region;


/* ------------------------------------------------------------
   Q12. Pending projects whose Projected Board Date has passed as
        of their As of Date, but that have not been approved.
   ------------------------------------------------------------ */
SELECT
  project_name,
  country,
  region,
  department,
  projected_board_date,
  as_of_date,
  DATEDIFF(as_of_date, projected_board_date) AS days_past_projected_board_date,
  total_approved_usd_mm
FROM ifc.curated.portfolio
WHERE status = 'Pending'
  AND approval_date IS NULL
  AND projected_board_date IS NOT NULL
  AND as_of_date IS NOT NULL
  AND projected_board_date < as_of_date
ORDER BY days_past_projected_board_date DESC;


/* ------------------------------------------------------------
   Q13 [Challenge]. Active projects whose main purpose is new
        renewable power generation -- count and approved amount
        by region.

   KEYWORD CALIBRATION (measured over the 1,233 Active projects)
     renewable      189
     solar          142
     power plant     86
     wind            39
     hydro           10
     geothermal       4
     biomass          0   (removed from the pattern)
     photovoltaic     0   (removed from the pattern)

   The dataset has no structured "purpose" field, so this is a
   keyword match over project_description. Two tiers are reported
   because "main purpose" cannot be operationalised exactly:

     broad  -- any renewable generation term is mentioned.
               Upper bound: includes projects where renewables
               appear but are not the main purpose.
     strict -- a renewable term AND a power generation term.
               Closer to "main purpose", but drops genuinely
               renewable projects described in other wording.

   The true answer lies between the two. Report the band, never a
   single number, and never present either tier as a census.
   ------------------------------------------------------------ */
SELECT
  region,
  SUM(CASE WHEN LOWER(project_description)
             RLIKE 'renewable|solar|wind|hydro|geothermal'
           THEN 1 ELSE 0 END)                                          AS broad_projects,
  ROUND(SUM(CASE WHEN LOWER(project_description)
             RLIKE 'renewable|solar|wind|hydro|geothermal'
           THEN total_approved_usd_mm ELSE 0 END), 1)                  AS broad_usd_mm,
  SUM(CASE WHEN LOWER(project_description)
             RLIKE 'renewable|solar|wind|hydro|geothermal'
           AND LOWER(project_description)
             RLIKE 'power plant|power generation|generation capacity|plant construction'
           THEN 1 ELSE 0 END)                                          AS strict_projects,
  ROUND(SUM(CASE WHEN LOWER(project_description)
             RLIKE 'renewable|solar|wind|hydro|geothermal'
           AND LOWER(project_description)
             RLIKE 'power plant|power generation|generation capacity|plant construction'
           THEN total_approved_usd_mm ELSE 0 END), 1)                  AS strict_usd_mm
FROM ifc.curated.portfolio
WHERE status = 'Active'
GROUP BY region
ORDER BY broad_usd_mm DESC;


/* ------------------------------------------------------------
   Q14. Summary of Proposed Investment documents disclosed each
        year after 2020.
   Run the value check block below first to confirm the exact
   document_type string; it is matched literally here.
   ------------------------------------------------------------ */
SELECT
  YEAR(date_disclosed) AS disclosure_year,
  COUNT(*)             AS documents
FROM ifc.curated.portfolio
WHERE document_type = 'Summary of Proposed Investment'
  AND YEAR(date_disclosed) > 2020
GROUP BY YEAR(date_disclosed)
ORDER BY disclosure_year;


/* ------------------------------------------------------------
   Q15. Environmental Category A projects that are still Pending --
        count and approved amount by region.
   ------------------------------------------------------------ */
SELECT
  region,
  COUNT(*)                             AS projects,
  ROUND(SUM(total_approved_usd_mm), 1) AS approved_usd_mm
FROM ifc.curated.portfolio
WHERE environmental_category = 'A'
  AND status = 'Pending'
GROUP BY region
ORDER BY approved_usd_mm DESC;


/* ------------------------------------------------------------
   Q16. Environmental & Social Review Summary documents, broken
        down by Environmental Category.
   ------------------------------------------------------------ */
SELECT
  environmental_category,
  COUNT(*) AS documents
FROM ifc.curated.portfolio
WHERE document_type = 'Environmental & Social Review Summary'
GROUP BY environmental_category
ORDER BY documents DESC;


/* ------------------------------------------------------------
   Q17. Approved investment by Department, last 5 years.
   ------------------------------------------------------------ */
SELECT
  department,
  COUNT(*)                             AS projects,
  ROUND(SUM(total_approved_usd_mm), 1) AS approved_usd_mm
FROM ifc.curated.portfolio
WHERE approval_date >  add_months((SELECT MAX(as_of_date)
                                  FROM ifc.curated.portfolio), -60)
  AND approval_date <= (SELECT MAX(as_of_date)
                        FROM ifc.curated.portfolio)
GROUP BY department
ORDER BY approved_usd_mm DESC;


/* ------------------------------------------------------------
   Q18. Product Line across regions, excluding Dropped projects.
   Returned in long format with both project count and approved
   amount, because "compare Product Line categories" can mean
   either. Amounts come from total_approved_usd_mm, not from the
   four product columns, so a project is not double counted.
   ------------------------------------------------------------ */
SELECT
  region,
  product_line,
  COUNT(*)                             AS projects,
  ROUND(SUM(total_approved_usd_mm), 1) AS approved_usd_mm
FROM ifc.curated.portfolio
WHERE status <> 'Dropped'
GROUP BY region, product_line
ORDER BY region, approved_usd_mm DESC;


/* ------------------------------------------------------------
   Q19. Industries with the largest risk management investment,
        and risk management as a share of each industry's total
        product allocation.
   ------------------------------------------------------------ */
SELECT
  industry,
  ROUND(SUM(risk_mgmt_usd_mm), 1) AS risk_mgmt_usd_mm,
  ROUND(SUM(loan_usd_mm) + SUM(equity_usd_mm)
      + SUM(guarantee_usd_mm) + SUM(risk_mgmt_usd_mm), 1) AS total_product_usd_mm,
  ROUND(SUM(risk_mgmt_usd_mm)
      / NULLIF(SUM(loan_usd_mm) + SUM(equity_usd_mm)
             + SUM(guarantee_usd_mm) + SUM(risk_mgmt_usd_mm), 0) * 100, 2) AS risk_mgmt_share_pct
FROM ifc.curated.portfolio
GROUP BY industry
ORDER BY risk_mgmt_usd_mm DESC;


/* ------------------------------------------------------------
   Q20. Projects approved by each Department, yearly 2020-2025.
   ------------------------------------------------------------ */
SELECT
  department,
  approval_year,
  COUNT(*) AS approved_projects
FROM ifc.curated.portfolio
WHERE approval_year BETWEEN 2020 AND 2025
GROUP BY department, approval_year
ORDER BY department, approval_year;


/* ------------------------------------------------------------
   Q21. Dropped projects with more than USD 250 million originally approved.
   Threshold is USD millions, so the literal is 250, not 250e6.
   ------------------------------------------------------------ */
SELECT
  project_name,
  country,
  region,
  industry,
  date_disclosed,
  approval_date,
  total_approved_usd_mm
FROM ifc.curated.portfolio
WHERE status = 'Dropped'
  AND total_approved_usd_mm > 250
ORDER BY total_approved_usd_mm DESC;


/* ------------------------------------------------------------
   Q22. Active projects whose first investment came more than two
        years after Board approval.
   add_months(..., 24) is used instead of a 730-day comparison so
   leap years do not move the boundary.
   ------------------------------------------------------------ */
SELECT
  project_name,
  country,
  region,
  approval_date,
  invested_date,
  DATEDIFF(invested_date, approval_date) AS days_approval_to_invest,
  total_approved_usd_mm
FROM ifc.curated.portfolio
WHERE status = 'Active'
  AND approval_date IS NOT NULL
  AND invested_date IS NOT NULL
  AND invested_date > add_months(approval_date, 24)
ORDER BY days_approval_to_invest DESC;


/* ------------------------------------------------------------
   Q23. Status mix by region, as a percentage of that region's
        projects. Each row must sum to 100.0 -- that is the check.
   ------------------------------------------------------------ */
SELECT
  region,
  COUNT(*) AS total_projects,
  ROUND(100.0 * SUM(CASE WHEN status = 'Active'  THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_active,
  ROUND(100.0 * SUM(CASE WHEN status = 'Closed'  THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_closed,
  ROUND(100.0 * SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_pending,
  ROUND(100.0 * SUM(CASE WHEN status = 'Dropped' THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_dropped
FROM ifc.curated.portfolio
GROUP BY region
ORDER BY region;


/* ------------------------------------------------------------
   Q24 [Challenge]. Total new renewable generation capacity (MW)
        for Active and Closed projects, by region, plus how many
        of those projects state no capacity at all.

   LIMITATION: capacity only exists inside free-text descriptions.
   It is extracted with a regular expression and is therefore a
   FLOOR, not a portfolio total. Projects that state capacity in
   GW, in words, or not at all are silently lost. The
   projects_without_capacity column is the honesty check: it makes
   the coverage gap visible instead of hiding it inside an average.
   ------------------------------------------------------------ */
WITH renewable AS (
  SELECT
    region,
    TRY_CAST(
      REPLACE(
        regexp_extract(LOWER(project_description), '([0-9][0-9,\\.]*)\\s*mw', 1),
        ',', ''
      ) AS DOUBLE
    ) AS capacity_mw
  FROM ifc.curated.portfolio
  WHERE status IN ('Active', 'Closed')
    AND LOWER(project_description) RLIKE 'renewable|solar|wind|hydro|geothermal'
)
SELECT
  region,
  COUNT(*)                            AS projects,
  COUNT(capacity_mw)                  AS projects_with_capacity,
  COUNT(*) - COUNT(capacity_mw)       AS projects_without_capacity,
  ROUND(100.0 * COUNT(capacity_mw) / COUNT(*), 1) AS pct_stating_capacity,
  ROUND(SUM(capacity_mw), 1)          AS total_capacity_mw
FROM renewable
GROUP BY region
ORDER BY total_capacity_mw DESC NULLS LAST;


/* ------------------------------------------------------------
   Q25 [Challenge]. MSME financing, excluding Dropped.
   Three blocks: headline, top 5 countries, target groups.
   LIMITATION: no structured MSME flag exists. The segment is
   identified by keyword over the description, so the population
   is "projects that mention MSMEs", not "MSME projects".
   ------------------------------------------------------------ */
SELECT
  COUNT(*)                             AS projects,
  ROUND(SUM(total_approved_usd_mm), 1) AS approved_usd_mm
FROM ifc.curated.portfolio
WHERE status <> 'Dropped'
  AND LOWER(project_description)
      RLIKE '\\bmsme\\b|\\bsme\\b|small and medium|micro, small|small business|microfinance';

SELECT
  country,
  COUNT(*)                             AS projects,
  ROUND(SUM(total_approved_usd_mm), 1) AS approved_usd_mm
FROM ifc.curated.portfolio
WHERE status <> 'Dropped'
  AND LOWER(project_description)
      RLIKE '\\bmsme\\b|\\bsme\\b|small and medium|micro, small|small business|microfinance'
GROUP BY country
ORDER BY approved_usd_mm DESC
LIMIT 5;

SELECT
  SUM(CASE WHEN LOWER(project_description) RLIKE 'women'                  THEN 1 ELSE 0 END) AS women_owned_or_led,
  SUM(CASE WHEN LOWER(project_description) RLIKE 'rural'                  THEN 1 ELSE 0 END) AS rural,
  SUM(CASE WHEN LOWER(project_description) RLIKE 'agri|farm'              THEN 1 ELSE 0 END) AS agriculture,
  SUM(CASE WHEN LOWER(project_description) RLIKE 'youth'                  THEN 1 ELSE 0 END) AS youth,
  SUM(CASE WHEN LOWER(project_description) RLIKE 'first-time|first time'  THEN 1 ELSE 0 END) AS first_time_borrowers,
  SUM(CASE WHEN LOWER(project_description) RLIKE 'low-income|low income'  THEN 1 ELSE 0 END) AS low_income
FROM ifc.curated.portfolio
WHERE status <> 'Dropped'
  AND LOWER(project_description)
      RLIKE '\\bmsme\\b|\\bsme\\b|small and medium|micro, small|small business|microfinance';


/* ------------------------------------------------------------
   Q26 [Challenge]. Projects whose description implies a different
        financing product from the one recorded in product_line.

   METHOD: each description is scanned for product keywords. A
        mismatch is flagged only when exactly ONE product keyword
        appears and it is not the recorded product_line. That
        restriction keeps precision high and errs towards
        under-reporting: ambiguous descriptions are not flagged.

   Run the VALUE CHECK block first -- the product keyword tags
   below are matched to the literal product_line values, and if
   those differ the rule has to be re-tagged.
   ------------------------------------------------------------ */
WITH tagged AS (
  SELECT
    project_name,
    country,
    region,
    product_line,
    total_approved_usd_mm,
    LOWER(project_description)                                          AS d,
    CAST((LOWER(project_description) RLIKE '\\bloan')      AS INT) AS m_loan,
    CAST((LOWER(project_description) RLIKE '\\bequity')    AS INT) AS m_equity,
    CAST((LOWER(project_description) RLIKE '\\bguarantee') AS INT) AS m_guarantee,
    CAST((LOWER(project_description) RLIKE 'risk management|risk-sharing|risk sharing') AS INT) AS m_risk
  FROM ifc.curated.portfolio
),
implied AS (
  SELECT
    *,
    CASE
      WHEN (m_loan + m_equity + m_guarantee + m_risk) <> 1 THEN NULL
      WHEN m_loan      = 1 THEN 'Loan'
      WHEN m_equity    = 1 THEN 'Equity'
      WHEN m_guarantee = 1 THEN 'Guarantee'
      WHEN m_risk      = 1 THEN 'Risk Management'
    END AS implied_product
  FROM tagged
)
SELECT
  product_line,
  implied_product,
  COUNT(*)                             AS projects,
  ROUND(SUM(total_approved_usd_mm), 1) AS approved_usd_mm
FROM implied
WHERE implied_product IS NOT NULL
  AND implied_product <> product_line
GROUP BY product_line, implied_product
ORDER BY projects DESC;

SELECT
  project_name,
  country,
  region,
  product_line,
  total_approved_usd_mm
FROM (
  SELECT
    project_name, country, region, product_line, total_approved_usd_mm,
    LOWER(project_description) AS d,
    CAST((LOWER(project_description) RLIKE '\\bloan')      AS INT) AS m_loan,
    CAST((LOWER(project_description) RLIKE '\\bequity')    AS INT) AS m_equity,
    CAST((LOWER(project_description) RLIKE '\\bguarantee') AS INT) AS m_guarantee,
    CAST((LOWER(project_description) RLIKE 'risk management|risk-sharing|risk sharing') AS INT) AS m_risk
  FROM ifc.curated.portfolio
)
WHERE (m_loan + m_equity + m_guarantee + m_risk) = 1
  AND CASE
        WHEN m_loan      = 1 THEN 'Loan'
        WHEN m_equity    = 1 THEN 'Equity'
        WHEN m_guarantee = 1 THEN 'Guarantee'
        WHEN m_risk      = 1 THEN 'Risk Management'
      END <> product_line
ORDER BY total_approved_usd_mm DESC;


/* ------------------------------------------------------------
   Q27. Bubble chart feed: 15 countries with the highest approved
        investment, excluding Dropped.
   x = loan, y = equity, size = total. Returned as a plain table;
   the visual is built by whoever consumes it.
   ------------------------------------------------------------ */
SELECT
  country,
  ROUND(SUM(loan_usd_mm), 1)           AS loan_usd_mm,
  ROUND(SUM(equity_usd_mm), 1)         AS equity_usd_mm,
  ROUND(SUM(total_approved_usd_mm), 1) AS total_approved_usd_mm
FROM ifc.curated.portfolio
WHERE status <> 'Dropped'
GROUP BY country
ORDER BY total_approved_usd_mm DESC
LIMIT 15;


/* ------------------------------------------------------------
   Q28. Projects where the Board-approved total differs from the
        sum of the four product allocations by more than USD 1 million.
   product_total_diff_usd_mm is precomputed in the pipeline.
   Expected count: 146. If that number moves, the pipeline changed.
   ------------------------------------------------------------ */
SELECT
  project_name,
  country,
  region,
  status,
  product_line,
  total_approved_usd_mm,
  product_sum_usd_mm,
  product_total_diff_usd_mm
FROM ifc.curated.portfolio
WHERE ABS(product_total_diff_usd_mm) > 1
ORDER BY ABS(product_total_diff_usd_mm) DESC;


/* ------------------------------------------------------------
   Q29. Multi-product projects: more than one product with a
        non-zero allocation.
   ------------------------------------------------------------ */
SELECT
  project_name,
  country,
  region,
  status,
  loan_usd_mm,
  equity_usd_mm,
  guarantee_usd_mm,
  risk_mgmt_usd_mm,
  product_count,
  total_approved_usd_mm
FROM ifc.curated.portfolio
WHERE product_count > 1
ORDER BY product_count DESC, total_approved_usd_mm DESC;


/* ------------------------------------------------------------
   Q30. Heatmap feed: region x industry, total approved investment,
        excluding Dropped. Long format -- one row per cell.
   ------------------------------------------------------------ */
SELECT
  region,
  industry,
  COUNT(*)                             AS projects,
  ROUND(SUM(total_approved_usd_mm), 1) AS approved_usd_mm
FROM ifc.curated.portfolio
WHERE status <> 'Dropped'
GROUP BY region, industry
ORDER BY region, approved_usd_mm DESC;


/* ------------------------------------------------------------
   VALUE CHECK -- run this once before trusting Q14, Q16 and Q18.
   It prints the actual distinct values so that literal matches
   such as 'Summary of Proposed Investment' are not guesses.
   ------------------------------------------------------------ */
SELECT 'document_type' AS field, document_type AS value, COUNT(*) AS n
FROM ifc.curated.portfolio GROUP BY document_type
UNION ALL
SELECT 'environmental_category', environmental_category, COUNT(*)
FROM ifc.curated.portfolio GROUP BY environmental_category
UNION ALL
SELECT 'product_line', product_line, COUNT(*)
FROM ifc.curated.portfolio GROUP BY product_line
ORDER BY field, n DESC;
