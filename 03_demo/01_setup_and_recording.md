# 录 demo 前的准备

给负责录制的人。不需要懂代码，按顺序做，每步都写了「应该看到什么」。

全程约 1 小时，其中前 45 分钟不录，只是把环境准备好；最后 20 分钟才开录屏。

---

## 开始之前，三条硬规则

**一、绝对不要点 Run All。** notebook 里有 19 处调用模型，全跑一遍要 30–45 分钟，而且可能把试用额度跑光，后面就没法录了。第 6 节只跑 17 格，大约 5 分钟。

**二、先把所有东西跑通，再开录屏。** 录的时候只是滚动鼠标、照着稿子念，不要让模型现场跑。模型一次回答要 20–40 秒，录进去就是一段空白。

**三、每一步都对一下「应该看到什么」。** 对不上就停下来问，不要猜着往下做。后面每一步都依赖前面那一步。

---

## 1. 要准备的东西

| 需要 | 说明 |
|---|---|
| 一个 Databricks 账号 | 用**新邮箱**注册免费试用。之前用过的邮箱额度已经耗尽，登录进去什么也做不了 |
| 两个 CSV | 找 Jimmy 要：`synthetic_ifc_projects_5000.csv`（2.3 MB）、`synthetic_project_monitoring.csv`（358 KB） |
| 仓库链接 | `github.com/sherryLxyy/BTA-Accenture-Case-Comp`，已公开，不需要 token |
| 时间 | 约 60 分钟，中途不要关浏览器 |

注册完先进一次工作区，确认左上角能看到自己的邮箱。看不到就是账号没激活，先解决这个再往下。

---

## 2. 建环境（约 10 分钟，不录）

### 2.1 建一个 SQL warehouse

左侧导航 → **SQL Warehouses** → **Create** → 选 **Serverless** 或 **2X-Small** → Create。

等状态变成绿色的 Running，大约 1–2 分钟。后面所有 SQL 和 notebook 都跑在它上面。

**用完记得停掉。** 它开着就算不用也在扣额度，在 SQL Warehouses 页面点 Stop。

### 2.2 建 catalog、schema 和 volume

左侧导航 → **SQL Editor** → 新建一个查询。

把仓库里 `00_setup/00_config.sql` 的内容整个粘进去，全选，点 **Run**。

**应该看到：** 没有报错。这个文件是 5 条独立语句（建一个 catalog、三个 schema、一个 volume），编辑器可能只显示最后一个的结果，也可能显示 5 行 `OK`，两种都正常。报错才是不正常。

如果报错说没有 warehouse，右上角下拉框选你刚建的那个。

### 2.3 上传两个 CSV

左侧导航 → **Catalog** → 点 `ifc` → 点 `raw` → 点 **Volumes** 标签 → 点 `raw_files` → 点 **Upload to this volume**。

把两个 CSV 都拖进去，等上传完成。

> `raw_files` 这个 volume 是上一步 `00_config.sql` 建出来的。如果 Catalog 里看不到 `ifc`，说明 2.2 没成功，回去重做。

**应该看到：** `raw_files` 里有两个文件，名字和大小都对。

### 2.4 核对

在 SQL Editor 里跑：

```sql
LIST '/Volumes/ifc/raw/raw_files/'
```

**应该看到：** 两个文件。文件名一个字都不能错，下一步是按名字读的。

---

## 3. 把仓库挂进来（约 3 分钟，不录）

左侧导航 → **Workspace** → 点你自己的邮箱那一层 → 右上角 **Create** → **Git folder**。

填仓库链接，点 Create。

> **不要**建在 `Groups` 文件夹里。那是 Databricks 的保留目录，会报 `Folder Groups is protected`，而且报错看起来像 clone 失败，其实不是。

**应该看到：** 一个叫 `BTA-Accenture-Case-Comp` 的文件夹，点进去有 `00_setup`、`01_data`、`02_agent`、`04_answers`、`README.md`。

---

