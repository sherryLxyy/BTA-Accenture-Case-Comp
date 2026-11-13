# WS3 - Recommendation to the Board

**Prepared for:** IFC Board risk review
**Scope:** 400 clients, 3,768 projects, USD 555,119 million approved
**Data:** `ifc.analytics.client_score`, built from `ifc.curated.portfolio`
**Reproduce:** `01_ws3_client_analysis.sql`, `02_ws3_shortlist.sql`, `03_ws3_finalists.sql`

---

## The recommendation

Four clients, named against evidence the Board can re-run.

| | Client | Action | Approved | Undisbursed |
|---|---|---|---|---|
| 1 | **Rosar Telecom Holdings** | Continue to invest | 6,283 | 2,704 |
| 2 | **Zansorzen Renewables Corp** | Continue to invest | 5,040 | 2,176 |
| 3 | **Wenharval Renewables Corp** | Reduce exposure | 5,544 | 2,058 |
| 4 | **Mijul Farms PLC** | Place under review | 15,927 | 6,657 |

**USD million.** Exposure affected:

- Directed toward growth: **11,323 approved, 4,880 undisbursed**
- Directed toward reduction or review: **21,471 approved, 8,715 undisbursed**

The reduction side carries almost twice the capital of the growth side.
That ratio is the substance of the recommendation: the portfolio does not
need more capital, it needs to stop adding to two relationships and start
adding to two others.

---

## How the four were chosen

Three steps, each one reproducible from the SQL in this folder.

**Step one, score every client on quality.** No thresholds were set by hand.
Each driver is converted to a percentile rank across all 400 clients, so a
client's score says where it sits in the book rather than whether it cleared
a number someone chose.

`attention_score` (higher is worse) - expected credit loss 30%, share of the
client's book on Watchlist or Past Due 25%, worst internal risk rating 20%,
undisbursed commitment 15%, dropped-project share 10%.

`growth_score` (higher is better) - clean record 35%, deployment 25%, low
risk rating 20%, relationship depth 20%.

**Step two, apply a materiality floor of USD 5,000 million approved.** The
book median is USD 840 million, the 90th percentile is USD 2,333 million. A
quality ranking on its own puts small, tidy relationships at the top: a
client with three fully disbursed projects outranks one with USD 15 billion
committed across a hundred. That is correct for a risk officer and wrong for
a Board, where every name has to be worth the room's attention. The floor
selects 19 clients holding 46.6% of approved value.

**Step three, rank the survivors within each list.** The growth list was also
required to have no Past Due project, none on the Watchlist, and no exit at a
loss. A client that has already lost money is not a growth story, however
large it is.

Within the reduction list the two names are chosen on different measures, not
as the first two rows of one ranking. **Wenharval ranks first on
`attention_score`** and is the quality case: eight of its thirty-three projects
are Past Due and its expected credit loss of USD 853 million is the largest in
the shortlist. **Mijul ranks seventh on the same score**, because three Past
Due out of a hundred and six is close to the portfolio average, and is the size
case: USD 6,657 million still to disburse is the largest remaining commitment
of any client that carries impairment at all. One name tells the Board where
the book is deteriorating. The other tells it where a deterioration would be
most expensive. Ranking both on the same column would have produced two names
saying the same thing.

The result is not that 19 clients are acceptable and 381 are not. It is that
within the part of the book large enough to matter, the evidence separates
cleanly, and this is where it separates.

---

## 1. Rosar Telecom Holdings - continue to invest

| | |
|---|---|
| Client ID | CL-0324 |
| Projects | 50 |
| Approved | USD 6,283.49 million |
| Disbursed | USD 3,579.82 million (57.0%) |
| Undisbursed | USD 2,703.67 million |
| Performance | no Past Due, none on Watchlist, no exit at a loss |

**Evidence.** The largest relationship in the book that carries no adverse
performance of any kind. Fifty projects is the deepest relationship in the
clean cohort, which matters because a single project relationship can turn on
one counterparty event, and fifty cannot.

**Why it survives the test that matters.** The Board asked where capital is
most likely to perform. This client has never produced a Past Due payment
across fifty projects. That is not a forecast, it is a record.

**The counter-argument, stated.** Deployment is 57%, so USD 2,704 million is
committed and not yet paid out. If that capital stays undeployed for another
cycle, the recommendation should be revisited. Growth here means deploying
the existing commitment, not adding a new one.

## 2. Zansorzen Renewables Corp - continue to invest

| | |
|---|---|
| Client ID | CL-0088 |
| Projects | 28 |
| Approved | USD 5,039.64 million |
| Disbursed | USD 2,863.65 million (56.8%) |
| Undisbursed | USD 2,176.00 million |
| Performance | no Past Due, none on Watchlist, no exit at a loss |

**Evidence.** Second-cleanest large relationship, and the one where the
portfolio's climate mandate and its credit record point in the same
direction. Renewables is where IFC has committed to grow; this is a
counterparty in that sector that has not produced a single adverse project
across twenty-eight.

