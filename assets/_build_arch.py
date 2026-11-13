#!/usr/bin/env python3
"""Render the solution architecture diagram as SVG (no external deps)."""

W, H = 1680, 880
INK = "#12263a"
MUTED = "#5b6b7c"
BG = "#ffffff"

C_SRC = "#eef4fb"; C_SRC_B = "#9db8d6"
C_LAKE = "#e8f2ee"; C_LAKE_B = "#7fae9c"
C_ANA = "#fdf1e6"; C_ANA_B = "#d9a26a"
C_DEL = "#f0edf8"; C_DEL_B = "#9b8fc4"
C_GOV = "#f4f4f2"; C_GOV_B = "#b6b6ae"


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def wrap(text, width):
    words, lines, cur = text.split(), [], ""
    for w in words:
        trial = (cur + " " + w).strip()
        if len(trial) <= width:
            cur = trial
        else:
            if cur:
                lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines


out = []
add = out.append

add(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" '
    f'viewBox="0 0 {W} {H}" font-family="Helvetica Neue, Helvetica, Arial, sans-serif">')
add(f'<rect width="{W}" height="{H}" fill="{BG}"/>')

add(f'<text x="44" y="50" font-size="26" font-weight="700" fill="{INK}">'
    'Forward Deployed Agentic Solution - BigBang</text>')
add(f'<text x="44" y="76" font-size="14" fill="{MUTED}">'
    'IFC portfolio analysis on Databricks Unity Catalog   |   5,000 projects   |   400 clients   '
    '|   USD 742.6bn approved   |   snapshot 2026-06-30</text>')
add(f'<line x1="44" y1="92" x2="{W-44}" y2="92" stroke="{INK}" stroke-width="1.2"/>')

lanes = [
    (44, 264, "1  SOURCES", C_SRC_B),
    (332, 480, "2  LAKEHOUSE   (Unity Catalog)", C_LAKE_B),
    (836, 356, "3  ANALYSIS", C_ANA_B),
    (1216, 420, "4  DELIVERY", C_DEL_B),
]
for x, w, label, col in lanes:
    add(f'<rect x="{x}" y="112" width="{w}" height="25" fill="{col}" rx="3"/>')
    add(f'<text x="{x+10}" y="130" font-size="12.5" font-weight="700" '
        f'fill="#ffffff" letter-spacing="0.6">{label}</text>')

add('<defs><marker id="ar" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" '
    'markerHeight="6" orient="auto-start-reverse">'
    f'<path d="M 0 0 L 10 5 L 0 10 z" fill="{MUTED}"/></marker></defs>')


def box(x, y, w, h, title, body, fill, border, tsize=14, bsize=12.0):
    add(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="5" fill="{fill}" '
        f'stroke="{border}" stroke-width="1.3"/>')
    add(f'<text x="{x+13}" y="{y+24}" font-size="{tsize}" font-weight="700" '
        f'fill="{INK}">{esc(title)}</text>')
    ly = y + 42
    for line in wrap(body, int((w - 26) / (bsize * 0.545))):
        add(f'<text x="{x+13}" y="{ly}" font-size="{bsize}" fill="{MUTED}">{esc(line)}</text>')
        ly += bsize + 5.5


def arrow(x1, y1, x2, y2):
    add(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{MUTED}" '
        f'stroke-width="1.6" marker-end="url(#ar)"/>')


# lane 1
box(44, 152, 264, 74, "projects CSV", "5,000 rows x 24 columns", C_SRC, C_SRC_B)
box(44, 238, 264, 74, "monitoring CSV", "3,768 rows x 10 columns", C_SRC, C_SRC_B)
box(44, 324, 264, 150, "Raw defects kept visible",
    "1,126 shared project_number values. 1,232 Pending projects with NULL client_id and "
    "NULL performance status. Multi-line text inside project fields.",
    C_SRC, C_SRC_B, bsize=11.4)

# lane 2
box(332, 152, 480, 74, "ifc.raw   landing zone",
    "Volume /Volumes/ifc/raw/raw_files  ->  read_files, multiLine=true", C_LAKE, C_LAKE_B)
box(332, 238, 480, 130, "ifc.curated   single read surface",
    "projects (5,000) + monitoring (3,768) + portfolio (5,000 LEFT JOIN keyed on project_url, "
    "never on project_number). Duplicate-column renames, typed casts, range checks, column comments.",
    C_LAKE, C_LAKE_B, bsize=11.6)
box(332, 380, 480, 146, "ifc.analytics   derived layer",
    "project_text_flags: regex signals behind Q13, Q24, Q25, Q26.   client_portfolio (400 rows): "
    "exposure, deployment, impairment and ECL per client.   client_score: percentile ranks plus "
    "attention_score and growth_score.", C_LAKE, C_LAKE_B, bsize=11.6)

arrow(308, 189, 332, 189)
arrow(308, 275, 332, 214)
arrow(572, 226, 572, 238)
arrow(572, 368, 572, 380)