## 4. 跑 SQL（约 20 分钟，不录）

按这个顺序，一个文件一个文件跑。每个文件：点开 → 全选（Cmd+A）→ **Run**。

| 顺序 | 文件 | 应该看到 |
|---|---|---|
| 1 | `00_setup/00_config.sql` | 5 行 OK（2.2 已做，跳过） |
| 2 | `01_data/01_load_and_prepare.sql` | **5,000 / 3,768 / 5,000 / 1,232** |
| 3 | `01_data/02_data_quality_checks.sql` | 一张 `data_quality_checks` 表 |
| 4 | `01_data/03_add_comments.sql` | 一串 OK，没有报错 |
| 5 | `01_data/04_analytics_layer.sql` | 三张表建好 |
| 6 | `04_answers/ws1/01_ws1_answers.sql` | 30 题、共 36 段结果，最后一段是区域×行业热力图 |
| 7 | `04_answers/ws2/01_ws2_answers.sql` | 7 段，中间能看到 95 和 3,311.72 |
| 8 | `04_answers/ws3/01_ws3_client_analysis.sql` | 6 段，建 `client_portfolio`，**400 行**（399 个客户 + 1 个空客户） |
| 9 | `04_answers/ws3/02_ws3_shortlist.sql` | 6 段，建 `client_score`，也是 **400 行**，那个空客户排在增长榜第一 |
| 10 | `04_answers/ws3/03_ws3_finalists.sql` | 6 段，覆盖 `client_score`，**399 行**，给出四个客户 |

**第 2 步的四个数字必须对上。** 对不上就是 CSV 没读对，停下来重传，不要往下做——后面每一个数字都建立在这四个数上。

如果 SQL 编辑器提示「一次只能执行一条语句」，就按文件里的 `/* --- ... --- */` 分隔线一段一段跑。慢一点没关系，这部分不录。

### 两个必须知道的坑

**不要停在 02_ws3_shortlist.sql。** 它和 03_ws3_finalists.sql 都建 `ifc.analytics.client_score`，03 会**静默覆盖** 02，不报错。停在 02 会得到 400 行、一个建立在错误人口上的答案：一个没有客户的空行带着 187,440 million 排在增长榜第一。**两个都要跑，顺序不能反。**

**`05_grant_reviewers.sql` 不要跑。** 那是给四位评审授权用的，里面写死了他们的邮箱，在你的账号里会全部报错，而且演示用不到。

### 最后核对一次

```sql
SELECT COUNT(*) FROM ifc.analytics.client_score
```

**应该是 399。** 如果是 400，说明你只跑了 02 没跑 03，回去补。

---

## 5. 建 Genie space（约 10 分钟，不录）

左侧导航 → **Genie** → **New**，起名 `IFC Portfolio Analyst`，选你建的那个 warehouse。

**表只加一张：`ifc.curated.portfolio`。**

不要加 `client_score`。客户问题走的是 notebook 里的 `recommend_clients` 工具，不是 Genie；两边都配会让同一个问题有两个数字，评审一眼就看出不一致。

### Instructions（整段粘进去）

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

### 用这四个问题自检

建好后逐个问一遍。这四题的答案**不依赖日期窗口**，所以数字必须一模一样：

| 问 | 应该答 |
|---|---|
| How many projects are in the portfolio? | **5,000** |
| How many projects have status Dropped? | **1,232** |
| How many projects are Past Due, and how many are Watchlist? | **91 / 164** |
| For Category A projects that are Past Due or Watchlist, how many projects and how much disbursed? | **95 / 11,447.52** |

四题全对，说明表挂对了、注释读到了、金额单位没搞错。这部分不录。

不要用「过去五年」这类问题自检：Genie 会把窗口锚在当天，而我们的 SQL 锚在数据里的 `MAX(as_of_date)`，两边差几个月，数字对不上是正常的，不代表配置错了。

### 把 space 的 ID 换进 notebook

