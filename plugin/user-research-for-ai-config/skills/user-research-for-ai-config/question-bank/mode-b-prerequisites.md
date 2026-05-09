# Mode B 前置环节（前置 0 + 前置 1）

> **何时读**：Mode B 快速版启动时一次性加载本文，跑完 5 个共享核心问题之后、B1 任务深挖之前。
>
> **包含**：
> - **前置 0**：Mode A → Mode B 原则继承（如用户走 Mode C 路径，V1.1 新增）
> - **前置 1**：AI 项 5+2+1 候选任务让用户选（详见 `frameworks/task-shortlist-rules.md`）
>
> **来源**：cowork V0.4.8 平行进化的关键文件，V1.1 吸收。
>
> **价值**：解决"先 A 后 B"用户的 V1.0 痛点 — 之前 Mode B 不读 Mode A 输出，导致用户在 Mode B 重答已经在 Mode A 答过的问题（禁词 / 口吻 / 红线 / 自治度等），且生成的 SKILL.md 与 Mode A principles 不一致。

---

## 前置 0：Mode A → Mode B 原则继承（V1.1 新增）

> **触发条件**：用户在 Step 1 选了模式 **C（先 A 后 B）** 且已完成 Mode A → 现在进入 Mode B。
>
> **如用户没做过 Mode A（直接选 B）**：跳过本前置 0，直接进前置 1（任务选择）。

### 0.1 继承字段映射表

| Mode A 字段 | 继承到 Mode B 哪里 |
|---|---|
| **Persona / 角色比喻**（A2）| SKILL.md `## Persona modifier` 段（"在 Mode A 整体角色基础上，本 skill 的特化职责……"）|
| **Hard Rules**（禁词 / MUST / NEVER）| 自动进 SKILL.md `## Anti-patterns` + `references/glossary.md` 禁词列表 |
| **决策边界**（Do / Ask / Don't 三栏，A7）| 自动进 SKILL.md `## When to ask the user` 段 + Anti-patterns 中 Don't 部分 |
| **autonomy_level**（A5 自治度档位）| **作为基线默认**；Mode B 形态推断后允许根据具体任务 override（详见 §0.2）|
| **红线**（A8 选项）| 进 SKILL.md `Anti-patterns` 顶部"绝对红线"段 |
| **输出格式偏好**（A6）| 进 SKILL.md `## Output Format` 段 |
| **examples/good-1.md**（用户提供的好范例）| 拷贝到 Mode B `examples/`，B8 时问"已继承 Mode A 范例，是否补一份本 skill 专属的？"|

### 0.2 autonomy_level 不硬继承的特殊规则

| Mode A 设的值 | Mode B 默认值 | 何时应 override |
|---|---|---|
| `act`（全自动）| **`propose`** | Mode B 任务通常应保守一档（act → propose）— 单任务比整体协作风险面更大 |
| `propose` | `propose` | 默认保留 |
| `draft` | `draft` | 默认保留 |
| 任何值 + Mode B 任务是**高敏感**（AI 痕迹检查 / 法规检查 / 财务检查 / 客户数据处理）| **强制 `draft`** | 用户审过才交付，避免直发出去 |
| 任何值 + Mode B 任务是**低风险**（格式转换 / 翻译 / 整理）| 保留 Mode A 值 | 不动 |

→ Mode B 形态推断完成后，AI 应用此规则并生成"override 提示"让用户确认：

```
我注意到你的 Mode A 设了 autonomy_level=act（全自动）。
但本 skill 的任务是【AI 痕迹检查】属于高敏感类——
我自动降级为 draft（草稿模式，你审过才交付）。

[✅ 同意降级] [🔼 我要保持 act] [🖊 我自己说]
```

### 0.3 用户继承校验（5 选项）

进 B1 之前，AI 给用户看继承摘要 + 5 选项：

