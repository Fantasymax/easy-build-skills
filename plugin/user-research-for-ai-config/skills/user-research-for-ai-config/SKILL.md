---
name: user-research-for-ai-config
description: "Use this skill when the user wants to build a personalized AI configuration through structured self-interview rather than copying templates. Two outputs: (A) Principles document — CLAUDE.md / AGENTS.md / CODEX.md / .cursorrules / system-prompt for Claude Code, Cursor, Codex, OpenCode, Trae, Qoder etc. (B) Custom skill package — design a SKILL.md from scratch OR extract an existing recurring task; works whether the user already knows what skill they want or needs AI to help discover one. Trigger especially when users say things like build my own CLAUDE.md / write AGENTS.md / make a custom skill / design a skill from scratch / help me create a skill for X / AI that understands me / 我的 principles / 自己的 skill / 个性化 AI / 把我会的事教给 AI / 帮我设计一个 skill / 从零做一个 skill. Do NOT use for customer research about other users, product discovery interviews, market research, or generic help-me-write-a-system-prompt requests."
license: Complete terms in LICENSE.txt
---

# 用户研究：构建属于你自己的 AI 配置

## Overview

这个 skill 把"专业用户研究"应用在用户**自己身上**，通过一系列结构化提问 + 行为还原，产出两种可落地的 AI 配置：

- **Mode A — Principles**：一份个性化的 AI 行为契约文档（CLAUDE.md / AGENTS.md / CODEX.md / .cursorrules / 通用 system prompt）
- **Mode B — Custom Skill**：把用户某项重复性专业知识凝练成属于他自己的 SKILL.md 包

核心理念不是"问用户想要什么 AI"，而是**通过行为追问 + 边界对齐 + 隐性知识抽取**，反向推出他真正需要的 AI 能力契约。

## Quick Reference

```
[用户调用 skill]
        ↓
Step 0.5: 平台原生工具检测 → AskUserQuestion / ask_user_question / MCP / CLI fallback
          (没原生工具 + 在 Cursor/Windsurf/Cline 等 → 主动给装 MCP 建议)
        ↓
Step 1: 选模式 → A (principles) | B (custom skill) | C (先 A 后 B)
        ↓
Step 1.5: 选输出语言 → 中文 | 英文 | 双语 | 其他   ← V0.9 新增
        ↓
Step 2: 选档位 → 快速版 (10–15 分钟) | 标准版 (30–45 分钟) | 深度版 (跨 7–10 天)
        ↓
Step 3: 共享核心问题 (4 题) → 见 question-bank/shared-core.md
        ↓
Step 4: 模式分支问题  →  Mode A: question-bank/express-mode-a.md
                       →  Mode B: question-bank/express-mode-b.md
        ↓
Step 5: 三层 lint (偏误 + 措辞污染 + schema 校验)
        ↓
Step 6: 输出  →  Mode A: templates/mode-a/output-three-layer.md + 5 平台导出
                →  Mode B: templates/mode-b/atomic/ 包（或 orchestration / with-subagents / plugin-with-hooks / composite-plugin）
        ↓
Step 7.5: AI 自测验证 + 主动优化建议（V0.9）— Schema/触发/Dogfood/覆盖率/报告 5 步流水线
```

## When to use this skill

除 frontmatter description 中列出的触发词，以下情境也应该触发：
- 用户已经看过别人的 CLAUDE.md / AGENTS.md，想做"属于我自己的版本"
- 用户在 Cowork / Claude Code / Cursor / Codex 里反复重复同一类指令，意识到该有个固定 principles
- 用户重复做某个任务（写日报、改稿、整理素材、回邮件……）希望 AI 接管
- 用户提到"AI 不懂我"、"AI 输出像别人的"、"我希望 AI 像我自己一样"

## 启动流程

### Step 0.5：平台原生选项工具检测（必跑，V1.1 新增）

> **使命**：决定**整个 skill 流程**用什么呈现方式。不检测就上来用 markdown 列表 = 用户体验糟糕的根源。
>
> **完整规则**：见 [`frameworks/ux-interaction-rules.md`](frameworks/ux-interaction-rules.md) + [`references/cross-platform-tool-mapping.md`](references/cross-platform-tool-mapping.md)

#### 检测优先级（按顺序）

```
1. available_tools 含 AskUserQuestion         → mode = native_aaq
   （Claude Code 2.1.1+ / Desktop / Claude.ai / Cowork）

2. available_tools 含 ask_user_question       → mode = mcp_or_codex
   （Codex CLI 原生 / 装了 ask-user-questions-mcp 的 MCP 客户端）

3. available_tools 含 ask_followup_question   → mode = kilo_native
   （Kilo Code 原生）

4. 检测到 Gemini CLI / Trae / Qoder           → mode = limited_picker
   （有自己的 slash / @ picker，功能受限）

5. 都没有                                      → 判断客户端类型：
   • Cursor / Windsurf / Cline / VS Code+Copilot / Zed / Continue / OpenCode
     → mode = mcp_recommend  ⚠ 主动给装 MCP 建议（见下方）
   • 自部署 LLM / Web ChatGPT / 其他纯文本环境
     → mode = cli_text_fallback
```