# lane 3
box(836, 152, 356, 108, "WS1   30 baseline questions",
    "One SQL file, every answer reproducible. The date window is pinned to the snapshot, "
    "not to the current calendar year.", C_ANA, C_ANA_B, bsize=11.6)
box(836, 272, 356, 130, "WS2   Board risk question",
    "Category A: 95 projects, USD 11,447.52m disbursed, ECL = 60% x Past Due = USD 3,311.72m. "
    "Watchlist carries no provision. Whole-book sensitivity: USD 7,596.21m.",
    C_ANA, C_ANA_B, bsize=11.6)
box(836, 414, 356, 112, "WS3   four client decisions",
    "Percentile scoring, USD 5,000m materiality floor, 19 large clients. Two continue, "
    "one reduce, one review.", C_ANA, C_ANA_B, bsize=11.6)

arrow(812, 206, 836, 206)
arrow(812, 445, 836, 337)
arrow(812, 452, 836, 470)

# lane 4
box(1216, 152, 420, 108, "Genie space   natural language",
    "Two sources: portfolio at project grain, client_score at client grain. Eight written rules "
    "pin the unit, the date window, the ECL formula and the NULL scope.",
    C_DEL, C_DEL_B, bsize=11.6)
box(1216, 272, 420, 148, "Agent   orchestrator + guardrails",
    "The LLM chooses the tool. Tool 1 Genie (lookup). Tool 2 Risk Calculator (ECL). Tool 3 "
    "Client Analysis (score one relationship). Financial guardrails reject unsupported figures "
    "and every call is logged.", C_DEL, C_DEL_B, bsize=11.6)
box(1216, 432, 420, 94, "Board outputs",
    "Named recommendation. Three-minute demo video. Every figure traceable to a SQL file.",
    C_DEL, C_DEL_B, bsize=11.6)

arrow(1192, 206, 1216, 206)
arrow(1192, 337, 1216, 337)
arrow(1192, 470, 1216, 478)

# governance
add(f'<rect x="44" y="552" width="1592" height="112" rx="5" fill="{C_GOV}" '
    f'stroke="{C_GOV_B}" stroke-width="1.3"/>')
add(f'<text x="60" y="576" font-size="13.5" font-weight="700" fill="{INK}">'
    'GOVERNANCE AND TRUST</text>')
gov = [
    ("Access", "Unity Catalog grants to all four reviewers: workspace Admin, USE CATALOG, "
               "USE SCHEMA + SELECT on raw, curated and analytics, READ VOLUME, warehouse Can use, "
               "and Genie shared only after the tables."),
    ("Version control", "Every answer, table definition and check is a file in Git. The workspace "
                        "is a Git folder, not a notebook dump."),
    ("Reproducibility", "Pipeline rebuilt from the two raw CSVs in a fresh workspace on 2026-11-13. "
                        "Headline figures reproduced to the cent."),
]
gx = 60
for head, body in gov:
    add(f'<text x="{gx}" y="600" font-size="11.4" font-weight="700" fill="{INK}">{head}</text>')
    ly = 618
    for line in wrap(body, 62):
        add(f'<text x="{gx}" y="{ly}" font-size="10.7" fill="{MUTED}">{esc(line)}</text>')
        ly += 14
    gx += 528

# limit
add('<rect x="44" y="680" width="1592" height="108" rx="5" fill="#fdf6f6" '
    'stroke="#d9a0a0" stroke-width="1.3"/>')
add('<text x="60" y="704" font-size="13.5" font-weight="700" fill="#8c2f2f">'
    'STATED LIMIT   what the client view does not cover</text>')
caveat = ("1,232 of 5,000 projects, USD 187,440.1m of USD 742,558.7m approved and 25.2% of value, "
          "are Pending and carry no client_id. Because their performance status is also NULL they "
          "score as perfectly clean, and an unlabelled NULL client row would otherwise top the growth "
          "ranking. The client view therefore covers 3,768 projects and USD 555,118.6m, 74.8% of "
          "approved value, and every client-level statement is scoped to that population.")
ly = 726
for line in wrap(caveat, 132):
    add(f'<text x="60" y="{ly}" font-size="11.2" fill="#7a3b3b">{esc(line)}</text>')
    ly += 15.5

add(f'<text x="44" y="822" font-size="10.6" fill="{MUTED}">'
    'Files: 01_data/01_load_and_prepare.sql  |  01_data/02_data_quality_checks.sql  |  '
    '01_data/04_analytics_layer.sql  |  04_answers/ws1-3  |  02_agent/build_agent.ipynb</text>')
add('</svg>')

path = "/Users/wangsuyu/MMA/Case_Comp/BTA_AIC/assets/architecture_diagram_agentic_solution.svg"
with open(path, "w", encoding="utf-8") as fh:
    fh.write("\n".join(out))
print("wrote", path)
