---
name: {kebab-case-skill-name}
description: Use this skill when {B1 一句话定义关键动词}. This includes: {B7 ② 子场景列举，3–5 个，逗号隔开}. Trigger especially when the user mentions {B7 ① 触发原话片段，至少 3 句，原话保留} or files matching {B7 ② 文件名/关键词}. Do NOT use for {B7 ③ 反例 + 通用兜底"general writing requests where the user doesn't want X-specific style"}.
---

# {Skill 标题，人话版，对应 H1}

> 这是 {用户名} 把"{B1 一句话定义}"这件事抽成的属于自己的 skill。
> 生成日期 {YYYY-MM-DD} | 版本 V1（快速版）

## Overview

{B1 一句话定义原话}

> ✏️ 写法提示：1–3 句，散文体。第一句直接复用 B1。第二句可补"为什么这件事值得有 skill"。第三句可省略。

## Quick Reference

| 输入 | 输出 | 主要工具 |
|---|---|---|
| {B2 输入材料关键项} | {B1 输出物} | {B2 工具} |

**触发情境（用户原话）**：
- "{B7 ① 第 1 句原话}"
- "{B7 ① 第 2 句原话}"
- "{B7 ① 第 3 句原话}"

## When to use this skill

补充说明（如 description 中已经够具体可省）：
- {B7 ② 子场景说明}

**不该触发**（务必明示）：
- {B7 ③ 反例 1}
- {B7 ③ 反例 2}

## Workflow

> 来源：B3 用户的手动 SOP，按时间线排列。每步保留用户原话动词。

### Phase 1：{第一阶段名，如"准备"}

1. **{B3 步骤 1 用户原话}**
   - 输入：{该步用到的 B2 材料}
   - 注意：{若 B5 行内规矩涉及该步，原话引用}

2. **{B3 步骤 2 用户原话}**
   - {若该步是 B4 判断节点 → 标 `[需要用户判断]`}
   - {判断依据：B4 用户原话规则}

### Phase 2：{第二阶段名，如"执行"}

{继续按 B3 步骤填，每步用户原话动词开头}

### Phase 3：{第三阶段名，如"收尾"}

{继续}

> 阶段拆分原则：B3 步骤超过 5 步建议拆 2–3 个 phase；step 命名用动词开头。

## Domain Knowledge & Anti-patterns

> 来源：B5 行内规矩 + B6 禁词禁句。**用户原话保留，禁止 AI 改写**。

### 必须遵守的"行内规矩"

- **{B5 规矩 1 用户原话}**
  - 为什么：{用户解释，原话；如果用户没解释，AI 可补但需用户审核}

- **{B5 规矩 2 用户原话}**
  - 为什么：{解释}

- **{B5 规矩 3 用户原话}**
  - 为什么：{解释}

### Anti-patterns（绝不许这样做）

- ❌ {B6 ③ 禁词/禁句原话} — 出现这个就是错的
- ❌ {B5 ① 新人最容易出错的步骤的反向规则}
- ❌ {B5 ③ 反直觉规则：看似该这样但实际不能}

### 反例：用户见过的"做得最差"的版本

```
{B5 ② 用户给的差版本原话片段}
```

**差在哪里**：{用户原话或 AI 推断后用户审核}

## When to ask the user

> 来源：B4 判断节点。这些步骤 AI **不该**自行决定。

- **{B4 节点 1}**：选 A 还是 B 时，依据 {B4 ① 选择内容 + ② 决定依据}。如果不清楚，问用户。
- **{B4 节点 2}**：...

## Self-check before delivery

> 来源：B9 用户的交付前自检。如有 ≥ 5 条，单独拆 `references/checklist.md`。

完成前自查：
- [ ] {B9 第 1 条原话}
- [ ] {B9 第 2 条原话}
- [ ] {B9 第 3 条原话}

## Reference files

按需读取（Progressive Disclosure）：

- `examples/good-1.md` — 用户给的好范例原物（B8）
- `examples/bad-with-fix.md` — 差范例 + 修订说明（B8）
- `references/glossary.md` — 领域术语表（B6）
- `references/checklist.md` — 完整自检清单（如 B9 ≥ 5 条时）
- `assets/templates/` — 固定模板（B2 / B6 用户原文）

## Notes from author

> 来源：B10 ① 收尾开放回答。如有用户重要补充，原话保留在此。

{B10 ① 用户原话；如果用户没补充则删掉本段}

---

## 元信息（可删除）

- **生成方式**：通过 `user-research-for-ai-config` skill Mode B 快速版
- **基于的访谈**：共享核心 4 题 + Mode B 10 题
- **质检状态**：description 触发测试 [✓/✗] | dogfood 一次 [✓/✗]
- **下一次迭代触发条件**：dogfood 连续 ≥ 3 次发现"AI 输出不像用户"，回到 examples/ 补充
