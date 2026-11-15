# BigBang - Forward Deployed: Agentic Innovation Challenge

Accenture x BTA, submission for **Team BigBang**.

A working analysis of a synthetic IFC portfolio: 5,000 projects, 399 clients,
USD 742.6 billion approved, as of the 2026-06-30 snapshot. Three workstreams,
one agent, and a set of findings that a Board can act on without asking how
the numbers were produced.

---

## What is in here

| Folder | What it holds |
|---|---|
| `00_setup/` | Environment bootstrap and the reviewer access grants |
| `01_data/` | Load, data quality checks, column comments, derived analytics layer |
| `02_agent/` | The agent notebook: three tools, orchestrator, guardrails, evaluation |
| `03_demo/` | Demo materials |
| `04_answers/` | WS1 (30 questions), WS2 (Board risk question), WS3 (client recommendation) |
| `assets/` | Architecture diagram, generated from `assets/_build_arch.py` |

---

## The architecture

![Architecture](assets/architecture_diagram_agentic_solution.png)

Four lanes, and the line that matters is the one through `ifc.curated`. Two raw
CSVs land in a volume, become three Delta tables, and every question in WS1,
WS2 and WS3 reads the same joined table. A question cannot disagree with
another question because the two read different sources.

`ifc.analytics` is where derived judgement lives: regex text flags, the client
roll-up, and the percentile scores behind WS3. Everything above it is
reproducible SQL; everything below it is the raw file untouched.

---

## The headlines

**Two thirds of the approved capital has never been drawn.** Of USD 742.6
billion approved, USD 296.7 billion is disbursed and USD 445.9 billion is not.
Forty-two per cent of that undrawn balance, USD 187.4 billion, sits in 1,232
projects that are still Pending and have no client assigned at all. The
capital is not stuck in a relationship that has gone bad; it is stuck before a
relationship exists.

**Default is concentrated, and the clean names are scarce.** Above a
materiality floor of USD 5,000 million approved there are 18 clients holding
28.5% of the client-attached book. Only **three** of them carry no Past Due project, no
Watchlist project and no exit at a loss. The recommendation names two of those
three for growth and two impaired names for action.

**Category A carries more loss than its share of capital.** Category A projects
are 38.8% of impaired disbursed capital and 43.6% of expected credit loss. The
ratio is 1.12, not the multiple the raw ECL figures suggest. The gap is small
but it is in the direction the Board cares about.

---

## WS2 - the Board risk question

Scope is Category A, as the question requires.

| Population | Projects | Disbursed | Expected credit loss |
|---|---|---|---|
| **Category A (question scope)** | 95 | 11,447.52 | **3,311.72** |
| All projects (sensitivity) | 255 | 29,509.43 | 7,596.21 |

ECL is 60% of the disbursed balance of Past Due projects. Watchlist projects
carry no provision, because the case brief says the provision covers losses on
those that are Past Due. Reading Watchlist into the calculation would add a
provision the question does not ask for.

The second row is the honest context: restricting to Category A removes 56% of
the expected loss. A reader who only sees the first row will underestimate the
book by USD 4,284 million.

---

## WS3 - the four clients

| | Client | Action | Approved | Undisbursed |
|---|---|---|---|---|
| 1 | **Rosar Telecom Holdings** | Continue to invest | 6,283 | 2,704 |
| 2 | **Zansorzen Renewables Corp** | Continue to invest | 5,040 | 2,176 |
| 3 | **Wenhargal Renewables Corp** | Reduce exposure | 5,544 | 2,058 |
| 4 | **Bricor Finance Group** | Place under review | 6,156 | 2,708 |

The full reasoning, the scoring method and the defence of each name is in
`04_answers/ws3/README.md`. Three points belong here:

- The two sides hold almost the same capital and are nothing alike in quality.
  The growth pair carries no provision; the review pair carries 18.3% of the
  portfolio's expected loss on 1.6% of its approved value.
- The two reduction names are **not** a ranking of equal things. Wenhargal is a
  realised loss already on the books, with one project exited at a loss. Bricor
  is a deterioration still on the Watchlist with nothing yet written off. One
  name says where the loss is, the other where it is forming.
- A client that has already lost money cannot be a growth story. The growth
  list therefore requires a completely clean record, which is why it has only
  three names rather than ten.

---

## Before step 1

Two CSV files are needed, and neither is in this repository, because they are
case material rather than team output:

| File | Rows | Destination |
|---|---|---|
| `synthetic_ifc_projects_5000.csv` | 5,000 | `/Volumes/ifc/raw/raw_files/` |
| `synthetic_project_monitoring.csv` | 3,768 | `/Volumes/ifc/raw/raw_files/` |