把 mode 存到 session，**全程沿用**（不要每题都检测一次）。

#### Mode = mcp_recommend 时的处理（关键 — V1.1 重点）

如果检测到用户在 Cursor / Windsurf / Cline / VS Code+Copilot / Zed / Continue / OpenCode 等**支持 MCP 的客户端**但**没装 `ask-user-questions-mcp`**：

**一次性安装建议**（不要每次都提）：

```
🔍 检测到你的环境没有原生选项工具，选项体验会差一些。

如果你用的是 Cursor / Windsurf / Cline / VS Code+Copilot / Zed / Continue / OpenCode：
强烈建议装 ask-user-questions-mcp 这个 MCP server，5 分钟搞定 — 装完所有选项题就有原生选项卡了。

📖 安装指南：https://github.com/paulp-o/ask-user-questions-mcp

你怎么选？
[✅ 现在装（暂停 skill，装完重启）]
[⏭ 用 CLI 文字模式继续（精简编号 + 自由输入兜底）]
[❓ 这是啥（先解释）]
```

- 用户选 ✅ → 暂停 skill，给装 MCP 的具体步骤；用户装完重启 Claude Code / 客户端后回来跑 skill
- 用户选 ⏭ → 切到 `mode = cli_text_fallback`，全程用精简编号 + 自由输入兜底
- 用户选 ❓ → 解释什么是 MCP + 装 MCP 的好处（让选项卡 UI 工作）+ 不装的代价（CLI 体验差）

#### Mode = cli_text_fallback 时的呈现规则（**绝不能糟糕**）

即使没原生工具，也**不准退化为大段 markdown**。CLI fallback 必须：
- **题目 1 行**（≤ 60 字）
- **每个选项 1 行**（≤ 30 字，编号 1-N）
- **每题 ≤ 10 行总输出**
- **明确单选/多选标注**："回 1 个数字" vs "回多个数字 1,3,5"
- **自由输入兜底**：选 `6. 其他（请说）` 或直接输入文字

正例（小马 C3.1 笔记/知识管理 在 CLI 模式下）：

```
🤔 你常用哪些笔记 / 知识管理工具？（多选）

  1. Notion
  2. 飞书文档 / 语雀
  3. Obsidian / 本地 markdown
  4. 不太用 / 全靠脑子
  5. 其他（请说，例如 Bear / Roam / Dropbox Paper）

→ 回数字 1-4 或自由文字（多选用逗号 "1,3"）
```

→ 用户 5 秒看完、5 秒回应。**比 markdown 列表 + 大段说明文好 10 倍**。

#### 反例（在任何模式下都禁止）

```
❌ 你做这件事时用了什么工具或数据？

请按下面 4 类列出（每类 ≥ 1 项）：

1. **笔记 / 知识管理**：Notion / Obsidian / 飞书 / Apple Notes / ...
2. **协作 / 沟通**：Slack / 微信 / Discord / Linear / Jira / ...
...
```

→ 用户被迫读 20+ 行 markdown 然后打字回复 = **设计失败**。

---

### Step 1：选产出模式（必跑）

向用户呈现 3 个选项，让其选择：

1. **A — 我想给 AI 写一份'我的 principles'**：定义整体协作风格，跨任务通用。AI 整体上应该如何与我配合？
2. **B — 我想构建一个'我的 skill'**：把某个我重复做的任务凝练成 AI 可执行的 skill（含 SKILL.md + 范例 + 术语表）。
3. **C — 两者都要（推荐）**：先 A 后 B。Mode A 建立全局协作契约，再从中挑 1–2 个高频任务用 Mode B 抽成专属 skill。

**为什么先选模式**：Mode A 横向覆盖、Mode B 纵向深挖，问题清单和输出形态完全不同。提前选好减少后续切换成本。

### Step 1.5：选输出语言（必跑，V0.9 新增）

> **完整规则**：见 [`frameworks/output-language-rules.md`](frameworks/output-language-rules.md)

用 AskUserQuestion 单选呈现 4 个选项：

1. **中文** — 段标题、说明文字、注释全部中文（默认）
2. **英文** — 全部英文
3. **双语对照** — 段标题双语 + 说明文字按用户答题语言
4. **其他（自行说）** — 让用户自由输入目标语言（如"日语""韩语"）

