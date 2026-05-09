# UX 交互呈现规则（V0.8 — 方法论级）

> **何时读**：Skill 启动时一次性加载本文，作为所有"让用户做选择"环节的方法论基础。
>
> **使命**：用户**绝不应该**被要求阅读大段 markdown 题目然后打字回复——必须用平台原生 UI 工具（如选项卡、单选框、多选框）让用户**点击**。
>
> **与 `references/cross-platform-tool-mapping.md` 的分工**：
> - **本文件（方法论级）**：为什么这样做 / 如何检测平台 / 什么时候用什么模式 / 题库格式设计
> - **`references/cross-platform-tool-mapping.md`（落地表）**：11 平台的具体工具调用映射表 + auq-mcp 部署示例
>
> 适用所有 question-bank 题目、shape-inference 5 段式预览、所有"5 选项 + 自定义"反馈环节。

---

## Part 1 — 核心铁律（V0.7 实测）

1. **禁止大段 markdown 题目** — 题目内容输出超过 8 行就视为违反 UX 规则
2. **优先调用平台 UI 工具** — `AskUserQuestion` / `ask_user_question` / MCP picker
3. **CLI 环境必用精简编号选项** — 单行问题 + 编号选项 + "回数字或文字"
4. **单选 vs 多选必须显式声明** — 并尝试调用对应 UI 模式
5. **每题必有自定义兜底** — 选项后必有"自由输入"路径

> **V0.7 实测教训**：plugin 装好后第一次跑用 markdown 列表让用户打字，反馈"体验上的大问题"。从此本规则升为铁律。

---

## Part 2 — 平台 UI 工具检测（一次检测全程沿用）

### 检测伪代码

```
on skill 启动:
    # 优先级 1：原生 / MCP AskUserQuestion 系列
    if 'AskUserQuestion' in available_tools:
        # Claude Code 2.1.1+ / Desktop / Claude.ai / Cowork（原生）
        mode = 'native_aaq'
    elif 'ask_user_question' in available_tools:
        # Codex CLI（原生）/ 任何配了 ask-user-questions-mcp 的 MCP 客户端
        mode = 'mcp_or_codex'

    # 优先级 2：客户端内置非 MCP picker
    elif 检测到运行在 Gemini CLI:
        mode = 'gemini_slash'  # 用 slash / @ picker（功能受限）

    # 优先级 3：fallback（自部署 LLM / Web ChatGPT 等）
    else:
        mode = 'cli_text_fallback'

    save mode to ${SESSION_DATA}/ui_mode
```