Step 1 creates the catalog, the three schemas and that volume. Upload the two
files into it before step 2, either through **Catalog > ifc > raw > raw_files >
Upload** or with `databricks fs cp`. Nothing else in the repository refers to a
path outside `ifc`, so the pipeline lands on any workspace without edits.

---

## How to run it

Run in this order. Each script is safe to re-run.

| Step | Script | Result |
|---|---|---|
| 1 | `00_setup/00_config.sql` | Catalog `ifc`, schemas `raw`, `curated`, `analytics`, landing volume |
| 2 | `01_data/01_load_and_prepare.sql` | `projects` (5,000), `monitoring` (3,768), `portfolio` (5,000) |
| 3 | `01_data/02_data_quality_checks.sql` | `ifc.curated.data_quality_checks` |
| 4 | `01_data/03_add_comments.sql` | Table and column comments for Genie |
| 5 | `01_data/04_analytics_layer.sql` | `config_params`, `projects_excl_dropped`, `project_text_flags` |
| 6 | `04_answers/ws1/01_ws1_answers.sql` | All 30 questions, one block per question |
| 7 | `04_answers/ws2/01_ws2_answers.sql` | Two Board answers plus the sensitivity |
| 8 | `04_answers/ws3/01` then `02` then `03` | `client_portfolio`, then `client_score`, then the four names. Run all three: see the note below. |
| 9 | `00_setup/05_grant_reviewers.sql` | Catalog, schema and volume grants for the four reviewers |

Every answer reads `ifc.curated.portfolio`, the project table joined to
monitoring. One read surface for all three workstreams, so no two answers can
disagree because they read different tables. `projects` and `monitoring` remain
the inputs; the join is one to one on `project_url`, 5,000 rows either way.

**Checkpoint after step 2.** The four counts must be 5,000 projects, 3,768
monitoring rows, 5,000 portfolio rows and 1,232 unmatched. The monitoring file
covers only projects that reached a client, which is why the third number is
the whole book and the second is not.

**Steps 1 to 8 are SQL and run anywhere.** Step 9 adds the four named reviewers
to the workspace and will fail anywhere they do not exist; skip it unless you
are setting up the competition workspace itself.

**Do not stop at step 8's second file.** `02_ws3_shortlist.sql` and
`03_ws3_finalists.sql` both write `ifc.analytics.client_score`, and the third
silently replaces the second. That is deliberate - the second file is the first
pass and the third is its correction - but it means a reader who stops early
gets a complete, plausible answer built on the wrong population.

The first pass scores every client including the 1,232 projects with no
`client_id`. Those projects are Pending, so their `performance_status` is also
NULL, which reads as perfectly clean. A null client carrying USD 187,440
million of approved investment therefore ranks first on growth. The third file
excludes them and recomputes the percentiles against the 399 real clients. The
correct `client_score` has 399 rows.

---

## Running the agent

`02_agent/build_agent.ipynb` is the only notebook in the repository, and it is
the only part that needs more than a SQL warehouse. Three things must exist in
the workspace that runs it:

| Need | Locate by | Note |
|---|---|---|
| A Genie space | search `GENIE_SPACE_ID` | Defined in two adjacent cells near the top; set both. The ID in the file belongs to our workspace and will not resolve in yours. Build the space as described below and paste its ID. |
| A chat-completion endpoint | search `MODEL =` | Set to `databricks-gpt-oss-120b`. Any serving endpoint that speaks the chat API will do; change the constant. |
| `databricks-openai` | the `%pip` cells | After `%pip` use **Run > Restart Python**, then continue. Run All does not restart the interpreter, so the import fails on a cold start. The client cell falls back to the workspace credentials if the package is absent. |

The four tools read `ifc.curated.portfolio` and `ifc.analytics.client_score`, so
steps 1 to 8 must have completed. Beyond the three items above, the notebook has
no dependency on our workspace. The notebook decides which tool to call; it
does not compute any figure itself.

### Building the Genie space

The space is part of the answer surface, not a convenience. `query_portfolio`
passes the model's question straight through and returns whatever SQL Genie
wrote, so whichever tables the space holds become tables the agent can answer
from.

**Add `ifc.curated.portfolio` and nothing else.** Not `projects`, not
`monitoring`, and not `analytics.client_score`. `client_score` is what the
`recommend_clients` tool reads; putting it in the space too gives the model two
paths to the same client question that round differently, and the reviewer sees
the disagreement before they see the reasoning.

