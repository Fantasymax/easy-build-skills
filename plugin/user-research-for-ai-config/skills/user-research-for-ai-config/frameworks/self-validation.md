# Skill 自测验证规则（V0.9 — Step 7.5 落地）

> **何时读**：Step 6 输出生成后、用户确认 final 前。Mode B 全跑；Mode A 跑简化版（Step 1 + Step 4）。
>
> **使命**：V0.7/V0.8 的 Step 7 只有"念 5 假问题 + 跑 1 真实任务"，过于粗糙。V0.9 升级为 5 步自测流水线，AI **主动**发现问题 + 提优化建议，**不等用户找问题**（用户是小白，他们不知道哪里有问题）。

---

## 设计原则

1. **AI 主动**，不等用户找问题
2. **机械化优先**：Schema 自检 / 触发测试 / 语言一致性都靠 grep / regex / 字符串匹配，比模型判断准 10 倍
3. **不强行让用户全接受**：用户有权说"我知道这条 anti-pattern 漏了，但我不在乎"
4. **5 选项反馈** 与 Step 5.5 一致（① 全接受 / ② 部分接受 / ③ 拒绝优化 / ④ 我自己改 / ⑤ 详细说明）
5. **循环上限 3 轮**：第 3 轮还没 ① 时主动建议"先 dogfood V1 再调"

---

## Step 1：Schema 自检（机械化，强制 100% 通过）

### 1.1 Mode B SKILL.md Schema

| 检查项 | 机械化方法 | 失败处理 |
|---|---|---|
| **frontmatter 4 字段** | 解析 YAML frontmatter，必含 `name` / `description` / `version` / `author` | 缺字段 → 阻塞输出，回到 Step 6 补 |
| **frontmatter `name`** | 正则 `^[a-z][a-z0-9-]+$`（kebab-case） | 命名不合规 → 重命名 |
| **`description` 字段长度** | ≤ 200 词（英文）或 ≤ 400 字（中文） | 超长 → 压缩 |
| **`description` 含触发词** | grep 用户 B7 触发原话 ≥ 1 处 | 缺 → 加 |
| **`description` 含 "Do NOT"** | grep `Do NOT use|不要用|不适用` ≥ 1 处 | 缺 → 加 |
| **正文行数** | `wc -l SKILL.md` ≤ 500 | 超 → 拆 references/ |
| **Hard Rules 大写** | grep `MUST\|NEVER\|ALWAYS` 在 `## Hard Rules` 段下 ≥ 3 处 | 不足 → 补 |
| **Anti-patterns ≥ 3 条** | 数 `## Anti-patterns` 段下 `- ` 列表项 | < 3 → 补 |
| **examples/ ≥ 1 个 good** | `ls examples/good-*.md` 至少 1 个 | 缺 → 阻塞 |
| **examples/ ≥ 1 个 bad** | `ls examples/bad-*.md` 至少 1 个 | 缺 → 阻塞 |

### 1.2 Mode A 三层文档 Schema

| 检查项 | 机械化方法 | 失败处理 |
|---|---|---|
| **三层完整** | grep `## 第一层\|## Layer 1` / `## 第二层\|## Layer 2` / `## 第三层\|## Layer 3` 各 1 处 | 缺 → 阻塞 |
| **9 段全在第三层** | grep `### ① ` 到 `### ⑨ ` 各 1 处 | 缺 → 补 |
| **Hard Rules MUST/NEVER 大写** | 同上 | 同上 |
| **5 平台导出文件存在** | `ls templates/mode-a/exports/` 含 `CLAUDE.md` / `AGENTS.md` / `CODEX.md` / `.cursorrules` / `system-prompt.md` | 缺 → 阻塞（除非 platform-export-selector 已过滤）|

### 1.3 输出语言一致性（V0.9 关键）

> 来源：`frameworks/output-language-rules.md`

