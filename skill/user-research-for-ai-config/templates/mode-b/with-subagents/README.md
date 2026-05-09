# Sub-agent Skill 模板（Mode B 架构 #3）

> ⚠ **V0.4 重要提示**：用户**不会主动选**"我要 sub-agent"。本架构由 AI 在 Step 5.5 通过语义反推（见 `frameworks/intent-inference.md`）后**自动选定**。
> 用户拿到的方案是**人话**："你这个任务有 N 个角度需要并行考虑，AI 会同时让 N 个'分身'分别看一遍，最后汇总给你" — 不会出现 "sub-agent" / "fork" 字眼。

**何时由 AI 选定本架构**：raw_answers 里有强信号显示用户需要 ≥ 3 个独立视角并行（关注点不重叠）且能列出每个视角具体的不同关注点（B5 行内规矩可按视角拆分）

## 这个架构是什么

一个 **coordinator skill**（顶层入口，带 `context: fork`）+ N 个 **subagents**（独立 prompt + 工具集 + 模型）。
Coordinator 派发任务给 N 个 subagent **并行**跑（每个独立 context 不互相污染），最后**汇总结果**。

**典型用例**（Alex 的"PR review 3 视角"）：
```
                  ┌────────────────────┐
                  │  /pr-review-3views │  ← coordinator skill
                  └──────────┬─────────┘
                             ├──→ stability-reviewer  (.claude/agents/stability-reviewer.md)
                             ├──→ perf-reviewer       (.claude/agents/perf-reviewer.md)
                             └──→ maintainability-reviewer (.claude/agents/maintainability-reviewer.md)
                             ↓
                       汇总 JSON 输出到主对话
```

## 怎么用这个模板

```
my-multiview-skill/
├── README.md                       ← 整体说明（即本文件）
├── coordinator/
│   └── SKILL.md                    ← 入口 skill，带 context: fork
├── agents/
│   ├── {role-1}.md                 ← 视角 1 subagent（如 stability-reviewer）
│   ├── {role-2}.md                 ← 视角 2 subagent
│   └── {role-N}.md                 ← 视角 N subagent
├── examples/
│   └── three-views-walkthrough.md  ← 一次完整 3 视角并行 + 汇总的实例
└── references/
    └── glossary.md
```

## 部署位置

```
~/.claude/skills/{my-multiview-skill}-coordinator/SKILL.md
~/.claude/agents/{role-1}.md
~/.claude/agents/{role-2}.md
~/.claude/agents/{role-N}.md
```

⚠ **关键**：subagent 配置文件的路径是 `.claude/agents/<name>.md`（与 `.claude/skills/` 平级），不是 skill 子目录。

## 关于 `context: fork` + `agent` 字段

`coordinator/SKILL.md` 在 frontmatter 里写：

```yaml
---
name: my-multiview-skill-coordinator
description: ...
context: fork
agent: general-purpose
---
```

**当 coordinator 被调用时**：
1. 一个新的 isolated context 被创建（fork）
2. SKILL.md 内容作为 prompt 进入这个 fork
3. 在 fork 里，Claude 根据 description 匹配自动派发到 `~/.claude/agents/` 里的 subagent
4. 各 subagent 在**自己的 isolated context** 跑（互不污染）
5. 各 subagent 返回结果到 coordinator 的 fork
6. coordinator 汇总 → 返回主对话 summary

## Subagent 配置文件 frontmatter

每个 `.claude/agents/<role>.md` 的 frontmatter：

| 字段 | 用途 |
|---|---|
| `name` | subagent 名 |
| `description` | **关键** — Claude 在 coordinator 阶段据此自动派发 |
| `model` | `claude-haiku-4-5-20251001`（节省成本）/ `claude-sonnet-4-6` / `inherit` |
| `tools` | 限定工具集（`Read Grep Bash` 等）|
| `permission-mode` | `default` / `auto` / `acceptEdits` |

**关键写法**：每个 subagent 的 description 必须**清楚说明本视角的边界**，让 coordinator 知道"什么任务派给哪个 subagent"。

例：

```yaml
---
name: stability-reviewer
description: Review code for stability risks — race conditions, error handling gaps, resource leaks, retry strategies, idempotency. Use ONLY when reviewing PR diffs / fix patches. Do NOT use for performance, code style, or doc reviews (use perf-reviewer / maintainability-reviewer instead).
model: claude-haiku-4-5-20251001
tools: Read Grep Glob
---
```

## 与 Single Skill 的成本对比

| 维度 | Single Skill | Sub-agent Skill |
|---|---|---|
| 文件数 | 1 | 1 + N（coordinator + N agents）|
| description / prompt 写作 | 1 份 | 1 + N 份 |
| 上下文成本 | 1 份 SKILL 内容入主对话 | coordinator 也是 fork 隔离 + N agent 各自 fork（**主对话只看到 summary**）|
| 并行能力 | 否 | **是（N 视角同时跑）**|
| 调试 | 易 | **较难（哪个 agent 出错要单独跑）**|
| 成本 | 1 模型 turn | N+1 模型 turn（但可用 Haiku 省钱）|
| 适合场景 | 单视角 / 单上下文 | 多视角并行 + 上下文需要隔离 |

## 字段映射（来自 question-bank）

| Question | Maps to |
|---|---|
| B1 一句话定义 | coordinator SKILL.md Overview + description |
| B2 输入材料 | coordinator Quick Reference |
| **B12 ② 多视角分工** | **决定要 N 个 agent + 每个 agent 的视角** |
| B5 行内规矩（按视角拆分）| 各 agent 的 system prompt（subagent .md 正文）|
| B7 触发原话 | coordinator description 主触发 |
| B8 好 / 差范例 | examples/three-views-walkthrough.md |
| B9 自检 | coordinator 在汇总阶段做整体自检；各 agent 也有视角内自检 |

## 模板文件

- `coordinator/SKILL.md` — 入口
- `agents/agent-template.md` — subagent 模板（拷贝 N 次，每次改名为 `~/.claude/agents/<role>.md`）

## 质检

- description 触发测试：coordinator + 每个 subagent 各 5 条
- dogfood 一次完整 3 视角并行任务（用 B8 好范例对应场景）
- 验证各 subagent **真的独立** —— 同一输入派给 3 个 subagent，结果应有显著差异（如果都给一样的输出，说明视角分工失败，回去改 subagent 的 description / prompt）
