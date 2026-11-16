# Before you record: workspace setup

For whoever records the demo. No coding needed. Work through it in order; every
step says what you should see.

About one hour in total. The first 45 minutes is setup and nothing is recorded.
Recording starts at section 8 and takes about 20 minutes.

---

## Three rules that matter more than the rest of this page

**1. Never press Run All in the notebook.** It makes 19 model calls and takes
30-45 minutes, and it can use up the trial credit before you have recorded
anything. Section 6 runs 17 cells instead, about 5 minutes.

**2. Get everything working before you start recording.** Recording is scrolling
and reading aloud. Do not let the model run on camera: one answer takes 20-40
seconds and that is 20-40 seconds of blank footage.

**3. Check every "you should see" line.** If it does not match, stop and ask.
Every step depends on the one before it.

---

## 1. What you need

| Need | Note |
|---|---|
| A Databricks account | Register a free trial with an email that has **not** started a Databricks trial before. An account that already used its trial will let you log in and then refuse to run anything. |
| Two CSV files | Ask Jimmy for `synthetic_ifc_projects_5000.csv` (2.3 MB) and `synthetic_project_monitoring.csv` (358 KB). They are case material, so they are deliberately not in the repository. |
| Repository link | `github.com/sherryLxyy/BTA-Accenture-Case-Comp`. Public, no token needed. |
| Time | About one hour, without closing the browser. |

After registering, open the workspace once and check that your email appears in
the top corner. If it does not, the account is not active yet; fix that first.

---

## 2. Build the environment (about 10 minutes, not recorded)

### 2.1 Create a SQL warehouse

Left sidebar -> **SQL Warehouses** -> **Create** -> choose **Serverless** or
**2X-Small** -> Create.

Wait for the state to turn green and say Running, about 1-2 minutes. Every SQL
step and the notebook run on it.

**Stop it when you are done.** A warehouse that is merely running consumes
credit. The Stop button is on the SQL Warehouses page.

### 2.2 Create the catalog, schemas and volume

Left sidebar -> **SQL Editor** -> new query.

Paste the whole of `00_setup/00_config.sql` from the repository, select all,
press **Run**.

**You should see:** no error. The file is five independent statements (one
catalog, three schemas, one volume), so the editor may show only the last
result or all five as `OK`. Either is fine. An error is not.

If it complains that there is no warehouse, pick the one you just created in the
dropdown at the top right.

### 2.3 Upload the two CSVs

Left sidebar -> **Catalog** -> click `ifc` -> click `raw` -> the **Volumes** tab
-> click `raw_files` -> **Upload to this volume**.

Drag both CSVs in and wait for the upload to finish.

> The `raw_files` volume is what `00_config.sql` created in the previous step. If
> you cannot see `ifc` in Catalog, step 2.2 did not succeed. Go back.

**You should see:** two files inside `raw_files`, with the right names and sizes.

### 2.4 Confirm

In the SQL editor:

```sql
LIST '/Volumes/ifc/raw/raw_files/'
```

**You should see:** two files. The file names must match exactly; the next step
reads them by name.

---

## 3. Attach the repository (about 3 minutes, not recorded)

Left sidebar -> **Workspace** -> click your own email -> **Create** in the top
right -> **Git folder**.

Paste the repository link and press Create.

> Do **not** create it inside `Groups`. That is a reserved Databricks folder. It
> fails with `Folder Groups is protected`, and the error looks like a clone
> failure when it is really a location problem.

**You should see:** a folder called `BTA-Accenture-Case-Comp` containing
`00_setup`, `01_data`, `02_agent`, `04_answers` and `README.md`.

---

## 4. Run the SQL (about 20 minutes, not recorded)

In this order, one file at a time. For each: open it, select all (Cmd+A), **Run**.

