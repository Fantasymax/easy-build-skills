---
name: {chain-name}-step-{N}-{kebab-step-name}
description: Step {N} of {chain-name} chain — {B3 第 N 步用户原话动词} {B3 第 N 步对象}. Use AFTER running /{chain-name}-step-{N-1} OR when the user says any of {B7 ① 第 N 步独立触发原话 1–2 句}. Trigger especially when the user mentions {B7 第 N 步触发关键词} or files matching {B7 ② 第 N 步对应文件}. Output goes to /{chain-name}-step-{N+1}. Do NOT use for: standalone {step-N task} requests outside this chain context.
---

# {Step N: 步骤标题}

> {chain-name} 链的第 {N} 步。可以 standalone 跑（如果用户已经有第 N-1 步的输出），也可以由 orchestrator 自动调起。
> 生成日期 {YYYY-MM-DD} | V1

## Overview

{第 N 步在做什么的一句话}

**链中位置**：`step-{N-1}` → **本步** → `step-{N+1}`

## Quick Reference

| 项 | 值 |
|---|---|
| 输入 | {B3 第 N 步的输入：上一步输出 / 用户额外贴的内容} |
| 输出 | {B3 第 N 步的输出} |
| 估时 | {分钟} |
| 主要工具 | {B2 第 N 步用到的工具} |

**触发原话（用户原话保留）**：
- "{B7 ① 第 N 步触发原话 1}"
- "{B7 ① 第 N 步触发原话 2}"

## When to use this skill

- standalone 跑：用户已经有上一步输出，想跳进来
- 由 orchestrator 调度

**不该触发**：
- 用户没有第 N-1 步的输出（先跑 step-{N-1} 或 orchestrator）
- 用户在做其它任务（不在本链范围内）

## Workflow

> 来源：B3 该步骤的原话拆解

### Phase 1：{该步第 1 阶段，如"读取上一步输出"}

1. **{B3 该步第 1 子动作 用户原话}**
   - 输入：{该子动作用到的材料}
   - 注意：{若 B5 行内规矩涉及该步，原话引用}

2. **{B3 该步第 2 子动作}**
   - {若该子动作是 B4 判断节点 → 标 `[需要用户判断]`}
   - {判断依据：B4 用户原话规则}

### Phase 2：{该步第 2 阶段}

{继续按 B3 该步骤拆解}

## Domain Knowledge & Anti-patterns

### 必须遵守的"行内规矩"（属于本步骤）

- **{B5 该步骤涉及的规矩 用户原话}**
  - 为什么：{用户解释}

### Anti-patterns（绝不许这样做）

- ❌ {B6 ③ 禁词 / 禁句原话}
- ❌ {B5 ① 该步骤新人最易出错的反向规则}

## When to ask the user

> 来源：B4 该步骤涉及的判断节点

- **{B4 该步节点 1}**：选 A 还是 B 时，依据 {B4 ① 选择 + ② 决定依据}。如果不清楚，问用户。

## Self-check before delivery（本步专属）

- [ ] {B9 该步骤涉及的自检项 1}
- [ ] {B9 第 2 条}
- [ ] **链衔接专属**：输出格式与 step-{N+1} 的输入格式匹配？

## Reference files

- `examples/good-1.md` — 用户给的好范例（针对本步骤的产出）
- `references/glossary.md` — 共享术语表

## Notes for chain orchestrator

> 这一段给 orchestrator 调度时读

- **本步典型耗时**：{秒/分钟}
- **本步失败信号**：{用户在什么情况下会觉得这步白做了 → 通常需要回到第 N-1 步重做}
- **本步成功信号**：{用户在什么情况下会说"OK 继续下一步"}
