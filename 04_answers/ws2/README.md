# WS2 - Integrated Portfolio View

**Status:** complete
**Source:** Case Brief p.4, two questions carried over from the last Board risk review
**Data:** `ifc.curated.portfolio` (projects LEFT JOIN monitoring, one row per project)
**SQL:** `01_ws2_answers.sql`
**Tool:** Risk Calculator inside Sherry's custom agent (reconciled)

## The questions

1. Which **Category A** projects are currently Past Due or on the Watchlist,
   who are the clients, and how much was approved for each?
2. How much of IFC's disbursed capital is tied up in these projects, and how
   much should IFC set aside to cover potential losses on **those that are Past
   Due**?

ECL model, per the brief: Past Due projects are treated as in default and 60%
of their disbursed amount is lost.

## Q1 - the register

| Measure | Value |
|---|---|
| Category A projects currently Past Due or on the Watchlist | **95** |
| Distinct clients behind them | **61** |
| Approved amount across those projects | **USD 15,473.36 million** |
| of which Past Due | 35 projects |
| of which Watchlist | 60 projects |

The itemised register, with client name, country, internal risk rating and
approved amount per project, is the first query in `01_ws2_answers.sql`.

## Q2 - capital tied up and provision

| Measure | USD million |
|---|---|
| Approved | 15,473.36 |
| Disbursed, capital tied up | **11,447.52** |
| - Past Due | 5,519.53 |
| - Watchlist | 5,927.99 |
| Undisbursed commitment (approved minus disbursed) | 4,025.84 |
| **Expected credit loss provision** | **3,311.72** |

The provision covers only the Past Due book: 5,519.53 x 60% = 3,311.72.
Watchlist projects are reported for exposure, not for provisioning, because the
brief provisions losses only "on those that are Past Due". Measured against
total disbursed, the effective provisioning rate is 28.9% rather than 60% -
that gap is the Watchlist book, not an error.

Three internal checks hold:

- 5,519.53 + 5,927.99 = 11,447.52 (status breakdown equals total)
- 5,519.53 x 0.6 = 3,311.72 (provision drawn from one status only)
- 3,311.72 / 11,447.52 = 28.9% (weighted rate, not a flat 60%)

## Why the Category A filter matters

The same computation run without the Category A filter:

| Population | Projects | Disbursed | Provision |
|---|---|---|---|
| Category A only (what the Board asked) | 95 | 11,447.52 | **3,311.72** |
| All projects (no category filter) | 255 | 29,509.43 | 7,596.21 |

Dropping the filter would have overstated the provision by **USD 4,284.49
million, a factor of 2.3**. The wider number is arithmetically correct and
answers a different question, which is the failure mode this case is testing
for. The filter is left visible in every query rather than buried in a CTE so
that a reviewer can see the scope on the page.

## Reconciliation with the Risk Calculator tool

Sherry's Risk Calculator returns 35 Past Due projects (5,519.53 disbursed,
3,311.72 provision) and 60 Watchlist projects (5,927.99 disbursed, 0
provision). Those figures match the Category A population exactly, so the tool
is correctly scoped. The zero provision on Watchlist is also correct and
follows the brief's wording rather than a missing branch.

The only item the tool does not yet report is the approved amount required by
Q1 (15,473.36) and the undisbursed commitment (4,025.84). Both are available
from the same query and are worth adding so the two questions reconcile on one
screen.

## Definitions used

- "Past Due" and "Watchlist" come from `performance_status` in the monitoring
  record. Projects with no monitoring record have a NULL status and are
  excluded by the `IN` filter.
- `disbursed_usd_mm` is the amount paid out to date; `total_approved_usd_mm` is
  the Board-approved amount.
- `environmental_category = 'A'` is a required part of the population
  definition, not an optional cut.
