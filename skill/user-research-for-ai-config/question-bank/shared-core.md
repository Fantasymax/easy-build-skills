# 共享核心问题清单（5 题，V0.8 — C4 拆为 C4a/C4b）

> **何时用**：Step 3，无论 Mode A 还是 Mode B 都先跑这 4 题。耗时 3–5 分钟。
>
> **V0.7 关键变化**：每题标 metadata（工具 / multiSelect / header / options）。AI 在所有支持原生选项工具的平台（Claude Code / Desktop / Cursor / Codex / Gemini / Trae / Kilo 等）**必须调平台原生工具**（详见 SKILL.md §B8），不再用 markdown 列表让用户打字。
>
> **平台原生工具自动加 "Other / 自由输入"** 让用户能在选项不够时自定义——所以题里**不再列"⑥ 其他"**。
>
> **追问规则**：每题答完后按 SKILL.md §B2 自动追问 1–2 次 `为什么？` 或 `然后呢？`。每题答完后跑一次 §B3 偏误自检。

---

## 题序排列说明

按 Game Complexity Arc：暖场（C1）→ 中等（C2-C3）→ 复杂（C4a 满意 + C4b 崩溃）→ 转入模式分支。

**V0.8 关键变化**：原 C4 单题"讲满意 + 崩溃"拆为 C4a（满意）+ C4b（崩溃）两题。原因：
- 一题塞两件事 → 用户讲一件草草带过另一件
- 满意 vs 崩溃在 lint / shape inference / Anti-patterns 三处都需要独立信号源
- C4b 还是 task-shortlist Part 1 "崩溃修复价值"维度的唯一来源

---

## C1：身份 — 你是做什么的？

### 第一步（AskUserQuestion 单选）

**metadata**：
- `工具`：AskUserQuestion
- `multiSelect`：false
- `header`："身份"
- `question`："你最像下面哪一类？"
- `options`（4 个，AskUserQuestion 自动加 Other）：
  1. **label**：自媒体创作者
     **description**：公众号 / 短视频 / Newsletter / 播客
  2. **label**：独立开发者 / Indie Hacker
     **description**：SaaS / App / 工具 / 插件
  3. **label**：个人咨询 / 个人服务
     **description**：顾问 / 教练 / 设计 / 写作外包 / 财税
  4. **label**：大公司岗位 + 副业
     **description**：白天打工，业余用 AI 干私活 / 写公众号 / 接外包

### 第二步（文本输入 — 完全开放式）

**主问**：用一句话补充——"我具体在为 ___ 交付 ___"

例：
- "为 25–40 岁中产女性读者交付每周 1 篇 3000–5000 字的人生升级深度长文"
- "维护一款远程团队会议工具 SaaS，5–30 人团队，月收入 $4K"

### 为什么问

第一步 = Persona 段第一句的 + description "who is this skill for"暗示。第二步 = 抓个性。

### 追问候选

- 第一步选了"大公司岗位 + 副业"：`今天我们要配置的 AI 主要服务哪一边？`
- 第二步太抽象（"内容""服务"）：`再具体——篇幅 / 频次 / 受众一句话拼出来。`

### 写入

- Mode A → Persona 段第一句
- Mode B → SKILL.md frontmatter `description` 的"who is this skill for"暗示

---

## C2：工作场景 — 一周里你最常重复做的 3 件事

### 第一步（AskUserQuestion 多选）

**metadata**：
- `工具`：AskUserQuestion
- `multiSelect`：true
- `header`："高频任务"
- `question`："以下哪几类是你最近 7 天重复 ≥ 2 次的？（多选）"
- `options`（4 个 + Other）：
  1. **label**：写作型
     **description**：写文章 / 日报 / 周报 / 长文 / 邮件 / 文档
  2. **label**：创作型
     **description**：做选题 / 写脚本 / 录视频 / 剪辑 / 设计
  3. **label**：分析型
     **description**：跑数据 / 做表格 / 写报告 / 读资料 / 整理素材
  4. **label**：协调 / 运维型
     **description**：回客户消息 / 排会议 / 维护现有系统 / 修 bug / 答疑

### 第二步（文本输入）

**主问**：每选一项，补一句"具体形式 + 上周实际做了 X 次"

例：「① 写作型：每周 1 篇 3000–5000 字深度长文，上周做了 1 次必做 + 3 条小红书短文」

⚠ **重要**：用"实际次数"代替"应该 / 一般 / 大概"——这是 lint Layer 1 §1.1 偏误的预防机制。

### 为什么问

这是 Mode A "任务清单"段的种子，也是 Mode B 任务选择阶段的项目候选池。

### 追问候选

- 用户给"我应该每天 X / 一般每周 Y"含糊频次：直接套 lint L1.1 模板回写
- 用户选项 < 3 个：`再想想——周一早上你打开电脑第一件做的事？周五下班前最不想做的事？`

### 写入

- Mode A → Workflow 段的"高频任务清单"（必带实际频次）
- Mode B → 任务选择步骤的候选池

---

## C3：工具栈 — 你做这些事时用什么工具/数据/平台？

