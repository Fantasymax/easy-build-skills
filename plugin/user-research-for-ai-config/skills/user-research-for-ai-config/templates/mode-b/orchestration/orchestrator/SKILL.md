---
name: {kebab-chain-name}-orchestrator
description: Orchestrate a {N}-step workflow that {B1 一句话定义}. This is the entry point — when the user says any of {B7 ① 顶层触发原话 1–2 句}, this skill walks them through {sub-skills 列表} in order. Trigger especially when the user mentions {B7 整体触发原话} or wants to "do the whole flow". Do NOT use for: single-step requests (use the corresponding sub-skill directly).
---

# {Skill 链标题}

> 这是 {用户名} 的 {B1 一句话定义} 的 **orchestrator**。本 skill 不直接做任务，而是按次序驱动 N 个 sub-skills。
> 生成日期 {YYYY-MM-DD} | V1（快速版）

## Overview

{B1 一句话定义原话}

整条链分为 N 步：
1. `/{chain-name}-step-1-{name}` — {第 1 步做什么，一句}
2. `/{chain-name}-step-2-{name}` — {第 2 步做什么}
3. ...

每一步**独立**可跑（用户可以中间插入 / 跳过 / 重跑），也可以一气走完。

## Quick Reference

| 步骤 | sub-skill | 输入 | 输出 |
|---|---|---|---|
| 1 | `/{chain-name}-step-1-{name}` | {B2 输入材料 - 第 1 步} | {第 1 步输出} |
| 2 | `/{chain-name}-step-2-{name}` | {第 1 步的输出} | {第 2 步输出} |
| N | ... | ... | ... |

## When to use this orchestrator

- 用户想从 0 走完整条链：`/{chain-name}-orchestrator`
- 用户问 "{B7 整体触发原话}" 时 Claude 自动调用本 skill

**不该触发**：
- 用户只想做单步（如"只生成 hook 草稿"）→ 让 Claude 直接调 `/{chain-name}-step-N-{name}`
- 用户想做与本链无关的 generic 任务

## Workflow（链次序）

```
[Phase 1：链入口]
1. 接收用户输入（{B2 输入材料 - 起点}）
2. 简短复述："我会按 N 步处理：[1] [2] [3]，每步走完会给你看，你可以选'继续'或'停在这里改'"

[Phase 2：调度执行]
3. 调用 /{chain-name}-step-1-{name}，传入用户原始输入
4. 拿到 step-1 输出 → 展示给用户 → 等"继续"或修改指示
5. 调用 /{chain-name}-step-2-{name}，传入 step-1 输出
6. 拿到 step-2 输出 → 展示 → 等"继续"
7. ...直到最后一步

[Phase 3：收尾]
8. 整链跑完后总结："链已跑完。你可以：① 接受全部 ② 回到第 N 步重做 ③ 把整条产出导出"
```

## Hard Rules

- MUST 在每步之间**暂停等用户确认**（B11 选 ② 时通常意味着用户希望见每步结果，不能一气端）
- MUST 在出错时告知"在第 N 步失败了，原因是 X，可以从第 N 步重启"，不要静默重启整链
- NEVER 跳过某步（如果某步对用户太简单，Claude 会觉得"我直接用通用能力做就行"——那就该把那步从链里删掉，而不是动态跳过）
- ALWAYS 记录每步的输入输出（便于后续 dogfood 时找哪步出了问题）

## When to ask

- 第 1 步开始前：「你这次是想跑全链还是只跑前几步？」
- 每步结束后：「这步 OK 吗？继续下一步 / 还是改这步？」
- 某步用户原话和该步触发原话不匹配：「你这次的输入似乎更适合跳到第 N 步，要不要直接从 N 开始？」

## Reference files

按需读：

- `examples/full-chain-walkthrough.md` — 一次完整跑链的实例（用 B8 好范例对应场景）
- `references/glossary.md` — 整链共享的术语表（B6 ①）

## Notes from author

{B10 ① 收尾原话；如果用户提供了链整体上的重要补充}