| 检查项 | 机械化方法 | 失败处理 |
|---|---|---|
| **段标题语言一致** | 扫所有 `## ` / `### ` 标题，按 Step 1.5 选定语言归类。如选"中文"但发现"## Layer 1" / "## Workflow" → 命中错误 | 翻译为中文 |
| **Anthropic 形态名保留英文** | grep `## ` 段标题里出现 `atomic` / `orchestration` / `with-subagents` / `plugin-with-hooks` / `composite-plugin` 时**应为英文**（不要翻译为"原子"等）| 翻译错误 → 改回英文 |
| **文件路径保留英文** | grep `\.md` 文件路径必须是 `CLAUDE.md` / `AGENTS.md` / `SKILL.md` 等原英文 | 翻译错误 → 改回英文 |
| **用户原话未被翻译** | 比对 raw_answers 中的触发原话片段是否在 final 文档中**逐字保留** | 改写过 → 还原原话 |

---

## Step 2：触发测试（AI 自动 — 仅 Mode B）

### 2.1 自动生成 5 pos + 5 neg 假问题

> AI 用合成的 description + 用户 B7 触发原话 + 用户 C2 任务清单**反推 10 个假装来访的用户问题**：5 条**应当触发** + 5 条**应当不触发**。

**生成规则**：

```python
# 5 个 pos 问题（应当触发）
pos_questions = [
    f"我想{B7触发原话片段}怎么办？",  # 直接命中触发词
    f"{C2任务1}你能帮我吗？",          # 命中 C2 高频任务
    f"我有个{B2输入材料类型}要处理",    # 命中输入类型
    f"帮我{A4主目标动词+对象}",         # 命中主目标
    f"按{B5行内规矩}做{C2任务}"         # 命中规矩+任务组合
]

# 5 个 neg 问题（应当不触发）
neg_questions = [
    f"帮我做{与 skill 无关的任务}",      # 完全无关
    f"我想问{description Do NOT 段}",    # 命中 Do NOT
    f"做{C2 之外的常见 AI 任务}",        # 用户没说过的通用任务
    f"教我{description "doesn't include"段}",  # 教育类，skill 是执行类
    f"{A8 红线场景}"                    # 命中红线（应停下问，不应直接做）
]
```

### 2.2 AI 自检 description 区分能力

对每条问题，AI 自问：
- "看 description 全文，这条问题应该触发本 skill 吗？"
- 把 AI 的判断与"应当触发/不触发"标签对比

**通过标准**：10 / 10 全对。

**失败处理**：
- pos 问题误判为不触发 → description 触发词不够明显，加触发词
- neg 问题误判为触发 → description 范围太宽，加 "Do NOT use for..." 段

---

## Step 3：Dogfood 模拟执行（AI 自动 — 仅 Mode B）

### 3.1 拿 examples/good-1.md 作目标基线

用户提供的 `examples/good-1.md` 是**已知正确输出**的样板。

### 3.2 AI 用 skill 模拟跑同类任务

```
1. AI 假装是用户，把 examples/good-1.md 的"输入"部分（用户原话 + 输入材料）作为新一轮请求
2. AI 严格按 SKILL.md 的 Workflow + Hard Rules + Anti-patterns 跑
3. 生成模拟输出
4. 与 examples/good-1.md 的"输出"部分对比
```

### 3.3 对比 5 维度

| 维度 | 检查 | 通过标准 |
|---|---|---|
| **风格保真度** | AI 模拟输出 vs good-1 风格 | 段落结构 / 语气 / 长度 / 用户惯用词 ≥ 80% 重合 |
| **用户原话保留** | 模拟输出含用户原话片段 | 触发原话 / 行话 / 模板 5 类 ≥ 1 处 |
| **Hard Rules 命中** | 模拟输出无违反 MUST/NEVER 条目 | 0 违反 |
| **Anti-patterns 避免** | 模拟输出无 anti-pattern 列表项 | 0 命中 |
| **禁词扫描** | grep 用户 A3 ② 不信任话术 | 0 命中 |

### 3.4 失败处理

任一维度低于通过标准 → 报告差异，建议补 examples（**比改指令高效**，详见 Anti-pattern 第 5 条）。

---

## Step 4：覆盖率检查（B10 五类原话 + 用户红线）

### 4.1 §B10 五类用户原话覆盖率

