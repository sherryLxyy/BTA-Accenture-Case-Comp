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
| 1 | A | Show the total IFC loan investment by region for projects approved in the last 5 years. | | |
| 2 | A | List the top 10 projects by Total IFC investment as approved by the Board. | | |
| 3 | A | Compare Equity vs Loan investment across industries, excluding Dropped projects. | | |
| 4 | A | Which countries received more than $1,000M of IFC loan investment across their Active and Closed projects? | PASS | 23 countries, descending. Top: Brazil 2,373.3M. Threshold correctly read as 1,000 (millions), not 1e9. |
| 5 | A | Show the trend of IFC approved investment year-over-year. | | |
| 6 | B | What are the top performing regions by committed investment? Treat a project as committed once its agreements are signed, unless it was later Dropped. | FAIL | Ranking correct, two of three magnitudes wrong by 10x when rendering millions as billions. SSA reported as $10.2B vs actual $110.2B; LatAm $8.3B vs $83.1B; East Asia $74.4B correct. Data and SQL layers were accurate (753 projects matched exactly); the failure is in the natural-language rendering layer. Mitigation: Instructions now forbid any unit conversion. |
| 7 | B | List the 10 countries with the highest number of Active projects. | | |
| 8 | B | Show the IFC investment split (Loan / Equity / Guarantee / Risk Management) for East Asia & Pacific, excluding Dropped projects. | | |
| 9 | B | Which 10 WB Country Codes have the longest average time between approval and signing? Only include codes with at least 10 signed projects. | | |
| 10 | C | For each industry, show the number of projects approved and the number first invested each year from 2020 to 2025. | | |
| 11 | C | Show the average time taken between approval, signing and investment for each region. | | |
| 12 | C | List Pending projects whose Projected Board Date has passed as of their As of Date but that have not yet been approved. | PASS | 237 rows, matching an independently written SQL count exactly. Date logic and the Pending-and-not-approved filter both correct. |
| 13 | D | [Challenge] Which Active projects have new renewable power generation as their main purpose? Show the count and approved amount by region. | PARTIAL | Prose reported 53 projects / $23.3B, but its own chart summed to ~$47.1B. Chart is close to the broad SQL tier ($51.1B); the prose figure is roughly half the chart. No structured "purpose" field exists, so the answer is a keyword band: broad 336 projects / $51.1B, strict tier is narrower. Delivered as a range with method stated, not a single number. |
| 14 | D | How many Summary of Proposed Investment documents were disclosed each year after 2020? | | |
| 15 | D | Which projects have an Environmental Category = A but are still Pending? Show the count and approved amount by region. | | |
| 16 | D | Find all projects with Document Type = Environmental & Social Review Summary, broken down by Environmental Category. | | |
| 17 | E | Show approved investment by Department for projects approved in the last 5 years. | | |
| 18 | E | Compare Product Line categories across regions, excluding Dropped projects. | | |
| 19 | E | Which industries receive the largest risk management investments, and what share of each industry's investment is risk management? | | |
| 20 | E | Show the number of projects approved by each Department yearly from 2020 to 2025. | | |
| 21 | F | Find all Dropped projects with more than $250M originally approved investment. | | |
| 22 | F | List all Active projects whose first investment came more than 2 years after Board approval. | | |
| 23 | F | What percentage of projects are Active, Closed, Pending, and Dropped in each region? | | |
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