space 建好后，浏览器地址栏里 `/genie/rooms/` 后面那一长串就是 ID，形如 `01f1e0b95dd81634986239ff0a1bd9c4`。

打开 `02_agent/build_agent.ipynb`，搜 `GENIE_SPACE_ID`，**会搜到两格，两格都要改**。只改一格，另一格会把旧 ID 覆盖回去，而报错看起来像权限问题。

---

## 6. 跑 agent（约 5 分钟，不录）

打开 `02_agent/build_agent.ipynb`。第 1 格开头的注释就是下面这张表，不用记。

**只跑这 17 格**，按顺序。用 **Cmd+Enter** 运行当前格（Shift+Enter 会跳到下一格，容易跳过头）。

笔记本里没有格子编号。用 **Cmd+F** 搜下面「怎么找到它」那列的字符串，每个字符串全篇几乎只出现一次（需要数到第几处的我会写出来）。

| # | 怎么找到它 | 说明 |
|---|---|---|
| 1 | 拉到最顶上第一格，`%pip install` | 跑完**必须** Restart Python |
| 5 | 搜 `GENIE_SPACE_ID`，**第 1 处** | 你刚改的 ID |
| 6 | 搜 `GENIE_SPACE_ID`，**第 2 处**（同一格里有 `def query_portfolio`） | Genie 工具 |
| 10 | 搜 `def calculate_credit_risk` | WS2 工具 |
| 15 | 搜 `DatabricksOpenAI` | 模型客户端 |
| 17 | 搜 `MODEL =` | **会真的问模型一句话**，能出答案说明模型可用 |
| 27 | 搜 `"name": "query_portfolio"` | 工具清单 |
| 28 | 搜 `def execute_agent_tool` | 工具调用分发 |
| 29 | 搜 `This is the newest version` | 真正的 agent 循环 |
| 32 | 搜 `SYSTEM_PROMPT = """`，**第 2 处**（第 1 处是 28 格） | 系统提示词 |
| 63 | 搜 `12. Do not generalise` | 往提示词里追加第 12 条守则 |
| 79 | 搜 `WS3_RECALC_SQL` | WS3 重算 SQL |
| 80 | 搜 `def ws3_reconcile` | 对账 |
| 81 | 搜 `Recalculate from the portfolio using the team` | 真正在用的那版推荐函数 |
| 82 | 搜 `Replace only the WS3 registration` | 换掉 WS3 的工具注册 |
| 83 | 搜 `ECL scope carried on every row` | **不调模型**，只打印短名单 |
| 84 | 搜 `ANSWER AUDIT` | **唯一一次出答案的调用**，通常是最后一格 |

**如果某一格报 `NameError`**，说明前面有一格漏跑了或者跑错了。回到第 1 格开头那张清单，从上往下对一遍，不要接着往下做。

### 第 1 格：装完必须重启

`%pip install` 跑完，菜单 **Run → Restart Python**，然后再跑第 5 格。

不重启的话，包装上了但读不到，第 6 格会报 `ImportError`。点 Run All 不会自动重启，所以这条只能手动做。

### 第 17 格如果报错

报 `endpoint not found` 或类似的话，说明这个账号没有 `databricks-gpt-oss-120b`。去左侧 **Serving** 页面找一个支持 chat 的 endpoint，把它的名字填进 `MODEL = "..."`，再跑一次。

这一步通不过就别往下走，后面全部依赖它。

### 第 83 格应该看到

```
== continue_investing (2 rows) ==
== review_shortlist (8 rows) ==
```

**2 个投、8 个观察。** 8 个是给模型挑选的，最终答案只取 2 个。

### 第 84 格应该看到

一段英文分析（四个客户各说各的指标），最后是：

```
==========================================================================
ANSWER AUDIT
==========================================================================
  PASS   scope, floor, thresholds, ratios, rankings
==========================================================================
```

**必须是 PASS。** 如果是 FAIL，把 FAIL 那一行发给我，说明模型跑偏了。

---

## 7. 确认输出留存（1 分钟，但最容易漏）