**Why this one and not a larger client.** Among the 19 clients above the
materiality floor, three have a completely clean record. Two are recommended.
The third, Lozen Capital Corp, deploys only 36.9% of its commitment, the
weakest deployment ratio in the clean set, so capital added there would sit
rather than work.

---

## 3. Wenharval Renewables Corp - reduce exposure

| | |
|---|---|
| Client ID | CL-0037 |
| Projects | 33 |
| Approved | USD 5,543.94 million |
| Disbursed | USD 3,485.60 million (62.9%) |
| Undisbursed | USD 2,058.34 million |
| Past Due projects | 8 |
| Expected credit loss | USD 853 million |

**Evidence.** Eight of thirty-three projects are Past Due, 24% of the
client's book - the highest impaired share of any client in the negative
shortlist. The client carries **11.2% of the portfolio's entire expected
credit loss on 0.75% of its approved exposure** - a fifteen-fold
concentration. This is the single worst-performing large relationship in
the book by both severity and money.

**Why this is a sector lesson and not a sector verdict.** Zansorzen
Renewables is recommended for growth in the same sector in the same report.
The evidence does not support a statement about renewables. It supports a
statement about this counterparty, and the report should not blur the two.

**What to do.** No new commitments. The USD 2,058 million undisbursed should
be held rather than cancelled outright, because cancellation crystallises the
loss on the disbursed book and forgoes the option that the eight Past Due
projects recover. The right action is a hard stop on new approvals plus a
workout plan on the eight.

## 4. Mijul Farms PLC - place under review

| | |
|---|---|
| Client ID | CL-0001 |
| Projects | 106 |
| Approved | USD 15,927.34 million |
| Disbursed | USD 9,270.22 million (58.2%) |
| Undisbursed | USD 6,657.12 million |
| Past Due projects | 3 |
| Expected credit loss | USD 248 million |

**Evidence.** This is not the worst client in the book. It is the largest
exposed one. USD 15,927 million approved makes it the biggest single
relationship in the portfolio, and USD 6,657 million is still to be paid out
to a client that already has three projects in default. On its own the credit
loss is modest at USD 248 million. What makes it a Board item is that the
remaining commitment is **27x the loss already taken** (6,657 against 248).

**Why review rather than reduce.** Three Past Due out of a hundred and six is
a 2.8% impairment rate, close to the portfolio average. The case for acting
is not that Mijul is failing; it is that the size of the remaining commitment
means a deterioration here is expensive, and the review should establish
whether the three defaults are idiosyncratic or the start of a pattern.

**What to do.** No suspension. A conditions review before the next
disbursement tranche, with the three Past Due projects examined individually.
Lucor Communications Holdings (USD 14,805 million approved, USD 6,743 million
undisbursed) sits immediately behind Mijul on the same measure and should be
reviewed on the same timetable rather than held for a later cycle.

---

## What this recommendation is not

**It is not a verdict on 381 clients.** The floor of USD 5,000 million was
applied to make the recommendation material, not to dismiss the rest of the
book. The full ranked table is in `ifc.analytics.client_score` and every one
of the 400 clients carries a score and the numbers behind it.

**It is not a statement that renewables are risky.** One renewables client is
recommended for growth and one for reduction, on the same page, from the same
data.

**It does not stretch the ECL model.** Past Due is treated as default and 60%
of disbursed is lost, exactly as the brief specifies. Watchlist clients carry
zero provision, because the brief provisions losses only on Past Due. This is
consistent with WS2 and reconciles to it.

---

## Limitations

**Client coverage is 74.8% of the book.** 1,232 projects holding USD 187,440
million have no `client_id`; they are Pending and not yet assigned. Every
client-level figure in this report excludes them. A Board reading the
undisbursed total should know that USD 187,440 million of it belongs to
projects with no client at all, and the deployment gap in the assigned book
is USD 258,451 million, not the full USD 445,891 million.

**Only 19 clients clear the materiality floor.** The clean cohort within them
is three. Four names were selected from a shortlist of nineteen, so the
recommendation is sensitive to the floor. At USD 3,000 million the shortlist
would widen and the growth candidates would change. The floor is stated so
that a reader can disagree with it and re-run.

**Scores are relative, not absolute.** A `growth_score` of 92 does not mean
92 out of 100. It means the client sits in the top decile of the 400 on the
weighted drivers. The weights themselves are a judgment; the SQL exposes them
so that a different judgment can be substituted in one line.

**Performance status is a point-in-time field.** A client with no Past Due
today can develop one tomorrow. The recommendation should be re-run at each
Board cycle, which is cheap: four queries, under a minute of warehouse time.

---

## Reproducing this

```
03_ws3_finalists.sql  Step 2  scope check, 3,768 assigned vs 1,232 unassigned
                      Step 3  negative finalists, eight rows
                      Step 4  positive finalists, three rows
                      Step 5  how thin the clean cohort is
```

Both the scoring table and the shortlist are rebuilt from `ifc.curated.portfolio`
on every run, so the numbers above can be regenerated from scratch without
depending on any stored state beyond the curated layer.
