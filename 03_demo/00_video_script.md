# Three-minute demo - Team BigBang

Script for the recorded walkthrough. Every number spoken on camera is in the
appendix, and every figure in the appendix came out of
`Case Data/synthetic_ifc_projects_5000.csv` and
`Case Data/synthetic_project_monitoring.csv` independently of the agent.

The timing is not estimated. Each beat was counted and converted at 150 words
per minute, and every stamp below is the running sum of those measurements, so a
reader who follows the text lands on the marks. Total is **406 words, 2:42 at
150 wpm, 2:54 at 140 wpm.** If the speaker is slower than 140, cut beat 3 in
full - it is the only beat that can be removed without breaking the argument.

The workspace may or may not be reachable on the day. Each beat therefore lists
two ways to shoot it: **LIVE** if Databricks opens and executes, and **STILL**
if it does not. Both produce the same three minutes; only the footage changes.

**Setting up the workspace before recording** is a separate job and has its own
runbook: `03_demo/01_setup_and_recording.md`. It covers creating the trial
account, uploading the CSVs, running the nine SQL steps, building the Genie
space, and running the seventeen notebook cells that produce the three screens
this script needs. Do that first; this page assumes the screens already exist.

---

## Before recording

- **Capture the STILL frames first, before anything else.** All five are listed
  in the shot list. Databricks access has dropped twice already; if it drops a
  third time on the morning of the recording, the stills are what the video
  runs on. A screenshot taken today is worth more than a live demo promised for
  tomorrow.
- 1920x1080. Cursor hidden unless it is clicking something.
- Close every tab except the two you need. No notifications.
- Font size up two steps in the notebook so the table survives 1080p
  compression.
- Read the voice-over once out loud for timing before recording anything. Do
  not speed up to fit; cut beat 3 instead.
- Record the voice-over separately and lay it over the footage. Recording both
  at once means a mistimed click forces a retake of the narration.

---

## Shot list

| Time | On screen | Source | First words |
|---|---|---|---|
| 0:00 | Architecture diagram, slow push in | STILL `assets/architecture_diagram_agentic_solution.png` | "IFC's book is five thousand..." |
| 0:13 | `docs/数据质量备忘.md`, section P1 | STILL or LIVE GitHub | "Everything here comes from two..." |
| 0:35 | Same document, the shared-number example | STILL | "Join on the number instead..." |
| 0:43 | Section P6, the 1,232 figure visible | STILL | "A quarter of approved value..." |
| 1:04 | Catalog tree, `ifc` expanded to three schemas | LIVE catalog, or STILL | "Three layers in Unity Catalog." |
| 1:20 | Notebook, cell 27, the tool definitions | LIVE run, or STILL | "The agent has three tools." |
| 1:35 | The four-client table | LIVE output, or STILL | "Asked which two to back..." |
| 1:58 | The eight-row shortlist below it | LIVE output, or STILL | "It also prints the shortlist..." |
| 2:07 | `ANSWER AUDIT` block, PASS line visible | LIVE output, or STILL | "The agent audits its own answer..." |
| 2:37 | Diagram again, cut to black | STILL | "Numbers you can recompute..." |

---

## Voice-over

Read as written. Each beat ends where the screen changes, so a late start is
recoverable and a fast start is not.

**0:00** — 33 words, 13s  →  next beat 0:13

> IFC's book is five thousand projects and seven hundred forty-two billion
> dollars of approved investment. The board question is much narrower: which
> two clients to back, and which two to pull back from.

**0:13** — 54 words, 22s  →  next beat 0:35

> Everything here comes from two source files. First, what one row actually
> means. The project number is not unique - eleven hundred and twenty-six
> point at more than one project, and three numbers are each shared by five
> unrelated deals. The URL is unique, so the URL is the only key we join on.

**0:35** — 20 words, 8s  →  next beat 0:43

> Join on the number instead and the two files multiply into crossed wires;
> every credit figure downstream turns to noise.

**0:43** — 52 words, 21s  →  next beat 1:04

> A quarter of approved value sits in twelve hundred and thirty-two projects
> with no monitoring record at all. All were dropped in data quality: no
> client, no risk rating, no performance status. So the client view covers
> seventy-five percent of the book, and we say so rather than quietly dropping
> the gap.

**1:04** — 40 words, 16s  →  next beat 1:20

> Three layers in Unity Catalog. Raw holds both files untouched. Curated
> resolves them to one row per project. Analytics holds the client view: three
> hundred ninety-nine clients, eighteen of them above the materiality floor,
> holding twenty-eight percent of the value.

**1:20** — 37 words, 15s  →  next beat 1:35

> The agent has three tools: portfolio facts through Genie, a credit
> calculation using the case's sixty percent loss assumption, and a client
> review shortlist with evidence. Which one to call is the model's decision,
> not a script.

