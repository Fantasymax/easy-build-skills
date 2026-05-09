---
name: {kebab-multiview-name}-coordinator
description: Coordinate a {N}-perspective parallel review of {B1 对象}. Use when the user asks for "{B7 多视角触发原话，如 '从 N 个角度看' / '多角度 review' / '并行评估'}" or any request implying multiple independent perspectives. Trigger especially when the user mentions {N 个视角的关键词，如 stability + performance + maintainability}. Do NOT use for: single-perspective requests (use the relevant individual subagent directly).
context: fork
agent: general-purpose
allowed-tools: Read Grep Glob Bash(gh *)
---

# {Coordinator 标题：N 视角并行 review/分析}

> 这是 {用户名} 的"从 {N} 个独立视角并行处理 {B1 对象}"的 coordinator。本 skill 在 fork context 里跑 — 不污染主对话历史。
> 生成日期 {YYYY-MM-DD} | V1

## Overview

{B1 一句话定义原话}

本 skill 派发任务给 {N} 个独立 subagent 并行跑：
- `{role-1}` — {视角 1 边界}
- `{role-2}` — {视角 2 边界}
- `{role-N}` — {视角 N 边界}

各 subagent 各自在 isolated context 工作，最后返回 JSON，coordinator 汇总后输出主对话。

## Workflow

```
[Phase 1：理解任务]
1. 接收用户输入（{B2 输入材料}）
2. 判断是否真的需要多视角：
   - 是 → 进 Phase 2
   - 否（用户其实只问一个视角） → 直接调对应 subagent，不走并行
   - 用户没说清楚 → ASK：「你想要哪几个视角？默认是 [N 视角列表]」

[Phase 2：派发并行]
3. 把用户输入分别发给 {N} 个 subagent（每个 subagent 拿到的是同一份原始输入）
4. 等待 {N} 个 subagent 全部返回（Claude Code 自动并行 + 自动等待）

[Phase 3：汇总]
5. 收到 {N} 份 subagent 输出（各自是 JSON / 结构化结果）
6. 按统一 schema 汇总：
   ```json
   {
     "{role-1}": [...],
     "{role-2}": [...],
     ...
     "summary": "整体判断（≤ 3 句）",
     "blocking_issues": [...],   // 跨视角的红线问题
     "suggested_actions": [...]
   }
   ```
7. 输出给主对话

[Phase 4：用户回到主对话后]
8. 主对话只看到 summary（各 subagent 的细节在 fork 里）
9. 用户可问"{role-1} 具体说了什么" → coordinator 重新输出该 subagent 的明细
```

## Hard Rules

- MUST 派发**同一份原始输入**给所有 subagent（不要给每个 subagent 解读后的"摘要"，否则会污染独立性）
- MUST 在汇总时**保留各视角的标识**（不要把 N 份合并成 1 段散文 prose）
- MUST 在 `blocking_issues` 里提取**跨视角共同标记**的问题（说明真的是 critical）
- NEVER 让 subagent 直接执行带副作用的动作（subagent 应该是"分析者"，不是"执行者"；执行需要回到主对话用户确认后由主对话动手）
- NEVER 在 fork 里调用 Skill tool 启动其它 skill（避免无限嵌套）
- ALWAYS 在汇总输出顶部给 summary 段（一句话），让用户能 1 行决定继续看不看明细

## When to ask the user

- Phase 1 step 2：用户没说清楚要哪几个视角时，列默认 + 让用户挑
- Phase 4：用户问明细时，问"是要 {role-1} 全文还是只要某条 finding 的解释"

## Output Format

Coordinator 返回主对话的格式（统一 schema）：

```json
{
  "task": "{B1 对象一句话}",
  "perspectives": {
    "{role-1}": {
      "summary": "...",
      "findings": [
        { "severity": "critical|risk|smell", "detail": "...", "location": "..." }
      ]
    },
    "{role-2}": { ... },
    "{role-N}": { ... }
  },
  "summary": "整体判断（≤ 3 句）",
  "blocking_issues": [
    "issue-1 (出现于 {role-1} 和 {role-2})"
  ],
  "suggested_actions": [
    "action-1"
  ]
}
```

## Reference files

- `examples/three-views-walkthrough.md` — 完整 3 视角并行 + 汇总的实例
- `references/glossary.md` — 跨视角共享的术语
- 各 subagent 的 prompt 在 `~/.claude/agents/{role-N}.md`

## Notes from author

{B10 ① 收尾原话；如有用户重要补充}

---

## Coordinator 与各 subagent 的关系（架构图）

```
主对话
  ↓ (调用 coordinator)
fork context (coordinator 跑)
  ├─→ subagent {role-1} (own fork) → JSON 1
  ├─→ subagent {role-2} (own fork) → JSON 2
  ├─→ subagent {role-N} (own fork) → JSON N
  ↓
合并 JSON
  ↓ (返回主对话)
主对话看到 summary
```
