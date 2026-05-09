# Hybrid Skill 模板（Mode B 架构 #5）

> ⚠ **V0.4 重要提示**：用户**不会主动选**"我要 hybrid"。本架构由 AI 在 Step 5.5 通过语义反推（见 `frameworks/intent-inference.md`）后**自动选定**。**而且应该极少推 Hybrid** — V0.4 反推规则明确说"出现 ≥ 2 个强信号时也优先选最强的那个作为主架构，其他降为装饰；不直接推 Hybrid"。
> 用户拿到 Hybrid 方案的概率应 < 5%。如果 AI 频繁推 Hybrid 给小白，是 intent-inference 信号阈值设置错了，要回头修。

**何时由 AI 选定本架构**：raw_answers 里有 ≥ 3 个独立强信号且 dogfood 已经验证 single 装不下（V1 跑过失败才升级到 V2 hybrid）。新用户首次产出**几乎不应该**直接得到 hybrid。

例（仅参考 — 实际由 AI 信号扫描判定）：
- 用户原话能讲清多步串联（B3 ≥ 5 步 + 每步任务类型不同） + 同时讲清并行多视角（每步内 ≥ 3 个视角） → 极强信号 → Hybrid（chain × sub-agent）
- 用户原话能讲清触发驱动（≥ 1 个硬拦截）+ 同时讲清外部系统集成（频繁读写 Notion / GitHub）→ 极强信号 → Hybrid（hook × MCP）

## 这个架构是什么

**Hybrid 不是一种新模板**，而是**前 4 种模板的有意识组合**。本目录不放具体文件骨架（避免误导用户复制一份"标准 hybrid"），而是给：
- 决策路径（如何拆出 chain / sub-agent / hook 的职责）
- 一个落地示例（小马的写公众号 V2 完整 hybrid）
- 反模式提醒（什么时候不该上 hybrid，应该退到 single）

## 何时该上 hybrid（决策树）

```
跑完 B11–B14：
  ├─ 4 个维度都是默认值（① ① ① ⑦ + ①）
  │  → Single Skill（不上 hybrid）
  │
  ├─ 1 个维度非默认
  │  → 用对应单一架构（Skill Chain / Sub-agent / Hook-driven）
  │
  ├─ 2+ 个维度非默认
  │  → Hybrid，按"主架构 + 装饰"拆解
  │
  └─ 3+ 个维度非默认
     → Hybrid，但**强烈建议先做 V1（取最强一种架构）跑 dogfood，再升级 V2**
```

## 拆解 hybrid 的方法（"主 + 装饰"）

把多维度需求拆成 1 个**主架构** + N 个**装饰组件**：

| 主架构候选 | 装饰组件候选 |
|---|---|
| **Skill Chain**（多步流程为主）| - 某步内部用 sub-agent 并行<br>- 某步前后挂 hook<br>- 某步用 MCP 拉外部数据 |
| **Sub-agent Skill**（并行多视角为主）| - 触发用 hook（事件驱动 + 派多视角）<br>- 每个 subagent 用 MCP 各自拉数据 |
| **Hook-driven Skill**（事件驱动为主）| - 触发后调起 chain<br>- 触发后派 sub-agent 做评审<br>- 触发后通过 MCP 写回外部 |

**选主架构的原则**：选用户原话**最频繁提到**的那一种特征作为主。

## 落地示例：小马的"写公众号 V2"完整 hybrid

**B11 / B12 / B13 / B14 答案**：
- B11 = ② 多步串联（读卡片 → 选题 → hook → 改稿）
- B12 = ② 多视角（在"选题"那一步要"编辑视角 + 读者视角"并行）
- B13 = ④ 会话结束时（自动归档当天的卡片+选题候选到 Notion）
- B14 = ② 需要读 Notion（卡片库 + 选题池）

**主架构**：Skill Chain（4 步）