**为什么这一步必跑**：V0.7/V0.8 实测产物出现"骨架英文（Layer 1 / Workflow / Persona）+ 内容中文"的混杂问题。一次性确认输出语言，全程沿用，避免混杂。

**强制规则**（任何语言下都生效）：
- **强制保留英文**：技术术语（SKILL.md / atomic / frontmatter / Hook / MCP / lint）+ 文件名（CLAUDE.md / AGENTS.md / .cursorrules）+ 工具名 + Anthropic 官方形态名
- **必须按选定语言**：所有段标题、章节标题、说明文字、注释
- **用户原话保留**（按 §B10）：原文不动，无论选哪种输出语言

### Step 2：选深度档位（必跑）

| 档位 | 耗时 | 适合 | 输出粒度 |
|---|---|---|---|
| **快速版** | 10–15 分钟 | 想立刻有个能用的版本 | 简版 principles 或最小 skill 包（单 SKILL.md） |
| **标准版** | 30–45 分钟 | 想要一份认真做过研究的产物 | 完整 9 段 principles 或完整 skill 包（含 examples + references）|
| **深度版** | 7–10 天 / 3 次会话 | 想要一份打磨过、用真实使用反馈迭代过的产物 | V1→V2→V3 锁定版本 |

**MVP 当前只完整支持快速版**。标准版与深度版会在后续版本迭代加入；如果用户选择，告知并默认走快速版。

### Step 3：共享核心问题

无论模式如何，先跑共享核心 4 题（身份 / 工作场景 / 工具栈 / 协作过往）。详见 `question-bank/shared-core.md`。

### Step 4：模式分支问题

- Mode A → 读 `question-bank/express-mode-a.md`，按题序问
- Mode B → 读 `question-bank/mode-b-prerequisites.md`（前置 0 Mode C 原则继承 + 前置 1 任务选择），再读 `question-bank/express-mode-b.md` 跑 B1–B10
- Mode C（先 A 后 B）→ Mode A 跑完后进 Mode B 时，**必读** `question-bank/mode-b-prerequisites.md` 前置 0 做原则继承（V1.1 关键）

### Step 5：三层 lint（必跑）

合成输出前依次跑：

1. **偏误 lint**：扫用户回答里的"我应该 / 我打算 / 一般来说"等社会期望词，回写让用户用"上一次实际…"重答
2. **措辞污染 lint**：扫输出文档里的否定式指令、模糊形容词、风格冲突等 9 类陷阱（详见 `frameworks/lint-rules.md`）
3. **Schema 校验**：Mode A 9 段必填项；Mode B description 三要素 + 正文 ≤ 500 行 + 至少 1 个 examples

任一层不过都先回写让用户确认/修正，不要替用户决定。

### Step 5.5：架构反推（V0.4 关键修正）

> **设计原则**：用户是**小白** — 不懂 atomic / orchestration / subagents / hooks / MCP 这些术语。这个 skill 存在的全部理由就是**替小白做技术决策**。
>
> **绝对禁止**：让用户回答"你需要 atomic 还是 orchestration"这种技术选型问题。
>
> **完整规则**：见 `frameworks/intent-inference.md`（语义信号扫描表 + 综合判定 + 翻译成人话 + high-level 反馈循环）

#### AI 的反推工作流

```
1. 扫 raw_answers 全部回答（C1–C4b + A1–A10 + B1–B10）
   ↓
2. 按 intent-inference.md Part 1 跑语义信号扫描
   - Orchestration 信号 / Subagents 信号 / Hook 信号 / MCP 信号 / Atomic 锚点
   ↓
3. 按 Part 2 综合判定主架构 + 装饰组件
   - 默认 Atomic Skill（90%+ 小白用户走这条）
   - 只有强信号触发才升级
   ↓
4. 按 Part 3 翻译成人话呈现方案（V0.6 6 段结构必走）
   - 段 1：核心动作（一句话）
   - 段 2：✅ AI 自动会做的事
   - 段 3：❌ AI 永远不会做的事（红线独立段，**推荐 ≥ 3 条但不强制**，红线少是弱信号）
   - 段 3.5：⚙ 机械化检查点（V0.6 新增，AI 主动把红线压缩为 grep/regex/ASK 等可机械判定的硬规则）
   - 段 4：⏸ AI 拿不准会停下来问你的（语义判断）
   - 段 5：📁 交付物文件清单 + **配置成本**（如有，明确告知）
   - 禁用术语：atomic / orchestration / subagents / hook / MCP / frontmatter / fork / plugin
   ↓
5. 让用户给 high-level 反馈（5 选项，V0.4.1 关键）：
   ① 够用，就这样
   ② 不够好（一句话哪里没覆盖）
   ③ 太复杂（手动的事太多 / 步骤太多）
   ④ 太简单（漏了我经常需要的 X）
   ⑤ **我自己来调整：[自行输入]** ← 熟练用户出口；用户可以用术语 / 引用方案某部分修订 / 完全 override
   ↓
6. 按 Part 4 反推调整：
   - ② → AI 找漏掉的 raw_answer 段加进方案
   - ③ → AI 合并步骤 / 减少视角 / 改硬拦截为软提醒
   - ④ → AI 找用户原话里被忽略的高频场景加进来
   - ⑤ → AI 解析用户输入层级（术语级 / 修订级 / 范围级 / 完全 override），按层级处理（详见 intent-inference.md Part 4.2）
   ↓
7. 最多 3 轮收敛；第 3 轮还没 ① 时主动建议"先 dogfood V1 再调"
```