| Order | File | You should see |
|---|---|---|
| 1 | `00_setup/00_config.sql` | no errors (done in 2.2, skip) |
| 2 | `01_data/01_load_and_prepare.sql` | **5,000 / 3,768 / 5,000 / 1,232** |
| 3 | `01_data/02_data_quality_checks.sql` | a `data_quality_checks` table |
| 4 | `01_data/03_add_comments.sql` | a series of OK, no errors |
| 5 | `01_data/04_analytics_layer.sql` | three tables created |
| 6 | `04_answers/ws1/01_ws1_answers.sql` | 30 questions, 36 result blocks |
| 7 | `04_answers/ws2/01_ws2_answers.sql` | 7 result blocks, 95 and 3,311.72 among them |
| 8 | `04_answers/ws3/01_ws3_client_analysis.sql` | 6 blocks, builds `client_portfolio`, **400 rows** (399 clients plus one empty client) |
| 9 | `04_answers/ws3/02_ws3_shortlist.sql` | 6 blocks, builds `client_score`, also **400 rows**, the empty client ranks first on growth |
| 10 | `04_answers/ws3/03_ws3_finalists.sql` | 6 blocks, replaces `client_score`, **399 rows**, names the four clients |

**The four numbers after step 2 must match.** If they do not, the CSVs were not
read correctly. Stop and re-upload; do not continue. Every number afterwards
sits on top of those four.

If the editor says it can only run one statement at a time, run the file block
by block using the `/* --- ... --- */` separators. Slower is fine; none of this
is recorded.

### Two traps

**Do not stop at `02_ws3_shortlist.sql`.** It and `03_ws3_finalists.sql` both
write `ifc.analytics.client_score`, and the third **silently replaces** the
second. Stopping at 02 gives you 400 rows and an answer built on the wrong
population: a client row with no client attached, carrying USD 187,440 million,
ranked first on growth. **Run both, in order.**

**Do not run `05_grant_reviewers.sql`.** It grants access to the four named
reviewers. It contains their hard-coded emails, so on your account every
statement fails, and the demo does not need it.

### One last check

```sql
SELECT COUNT(*) FROM ifc.analytics.client_score
```

**It must be 399.** If it is 400, you ran 02 but not 03. Go back.

---

## 5. Build the Genie space (about 10 minutes, not recorded)

Left sidebar -> **Genie** -> **New**. Name it `IFC Portfolio Analyst` and pick
the warehouse you created.

**Add one table: `ifc.curated.portfolio`.** Nothing else.

Do not add `client_score`. The client question is answered by the
`recommend_clients` tool in the notebook, not by Genie. Having both gives the
same question two different answers, and a reviewer sees the disagreement before
they see the reasoning.

### Instructions (paste the whole block)

```
This space holds one table, ifc.curated.portfolio. All amounts are already in
USD millions - never multiply by a million.

1. Every answer reads ifc.curated.portfolio. Do not query another table.
2. project_url is the only unique key. project_number repeats across unrelated
   projects (1,126 values map to more than one) and must never be used for
   JOIN, GROUP BY or deduplication.
3. performance_status is NULL for exactly the 1,233 Pending projects. NULL
   means not yet monitored, never evidence of good performance.
4. The 1,232 Dropped projects have no monitoring row at all, so
   performance_status IS NOT NULL quietly excludes USD 187,440 million of
   approved investment. State the exclusion whenever that filter is applied.
5. Past Due is 91 projects and Watchlist is 164 across all categories.
   Category A narrows that to 35 and 60. The category filter is part of the
   Board question, not an optional cut.
6. For "the last N years", anchor on approval_date and say which window was used.
7. If the result is truncated, say so and do not total or rank the rows shown.
```

### Check it with these four questions

None of the four depends on a date window, so the answers must be exact:

| Ask | Answer |
|---|---|
| How many projects are in the portfolio? | **5,000** |
| How many projects have status Dropped? | **1,232** |
| How many projects are Past Due, and how many are Watchlist? | **91 / 164** |
| For Category A projects that are Past Due or Watchlist, how many projects and how much disbursed? | **95 / 11,447.52** |

