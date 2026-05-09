# Skill Chain 模板（Mode B 架构 #2）

> ⚠ **V0.4 重要提示**：用户**不会主动选**"我要 skill chain"。本架构由 AI 在 Step 5.5 通过语义反推（见 `frameworks/intent-inference.md`）后**自动选定**。
> 用户拿到的方案是**人话**："你这个工作可以拆成 N 步走，每步做完先给你看，你说继续才下一步" — 不会出现 "skill chain" 字眼。

**何时由 AI 选定本架构**：raw_answers 里有强信号显示用户工作流是多步串联且每步任务类型不同（如 B3 SOP 出现"先 X 后 Y 再 Z"模式 + X/Y/Z 是不同 mental mode 的动词，且能讲出每步 AI 角色差异）

## 这个架构是什么

一个 **orchestrator skill**（顶层入口）+ N 个 **sub-skills**（每段独立任务），由用户原话或 orchestrator 在 Workflow 段引用次序触发。

**典型用例**（小马的"写公众号"工作流）：
```
读卡片 (read-cards-skill)
   ↓
选题候选 (topic-candidate-skill)
   ↓
hook 起草 (hook-draft-skill)
   ↓
（用户挑了一版后）
改稿提示 (refine-skill)
```

## 怎么用这个模板

```
my-chain-name/
├── README.md                    ← 链整体说明（用户改 / 这就是当前文件）
├── orchestrator/
│   └── SKILL.md                 ← 顶层入口 skill（描述链 + 在 Workflow 段引用 sub-skills）
├── sub-skills/
│   ├── step-1-{name}/SKILL.md   ← 第 1 个 sub-skill
│   ├── step-2-{name}/SKILL.md   ← 第 2 个 sub-skill
│   └── step-N-{name}/SKILL.md   ← 第 N 个 sub-skill
├── examples/
│   └── full-chain-walkthrough.md ← 跑完整链一次的实例（含每步输入输出）
└── references/
    └── glossary.md
```

## 部署位置

按 SKILL.md 三层（个人 / 项目 / 插件）任选：

```
~/.claude/skills/                # 个人
├── my-chain-orchestrator/SKILL.md
└── my-chain-step-{N}-{name}/SKILL.md  # 每个 sub-skill 独立目录

或 .claude/skills/                # 项目
或 my-plugin/skills/              # plugin 内
```

⚠ **关键**：每个 sub-skill 都是**独立的** SKILL.md（不能嵌套），因为 Claude Code 按单层目录扫描 skill。

## 各 sub-skill 的 description 写法（关键）

每个 sub-skill 的 description 应该：
1. 包含 **本步骤独立的触发原话**（用户在该步会说的话，原话保留）
2. 显式说明**链中的位置**：「Use this skill **after** running `/step-1-read-cards`」
3. 显式说明**输出对接**：「Output goes to `/step-3-refine`」

例：

```yaml
---
name: my-chain-step-2-topic-candidate
description: Generate 3 topic candidates from extracted reading cards. Use AFTER running /my-chain-step-1-read-cards (which produces the cards). Trigger when user says "从这些卡片选 3 个角度" / "这周的卡片里挑选题" / "下篇文章方向". Output: 3 candidates in JSON format, ready for /my-chain-step-3-hook-draft. Do NOT use for: standalone topic generation without source cards (use /generic-topic-brainstorm for that).
---
```

## Orchestrator 的角色

Orchestrator skill 干 3 件事：

1. **向用户呈现整条链**：跑 `/my-chain-orchestrator` 时给出"我会按 N 步处理你的输入"
2. **明确次序**：在 Workflow 段写明每步调用哪个 sub-skill
3. **错误恢复**：某一步失败时，告诉用户在哪一步停了，能不能从中间重启

## 与 Single Skill 的成本对比

| 维度 | Single Skill | Skill Chain |
|---|---|---|
| 文件数 | 1 个 SKILL.md | 1 + N 个 SKILL.md |
| description 写作 | 1 份 | N+1 份 |
| 触发率风险 | 低（1 份对外）| **中（N 份各自要写好，否则中间步触发不到）** |
| 调试 | 易 | **较难（要排哪一步出问题）**|
| 重用性 | 低 | **高（sub-skill 可单独跑）** |
| 适合场景 | 简单任务 | 多步、每步任务类型不同的复杂工作流 |

## 字段映射（来自 question-bank）

| Question | Maps to |
|---|---|
| B1 一句话定义 | orchestrator SKILL.md 的 Overview |
| B2 输入材料 | orchestrator 的 Quick Reference 段 |
| B3 手动 SOP（拆 N 步）| **每步 → 1 个 sub-skill 的 Workflow** |
| B4 判断节点 | 对应 sub-skill 的 `## When to ask` 段 |
| B5 行内规矩 | 各 sub-skill 的 Anti-patterns（按步骤拆分）|
| B6 术语 + 禁词 | references/glossary.md（各 sub-skill 共享）+ 各 sub-skill Hard Rules |
| B7 触发原话（多句）| **拆给各 sub-skill 的 description**（每步独立触发原话）|
| B8 好 / 差范例 | examples/full-chain-walkthrough.md + 各步独立 examples/ |
| B9 自检 | 各 sub-skill 的 Self-check 段 |

## 质检（与 Single Skill 一样，所有 sub-skill 都跑）

- 跑 N+1 个 description 触发测试（每个 sub-skill 5 条假问 + orchestrator 5 条假问）
- dogfood 一次完整链（用 B8 的好范例对应场景）
- 如某一步 dogfood 不像用户做的，先补该 sub-skill 的 examples/

## 模板文件

下面 2 个文件是起步模板：
- `orchestrator/SKILL.md` — 拷贝改名为 `~/.claude/skills/<your-chain-name>-orchestrator/SKILL.md`
- `sub-skill-template.md` — 拷贝 N 次，每次改名为 `~/.claude/skills/<your-chain-name>-step-N-<sub-name>/SKILL.md`
