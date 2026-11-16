# IFC Data Quality Review Memo

> Based on measured results from the two source CSVs (not guesses). Each item should become an explicit rule in `01_data`, and the answers should state its effect on the numbers.
> Maps to scoring items: **Data Quality, 15 points** + **Forward Deployed mindset, 10 points** ("awareness of data-quality issues and how they affect answers").

---

## 1. True grain (the first thing to agree on)

| Table | Rows | True uniqueness | Conclusion |
|---|---|---|---|
| Project Portfolio | 5,000 | `Project Url` is **5,000 unique**; `Project Number` is only **3,559 unique** | **One row = one project** |
| Project Monitoring | 3,768 | `Project Url` is **3,768 unique**; `Project Number` is only **2,918 unique** | **One row = one project's monitoring record** |

`Document Type` distribution: Summary of Proposed Investment 3,592 / Environmental & Social Review Summary 1,408. Each project discloses only **one** document type, so this is not duplication.

**Conclusion**: `Project Url` is the only trustworthy identifier. The two tables map one-to-one on it.

---

## 2. Confirmed data problems

### P1. `Project Number` is a contaminated, duplicated ID (highest priority)

- **Symptom**: 1,126 `Project Number` values map to more than one `Project Url` (covering 2,567 rows). The reverse has no conflicts (URL -> Number is one-to-one).
- **Key check**: Among these duplicated numbers, **0 have the same project name, 0 have the same amount, and only 6 have the same country**. Example: number `5945` points to both "South Africa, Vani Capital credit line (Active)" and "Malawi, Anomva energy storage (Dropped)"; number `3299` is shared by 5 unrelated projects.
- **Conclusion**: This is **not "one project with several documents"**. The numbers were assigned more than once. `Project Number` does not represent any business grouping.
- **Impact**: Joining the two tables on Number causes **Cartesian amplification**, attaches the wrong client information to projects, and makes the WS2 ECL calculation meaningless.
- **Handling**: **One row = one independent project; use `Project Url` as the primary key and join key throughout.** `Project Number` is a display field only and must not be used for GROUP BY / JOIN / deduplication.

### P2. The region field has 2 legacy names

- **Symptom**: The data dictionary defines 7 standard regions, **including `North America`**. The actual data mixes in two non-standard spellings, `Latin America & Caribbean` (22) and `Middle East & North Africa` (21).
- **Note**: `North America` (5) is a **valid value and needs no normalization**.
- **Impact**: Grouping by Region splits the same region into two rows, distorting Q1/Q8/Q23 and others.
- **Handling**: Map only `Latin America & Caribbean -> Latin America` and `Middle East & North Africa -> Middle East`.

### P3. Approved total != sum of the four product components

- **Symptom**: 146 rows differ by more than $1M, with a maximum gap of **$88.17M**; roughly 4,992 further rows show floating-point-level differences.
- **Impact**: Q2 (ranking by total), Q28 (which tests exactly this), and any basis built on "total" versus "components" will contradict each other.
- **Handling**: Fix one primary basis. We suggest `Total IFC investment as approved by Board`, and output the list of differences separately (which is exactly the answer to Q28).

### P4. Status and date logic conflict

- **Symptom**: 37 rows have `IFC Signed Date` earlier than `IFC Approval Date`; **663 rows have status Pending but already have an Approval Date**.
- **Impact**: Q12 (Pending but past the Board Date) and Q22 (interval from approval to first investment) will produce negative or abnormal values.
- **Handling**: Keep the raw values unchanged, and state the exclusion/retention rule in the answers.

### P5. Nulls carry business meaning and must not be treated as 0

- projects: `IFC Invested Date` empty 2,465, `IFC Signed Date` empty 2,098, `IFC Approval Date` empty 1,064, `Projected Board Date` empty 104, `Project Description` empty 31.
- monitoring: `Performance Status` and `IFC Disbursed Amount` are each empty 1,233 (= the number of Pending projects); `Days Since Last Review` is empty 1,302 (= the number of Closed projects).
- **Handling**: `NULL` is always excluded from aggregation denominators; for any ratio, the denominator must be stated in the answer.

### P6. Monitoring coverage = every project except Dropped

- **Symptom**: 1,232 of the 5,000 projects have no record in monitoring, and **all 1,232 are Dropped (100%)**.
- Put another way: the 3,768 monitored projects = Active 1,233 + Closed 1,302 + Pending 1,233.
- **Impact**: Using monitoring as the main table loses every Dropped project; using projects as the main table with a LEFT JOIN leaves Dropped naturally empty on performance measures.
- **Handling**: **projects LEFT JOIN monitoring ON project_url**. No extra filter is needed for Dropped, and this is naturally consistent with the "excluding Dropped" basis in Q3/Q4/Q8.

### P7. Text fields need parsing, and coverage is low

- **Symptom**: `Project Description` averages 226 characters; only **218 rows** mention MW/megawatt, and among the 2,535 Active + Closed rows only **116**.
- **Impact**: Q13/Q24/Q25/Q26 (the 4 Challenge questions) depend on text parsing. Low coverage means "not mentioned" is itself part of the conclusion (Q24 explicitly asks how many projects do not state capacity).
- **Handling**: Regex extraction plus manual spot-checks; in the answers, give a three-way split of "successfully extracted / not mentioned / could not be parsed".

---

## 3. Basis questions that need business confirmation (to go in the README assumptions list)

1. **How is "a project" defined**: by `Project Url` (recommended), or by `Project Number`?
2. **When one project has several disclosure documents**, is the amount counted more than once?
3. **For the 663 rows that are Pending but have an Approval Date**, are they treated as "approved"?
4. **Are the two Region versions** legacy names for the same region?
5. **When the total and the components disagree**, which is the official basis?
6. **"Last 5 years"**: measured from `As of Date` or from the real current date?
7. **ECL model**: the 60% loss rate applies only to Past Due; does Watchlist need its own coefficient? (Not required by default in this question, but it must be explained.)

---

## 4. Suggested order of implementation

1. `01_data/01_load_and_prepare`: unify types, parse dates, normalize regions, and build a cleaned table keyed on `Project Url`.
2. Output a **data quality report table** (row count plus an example for each issue) as one of the deliverables in `assets/`.
3. Write the assumptions from section 3 into `README.md`, and in each answer in `04_answers` cite the matching assumption number.