> **关键事实**（V0.7 修正 — 之前误判）：
> - **几乎所有现代 AI 工具都支持 MCP** → 可通过 [`paulp-o/ask-user-questions-mcp`](https://github.com/paulp-o/ask-user-questions-mcp) 获得统一选项 UI
> - 之前的"非 Anthropic 工具都没有 → CLI fallback"判断**是错的**
> - Codex CLI **有内置 `ask_user_question`** — 不需要 MCP（来源：[Codex Issue #9926](https://github.com/openai/codex/issues/9926)）
> - **CLI 精简编号 fallback 只用在自部署 LLM / Web ChatGPT 等极少数环境**

完整 11 平台映射 + 部署示例 → 见 [`references/cross-platform-tool-mapping.md`](../references/cross-platform-tool-mapping.md)

### 用户安装建议（首次启动）

如果用户的客户端**不是 Claude 全家桶**也**不是 Codex CLI**，主动给一次安装提示（**不是每次都提**）：

```
🔍 我发现你的环境里没有 AskUserQuestion 工具，会让选项体验差一些。

如果你用 Cursor / Windsurf / Cline / VS Code + Copilot / Zed / Kilo 等：
强烈建议安装 ask-user-questions-mcp 这个 MCP server，5 分钟搞定。
说明：https://github.com/paulp-o/ask-user-questions-mcp

要现在装吗？
[✅ 现在装（暂停 skill）] [⏭ 用 CLI 文字模式继续] [❓ 这是啥]
```

---

## Part 3 — UI 工具调用模式（mode = native_aaq / mcp_or_codex）

### 单题调用 AskUserQuestion 例子

```python
AskUserQuestion(questions=[{
    "question": "你做什么 + 给谁交付？",
    "header": "工作形态",
    "multiSelect": False,
    "options": [
        {"label": "文字内容创作", "description": "公众号 / Newsletter / 视频脚本"},
        {"label": "软件/数字产品", "description": "Indie Hacker / SaaS / 工具"},
        {"label": "知识服务", "description": "顾问 / 教练 / 培训师"},
        {"label": "多重身份并行", "description": "正职 + 副业 + 自我探索"}
        # "其它"由 AskUserQuestion 自动添加，无需手动加
    ]
}])
```

### 多选时

```python
"multiSelect": True
```

### 多题打包（最多 4 题/次）

**何时打包**：相邻 2–4 题相关性强（如 A6 视觉偏好的 a/b 子问）打包；独立题不打包（让用户答完一题后给追问）。

### 选项 label 规则（硬约束）

- **≤ 12 字**（避免 UI 截断）
- **不要 emoji**（避免干扰 description）
- **互不重叠**
- **每题 ≤ 4 选项**（AskUserQuestion 硬限制；要 5 选项时拆 2 题，详见 `interview-basics.md` §B7.2）

---

## Part 4 — CLI 精简编号 fallback（mode = cli_text_fallback）

> ⚠ **仅在自部署 LLM / Web ChatGPT 等极少数环境启用** — 任何 Claude / Codex / MCP 平台一律不走这条 fallback。

### 标准格式

```
🤔 [一行问题]

  1. [选项 1 — ≤ 30 字]
  2. [选项 2]
  3. [选项 3]
  4. [选项 4 创意发散]
  5. [选项 5 创意发散]
  6. 自定义（请直接说）

→ 单选/多选标注 + "回数字或自由文字"
```

### 单选 vs 多选必须显式

- **单选**：`→ 回 1 个数字（1–5）或写下你的描述`
- **多选**：`→ 回多个数字（如 "1, 3, 5"）或写下你的描述`
- **强制 ≥ N**：`→ 至少回 N 个数字`

### 极简化原则

- **题目 1 行**（≤ 60 字）—— 不要 markdown 标题、不要"主问"框、不要"为什么问"段
- **每个选项 1 行**（≤ 30 字）—— 简短描述比详细更友好
- **总共 ≤ 10 行**（题 + 6 选项 + 提示行）

### 反例（任何平台都不要这样输出）

```
## C1：身份 — 你做什么 + 给谁交付什么

**主问**：

> 用一句话告诉我：你主要在做什么 + 给谁交付什么？

**先选一个最贴近的工作形态**（多选可选 ≤ 2）：

① **文字内容创作**（公众号 / Newsletter / 长文 / 视频脚本 / 课程）
...
```

→ 用户要读 30+ 行才知道怎么回——心智成本高、视觉疲劳。

### 正例（精简）

```
🤔 你做什么 + 给谁交付？

  1. 文字内容创作（公众号/Newsletter/视频）
  2. 软件产品（Indie Hacker/SaaS）
  3. 知识服务（顾问/教练）
  4. 多重身份并行
  5. 转型期/探索期
  6. 自定义（请说）

→ 回数字 1–5 或自由文字（多选用逗号"1,3"）
```

→ 用户 5 秒看完、5 秒回应。

---

## Part 5 — 单选 vs 多选自动判定

LLM 在出题前判断本题是单选还是多选：

| 题型 | 标识 | 例 |
|---|---|---|
| **单选** | "选一个最贴近的" / "你最喜欢哪种" / "你主要是谁" | C1 身份 / A2 角色比喻 / A5 自治度 |
| **多选** | "勾选所有适用的" / "选 N 项" / "列出 X 个" | C2 高频任务 / A3 ② 不信任话术 / A6 视觉偏好 |
| **强制必选 N 个** | "必须填 ≥ 3 条" / "至少给 X 项" | B5 行内规矩（≥ 3）/ B6 术语表（≥ 5）|

UI 模式：调用 AskUserQuestion 时设 `multiSelect: True/False`。
CLI 模式：明确告诉用户"回 1 个数字" / "回多个数字 1,3,5" / "至少回 N 个"。

---

## Part 6 — 题库格式调整规则

为支持两种模式，question-bank/*.md 的题目结构调整为（详见现有 question-bank/*.md 即按此设计）：

```markdown
## C1：身份

[题元数据]
mode_hint: single_select | multi_select | required_min_3
ui_label: "你做什么 + 给谁交付？"
ui_options:
  - label: "文字内容创作"
    description: "公众号/Newsletter/视频"
  - label: "软件产品"
    description: "Indie Hacker/SaaS"
  - label: "知识服务"
    description: "顾问/教练"
  - label: "多重身份并行"
    description: "正职+副业+探索"
# "自定义"由 UI 工具自动添加；CLI 模式 LLM 自动加 5/6. 选项

[CLI 模式呈现]
🤔 你做什么 + 给谁交付？
  1. ...
→ 回数字或自由文字

[追问规则]
- 选 1：你具体交付什么频率？
- 选 2：产品类型？面向哪类用户？
- ...
```

LLM 根据 `mode = native_aaq / mcp_or_codex / cli_text_fallback` 选呈现方式。

---

## Part 7 — Step 5.5 形态预览的 6 段式呈现适配

V0.6 形态推断的 6 段呈现（详见 `intent-inference.md` Part 3），CLI 用 ASCII 没问题；UI 模式可考虑：

- AskUserQuestion 的 `preview` 字段（如 SDK 支持）— 把 ASCII 图塞进 preview
- 5 选项反馈用 5 个 options（① 够用 / ② 不够好 / ③ 太复杂 / ④ 太简单 / ⑤ 自行输入）— 但 AskUserQuestion 硬限制 4 个，所以拆为 2 题：
  - 第 1 题：① 够用 / ② 不够好 / ③ 太复杂 / ④ 太简单
  - 用户选"其它（自动加的）" → 触发第 2 题：⑤ 自行输入（自由文字）

---

## Part 8 — 实测验证清单

任何 V0.x → V0.x+1 升级后，必须跑下列实测：

```
□ 在 Claude Code 跑——是否调用了 AskUserQuestion？
   通过：用户能用鼠标/方向键点选项
   失败：输出大段 markdown 让用户打字 → bug

□ 在 Codex CLI 跑——是否调用了 ask_user_question？
   通过：渲染 tabbed picker UI
   失败：fallback 到 markdown 列表 → bug

□ 在 Cursor + auq-mcp 跑——是否调用了 ask_user_question MCP tool？
   通过：渲染 MCP 选项卡
   失败：跳过 MCP 直接出 markdown → bug

□ 单选/多选标注是否清晰？
□ "自定义"兜底是否始终可用？
□ 每题输出 ≤ 10 行（CLI mode）？
```

---

## Part 9 — Fallback 链

```
1. AskUserQuestion 可用 → native_aaq 模式
2. ask_user_question 可用 → mcp_or_codex 模式
3. 否则 select / prompt_user 类工具可用 → 替代 UI 模式
4. 否则 → CLI 精简编号
5. 任何模式下都允许用户输自由文字（兜底）
6. 用户输的自由文字 LLM 解析为对应 option（如"1" / "1,3" / "我自己说..."）
```

---

## 版本

- **V0.8 (2026-05-09)** — 从 cowork V0.4.5 ux-interaction-rules.md 借鉴 + 与我们 V0.7 references/cross-platform-tool-mapping.md 分工。本文方法论级，11 平台映射在 cross-platform-tool-mapping.md。
- **V0.7 source**（我们）— 实测暴露"用 markdown 列表让用户打字 CLI 体验糟糕"，加 SKILL.md §B8 平台原生工具规则。
- **V0.4.5 source**（cowork）— 11 平台 web search 真实数据，发现 ask-user-questions-mcp 普适解。
