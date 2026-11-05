# WS1 - Baseline Analytics: 30 Portfolio Questions

**Status:** in progress
**Source:** `IFC_portfolio_questions.txt`
**Data:** `ifc.curated.portfolio` (one row per project, 5,000 rows)
**Interface:** Genie Space `IFC Portfolio Analytics - CFO Office`

## Scope and assumptions

1. All answers are computed from `ifc.curated.portfolio`, a superset of the
   Project Portfolio table: the LEFT JOIN to monitoring is resolved in the
   pipeline, not at query time. All 5,000 projects are preserved.
2. `project_number` is never used for counting, grouping or joining - 1,126
   values are shared by unrelated projects.
3. "Last 5 years" is interpreted as `approval_year >= YEAR(CURRENT_DATE()) - 5`.
   The exact range is stated in every affected answer.
4. Monetary values are USD millions throughout.
5. `total_approved_usd_mm` is used for "approved amount"; the four product
   columns are never summed to rebuild a total.

## Results tracker

Status: `PASS` = correct and traceable | `PARTIAL` = right direction, wrong
detail | `FAIL` = wrong number or unusable | `GAP` = data cannot answer

| # | Cat | Question | Status | Notes |
|---|-----|----------|--------|-------|
| 1 | A | Show the total IFC loan investment by region for projects approved in the last 5 years. | PASS | Full breakdown (USD millions): Sub-Saharan Africa: 16,689.5, Latin America: 12,731.9, East Asia & Pacific: 8,390.0, Europe & Central Asia: 7,865.3, South Asia: 6,873.3, Middle East: 5,770.4, North America: 0.0|
| 2 | A | List the top 10 projects by Total IFC investment as approved by the Board. | PASS | The top project is Varas Works Pharma 2021 in the Philippines at $300.0M, followed closely by Berdan Industries Energy Efficiency (Philippines, $299.9M) and Berva Communications Tower Portfolio (Dominican Republic, $299.8M). All ten projects in this list fall within a narrow band of roughly $299.4M–$300.0M in approved investment.|
| 3 | A | Compare Equity vs Loan investment across industries, excluding Dropped projects. | PASS | Across all five industries in the portfolio, Equity and Loan investment totals are broadly comparable, with Equity slightly edging out Loan overall. Energy has the highest combined investment ($58.4B), driven more by Equity ($30.6B) than Loan ($27.8B). Agribusiness is the only industry where Loan investment ($29.9B) clearly exceeds Equity ($27.0B) |
| 4 | A | Which countries received more than $1,000M of IFC loan investment across their Active and Closed projects? | PASS | 23 countries, descending. Top: Brazil 2,373.3M. Threshold correctly read as 1,000 (millions), not 1e9. |
| 5 | A | Show the trend of IFC approved investment year-over-year. | PARTIAL | After 2013, Genie output doesn't align with the SQL results. Both show the same shape (dip in 2022-2023, rebound in 2024-2025, partial 2026), but Genie’s numbers are consistently lower than the SQL results.<br>Likely cause: The Genie chart is labeled “Excluding Dropped Projects”, and the query likely has no such filter. That fits 2013 matching, since there may be no dropped projects that early. It also fits the gap being small in 2026. Recent approvals are less likely to have been dropped yet. The gap being steady at ~$9-10B from 2016 on is a bit unusual for a status filter. It’s worth checking whether Genie also filters on something else, such as a project status, a missing-amount rule, or a different currency or amount column.<br>Checks:<br>1. Click “Show code” on the Genie output and compare its WHERE clause, amount column and date field to yours.<br>2. Run your query grouped by project status to see how many projects and how much USD sit in “Dropped” per year, then compare that to the gap above.<br>3. If dropped projects explain 2014 and 2018 but not 2020 (~12B gap), something else is also filtered.|
| 6 | B | What are the top performing regions by committed investment? Treat a project as committed once its agreements are signed, unless it was later Dropped. | FAIL | Ranking correct, two of three magnitudes wrong by 10x when rendering millions as billions. SSA reported as $10.2B vs actual $110.2B; LatAm $8.3B vs $83.1B; East Asia $74.4B correct. Data and SQL layers were accurate (753 projects matched exactly); the failure is in the natural-language rendering layer. Mitigation: Instructions now forbid any unit conversion. |
| 7 | B | List the 10 countries with the highest number of Active projects. | PASS | |
| 8 | B | Show the IFC investment split (Loan / Equity / Guarantee / Risk Management) for East Asia & Pacific, excluding Dropped projects. | PASS | |
| 9 | B | Which 10 WB Country Codes have the longest average time between approval and signing? Only include codes with at least 10 signed projects. | PASS | |
| 10 | C | For each industry, show the number of projects approved and the number first invested each year from 2020 to 2025. | PASS | |
| 11 | C | Show the average time taken between approval, signing and investment for each region. | PASS | |
| 12 | C | List Pending projects whose Projected Board Date has passed as of their As of Date but that have not yet been approved. | PASS | 237 rows, matching an independently written SQL count exactly. Date logic and the Pending-and-not-approved filter both correct. |
| 13 | D | [Challenge] Which Active projects have new renewable power generation as their main purpose? Show the count and approved amount by region. | PARTIAL | Prose reported 53 projects / $23.3B, but its own chart summed to ~$47.1B. Chart is close to the broad SQL tier ($51.1B); the prose figure is roughly half the chart. No structured "purpose" field exists, so the answer is a keyword band: broad 336 projects / $51.1B, strict tier is narrower. Delivered as a range with method stated, not a single number. |
| 14 | D | How many Summary of Proposed Investment documents were disclosed each year after 2020? | | |
| 15 | D | Which projects have an Environmental Category = A but are still Pending? Show the count and approved amount by region. | | |
| 16 | D | Find all projects with Document Type = Environmental & Social Review Summary, broken down by Environmental Category. | | |
| 17 | E | Show approved investment by Department for projects approved in the last 5 years. | | |
| 18 | E | Compare Product Line categories across regions, excluding Dropped projects. | PASS | |
| 19 | E | Which industries receive the largest risk management investments, and what share of each industry's investment is risk management? | PARTIAL | Genie’s output and its thought process match each other, but your SQL result doesn’t match either. The gap is consistent with the missing status != 'Dropped' filter. Your totals are about 8-10B higher for risk management and 36-39B higher for total product. That is what you’d expect if your query includes dropped projects. Your own shares are internally consistent (e.g., 39,226.1 / 148,570.5 = 26.4%).<br>The conclusions differ:<br>Risk mgmt ranking: Genie ranks Agribusiness 3rd, ahead of Manufacturing and Energy. In your table it is last. Agribusiness has the smallest dropped risk-management amount (about 8.2B vs. 9.6-10.5B for the others), so the filter moves it up.<br>Finance vs. Telecom share: Genie says Telecom leads by 1.2 points. Yours shows 0.5 points.<br>Spread: Genie’s 22.8-27.2% range is slightly wider than yours at 22.9-26.9%. The “no industry is dramatically over- or under-weighted” takeaway holds either way.<br>Minor issues in Genie’s text:<br>It says Telecom is “4.4 points above Energy and Agribusiness.” That is 4.4 for Energy and 4.3 for Agribusiness. status != 'Dropped' also excludes rows where status is NULL, because the comparison evaluates to NULL. Genie may be dropping more than just Dropped projects. Check with SELECT status, COUNT(*) FROM ifc.curated.portfolio GROUP BY status.<br>To confirm: add WHERE status != 'Dropped' AND industry IS NOT NULL to your query. If your totals then match Genie’s exactly, the filter is the full explanation. If they don’t, something else is different, such as NULL statuses or the table used.|
| 20 | E | Show the number of projects approved by each Department yearly from 2020 to 2025. | | |
| 21 | F | Find all Dropped projects with more than $250M originally approved investment. | PASS | 204 Dropped projects|
| 22 | F | List all Active projects whose first investment came more than 2 years after Board approval. | PASS | There are 7 Active projects where the gap between Board approval and first disbursement exceeded 2 years (730 days). The longest delay is Vani Capital Green Credit Line 2019 (Burkina Faso, Finance) at 958 days (~2.6 years), followed by Praven Bank Trade Finance (Nigeria, Finance) at 907 days. Five of the seven projects are in Sub-Saharan Africa, Middle East, or East Asia & Pacific, and the Finance industry appears three times in this list. |
| 23 | F | What percentage of projects are Active, Closed, Pending, and Dropped in each region? | PASS | Across most regions, the four statuses (Active, Closed, Pending, Dropped) are fairly evenly split at roughly 20–29% each, with no single status dominating any region.<br>Detailed percentage breakdown by region:<br>- East Asia & Pacific: Active 24.0%, Closed 28.2%, Dropped 24.8%, Pending 23.0%<br>- Europe & Central Asia: Active 24.6%, Closed 27.5%, Dropped 24.9%, Pending 22.9%<br>- Latin America: Active 25.1%, Closed 26.0%, Dropped 25.7%, Pending 23.3%<br>- Middle East: Active 21.6%, Closed 28.8%, Dropped 24.6%, Pending 25.0%<br>- South Asia: Active 28.4%, Closed 20.2%, Dropped 22.4%, Pending 29.0%<br>- Sub-Saharan Africa: Active 24.5%, Closed 25.2%, Dropped 24.6%, Pending 25.7%<br>- North America: Active 20.0%, Closed 20.0%, Pending 60.0% (no Dropped) — based on only 5 total projects, so this percentage split is not statistically meaningful and shouldn't be compared directly with the other regions.|
| 24 | G | [Challenge] What is the total new renewable generation capacity (MW) of Active and Closed projects, by region, and how many of these projects do not state a capacity? | | |
| 25 | G | [Challenge] Summarize IFC's financing for micro, small and medium enterprises, excluding Dropped: number of projects, approved amount, top 5 countries, main groups of businesses targeted. | | |
| 26 | G | [Challenge] Which projects' descriptions describe a different financing product than the one recorded in Product Line? Show the count by recorded Product Line and list the projects. | | |
| 27 | H | Show a bubble chart for the 15 countries with the highest approved investment (excluding Dropped): x = Loan, y = Equity, size = Total. | | |
| 28 | H | Which projects have a Board-approved total that differs from the sum of their product allocations by more than $1M? | | |
| 29 | H | List multi-product projects (more than one product with a non-zero allocation) and their totals. | | |
| 30 | H | Provide a heatmap of region vs industry based on total approved investment, excluding Dropped projects. | | |

