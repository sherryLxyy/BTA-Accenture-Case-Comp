# WS3 - Recommendation to the Board

**Prepared for:** IFC Board risk review
**Scope:** 399 clients, 3,768 projects, USD 555,119 million approved
**Data:** `ifc.analytics.client_score`, built from `ifc.curated.portfolio`
**Reproduce:** `01_ws3_client_analysis.sql`, `02_ws3_shortlist.sql`, `03_ws3_finalists.sql`

---

## The recommendation

Four clients, named against evidence the Board can re-run.

| | Client | Action | Approved | Undisbursed |
|---|---|---|---|---|
| 1 | **Rosar Telecom Holdings** | Continue to invest | 6,283 | 2,704 |
| 2 | **Zansorzen Renewables Corp** | Continue to invest | 5,040 | 2,176 |
| 3 | **Wenhargal Renewables Corp** | Reduce exposure | 5,544 | 2,058 |
| 4 | **Bricor Finance Group** | Place under review | 6,156 | 2,708 |

**USD million.** Exposure affected:

- Directed toward growth: **11,323 approved, 4,880 undisbursed, nil expected loss**
- Directed toward reduction or review: **11,700 approved, 4,766 undisbursed, 1,389 expected loss**

The two sides hold almost exactly the same amount of approved capital and are
nothing alike in quality. The growth pair carries no provision at all; the
review pair carries **18.3% of the portfolio's entire expected credit loss on
1.6% of its approved value**. That asymmetry, not the size of either group, is
the substance of the recommendation: the portfolio does not need more capital,
it needs to stop adding to two relationships and start adding to two others.

---

## How the four were chosen

Three steps, each one reproducible from the SQL in this folder.

**Step one, score every client on quality.** No thresholds were set by hand.
Each driver is converted to a percentile rank across all 399 clients, so a
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
selects 18 clients holding 28.5% of the client-attached book.

**Step three, rank the survivors within each list.** The growth list was also
required to have no Past Due project, none on the Watchlist, and no exit at a
loss. A client that has already lost money is not a growth story, however
large it is.

Within the reduction list the top two rows are taken, but they are not the
same story told twice. **Wenhargal ranks first on `attention_score`** and is the
realised case: eight of its thirty-three projects are Past Due, one has already
exited at a loss, and its expected credit loss of USD 853 million is the
largest of any client in the book. **Bricor ranks second** and is the forming
case: six of its thirty-five projects sit on the Watchlist, not one has been
written off, and its USD 536 million is loss that has not happened yet. One
name tells the Board where the loss already is. The other tells it where the
next one is forming, while there is still time to act on it.

The result is not that 18 clients are acceptable and 381 are not. It is that
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

**Why this one and not a larger client.** Among the 18 clients above the
materiality floor, three have a completely clean record. Two are recommended.
The third, Lozen Capital Corp, deploys only 36.9% of its commitment, the
weakest deployment ratio in the clean set, so capital added there would sit
rather than work.

---

## 3. Wenhargal Renewables Corp - reduce exposure

| | |
|---|---|
| Client ID | CL-0087 |
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

## 4. Bricor Finance Group - place under review

| | |
|---|---|
| Client ID | CL-0168 |
| Projects | 35 |
| Approved | USD 6,156.00 million |
| Disbursed | USD 3,448.00 million (56.0%) |
| Undisbursed | USD 2,708.00 million |
| Past Due projects | 4 |
| Watchlist projects | 6 |
| Expected credit loss | USD 536 million |

**Evidence.** Ten of Bricor's thirty-five projects, 28.6% of the relationship,
are already Past Due or on the Watchlist. That is the second-highest impaired
share in the material book after Wenhargal, and unlike Wenhargal it has not yet
produced a single exit at a loss. The expected credit loss of USD 536 million is
therefore the largest stock of **pre-default** exposure on the list: money that
is still carried as an asset on the reporting date and may not be next quarter.

**Why this is a different name from Wenhargal, not a smaller copy of it.**
Wenhargal is a realised loss being managed. Bricor is a deterioration that has
not yet been recognised as one. The action differs accordingly: Wenhargal takes
a hard stop on new approvals, Bricor takes a decision before the Watchlist turns
into a provision. Together the two names hold USD 1,389 million of expected
loss, 18.3% of the portfolio total, on 1.6% of its approved value.

**What to do.** No suspension. The six Watchlist projects should be re-reviewed
individually before the next disbursement tranche, and the USD 2,708 million
undisbursed, 44% of the relationship, should not be released until that review
closes. If two or more of the six migrate to Past Due, the position moves from
review to reduction at the next Board cycle.

---

## What this recommendation is not

**It is not a verdict on 381 clients.** The floor of USD 5,000 million was
applied to make the recommendation material, not to dismiss the rest of the
book. The full ranked table is in `ifc.analytics.client_score` and every one
of the 399 clients carries a score and the numbers behind it.

**It is not a statement that renewables are risky.** One renewables client is
recommended for growth and one for reduction, on the same page, from the same
data.

**It is not a ranking of the largest relationships.** Mijul Farms PLC is the
biggest client in the book at USD 15,927 million approved, and it carries only
USD 248 million of expected loss on a 12.3% impaired share. It is not among the
four because the evidence does not put it there. It stays on the size watchlist
together with Lucor Communications Holdings, USD 14,805 million approved and
USD 6,743 million undisbursed, and both should be re-tested at every Board
cycle rather than acted on now. A large healthy client is a reason to keep
watching, not a reason to reduce.

**It does not stretch the ECL model.** Past Due is treated as default and 60%
of disbursed is lost, exactly as the brief specifies. Watchlist clients carry
zero provision, because the brief provisions losses only on Past Due. This is
consistent with WS2 and reconciles to it.

---

## Limitations

**Client coverage is 74.8% of the book.** 1,232 projects holding USD 187,440
million have no `client_id`; they are Dropped, so no client was ever attached
and the monitoring table holds no row for them. Every
client-level figure in this report excludes them. A Board reading the
undisbursed total should know that USD 187,440 million of it belongs to
projects with no client at all, and the deployment gap in the assigned book
is USD 258,451 million, not the full USD 445,891 million.

**Only 18 clients clear the materiality floor.** The clean cohort within them
is three. Four names were selected from a shortlist of eighteen, so the
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