### 主问（拆成 4 个 AskUserQuestion 调用，每题多选 + Other 兜底）

> ⚠ **V1.1 修正**：V0.7 当时用文本输入是错的 — 违反了我们自己的"永远给选项 + 自定义兜底"原则。改为 4 个独立 AskUserQuestion 调用（每类一题，4 个最常见工具 + Other 自由输入兜底，自动加常见替代品提示）。AI 在跑这一题时**必须**：
> 1. 调用 4 次 AskUserQuestion（每类一次），不要用 markdown 列表
> 2. 在 question 字段提示"如果都不对用 Other 自由输入，例如 [给 2-3 个示例]"
> 3. multiSelect: true 允许多选

#### C3.1：笔记 / 知识管理（AskUserQuestion 多选）

**metadata**：
- `工具`：AskUserQuestion
- `multiSelect`：true
- `header`："笔记/知识"
- `question`："你常用哪些笔记 / 知识管理工具？（多选；都不对就用 Other 自由输入，例如 Bear / Roam / Dropbox Paper）"
- `options`（4 个 + Other）：
  1. **label**：Notion
     **description**：海外用户主流
  2. **label**：飞书文档 / 语雀
     **description**：国内团队主流
  3. **label**：Obsidian / 本地 markdown
     **description**：本地优先 / 知识图谱
  4. **label**：不太用 / 全靠脑子
     **description**：跳过这类

#### C3.2：创作 / 开发工具（AskUserQuestion 多选）

**metadata**：
- `工具`：AskUserQuestion
- `multiSelect`：true
- `header`："创作/开发"
- `question`："你常用哪些创作 / 开发工具？（多选；都不对就 Other，例如 Excalidraw / 剪映 / Premiere）"
- `options`（4 个 + Other）：
  1. **label**：Word / Google Docs / 飞书文档
     **description**：长文写作
  2. **label**：Figma / Sketch / draw.io
     **description**：视觉设计 / 图表
  3. **label**：Cursor / VS Code / Claude Code
     **description**：代码 / 工程
  4. **label**：Excel / 飞书表格 / Numbers
     **description**：表格 / 数据处理

#### C3.3：AI 工具（AskUserQuestion 多选）

**metadata**：
- `工具`：AskUserQuestion
- `multiSelect`：true
- `header`："AI 工具"
- `question`："你常用哪些 AI 工具？（多选；都不对就 Other，例如 Kimi / 豆包 / Perplexity / 自部署 LLM）"
- `options`（4 个 + Other）：
  1. **label**：Claude Code / Desktop / Claude.ai
     **description**：Anthropic 全家桶
  2. **label**：ChatGPT / Codex
     **description**：OpenAI 系
  3. **label**：Gemini / Copilot
     **description**：Google / Microsoft
  4. **label**：Cursor / Cline / Aider 等编程 AI
     **description**：AI 编程 IDE

#### C3.4：协作 / 沟通 / 发布（AskUserQuestion 多选）

**metadata**：
- `工具`：AskUserQuestion
- `multiSelect`：true
- `header`："协作/发布"
- `question`："你常用哪些协作 / 沟通 / 发布平台？（多选；都不对就 Other，例如 Slack / Linear / 公众号后台 / 小红书后台）"
- `options`（4 个 + Other）：
  1. **label**：微信 / 企业微信
     **description**：国内主流
  2. **label**：飞书 / 钉钉
     **description**：国内办公 IM
  3. **label**：Slack / Discord
     **description**：海外主流
  4. **label**：不太用协作工具
     **description**：单人作战 / 异步为主

### 关键追问（AskUserQuestion 单选）

**metadata**：
- `工具`：AskUserQuestion
- `multiSelect`：false
- `header`："私货模板"
- `question`："你有没有自己写过给自己用的'模板 / 备忘 / SOP / 风格指南'？"
- `options`（4 个 + Other）：
  1. **label**：有，是文档型
     **description**：PDF / Word / Markdown
  2. **label**：有，是结构型
     **description**：Notion 数据库 / Airtable
  3. **label**：有，是私人辞典 / 词条库
     **description**：自己积累的语料 / 案例 / 句式
  4. **label**：没有，全靠脑子
     **description**：（如选这个，跳过追问"贴原文"）

如果选 1 / 2 / 3 → AI 必触发追问（文本输入）：`能贴一段原文给我吗？我们会一字不动地放进 skill。`（**Mode B 必触发**）

### 为什么问

- 第一段"按 4 类列工具"= recognition 模式定位高频工具（即使没用 AskUserQuestion）
- 关键追问"私货模板"= Mode B 最大金矿（用户原话保留的源头）

### 写入

- Mode A → Tools / Context 段
- Mode B → SKILL.md "Workflow"段的"输入"列；以及 `references/` 和 `assets/` 文件清单

---

## C4：协作过往 — 你和 AI 协作的两个具体瞬间

### 共享第一步（AskUserQuestion 多选） — C4a / C4b 共用