#### 关键禁止

❌ **禁止**让用户在 5 种架构里做选择题
❌ **禁止**用 atomic / orchestration / subagents / hook / MCP / plugin 等术语呈现方案
❌ **禁止**期望用户能精准描述"哪里不好"——必须接受 high-level 反馈 + 自己反推

#### 唯一例外

如果用户**主动**说"我懂 Claude Code 的能力，我要 orchestration"——这时用户已经不是小白，不在本 skill 目标用户画像内。可以直接按用户指定的架构走，跳过反推。但这是极小概率场景。

### Step 6：输出

- **Mode A**：先填 `templates/mode-a/output-three-layer.md`（三层合一主文档），再按用户选择的目标平台从 `templates/mode-a/exports/` 选对应模板导出（可一次导出全部 5 个）
- **Mode B**：根据 Step 5.5 AI 反推的形态，从 `templates/mode-b/{atomic,orchestration,with-subagents,plugin-with-hooks,composite-plugin}/` 拷贝对应骨架，填好 SKILL.md + examples + references 三件套

### Step 7.5：AI 自测验证 + 主动优化建议（V0.9 关键升级）

> **完整规则**：见 [`frameworks/self-validation.md`](frameworks/self-validation.md)
>
> **背景**：V0.7/V0.8 的 Step 7 只有"念 5 条假问题 + 跑 1 真实任务"，过于粗糙。V0.9 升级为 5 步自测流水线，AI **主动**发现问题并提优化建议，用户用 5 选项决定是否采纳。

#### 流程（Mode B 全跑；Mode A 跑简化版 Step 1+4）

```
Step 1：Schema 自检（机械化，AI 不靠语义）
        ↓
Step 2：触发测试（AI 自己出 5 pos + 5 neg 假问题验 description）
        ↓
Step 3：Dogfood 模拟执行（AI 用 skill 跑同类任务，对比 examples/good-1.md）
        ↓
Step 4：覆盖率检查（B10 五类原话 / Anti-pattern ≥ 3 / 用户红线全部命中 / 输出语言一致性）
        ↓
Step 5：主动报告 + 5 选项反馈循环
        ↓
        ① 全接受     → 进入修正后 final 输出
        ② 部分接受   → AI 列优先级让用户挑
        ③ 拒绝优化   → AI 记录"用户认为这些不是问题"，进入 final
        ④ 我自己改   → 用户自由修改，AI 协助落地
        ⑤ 详细说明   → AI 反推哪一步跑得不对，重跑
```

#### 关键原则

1. **AI 主动**，不等用户找问题 — 用户是小白，不知道哪里有问题
2. **机械化优先** — Schema 自检 / 触发测试 / 语言一致性都靠 grep / regex / 字符串匹配，准 10 倍
3. **不强行让用户全接受** — 用户有权说"我知道这条 anti-pattern 漏了，但我不在乎"
4. **循环上限 3 轮** — 第 3 轮还没 ① 时主动建议"先 dogfood V1 再调"

#### Mode A 简化版

Mode A 跑 Step 1（Schema 自检 — 段标题语言一致性 / Hard Rules MUST/NEVER 大写）+ Step 4（覆盖率 — 用户原话保留 / 红线全命中 / 5 平台导出已对齐用户工具栈）。

跳过 Step 2/3（Mode A 没有 description 触发场景，没有 examples/good-1.md 作对比基线）。

---

## 访谈基本功（B1–B10）

> **完整规则**：见 [`frameworks/interview-basics.md`](frameworks/interview-basics.md)
>
> Claude 在跑 skill 时全程贯彻 B1–B10。问题清单文件已经按这些规则起草过，但用户的自由文本回答需要 Claude 实时应用这些规则。