```
🔍 我从你的 Mode A 继承了这些到 Mode B：

  ✓ Persona：你的"资深同事编辑"角色
  ✓ 禁词：5 条（"亲爱的" / "✨" / 等）
  ✓ 红线：3 条（"看起来不专业" 等）
  ✓ autonomy_level: act → propose（自动降级，本任务更敏感）
  ✓ Output Format: TL;DR 顶 + 中文引语「」

你怎么选？

[① ✅ 直接继承全部]    推荐，省力
[② 🔧 继承大部分但要 override 几条]
[③ 🔄 不继承，本 skill 完全独立]    极少用
[④ 🛡 只继承 NEVER / Don't 红线，其他靠本 skill 自己定]
[⑤ 🖊 我自己说]
```

### 0.4 各选项处理

| 选项 | 处理 |
|---|---|
| ① 全部继承 | 直接进 B1，跳过 Mode A 已答过的字段（如 Persona / 禁词不再问）|
| ② 部分继承 | 让用户列出哪几条要 override，AI 在 Mode B 的对应题里**主动追问**那几条 |
| ③ 不继承 | 触发 §B3 偏误自检："为什么独立？通常 skill 应该和你整体 AI 风格一致——除非这个任务真的需要不同人格。" |
| ④ 只继承红线 | 红线（NEVER / Don't）必继承；其他字段在 Mode B 重新问 |
| ⑤ 自行输入 | 用户用术语 / 引用具体字段 override，AI 解析后落地 |

### 0.5 创意发散：本 skill 例外（高级用法）

如用户说"继承所有但加一条本 skill 例外"（例：Mode A 说 NEVER 用 emoji，但本 skill 是 `slack-message-skill` 可以用 emoji）：

- 这是高级用法，AI **不质疑用户**（按 §B7 § 5 自行输入处理规则）
- AI 在 SKILL.md 的 `## Anti-patterns` 段加注释："**本 skill 例外**：可用 emoji（与 Mode A 规则相反），原因是 Slack 沟通场景需要"

---

## 前置 1：任务选择（必跑）

> **完整规则**：见 [`frameworks/task-shortlist-rules.md`](../frameworks/task-shortlist-rules.md)

AI 综合 C2 高频任务 + A4 主目标 + C4b 崩溃经历 + A1 触发情绪 + 5 维度评分（频次×2 / 耗时×2 / 可拆解×1.5 / 隐性知识密度×1.5 / 崩溃修复价值×1）打分，项出 5+2+1 候选。

### 1.1 主问呈现

```
我们要把你**某一项重复任务**抽成属于你的 skill。

—— 默认（推荐）：直接看 AI 项的 5+2+1 候选 ——

  ① 强相关 1（基于 C2 + A4）
  ② 强相关 2
  ③ 强相关 3
  ④ 创意发散 1（基于 C4b 崩溃 + A8 红线）
  ⑤ 创意发散 2（隐藏自动化 / 跨界组合）

  🖊 ⑥ 我已经知道我要抽什么——直接告诉你

—— 进阶入口（熟练用户）——

  • 我直接从 C2 我自己说的任务里挑（跳过 AI 项）
  • 我已经知道任务名（自由输入）
```

### 1.2 任务筛选硬标准（强制）

- 频次 ≥ 每周 1 次
- 单次手工 ≥ 15 分钟（< 15 分钟不值得做 skill）
- 步骤可拆（能讲出几步）
- 知识密集（有"我懂但 AI 默认不懂"的判断）
- **5 维评分总分 ≥ 25** 才入 shortlist；**≥ 35** 为强候选

### 1.3 追问规则

- 用户从 AI shortlist 选 ④⑤ 创意发散 → 必须二次校验"真要还是觉得有趣？"
- 用户选"自己挑"但任务低频 / 琐碎 → "这个回报偏低，要不要看下我项的？"
- 用户选自定义但描述模糊 → §B3 偏误自检 + 行为追问
- 用户都不选 → "5 个都不合心意？是不是 C2 漏了什么任务？回去补充？"

---

## 完成两个前置后

进入 `question-bank/express-mode-b.md` 跑 B1–B10 题库。

---

## 版本

- **V1.1 (2026-05-09)** — 创建。基于 cowork V0.4.8 平行进化的 `mode-b-prerequisites.md`。前置 0 是 V1.0 完全缺失的关键内容（解决"先 A 后 B"用户的 V1.0 痛点）。
