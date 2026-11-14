# Expected output for the twelve WS1 blocks that had no recorded result

These are not a second opinion. They were recomputed from the two raw CSVs with
the same rules the pipeline applies, so that the twelve queries in
`_run_missing_12.sql` can be checked the moment they finish rather than after
someone reads them.

**The method was validated before use.** The same script reproduces Q1 exactly:
Sub-Saharan Africa 15,240.2, Latin America 10,607.5, East Asia & Pacific
7,675.1, Europe & Central Asia 6,988.9, South Asia 6,531.1, Middle East 5,333.1,
North America 0.0, total 52,375.8, across 1,595 projects. It also reproduces the
`146` in the Q28 comment. If a number below disagrees with the warehouse, the
warehouse is right and this file is wrong, but the disagreement is worth reading
before it is dismissed.

Two rules are applied here that are easy to miss:

- **Region is normalised before grouping.** The raw file carries nine spellings:
  `Latin America & Caribbean` (22 rows) and `Middle East & North Africa`
  (21 rows) are aliases. `01_load_and_prepare.sql` maps them into
  `Latin America` and `Middle East`, so every regional table below has seven
  rows, not nine.
- **Q1 sums the loan column, not the total column.** The 52,375.8 quoted
  everywhere is `SUM(loan_usd_mm)` in the window. The total approved in the
  same window is 228,202.6, which is what Q17 adds up. Both are correct; they
  answer different questions.

---

## Q13 - Active projects whose main purpose is renewable generation

Two tiers, because "main purpose" is not a column in this dataset.

| Region | broad projects | broad USD mm | strict projects | strict USD mm |
|---|---|---|---|---|
| Sub-Saharan Africa | 97 | 15,022.1 | 15 | 1,973.3 |
| Latin America | 59 | 9,448.2 | 5 | 703.0 |
| East Asia & Pacific | 61 | 9,203.7 | 12 | 2,029.0 |
| Europe & Central Asia | 55 | 8,135.4 | 7 | 1,230.2 |
| South Asia | 34 | 4,523.2 | 6 | 850.3 |
| Middle East | 29 | 4,468.0 | 6 | 1,372.0 |
| North America | 1 | 272.1 | 0 | 0.0 |
| **Total** | **336** | **51,072.7** | **51** | **8,157.8** |

Report the band 336 to 51 projects, or 51.1 to 8.2 billion. A single number
would be a choice dressed up as a measurement.

## Q14 - Summary of Proposed Investment disclosed after 2020

| Year | Documents |
|---|---|
| 2021 | 212 |
| 2022 | 193 |
| 2023 | 166 |
| 2024 | 603 |
| 2025 | 457 |
| 2026 | 63 |
| **Total** | **1,694** |

The 2024 step change is in the data, not in the query: disclosure volume
roughly quadruples between 2023 and 2024.

## Q15 - Environmental Category A projects still Pending

| Region | Projects | Approved USD mm |
|---|---|---|
| Sub-Saharan Africa | 121 | 17,204.3 |
| East Asia & Pacific | 71 | 12,052.3 |
| Latin America | 71 | 9,656.3 |
| Europe & Central Asia | 55 | 7,135.6 |
| South Asia | 49 | 6,785.3 |
| Middle East | 33 | 5,358.9 |
| North America | 2 | 358.6 |
| **Total** | **402** | **58,551.4** |

## Q16 - Environmental & Social Review Summary by category

| Category | Documents |
|---|---|
| A | 891 |
| B | 517 |
| **Total** | **1,408** |

No Category C review summaries exist in the file, which is consistent with the
case data: C projects are screened but not written up.

## Q17 - Approved investment by Department, snapshot window

Window is 2021-07-01 to 2026-06-30, the same 60 months Q1 uses.

| Department | Projects | Approved USD mm |
|---|---|---|
| INF | 337 | 46,996.3 |
| MAS | 326 | 46,791.1 |
| CFG | 337 | 46,207.6 |
| FIG | 302 | 45,284.1 |
| CBA | 293 | 42,923.5 |
| **Total** | **1,595** | **228,202.6** |

**This is the checkpoint that matters.** 1,595 and 228,202.6 are the same two
figures the Q1 window reconciliation produced, from a different query. If they
match, the window definition is consistent across the whole answer set.

## Q24 - Renewable generation capacity in MW

Capacity only exists inside free text. This is a floor, not a total.

| Region | Projects | Stating capacity | % | Total MW |
|---|---|---|---|---|
| Sub-Saharan Africa | 196 | 44 | 22.4% | 13,575.0 |
| Europe & Central Asia | 96 | 23 | 24.0% | 7,190.0 |
| East Asia & Pacific | 123 | 27 | 22.0% | 6,175.0 |
| Middle East | 64 | 13 | 20.3% | 4,630.0 |
| Latin America | 132 | 13 | 9.8% | 4,370.0 |
| South Asia | 58 | 14 | 24.1% | 3,295.0 |
| North America | 1 | 0 | 0.0% | 0.0 |
| **Total** | **670** | **134** | **20.0%** | **39,235.0** |