> ## 🚨 绝对硬规则（V1.1 加 — 实测反复出错）
>
> **永远不要用 markdown 列表代替 AskUserQuestion 工具调用**。
>
> 看到题库里写 `工具：AskUserQuestion` → **必须**调用真实工具，不准用列表 + "请回复编号"。
> 看到题目选项 ≥ 5 → **拆 2-4 个 AskUserQuestion 调用**，不准退回文本输入。
> 用户输入文本回答 markdown 列表题 = 我们的设计失败 = 用户体验糟糕。
>
> **没有原生 AskUserQuestion / ask_user_question 时**（如用户在 Cursor / Windsurf / Cline / Zed 但没装 `ask-user-questions-mcp`）：
> 1. **首次必给安装建议**（Step 0.5 流程，一次性，不重复提）
> 2. 用户拒绝装 → 切到 CLI 精简编号模式（**每题 ≤ 10 行**，单选/多选明确标注，自由输入兜底）
> 3. **绝不**用大段 markdown + "请按下面 4 类列出" 这种文本作答模式 — 这是已知反例
>
> **每个 AskUserQuestion 调用必须**：
> - `question` 字段在主问之外**附带 Other 输入示例**："如果都不对就用 Other 自由输入，例如 [Foo / Bar / Baz]"
> - `options` 每个 label ≤ 12 字，description 5-15 字
> - `multiSelect` 按题型决定（"勾选所有适用的" → true）
>
> **拆题策略**（题库已写好，照抄即可）：
> - C1 身份 → 1 题 4 选项
> - C2 高频任务 → 1 题 4 选项（multiSelect）
> - **C3 工具栈 → 拆 4 题**（C3.1 笔记 / C3.2 创作 / C3.3 AI / C3.4 协作，每题 multiSelect + Other）
> - C4a/C4b → 1 题任务类型 4 选项 + 2 题文本"讲故事"（这两个是开放题，允许文本）
>
> 完全开放题（C1 第二步具体身份、C4a/C4b 故事讲述、B7 触发原话）仍走文本输入 — 但这些题**本身**就标了"文本输入"。**只要题库标 `工具：AskUserQuestion` 就必须用工具，不准偷懒**。

| # | 规则 | 一句话 |
|---|---|---|
| **B1** | 行为追问优先于想法追问 | 把"想要"逼回"上一次实际做了什么" |
| **B2** | 每答必 Why × 1–2 | 直到答案落到具体行为或情绪词 |
| **B3** | 偏误自检 | 扫"我应该 / 我打算 / 一般来说" |
| **B4** | 矛盾回写（不替用户决定）| 原话回写让用户自己挑 |
| **B5** | 不诱导提问 | 4 类偏误 lint：Leading / Shallow / Personal bias / Unconscious bias |
| **B6** | 题序排列：Game Complexity Arc | 暖场 → 中等 → 复杂 → 收尾 |
| **B7** | 选项法 3+2+1 | 3 强相关 + 2 创意发散 + 1 自定义；UI 工具硬限制 ≤ 4 时拆 2 题 |
| **B8** | 形态推断 + 小白友好反馈三铁律 | 绝不问"你要哪种形态"；5 选项反馈；默认偏 Atomic |
| **B9** | UX 交互呈现（平台原生 UI） | 必用 AskUserQuestion / ask_user_question / MCP；不要让用户打字 |
| **B10** | 用户原话保留（仅 Mode B 强制）| 触发词 / 行话 / 范例 / 模板 / 禁忌 — 逐字保留 |

---

## 引用文件索引

按需读取（Progressive Disclosure 原则——不要一次全读）：