All four correct means the table is attached, the comments were read, and the
units are right. None of this is recorded.

Do not self-check with a "last five years" question. Genie anchors the window on
today, while our SQL anchors it on `MAX(as_of_date)` in the data. The two differ
by months, so the numbers will not match. That is expected and does not mean the
space is misconfigured.

### Put the space id into the notebook

Open `02_agent/build_agent.ipynb` and search for `GENIE_SPACE_ID`. The id is the
long string in your browser address bar after `/genie/rooms/`, something like
`01f1e0b95dd81634986239ff0a1bd9c4`.

**It appears in two cells. Change both.** If you change only one, the other
overwrites it with the stale value, and the failure looks like a permissions
problem rather than a half-finished edit.

---

## 6. Run the agent (about 5 minutes, not recorded)

Open `02_agent/build_agent.ipynb`. The comment at the top of the first cell is
the same list as below.

**Run only these 17 cells**, in this order. Use **Cmd+Enter** to run the current
cell and stay in place. Shift+Enter moves to the next cell and it is easy to skip
one by accident.

The notebook has no visible cell numbers. Use **Cmd+F** and search for the string
in the middle column. Each one occurs exactly once in the file, except where
noted.

| # | Find it by | Note |
|---|---|---|
| 1 | first cell at the top, `%pip install` | you **must** restart Python afterwards |
| 5 | search `GENIE_SPACE_ID`, **first hit** | the id you just pasted |
| 6 | search `GENIE_SPACE_ID`, **second hit** (same cell has `def query_portfolio`) | the Genie tool |
| 10 | search `def calculate_credit_risk` | the WS2 tool |
| 15 | search `DatabricksOpenAI` | the model client |
| 17 | search `MODEL =` | **really asks the model one question**; if you get an answer, the endpoint works |
| 27 | search `"name": "query_portfolio"` | the tool list |
| 28 | search `def execute_agent_tool` | tool dispatch |
| 29 | search `This is the newest version` | the agent loop itself |
| 32 | search `SYSTEM_PROMPT = """`, **second hit** (the first is in cell 28) | the system prompt |
| 63 | search `12. Do not generalise` | appends the twelfth rule to the prompt |
| 79 | search `WS3_RECALC_SQL` | the WS3 recalculation SQL |
| 80 | search `def ws3_reconcile` | reconciliation |
| 81 | search `Recalculate from the portfolio using the team` | the recommend_clients that is actually used |
| 82 | search `Replace only the WS3 registration` | swaps the WS3 tool registration |
| 83 | search `ECL scope carried on every row` | **no model call**, just prints the shortlist |
| 84 | search `ANSWER AUDIT` | **the one model call that produces the answer** |

**If any cell raises `NameError`**, a cell above it was skipped or run out of
order. Go back to the list in cell 1 and work down it again. Do not continue.

### Cell 1: restart Python after the install

After `%pip install` finishes, use the menu **Run -> Restart Python**, then
continue from cell 5.

Without the restart the package is installed but invisible to the process, and
cell 6 fails with `ImportError`. Run All does not restart the interpreter, which
is why this has to be manual.

### If cell 17 fails

If it reports `endpoint not found` or similar, the account does not serve
`databricks-gpt-oss-120b`. Run the cell that contains `serving_endpoints.list`
to see what the account does serve, then put one of those model names into
`MODEL = "..."` and try again.

Do not go past this point until cell 17 returns an answer. Everything after it
depends on it.

### Cell 83 should print

```
== continue_investing (2 rows) ==
== review_shortlist (8 rows) ==
```

**Two to invest, eight to watch.** The eight are the pool the model chooses from;
the final answer names two.

### Cell 84 should print

A written analysis of four clients, one at a time, then:

```
==========================================================================
ANSWER AUDIT
==========================================================================
  PASS   scope, floor, thresholds, ratios, rankings
==========================================================================
```