录之前回头检查：第 83 格和第 84 格下面**有没有输出**。

没有输出的话，录的时候就是一片空白。有的话，录的时候只要滚动。

不要关这个 notebook，不要关浏览器标签页。Databricks 会把输出留在页面上，直到工作区自己回收。

---

## 8. 开录（约 20 分钟）

照 `03_demo/00_video_script.md` 的 Shot list 来。10 个镜头里 5 个是静态图，5 个是现场画面，每个都写了 STILL 兜底。

| 时间 | 拍什么 | 在哪 |
|---|---|---|
| 0:00 | 架构图 | 仓库里 `assets/architecture_diagram_agentic_solution.png` |
| 0:13 | 数据质量问题文档 | 仓库里 `docs/数据质量备忘.md`，P1 那一段 |
| 0:35 | 同一个文档，重复编号那段 | 同上 |
| 0:43 | P6 那一段，能看到 1,232 | 同上 |
| 1:04 | Catalog 树，`ifc` 展开三层 | 左侧 Catalog → `ifc` |
| 1:20 | notebook 里 agent 那格，四个工具名 | 第 27 格 |
| 1:35 | 四个客户那张表 | 第 84 格的输出 |
| 1:58 | 八行短名单 | 第 83 格的输出 |
| 2:07 | ANSWER AUDIT 的 PASS 那一行 | 第 84 格输出最下面 |
| 2:37 | 回到架构图，淡出 | 同 0:00 |

### 录之前的三个提醒

**语速。** 稿子是按每分钟 150 词写的，2 分 42 秒。慢一点到 140 词是 2 分 54 秒，也在 3 分钟内。不要赶。

**数字怎么念。** 稿子最后有一张读音表，照那个念。特别是 1,232 念 "twelve hundred and thirty-two"，不是 "one thousand two hundred"。

**稿子最后有三条不要说的话。** 念之前先看一遍，那三条是最容易被追问的地方。

### 如果现场画面出不来

不是所有镜头都必须现场跑。Catalog 树、四个客户表、八行短名单、ANSWER AUDIT，都可以截图放进剪辑里，效果一样。稿子是按「画面能对上台词」写的，不要求连续录。

---

## 9. 出问题查这张表

| 症状 | 原因 | 怎么办 |
|---|---|---|
| `Folder Groups is protected` | Git folder 建在 Groups 目录里 | 换到你自己邮箱那一层重建 |
| Catalog 里没有 `ifc` | `00_config.sql` 没跑成功 | 回 2.2 |
| Volume 里看不到文件 | 上传没完成，或文件名不对 | 回 2.3，文件名必须和文档一致 |
| 第 2 步跑出 5,638 行而不是 5,000 | CSV 里的换行被当成了新行 | 说明 `multiLine` 没生效，重跑整个文件，不要只跑一半 |
| `client_score` 是 400 行 | 只跑了 02 没跑 03 | 回第 4 节第 10 步 |
| `ImportError: databricks_openai` | `%pip` 之后没重启 Python | Run → Restart Python |
| 报 space 不存在 / 权限不足 | 两处 `GENIE_SPACE_ID` 只改了一处 | 两处都改成同一个新 ID，报错会假装成权限问题 |
| `endpoint not found` | 这个账号里没有这个模型 | 先跑一格看有哪些可用：搜 `serving_endpoints.list`，从输出里挑一个 chat 模型填进 `MODEL = "..."` |
| `NameError` | 前面某一格漏跑了或跑错了 | 回到第 1 格开头那张清单，从上往下对一遍 |
| 第 84 格是 FAIL | 模型多说了话（排名、比较） | 把 FAIL 那行发给我，不要自己改稿子 |

---

## 录完

1. **Stop 掉 SQL warehouse**（SQL Warehouses → 你的 warehouse → Stop）
2. 把视频原文件发给 Jimmy，不要自己剪辑
3. 如果中途换了账号，第 5 节和第 6 节的绑定关系要重做一遍