**536 of 670 renewable projects never state a capacity.** Any single MW figure
quoted from this table understates the portfolio by a factor of roughly five.

## Q25 - MSME financing, excluding Dropped

Headline: **535 projects, USD 73,008.2 million**.

| Country | Projects | Approved USD mm |
|---|---|---|
| Brazil | 14 | 2,009.1 |
| India | 12 | 1,740.3 |
| Nigeria | 12 | 1,737.6 |
| Turkey | 10 | 1,436.4 |
| Philippines | 12 | 1,420.2 |

Target groups mentioned inside those 535 descriptions: women 62, rural 36,
agriculture 66, **youth 0, first-time 0, low-income 0**.

The three zeros are the finding. The dataset cannot answer a youth or
first-time-borrower question, and saying so is worth more than a keyword match
that returns two projects.

## Q26 - Product line that contradicts its own description

Flagged only when exactly one product keyword appears and it disagrees with the
recorded line, so this under-reports rather than over-reports.

| Recorded | Implied | Projects | Approved USD mm |
|---|---|---|---|
| Risk Management | Loan | 123 | 18,979.2 |
| Equity | Loan | 66 | 10,265.0 |
| Guarantee | Loan | 26 | 3,608.4 |
| Risk Management | Equity | 22 | 2,486.7 |
| Loan | Equity | 18 | 2,835.1 |
| Loan | Guarantee | 15 | 1,998.9 |
| Risk Management | Guarantee | 14 | 2,784.5 |
| Loan | Risk Management | 11 | 1,354.8 |
| Equity | Guarantee | 10 | 1,606.0 |
| Equity | Risk Management | 7 | 1,212.7 |
| Guarantee | Equity | 7 | 744.5 |
| Guarantee | Risk Management | 1 | 12.0 |
| **Total** | | **320** | **47,887.8** |

320 of 5,000 projects, USD 47.9 billion, disagree with their own description.
The direction is not random: every large cell moves toward "Loan", which means
the description text was written around loan language and the product line was
assigned separately. That is a process finding, not a rounding error.

## Q27 - Top 15 countries by approved investment, excluding Dropped

| Country | Loan | Equity | Total |
|---|---|---|---|
| India | 4,409.8 | 4,157.7 | 16,051.8 |
| Brazil | 3,136.9 | 2,577.3 | 11,492.0 |
| Indonesia | 2,235.6 | 2,748.8 | 11,357.2 |
| Nigeria | 2,369.4 | 3,508.1 | 10,494.0 |
| Vietnam | 2,925.7 | 1,892.8 | 10,209.8 |
| Turkey | 2,384.1 | 2,682.3 | 10,158.1 |
| Bangladesh | 2,160.3 | 2,290.2 | 8,939.7 |
| China | 1,180.0 | 2,071.3 | 8,621.0 |
| Pakistan | 1,444.8 | 1,867.9 | 7,992.1 |
| Egypt | 1,547.0 | 2,028.4 | 7,898.6 |
| Argentina | 1,345.2 | 1,831.9 | 7,735.3 |
| Ghana | 1,877.3 | 2,054.7 | 7,553.4 |
| Colombia | 1,518.2 | 2,159.2 | 7,481.7 |
| Cambodia | 1,927.8 | 1,426.5 | 7,182.0 |
| Kazakhstan | 897.5 | 2,127.3 | 6,336.9 |

Total column includes guarantee and risk management on top of loan and equity,
so loan plus equity will not add up to it. Say so rather than letting a reader
discover it.

## Q28 - Approved total differs from the sum of the four product allocations

**146 projects.** This is the number written in the SQL comment; if it moves,
the load changed.

## Q29 - Multi-product projects

**1,594 projects**, 31.9% of the file, carry more than one non-zero product
allocation.

## Q30 - Region by industry heatmap, excluding Dropped

**33 cells**: 7 regions, 5 industries, two combinations empty.

| Region | Industry | Projects | Approved USD mm |
|---|---|---|---|
| Sub-Saharan Africa | Agribusiness | 226 | 35,198.5 |
| Sub-Saharan Africa | Energy | 227 | 32,814.3 |
| Sub-Saharan Africa | Telecom | 209 | 31,606.6 |
| Sub-Saharan Africa | Finance | 204 | 29,863.6 |
| Sub-Saharan Africa | Manufacturing | 201 | 26,962.7 |
| Latin America | Energy | 158 | 24,738.4 |
| Latin America | Finance | 151 | 23,442.6 |
| East Asia & Pacific | Manufacturing | 138 | 23,175.6 |

Sub-Saharan Africa holds all five of the largest single cells. The heatmap's
story is that the region is not concentrated in one sector, it is uniformly
large across all of them.

---

## What to do with this file

Run `_run_missing_12.sql`, compare each result against the matching section
above, and paste the warehouse output into `01_ws1_results.md`. Where a number
differs, keep the warehouse number and note the difference; do not edit this
file to match.