**装饰组件**：
1. step-2（选题）内部用 Sub-agent（编辑视角 + 读者视角并行）
2. SessionEnd 时挂 Hook（archive-cards-and-topics.sh，写 Notion）
3. step-1（读卡片）+ step-4（改稿）通过 Notion MCP 读写

**完整文件树**：

```
~/.claude/skills/
├── xiaoma-publish-orchestrator/SKILL.md           ← 主入口（chain orchestrator）
├── xiaoma-publish-step-1-read-cards/SKILL.md      ← 读卡片（用 Notion MCP）
├── xiaoma-publish-step-2-topic-coordinator/SKILL.md ← 选题（context: fork + 派 2 个 subagent）
├── xiaoma-publish-step-3-hook-draft/SKILL.md      ← 起草 hook
└── xiaoma-publish-step-4-refine/SKILL.md          ← 改稿（用 Notion MCP）

~/.claude/agents/
├── xiaoma-editor-perspective.md                   ← step-2 的 subagent 1
└── xiaoma-reader-perspective.md                   ← step-2 的 subagent 2

~/.claude/settings.json (相关片段):
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          { "type": "command", "command": "~/.claude/skills/xiaoma-publish-orchestrator/hooks/archive-to-notion.sh" }
        ]
      }
    ]
  }
}

.mcp.json:
{
  "mcpServers": {
    "notion": { ... }   // Notion MCP 配置
  }
}
```

**这条 hybrid 同时使用了 4 种架构能力**：Skill Chain（主）+ Sub-agent（step-2 内部）+ Hook（SessionEnd）+ MCP（step-1 step-4）。

## 反模式提醒

不要因为可以 hybrid 就 hybrid。常见反模式：

1. **过早架构化** —— 用户其实只是单步任务但你给了一个 5 文件的 chain，第一次跑就放弃
2. **追求"全能"** —— 把 4 种能力都堆进 V1，调试时不知道哪个组件出问题
3. **抽象过度** —— 1 个 caller 的任务抽象成 chain（违反 over-engineer 规则，与 lint L2.1 同源）
4. **MCP 滥用** —— 本地脚本能搞定的非要用 MCP server（增加用户配置负担）
5. **Hook 滥用** —— 用户原话只是"我希望 AI 提醒我别忘 X"（软提醒）你给写了 hook（硬拦截）

## 推荐路径（V1 → V2 渐进）

✅ **V1**：选**最重要的 1 个特征**作为主架构（不要 hybrid），跑 dogfood 一次

✅ **V2**：dogfood 暴露的"V1 装不下"的具体问题作为装饰组件，按需加（每次只加 1 个组件 + 重 dogfood）

❌ **不推荐**：V1 直接全堆，期待"一步到位"

## 字段映射

Hybrid 没有标准字段映射 — 以选定的主架构为准，装饰组件按对应单架构的字段映射拆装。详见：
- `templates/mode-b/orchestration/README.md` 的字段映射段
- `templates/mode-b/with-subagents/README.md` 的字段映射段
- `templates/mode-b/plugin-with-hooks/README.md` 的字段映射段

## 质检（最严格）

Hybrid 的质检要分组件跑：
1. 主架构按对应单一架构的质检跑（如 chain → 跑 N+1 个 description 触发测试 + 完整 dogfood）
2. 每个装饰组件**独立**跑质检（如 sub-agent 部分单独跑 5 假问 + 视角独立性验证；hook 部分单独跑 5 触发测试）
3. 完整 hybrid 整体跑 dogfood 1 次（用 B8 好范例对应场景）

如任一组件不通过 → 回到 V1（拆掉装饰），先把主架构稳定，再加装饰。

## 不在本目录放具体文件的原因

Hybrid 没有"标准模板" — 每个用户的组合都不同。强行给一个"标准 hybrid 文件树"反而会误导用户照搬。
本 README 的作用：决策思路 + 反模式 + 落地示例。具体文件由用户根据选定的主架构 + 装饰组件，从对应模板目录拷贝拼装。