## Ground truth verified

These figures were produced by the hand-written SQL in
`01_ws1_answers.sql` and are the reference values used to score Genie.
A query that reproduces them is trustworthy; one that does not is not.

| Measure | Value | Source |
|---|---|---|
| Countries above USD 1,000 million of loan (Active + Closed) | 23, top: Brazil 2,373.3 | Q4 |
| Committed investment total (signed, not Dropped) | USD 400,353.0 million | Q6 |
| Pending projects past their Projected Board Date | 237 | Q12 |
| Projects where approved total differs from product sum by over USD 1 million | 146 | Q28 |
| Multi-product projects | 1,000+ | Q29 |
| Distinct document_type | 2 values: Summary of Proposed Investment 3,592 / Environmental & Social Review Summary 1,408 | VALUE CHECK |
| Distinct environmental_category | A 1,645 / B 1,754 / C 1,601 | VALUE CHECK |
| Distinct product_line | Loan 1,214 / Equity 1,243 / Guarantee 1,306 / Risk Management 1,237 | VALUE CHECK |

Two of these are self-checking and need no external reference:

- `document_type`, `environmental_category` and `product_line` each sum to
  exactly 5,000 with no NULL, so the column is fully populated and the
  literal strings used in Q14, Q16, Q18 and Q26 are exact matches.
- Each row of Q23 must sum to 100.0 across the four status percentages.

## Questions that need a known ground truth first

Several questions cannot be judged without an independently computed answer.
These are checked against hand-written SQL before the Genie output is accepted:

| # | Why | Ground truth |
|---|-----|--------------|
| 1 | checks the 5-year window and the loan column | pending |
| 23 | checks that status mix sums to 100% per region | pending |
| 28 | same definition as `product_total_diff_usd_mm` | 146 projects - confirmed |
| 21 | threshold is USD millions, not dollars | pending |
