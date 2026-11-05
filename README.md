# BTA-Accenture-Case-Comp

## Workstream 1: how to run

Run in this order. Each script is safe to re-run.

| Step | Script | Result |
|---|---|---|
| 1 | `00_setup/00_config.sql` | Catalog `ifc`, schemas `raw`, `curated`, `analytics`, and the landing volume |
| 2 | `01_data/01_load_and_prepare.sql` | `ifc.curated.projects`, `monitoring`, `portfolio` |
| 3 | `01_data/02_data_quality_checks.sql` | `ifc.curated.data_quality_checks` |
| 4 | `01_data/03_add_comments.sql` | Table and column comments for Genie |
| 5 | `01_data/04_analytics_layer.sql` | `ifc.analytics.config_params`, `ifc.analytics.projects_excl_dropped`, `ifc.analytics.project_text_flags` |
| 6 | `04_answers/ws1/01_ws1_answers.sql` | All 30 questions in one runnable file, one block per question, each safe to run on its own |

Every answer reads `ifc.curated.portfolio`, the project table joined to monitoring. One read surface for WS1, WS2 and WS3, so no two answers can disagree because they read different tables. `ifc.curated.projects` and `monitoring` remain the inputs; the join is one to one, 5,000 rows either way, so questions that do not need monitoring return the same figures from either table.

## Assumptions register

Where the questions or the data are ambiguous, these rules are applied in every answer. Each answer file lists the IDs it depends on.

| ID | Rule | Effect on figures |
|---|---|---|
| A-01 | **A project is approved when `approval_date` is not NULL. Status is not used to decide this.** The data dictionary says the approval date is blank only if the project is not yet approved. Status decides only the status questions (Q15, Q23). Used by Q1, Q5, Q9, Q10, Q12, Q17, Q20, Q22. | 663 Pending projects have an approval date and count as approved. They are 663 of the 1,595 projects in Q1's window, with $21.1B of its $52.4B loan total. Deciding by status instead would make Q1 $31.3B and Q12 889 rows instead of 237. |
| A-02 | `project_url` is the only project key. `project_number` is display only and is never used to join, group or deduplicate. | 1,126 project numbers are shared across 2,567 unrelated projects. |
| A-03 | Reference date is the latest As of Date, 2026-06-30 (`ifc.analytics.config_params`). "Last 5 years" means `approval_date` after 2021-06-30 and up to 2026-06-30. Q10 and Q20 use the fixed calendar years 2020 to 2025. Q12 compares each row's own As of Date. | Answers do not change with the day they are run. 2026 is a partial year (approvals run to 2026-06-27). |
| A-04 | "Excluding Dropped" is applied once, through the view `ifc.analytics.projects_excl_dropped`. Q1 and Q17 do not say "excluding Dropped", so they include Dropped projects that have an approval date (Q1 also shows the alternative). | Q3, Q8, Q18, Q25, Q27 and Q30 read the view. |
| A-05 | Committed (Q6) means `signed_date` is not NULL and status is not Dropped, as the question states. | Includes 191 Pending projects that have a signed date. |
| A-06 | "After 2020" in Q14 means 2021 onward. Only Summary of Proposed Investment documents are counted. | Each project has one document, so no deduplication is needed. 2026 is partial (disclosures to 2026-04-29). |
| A-07 | The approved amount is `total_approved_usd_mm`. Questions about the product split (Q8, Q19, Q29) use the four product columns. | For 146 projects the approved total differs from the product sum by more than $1M (Q28 lists them). |
| A-08 | Region labels follow the data dictionary: Latin America, Middle East, and North America (5 rows, kept as is). | 43 rows were renamed from the long variants. |
| A-09 | Rankings keep ties at the cutoff. | A top 10 can return more than 10 rows. |
| A-10 | Dates are kept as recorded. Intervals that are negative are not corrected. | 37 projects were signed before approval. Q9 reports how many fall in each country code. |
| A-11 | Q13, Q24, Q25 and Q26 use fixed pattern rules over Project Description (`ifc.curated.project_text_flags`). Missing capacity is never imputed. | These four answers require human review. Hand-label about 50 descriptions and report the agreement. |
| A-12 | Projects without an approval date show their proposed amount in `total_approved_usd_mm`. | 570 Pending and 494 Dropped projects. Q15 and Q21 show which rows were Board-approved. |
| A-13 | `product_line` is the recorded principal product. Allocation columns are used for amounts. | Q26 compares the recorded product with the one named in the description. |