| 类别 | 检查 |
|---|---|
| 触发原话片段 | 在 description 或 Examples 段保留 ≥ 1 处 |
| 行业行话 / 术语 | 在 references/glossary.md 或 Hard Rules 保留 ≥ 1 处 |
| 好范例原物 | 在 examples/good-*.md 保留 ≥ 1 处 |
| 固定模板 | 在 references/ 或 assets/templates/ 保留 ≥ 1 处 |
| 禁忌原话 | 在 Anti-patterns 或 Hard Rules NEVER 保留 ≥ 1 处 |

通过标准：5 / 5 全部覆盖（如某类用户没提供，标 N/A 不计入分母）。

### 4.2 用户红线全部命中

扫 raw_answers 中 A8 / C4b 提到的红线，每条应在 final 文档**至少一处**出现：
- Hard Rules NEVER 段
- 或 Anti-patterns
- 或 Examples ❌ 反例

通过标准：100% 命中。

### 4.3 工具栈与导出对齐（仅 Mode A）

按 `frameworks/platform-export-selector.md` Rules A-F：
- 用户 C3 工具栈 → 应导出哪些平台
- final 已导出哪些平台
- 应导出但未导出 → 报告
- 已导出但用户不需要 → 报告

通过标准：导出集合 = AI 推荐集合（如有出入，AI 提醒用户确认）。

---

## Step 5：主动报告 + 5 选项反馈循环

### 5.1 报告模板

```markdown
# Skill 自测验证报告 — {skill-name}

## ✅ 通过项（{N}/{Total}）
- Schema 自检：✓
- 触发测试：✓ 10/10
- Dogfood 模拟：✓ 5/5 维度通过
- 覆盖率：✓ 5/5 类原话覆盖 + 100% 红线命中

## ⚠ 发现的问题（{M} 项，按严重度排序）

### 🔴 严重（必须修；阻塞输出）
1. {问题描述}
   - 检查项：Step 1.1 frontmatter description 缺触发词
   - 建议：加 "{B7 触发原话}" 进 description
   - 影响：可能 description 不被 Claude 正确触发

### 🟡 中等（建议修）
2. {问题描述}
   - 检查项：Step 4.2 红线"客户数据脱敏"未在 Hard Rules 命中
   - 建议：在 Hard Rules 加 "NEVER 在脱敏前贴客户原始数据"
   - 影响：用户最怕的事可能漏防御

### 🟢 轻微（可选修）
3. {问题描述}
   - 检查项：Step 3.3 风格保真度 73%（< 80%）
   - 建议：补 1 个 examples/good-2.md 强化"温和但坚定"语气
   - 影响：AI 在边缘 case 可能偏离用户风格

## 你怎么处理？

[① 全接受]    AI 按上面 3 项建议修改，重新生成 final
[② 部分接受]  你挑哪几项要修（如"只修 1+2，不要 3"）
[③ 拒绝优化]  你确认这些不是问题，AI 记录"用户认为已可用"，进入 final
[④ 我自己改]  你直接说怎么改，AI 协助落地
[⑤ 详细说明]  AI 哪一步跑得不对？或你想看更细的检查证据
```

### 5.2 5 选项反馈处理

| 选项 | AI 处理 |
|---|---|
| ① 全接受 | 按全部建议修改，重跑 Step 1-4，应当全 ✓，进入 final |
| ② 部分接受 | 用户给优先级（如"只要 1 + 3"），AI 修改后重跑命中项 |
| ③ 拒绝优化 | AI 记录 `user_acknowledged_issues: [...]` 进 frontmatter（提醒未来 dogfood 时关注），进入 final |
| ④ 我自己改 | 用户说怎么改，AI 落地后重跑 Step 1（机械化检查），仍要保证 schema 通过 |
| ⑤ 详细说明 | AI 给出每个检查项的具体证据（grep 结果 / 行号 / 命中文本），帮助用户判断 |

### 5.3 循环上限

最多 3 轮。第 3 轮还没 ① 时 AI 主动说：

> 我们已经迭代 3 轮还没收敛 — 建议你先用 V1 跑一道**真实**任务（不是模拟），看 AI 实际做出来怎么样，再针对真实问题升 V2。这比纸面继续打磨更高效。

### 5.4 "暂搁"产生 KNOWN_ISSUES.md（V1.1 — 用户选 ③ 拒绝优化时）