**Run step 4 first.** `01_data/03_add_comments.sql` writes the table and column
comments, and Genie reads those comments as business semantics. Without them the
space guesses that amounts are in dollars and that `project_number` is a key.
On top of the comments, add these rules to the space instructions:

1. Every answer reads `ifc.curated.portfolio`. Do not query another table.
2. Amounts are already USD millions. Never multiply by a million to report USD.
3. `project_url` is the only unique key. `project_number` repeats across unrelated
   projects (1,126 values map to more than one) and must never be used for JOIN,
   GROUP BY or deduplication.
4. `performance_status` is NULL for exactly the 1,233 Pending projects. NULL means
   not yet monitored, never evidence of good performance.
5. The 1,232 Dropped projects have no monitoring row at all, so
   `performance_status IS NOT NULL` quietly excludes USD 187,440 million of
   approved investment. State the exclusion whenever that filter is applied.
6. `Past Due` is 91 projects and `Watchlist` is 164 across all categories.
   Category A narrows that to 35 and 60. The category filter is part of the Board
   question, not an optional cut.
7. For "the last N years", anchor on `approval_date` and say which window was used.
8. If the result is truncated, say so and do not total or rank the rows shown.

**Sample questions to validate the space on creation:**

- How many projects are in the portfolio?
- What is total approved investment by region for projects approved in the last five years?
- For Category A projects, how much disbursed capital is Past Due or Watchlist?
- Which countries have more than USD 1,000 million of approved loan investment?

Every one of them should come back with SQL that reads only
`ifc.curated.portfolio`. A sample question that fails means a missing comment or
a missing grant, not a missing instruction.

**The notebook is checked in without output.** Its last execution happened in a
workspace that is no longer reachable, and the stored outputs went with it.
This does not affect reproducibility: every number in `04_answers/` comes from
the SQL in steps 1 to 8 and is regenerated by running them.

---

## Assumptions register

Where the questions or the data are ambiguous, these rules are applied in every
answer. Each answer file lists the IDs it depends on.

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

---

## What this analysis does not do

**The client view covers 74.8% of approved value.** 1,232 of 5,000 projects
carry no `client_id`. They are Pending, and their performance status is also
NULL, which means a naive scoring pass treats them as perfectly clean and puts
an unlabelled row with USD 187.4 billion approved at the top of the growth
ranking. The client analysis excludes them explicitly and says so on every
page. It covers 3,768 projects and USD 555.1 billion.

**The scores are relative, not absolute.** `attention_score` and `growth_score`
are weighted percentile ranks across 399 clients. They answer "how does this
client compare with the rest of the book", not "what is the probability of
default". A score of 90 is not 90% of anything.

**ECL is the case's rule, not a credit model.** A flat 60% of the Past Due
disbursed balance. No PD, no LGD, no recovery assumption, no discounting. It is
the right number for the question asked and the wrong number for capital
planning.

**Everything is a point in time.** One snapshot, 2026-06-30. No trends, no
vintages, no migration between rating bands.

**Four WS1 answers rest on pattern matching.** Q13, Q24, Q25 and Q26 read
Project Description with fixed regex rules. They are labelled for review, and
the agreement rate against a hand-labelled sample is not yet measured.

---

## Reproducing this

The pipeline was rebuilt from the two raw CSVs in a fresh workspace on
2026-11-13, after the original workspace ran out of credits. Every headline
figure reproduced to the cent: WS2 Category A exposure of USD 11,447.52 million
and expected credit loss of USD 3,311.72 million are identical to the first
run, and so are the four WS3 clients.

Nothing in the reported figures depends on workspace state, on who ran the
query, or on the day it was run. The date window is pinned to the snapshot
rather than to `CURRENT_DATE`, which is why a rerun in December returns the
same numbers as a rerun in November.

`04_answers/ws1/02_q1_window_reconciliation.sql` shows what happens when that
discipline is not applied: the calendar-year window and the snapshot window
differ by 171 projects and USD 5,944 million on Q1 alone.

---

## Reviewer access

The four reviewers named in the Submission Access Checklist are granted
workspace admin and, separately, `USE CATALOG`, `USE SCHEMA` and `SELECT` on
`raw`, `curated` and `analytics`, `READ VOLUME` on the landing volume, and
`Can use` on the SQL warehouse. `00_setup/05_grant_reviewers.sql` holds the SQL
half of that; the workspace, warehouse and Genie steps are UI actions and are
listed at the foot of the same file.

Genie is shared only after the table grants are in place, because Genie answers
with each user's own data permissions. Sharing the space first produces a
permission warning on every question.