**It must say PASS.** If it says FAIL, send me the FAIL line and stop there.

---

## 7. Confirm the output is still on the page (1 minute, easiest to forget)

Before recording, scroll back and check that cells 83 and 84 have output
underneath them. Without output the recording is a blank screen.

Leave the notebook open. Leave the browser tab open. Databricks keeps the output
on the page until the workspace reclaims it.

---

## 8. Record (about 20 minutes)

Follow the shot list in `03_demo/00_video_script.md`. Five of the ten shots are
still images and five are live screens, and every live one has a STILL fallback.

| Time | What is on screen | Where |
|---|---|---|
| 0:00 | architecture diagram | `assets/architecture_diagram_agentic_solution.png` |
| 0:13 | the data quality note, section P1 | `docs/数据质量备忘.md` |
| 0:35 | same document, the duplicated-number example | same |
| 0:43 | section P6, the 1,232 figure visible | same |
| 1:04 | Catalog tree, `ifc` expanded to three schemas | Catalog -> `ifc` |
| 1:20 | the tool definitions | cell 27, and the third is added by cell 82 |
| 1:35 | the four-client table | output of cell 84 |
| 1:58 | the eight-row shortlist | output of cell 83 |
| 2:07 | the ANSWER AUDIT PASS line | bottom of cell 84's output |
| 2:37 | back to the diagram, fade out | same as 0:00 |

The narration says three tools because that is what the answer path registers:
`query_portfolio` in cell 6, `calculate_credit_risk` in cell 10, and
`recommend_clients`, added by cell 82. The notebook also defines a fourth,
`analyze_client_risk`, in cells 38 and 41, but those are not among the 17 and the
answer does not use it. If you show cell 27 on camera, expect **two** names on
screen rather than three: the third only arrives at 82.

### Three things before you press record

**Pace.** The script is 406 words, written for 150 words a minute, which is 2:42.
Slower at 140 is 2:54, still inside three minutes. Do not rush it.

**Numbers.** The script ends with a pronunciation table. Follow it. In
particular 1,232 is "twelve hundred and thirty-two", not "one thousand two
hundred".

**Read the last section of the script before you start.** It lists three things
not to say. Those are the three most likely to be challenged in questions.

### If a live shot will not cooperate

You do not have to shoot everything live. The Catalog tree, the four-client
table, the shortlist and the audit block can all be screenshots dropped into the
edit. What you must **not** do is type the audit block by hand or otherwise make
output look like something the agent produced when it did not.

---

## 9. If something goes wrong

| Symptom | Cause | Fix |
|---|---|---|
| `Folder Groups is protected` | Git folder created inside `Groups` | recreate it one level up, under your own email |
| `ifc` is not in Catalog | `00_config.sql` did not run | back to 2.2 |
| no files in the volume | upload did not finish, or a wrong file name | back to 2.3; names must match exactly |
| step 2 gives 5,638 rows instead of 5,000 | line breaks inside the CSV were read as new rows | `multiLine` did not apply; re-run the whole file, not part of it |
| `client_score` has 400 rows | ran 02 but not 03 | back to section 4, step 10 |
| `ImportError: databricks_openai` | Python was not restarted after `%pip` | Run -> Restart Python |
| space not found, or a permissions error | only one of the two `GENIE_SPACE_ID` cells was changed | change both to the same new id |
| `endpoint not found` | the account does not serve that model | run the `serving_endpoints.list` cell and pick one it does serve |
| `NameError` | an earlier cell was skipped | work down the list in cell 1 again |
| cell 84 says FAIL | the model said more than the payload supports | send me the FAIL line; do not edit the script |

---

## When you are done

1. **Stop the SQL warehouse** (SQL Warehouses -> your warehouse -> Stop).
2. Send Jimmy the raw video file. Do not edit it.
3. If you had to switch accounts partway through, sections 5 and 6 have to be
   redone, because the Genie space id is tied to the workspace.