> **来源**：cowork V0.4.8 实测补丁。

用户选 ③ 拒绝优化后，AI 不只是把问题记进 frontmatter — 同时在 skill 包根目录**生成 `KNOWN_ISSUES.md`**：

```markdown
# KNOWN_ISSUES.md — 已知问题（用户已确认接受）

> 在 V1 跑几次真实任务后，如果发现这些问题确实影响使用，回头再修。

## 🟡 中等（用户接受）

- **[Q2] 红线"客户数据脱敏"未在 Hard Rules 显式命中**
  - 检查项：Step 4.2
  - 修复建议（待跑）：在 Hard Rules 加 "NEVER 在脱敏前贴客户原始数据"
  - 用户决定：接受 — 暂时不影响使用，V2 再说

## 🟢 轻微（用户接受）

- **[Q3] 风格保真度 73%（< 80% 阈值）**
  - 检查项：Step 3.3
  - 修复建议（待跑）：补 1 个 examples/good-2.md
  - 用户决定：接受
```

让用户跑几道真实任务后回头看这份清单，识别哪些"已知问题"真的会影响使用 → 触发 V2 self-test 修复。

## Part 6 — 失败处理（V1.1 — 连续 3 轮不通过的降级建议）

> **来源**：cowork V0.4.8 实测补丁。

### 6.1 触发测试通过率 < 80%

- description 设计有问题
- 回 question-bank/express-mode-b.md B7（触发原话挖掘）补 ≥ 3 句更具体原话
- 重新合成 description → 重跑 Step 1-4

### 6.2 Dogfood 相似度 < 4/10

- examples/good-1.md 不够代表性 / 风格挖得不够深
- 让用户补 examples/good-2.md（最近的另一份好作品）
- 重跑 Step 3

### 6.3 自测连续 3 轮不通过 → AI 主动建议降级形态

```
🚨 我们已经跑了 3 轮自测都没通过 — 这通常意味着方案过于复杂。

建议你考虑**降级形态**：

  当前形态: Composite Plugin (含 4 sub-skills + 2 agents + 3 hooks)
              ↓ 降级
  推荐形态: Plugin with Hooks (含 2 sub-skills + 1 hook)
              ↓ 进一步降级
  最简形态: Atomic Skill (单 SKILL.md + examples)

降级原理：减少形态复杂度 → 减少出错面 → 自测通过率提升

要降级吗？
[✅ 降一级] [⏬ 降到最简 Atomic] [⏭ 不降，先跑真实任务] [🖊 我自己改]
```

降级阶梯（按 §intent-inference 的形态层级反向）：
```
Composite Plugin → Plugin with Hooks → Skill with Subagents → Skill Orchestration → Atomic Skill
```

降级后**重跑**全套自测，应当至少有一档能通过。

---

## Mode A 简化版

Mode A 没有 description 触发场景（principles 不是被 Claude 触发的），没有 examples/good-1.md 作 dogfood 基线。

**只跑**：
- Step 1（Schema 自检 — 三层 + 9 段 + 输出语言一致性）
- Step 4.1 + 4.2 + 4.3（覆盖率 + 用户红线 + 工具栈对齐）
- Step 5（报告 + 反馈）

**跳过**：Step 2（触发测试）+ Step 3（Dogfood 模拟）。

---

## 与 §B3 偏误自检 / §B4 矛盾回写的关系

§B3 / §B4 是**用户回答阶段**的检查（生成阶段的素材质量）。
本文 Step 7.5 是**输出生成后**的检查（最终产物质量）。

两者**不重叠**：
- B3 / B4 抓"用户回答里的偏误 / 矛盾"
- Step 7.5 抓"最终文档的 schema / 触发 / 风格 / 覆盖率"

---

## 版本

- **V0.9 (2026-05-09)** — 创建。基于老板对 V0.8 实测反馈："skill 写完后需要主动自行测试验证，有没有问题，需不需要优化"。把 V0.7/V0.8 粗糙的 Step 7（"念 5 假问题 + 跑 1 真实任务"）升级为 5 步流水线（Schema / 触发 / Dogfood / 覆盖率 / 报告 + 反馈循环）。