| 文件 | 何时读 |
|---|---|
| `question-bank/shared-core.md` | Step 3 跑共享核心 5 题（C1-C4b）|
| `question-bank/express-mode-a.md` | Step 4，用户选 Mode A 时 |
| `question-bank/mode-b-prerequisites.md` | **Step 4 Mode B 必读** — 前置 0（Mode C 原则继承）+ 前置 1（任务选择）— V1.1 加 |
| `question-bank/express-mode-b.md` | Step 4，用户选 Mode B 时（跑完前置后）|
| `frameworks/hook-canvas.md` | Mode A，挖掘触发场景时 |
| `frameworks/mental-model-6d.md` | Mode A 标准版需要 6 维全跑时（快速版只跑 Memory + Decision + Emotion 三轴，已嵌在 express-mode-a 里）|
| `frameworks/agent-fields.md` | Mode A 合成阶段，按 11 字段映射时 |
| `frameworks/lint-rules.md` | Step 5 三层 lint |
| `frameworks/intent-inference.md` | Step 5.5 AI 反推架构（V0.4+ 核心，V0.8 加 §1.6 C 题信号源 + ASCII preview）|
| `frameworks/interview-basics.md` | **Skill 启动必读** — B1–B10 访谈基本功（V0.8 拆出，原内联在 SKILL.md）|
| `frameworks/ux-interaction-rules.md` | **Skill 启动必读** — UX 交互方法论（V0.8 拆出，与 cross-platform-tool-mapping 分工）|
| `frameworks/task-shortlist-rules.md` | Mode B 任务选择阶段，5 维评分项出 5–8 候选（V0.8 加）|
| `frameworks/platform-export-selector.md` | Mode A Step 6 导出阶段，按 C3 工具栈 Rules A-F 智能筛选 1–3 平台（V0.8 加）|
| `frameworks/output-language-rules.md` | **Step 1.5 + Step 6 + Step 7.5 必读** — 输出语言三档分类（V0.9 加）|
| `frameworks/self-validation.md` | **Step 7.5 必读** — 5 步自测流水线（Schema / 触发 / Dogfood / 覆盖率 / 报告）（V0.9 加）|
| `references/cross-platform-tool-mapping.md` | §B9 跨平台原生选项工具映射（Claude Code / Codex / Cursor / Windsurf / Zed 等 11 平台真实查证 + auq-mcp 部署示例）|
| `templates/mode-a/output-three-layer.md` | Mode A 输出，三层合一主文档 |
| `templates/mode-a/exports/*.md` | Mode A 输出，按平台选导出模板 |
| `templates/mode-b/atomic/` | Mode B 输出 — 单文件 skill（最常见，90%+ 小白默认）|
| `templates/mode-b/orchestration/` | Mode B 输出 — main-SKILL 编排多个 sub-skills |
| `templates/mode-b/with-subagents/` | Mode B 输出 — skill + 专精 subagents |
| `templates/mode-b/plugin-with-hooks/` | Mode B 输出 — plugin 含触发自动化 hooks |
| `templates/mode-b/composite-plugin/` | Mode B 输出 — plugin 含 skills + agents + hooks 全套 |

---

## Anti-patterns（常见错误）

1. **直接套别人的 CLAUDE.md / SKILL.md** —— 这正是这个 skill 要破解的问题，**绝不**让用户从别人的模板开始填空
2. **替用户做选择** —— 遇到矛盾、缺信息时，回写让用户自己决定，而不是 AI 拍板
3. **用 AI 改写用户原话**（仅 Mode B）—— description 的触发词、术语、好范例必须逐字保留
4. **跳过 lint 直接出文档** —— 偏误 / 措辞污染 / schema 三层 lint 是质量底线
5. **在 Mode B 里跳过触发测试和 dogfood** —— 这两道质检决定 skill 能否被 Claude 正确调起
6. **快速版超过 15 分钟** —— 如果 10 题已经超时，是问题清单或追问失控了，停下来收口

---

## 设计依据

本 skill 基于以下方法论提炼（详见 `outputs/02_methodology_distilled.md`）：

- **用户访谈方法论** — 不诱导提问 / 行为追问 / 偏误识别 / Game Complexity Arc
- **精益用户研究** — 精益迭代 / 可证伪假设 / 饱和判定（用于深度版）
- **认知心理学 6 维框架** — 6 维心智模型 → AI 行为约束
- **习惯回路四要素** — 四要素反向用作触发场景挖掘
- **Agent 设计指南** — Agent 11 字段契约
- **Prompt 工程系统化指南** — 9 段 principles 骨架 / 跨平台差异
- **skill-creator 范式**（Anthropic 官方）— SKILL.md 三要素 description / 用户原话保留 / 触发测试 + dogfood

---

## 版本

- **V0.9 (2026-05-09)** — 基于老板对 V0.8 实测反馈的 2 个问题：
  - **问题 1（中英混杂）**：V0.7/V0.8 产物出现"骨架英文（Layer 1 / Workflow / Persona）+ 内容中文"。修正：
    - **加 Step 1.5 选输出语言**（中文 / 英文 / 双语 / 其他自行说），用 AskUserQuestion 单选呈现
    - **新增 frameworks/output-language-rules.md** — 三档分类（强制保留英文：技术术语+文件名+工具名+Anthropic 形态名 / 必须翻译：所有段标题+章节标题+说明文字 / 用户原话保留：按 §B10 不动），含中英映射表 + 双语对照模式 + 实施清单
    - **改 templates/mode-a/output-three-layer.md** — 段标题统一中文（"Layer 1 — 用户画像"→"第一层 — 用户画像"等），头部加语言一致性提醒
  - **问题 2（缺主动自测）**：V0.7/V0.8 Step 7 只有"念 5 假问题 + 跑 1 真实任务"，过于粗糙。修正：
    - **改写 Step 7 → Step 7.5：AI 自测验证 + 主动优化建议**（5 步流水线 — Schema 自检 / 触发测试 / Dogfood 模拟 / 覆盖率检查 / 主动报告 + 5 选项反馈循环）
    - **新增 frameworks/self-validation.md** — 详细规则：Schema 检查清单（frontmatter / 行数 / Hard Rules 大写 / Anti-patterns ≥ 3 / examples ≥ good-1+bad-1 / 输出语言一致性）+ 触发测试样本生成法（5 pos + 5 neg）+ Dogfood 5 维度对比（风格 / 原话 / Hard Rules / Anti-patterns / 禁词）+ 覆盖率指标（B10 五类 + 红线全命中 + 工具栈对齐）+ 报告模板（🔴 严重 / 🟡 中等 / 🟢 轻微）+ 5 选项反馈处理
    - **关键设计原则**：AI 主动（不等用户找问题）+ 机械化优先（grep/regex 比模型判断准 10 倍）+ 用户保留拒绝权（不强行让用户全接受）