**1:35** — 59 words, 24s  →  next beat 1:58

> Asked which two to back and which two to review, it returns four names with
> the arithmetic attached. Wenhargal Renewables: eight past-due projects, eight
> hundred fifty-three million dollars of expected loss on five and a half
> billion approved - fifteen point four percent. Bricor Finance: five hundred
> thirty-six million. And two growth candidates with no past-due exposure at
> all.

**1:58** — 22 words, 9s  →  next beat 2:07

> It also prints the shortlist behind the answer in loss order, so a reader can
> check the selection without trusting the prose.

**2:07** — 13 words, 5s  →  next beat 2:12

> Every figure was recomputed from source. None of it came from the model.

**2:12** — 63 words, 25s  →  next beat 2:37

> The agent audits its own answer before signing off: the scope of the loss
> figure, the materiality floor, every percentage against what the tools
> returned, and any ranking the data cannot support. An earlier run caught
> itself calling a client the highest-growth name in the book, when three names
> it had never been shown scored higher. We fixed the prompt, not the sentence.

**2:37** — 13 words, 5s  →  ends 2:42

> Numbers you can recompute, and an agent that will not overstate them.

---

## Pronunciation and number reading

Read numbers as written below. The numerals appear on screen; the voice says the
words.

| On screen | Say | Note |
|---|---|---|
| Rosar | ROH-sar | not on camera in the final cut |
| Zansorzen | zan-SOR-zen | not on camera in the final cut |
| Wenhargal | WEN-har-gal | stress the first syllable |
| Bricor | BRY-kor | rhymes with "dryer" |
| Genie | JEE-nee | Databricks product name |
| 742,558.66 | seven hundred forty-two billion | do not say the decimals |
| 555,118.56 | five hundred fifty-five billion | only if asked; not in the script |
| 5,543.94 | five and a half billion | rounded on purpose |
| 852.90 | eight hundred fifty-three million | rounded on purpose |
| 535.97 | five hundred thirty-six million | rounded on purpose |
| 15.4% | fifteen point four percent | the one decimal worth keeping |
| 1,232 | twelve hundred and thirty-two | not "one thousand two hundred" |
| 1,126 | eleven hundred and twenty-six | the shared project numbers |

Rounding is deliberate and defensible: the approved figures are spoken to two
significant figures because the audit block on screen carries the exact values.
Saying "five thousand five hundred forty-three point nine four" costs four
seconds and adds nothing a viewer can use.

---

## Appendix - read these correctly

| Figure | Value | Where it comes from |
|---|---|---|
| Projects | 5,000 | projects file, `Project Url` unique |
| Approved, whole book | USD 742,558.66 mm | sum of board-approved column |
| Project numbers used more than once | 1,126 | three numbers appear five times each |
| Projects with monitoring | 3,768 | monitoring file, one row per project |
| Approved, client-attributable | USD 555,118.56 mm | the 3,768 rows |
| Unmatched projects | 1,232 | projects minus monitoring, all `Dropped` |
| Unmatched approved | USD 187,440.10 mm | the difference |
| Client coverage | 74.8% | 555,118.56 / 742,558.66 |
| Clients | 399 | distinct `Client ID` |
| Materiality floor | approved >= USD 5,000 mm | 18 clients |
| Share of approved above floor | 28.5% | 158,317.34 / 555,118.56 |
| Portfolio expected credit loss | USD 7,596.21 mm | 60% of past-due disbursed |

The four clients in the answer:

| Client | ID | Approved | ECL | ECL / approved | Past due |
|---|---|---|---|---|---|
| Rosar Telecom Holdings | CL-0324 | 6,283.49 | 0.00 | 0.0% | 0 |
| Zansorzen Renewables Corp | CL-0088 | 5,039.64 | 0.00 | 0.0% | 0 |
| Wenhargal Renewables Corp | CL-0087 | 5,543.94 | 852.90 | 15.4% | 8 |
| Bricor Finance Group | CL-0168 | 6,156.01 | 535.97 | 8.7% | 4 |

All figures in USD millions. Wenhargal's ECL is 24.5% of its disbursed balance
and Bricor's is 15.5%; the approved-based ratios are the ones quoted on camera
because the question is about commitment size.

---

## Three things not to say

1. **Do not say "five hundred clients".** It is 399.
2. **Do not say the two growth clients have the highest growth scores in the
   book.** They are the highest among clients above the materiality floor.
   Three clients below the floor score higher, and that is the exact overreach
   the audit exists to catch. Saying it on camera would undercut the last
   thirty seconds of the video.
3. **Do not say "no losses"** about the growth pair. Say "no past-due
   exposure". Watchlist losses sit outside the case model, and the written
   answer states that in its limitations.