**metadata**：
- `工具`：AskUserQuestion
- `multiSelect`：true
- `header`："任务类型"
- `question`："AI 帮你做过的'任务类型'有哪几类？（多选）"
- `options`（4 个 + Other）：
  1. **label**：素材抽取 / 对比 / 总结
     **description**：读书卡片 / 资料归类 / 论点对照
  2. **label**：写作 / 改稿 / 翻译
     **description**：起草 / 润色 / 中英互译
  3. **label**：分析 / 编程 / 数据
     **description**：跑数 / 出图 / 写代码 / debug
  4. **label**：头脑风暴 / 起候选
     **description**：出想法 / 起候选标题 / 列方案

> 用户先勾选 ≥ 1 个类型，再分别答 C4a 和 C4b（C4a/C4b 可对应不同的勾选类型）。

---

### C4a：最满意的一次（文本输入 — 讲故事）

**主问**：从你勾选的类型里挑 1 个，讲**最满意的一次**——

- 哪个 AI（ChatGPT / Claude / Gemini / 本地）？
- 它做对了什么？
- 给我**一句它说的原话**让我感受一下"对的味道"。

#### 为什么问

- "最满意" = Variable Reward 偏好（喂 Mode A Goals 段）
- 满意经历的原话 = few-shot positive examples 种子

#### 追问候选

- 用户给"AI 帮我提高效率"空话：`具体哪一次？任务是什么？它说的哪一句让你眼睛一亮？`
- 用户答不上来：`你用 AI 做事多久了？如果 < 1 个月，我们跳过 C4a。`

#### 写入

- Mode A → Goals 段
- Mode B → "Variable Reward" 期望段 / examples/good-*.md 种子

---

### C4b：最崩溃的一次（文本输入 — 讲故事）

**主问**：从你勾选的类型里挑 1 个（可以与 C4a 同类型也可以不同），讲**最崩溃的一次**——

- 哪个 AI？
- 它做错了什么？
- 你最后怎么收拾的？花了多久？
- 给我**一句它说的让你最不爽的原话**让我感受一下"错的味道"。

#### 为什么问（V0.8 关键 — 单独提取出来）

- "最崩溃" = 用户红线（喂 Mode A Guardrails / Mode B Anti-patterns 段）
- C4b 是 **task-shortlist Part 1 "崩溃修复价值"维度**的唯一信号源
- C4b 是 **intent-inference Part 1 "反向任务"创意发散候选**的唯一信号源
- 崩溃原话 = few-shot negative examples 种子

#### 追问候选

- 用户没说"怎么收拾"：`你最后是怎么改 / 重做的？花了多久？`
- 用户用形容词敷衍（"很糟糕 / 离谱"）：`具体它说了哪一句让你最炸毛？给我那一句。`
- 用户答不上来：`如果想不起具体的，跳过 C4b 没关系——但请确认一下：你是否真的没遇到过崩溃，还是想不起来？`（区分两种情况）

#### 写入

- Mode A → Guardrails 段 / 红线段
- Mode B → Anti-patterns 段 / examples/bad-*.md 种子
- task-shortlist 评分 → "崩溃修复价值"维度
- intent-inference → "反向任务"创意发散候选

---

## 完成共享核心后

跑一次 §B3 偏误自检（详见 `frameworks/interview-basics.md`），重点扫：
- C2 第二步频次描述里的"应该做 / 一般做"等社会期望词（→ 触发 lint L1.1 重答）
- C4a / C4b 故事是否有具体场景（→ 触发 handle 提问法重答）
- C4a 与 C4b 是否互相矛盾（→ 触发 §B4 矛盾回写）

通过后进入 Step 4 模式分支：
- Mode A → 读 `question-bank/express-mode-a.md`
- Mode B → 先做"任务选择"（用 C2 清单做候选），再读 `question-bank/express-mode-b.md`

---

## 版本

- **V0.8 (2026-05-09)** — C4 拆为 C4a（最满意）+ C4b（最崩溃）两题。原因：
  - 一题塞两件事 → 用户讲一件草草带过另一件
  - C4b 是 task-shortlist 评分"崩溃修复价值"维度的唯一信号源
  - C4b 是 intent-inference"反向任务"创意发散候选的唯一信号源
  - 满意 vs 崩溃在 Mode A Goals/Guardrails 和 Mode B examples/good-vs-bad 处都需要独立信号源
- **V0.7 (2026-05-09)** — 实测反馈："markdown 列表让用户打字糟糕"。修正：每题加 metadata（工具 / multiSelect / header / options 含 description），AI 在**任何支持原生选项工具的平台**（Claude Code / Desktop / Cursor / Codex / Gemini / Trae / Kilo / OpenCode 等）必须调平台原生工具（详见 SKILL.md §B8）。选项 ≤ 4（5 选项超工具上限），删手动"⑥ 其他"（原生工具自动加 Other）。完全开放题（C1 第二步 / C4 第二步）保留文本输入；C3 工具栈类别太多（>4）保留文本输入。**跨平台抽象**：题目 metadata 平台无关，让具体 AI 平台自己映射到自己的工具。
- **V0.2 (2026-05-09)** — 加入"3 强相关 + 2 创意发散 + 自定义"题型范式（已被 V0.7 替代）
- V0.1 (2026-05-09) — 初版