- **V0.8 (2026-05-09)** — 基于与 cowork 版（`D:\Book\AI 构建引用书籍\github-release`）双实施横向对比，吸收 cowork 高价值资产 + 反向输送我们差异化资产。完整对比见 `17_cross_implementation_review.md` + `COWORK_PATCH_V08.md`。修正：
  - **架构命名对齐 Anthropic 官方术语**：`skill-package`→`atomic` / `skill-chain`→`orchestration` / `sub-agent-skill`→`with-subagents` / `hook-driven-skill`→`plugin-with-hooks` / `hybrid-skill`→`composite-plugin`。intent-inference.md 全文术语统一（Single Skill→Atomic Skill 等）
  - **拆 SKILL.md §B1–B8 到 frameworks/interview-basics.md**，升级为 B1–B10：加 B7（3+2+1 选项法）、B8（形态推断三铁律）、B9（UX 交互）、B10（用户原话）作为独立基本功。SKILL.md 339 → 278 行
  - **新增 frameworks/ux-interaction-rules.md**（方法论级）— 与 references/cross-platform-tool-mapping.md 分工：前者讲"为什么 + 如何检测 + 何时用什么模式"，后者讲"11 平台具体调用映射"
  - **新增 frameworks/task-shortlist-rules.md** — Mode B 任务 5 维评分（频次×2 / 耗时×2 / 可拆解×1.5 / 隐性知识密度×1.5 / 崩溃修复价值×1）+ 任务类型多样性约束
  - **新增 frameworks/platform-export-selector.md** — Mode A Rules A-F 按 C3 工具栈智能筛选 1–3 平台导出（避免无脑全部 5 个）
  - **shared-core C4 拆为 C4a（满意）+ C4b（崩溃）** — 一题塞两件事 → 用户讲一件草草带过另一件；C4b 是 task-shortlist "崩溃修复价值"维度 + intent-inference "反向任务"创意发散候选的唯一信号源
  - **intent-inference.md Part 1 加 §1.6 C 题信号源** — C 题作为元层级信号（用户能力 vs 工具复杂度匹配度）；C 题信号可强制覆盖主架构判定（如 C4a/C4b 都答不上 → 强制降级 Atomic）
  - **intent-inference.md Part 3 翻译模板加 ASCII preview 树** — 每种形态的段 5 文件清单都附 ASCII 树状结构
  - **填充 examples/** — 项目根 examples/ 三角色 dogfood 拷到 skill 包内 + 两份 cross_review
  - 保留我们 V0.6/V0.4.1 差异化资产：段 3.5 机械化检查点 / §2.6 对照镜模式 / ⑤ 自行输入出口（每题 ≤ 4 选项硬限制下用拆题方式实现 5 选项反馈）
- **V0.7 (2026-05-09)** — 基于实测暴露的体验漏洞："markdown 列表让用户打字回复，CLI 体验糟糕"。修正：
  - 加 §B8 — 每次呈现选项时**必须调 AskUserQuestion 工具**（CLI 真交互式选择器，自动给 Other / multiSelect / header / description 全套）
  - **每题选项 ≤ 4**（V0.6 的"3 强相关 + 2 创意发散 = 5"超 AskUserQuestion 4-option 硬限制）
  - **删手动"⑥ 其他"**（AskUserQuestion 自动加 Other）
  - **每题加 metadata**（工具 / multiSelect / header）
  - **完全开放题** + **必须贴原物题**仍走普通文本输入（不强行 AskUserQuestion）
  - shared-core / express-mode-a / express-mode-b 全部按新格式重写
- **V0.6 (2026-05-09)** — 基于 Mode A 三角横向对比（`15_dogfood_review.md`）暴露的 4 个 V0.6 候选：
  - `intent-inference.md` Part 2 拆"主架构判定"和"装饰组件判定"为两个独立步骤
  - `intent-inference.md` Part 3 段 3 "≥ 3 条"改为软性推荐（红线少是弱信号）
  - `intent-inference.md` Part 3.1 加 **段 3.5 机械化检查点**（5 段 → 6 段；AI 主动把红线压缩为可机械判定的硬规则）
  - `02_methodology_distilled.md` Part 2 加 §2.6 **对照镜模式**（来自 Mode A 三角共性：3 角色都把 AI 当"对照镜"不是"代笔人"）
- **V0.5 (2026-05-09)** — 基于林女士 V0.4.1 dogfood 暴露的问题：轮 1 方案把红线藏在"它不会做"散文式描述里，林女士选 ④ 太简单"漏了客户隔离"——其实她已经看到那一句但不够醒目。修正：`intent-inference.md` Part 3.1 翻译模板从单段散文改为 **5 段独立结构**（核心动作 / ✅ AI 会做 / ❌ AI 不会做（红线独立段）/ ⏸ AI 会停下来问 / 📁 文件清单 + 配置成本）。Step 5.5 第 4 步呈现方案时使用此结构。
- **V0.4.1 (2026-05-09)** — 基于老板对 V0.4 的纠正："用户大部分是小白，但少部分是 AI 熟练用户；所有 AI 给选项的地方都应该保留'用户自行输入/补充'出口。" V0.4 把熟练用户出口砍了又走极端。本版修正：
  - Step 5.5 反馈循环从 4 选项加到 **5 选项**（⑤ 自行输入调整指示）
  - `intent-inference.md` Part 4 加 ⑤ 处理规则：按用户输入层级（术语级 / 修订级 / 范围级 / 完全 override）分类响应
  - **关键**：选 ⑤ 后 AI 不质疑用户、不试图劝小白思维 — 这是熟练用户的 agency
  - question-bank 各题已有"⑥ 自定义"出口（V0.2 题型范式自带），不需补
- **V0.4 (2026-05-09)** — 基于老板对 V0.3.1 的根本性反馈："用户都不知道，他怎么会告诉你我需要单一还是复杂？必须语义和意图分析，由 AI 来判断。"V0.3 让小白用户回答"single 还是 chain"违反了这个 skill 的目标用户画像（小白）。
  - **删除** A11 / A12 / B11 / B12 / B13 / B14（让小白做技术选型的题）
  - **新建** `frameworks/intent-inference.md` — AI 语义反推规则手册（信号扫描 + 综合判定 + 翻译成人话 + high-level 反馈循环）
  - **改写** Step 5.5：从"用户选架构"改为"AI 反推 + 用户 high-level 确认（够 / 不够 / 太复杂 / 太简单）"
  - 5 种架构模板（V0.3 已建）保留不动，但用户**不需要选** — AI 反推后自动拷对应模板
- **V0.3 (2026-05-09)** — 基于 Alex dogfood 反馈：现有 skill 默认输出"single skill"，不能覆盖 skill chain / sub-agent / hook-driven 等复合工作流。本版新增：
  - `notes/08_claude_code_capabilities.md` —— Claude Code 6 大能力一手地图（Skills / Sub-agents / Hooks / Slash / MCP / Plugins，全部基于 docs.claude.com 一手 WebFetch）
  - `02_methodology_distilled.md` 加 §Part 3.7 架构选择决策树（合成前依据）
  - `express-mode-a.md` 加 A11（工作流复杂度）+ A12（自动化触发场景）
  - `express-mode-b.md` 加 B11（架构需求）+ B12（专精分工）+ B13（触发自动化）+ B14（外部系统）；同时把 V0.2 题型范式（3+2+自定义）应用到 B1–B10
  - `templates/mode-b/` 新增 4 种架构模板：`skill-chain/` / `sub-agent-skill/` / `hook-driven-skill/` / `hybrid-skill/`（保留原 `skill-package/` 作为 single-skill 模板）— **V0.8 全部 rename 为 Anthropic 官方术语**：`atomic` / `orchestration` / `with-subagents` / `plugin-with-hooks` / `composite-plugin`
  - 主流程加 Step 5.5：架构选择（基于决策树推荐 + 用户 override）
- **V0.2 (2026-05-09)** — 基于小马 dogfood 反馈：question-bank 全部 14 题（C1–C4 + A1–A10）改成 **「3 强相关选项 + 2 创意发散选项 + 自定义」** 题型范式。原理：用户访谈方法论的偏误谱系 + Social desirability bias —— 用户自由文字回答会因措辞习惯偏离真实行为，给选项 = 用 recognition 模式降低 self-report bias。新增字段：A5 ⑤ 双轨模式（来自小马三角矛盾仲裁）；A8 ⑦ 稀释语感（来自小马 A10 原话）；A10 5 个提示话题作引子。
- V0.1 (2026-05-09) — MVP，完整支持快速版（Mode A + Mode B）。标准版与深度版的 AI 主动追问脚本待后续加。
