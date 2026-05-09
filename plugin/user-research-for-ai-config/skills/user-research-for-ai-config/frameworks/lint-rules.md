# 三层 Lint 规则（合成输出前必跑）

> 在 Step 5 由 skill 主流程调用。任一层有违规先回写让用户确认/修正，不替用户决定。

---

## Layer 1 — 偏误 lint（扫**用户的回答**）

逐题检查，命中任一项就回写。

| 信号 | 表现 | 回写模板 |
|---|---|---|
| 社会期望 | 回答里出现"我应该 / 我打算 / 一般来说 / 通常 / 应该是"这类措辞 | "你说**我应该 X**——这是你想要的还是你实际做的？想想**上一次实际**发生时是不是这样。" |
| 一字答 | 给了 yes/no/有/没有 一个字 | "能展开讲讲吗？最近一次具体怎么做的？" |
| 自我矛盾 | 回答与本人之前回答冲突 | 把两条原话并排丢给用户："这是你说的 A，这是你说的 B——这两条听起来不同方向，请你自己挑一个保留，或写一段话说明为什么两者并存。" |
| 模糊形容词 | 回答里大量"专业""高质量""高效""清晰" | "**专业**指什么——能拆成 2–3 条可勾选的具体项吗？比如'每段 ≤ 5 行'、'数据带来源链接'。" |
| 工具替代答案 | 用户回答的是"用什么工具"，不是"做什么动作" | "工具知道了。**做什么**——一个动词加一个对象。" |
| Persona 错配 | A2 选了"实习生"但 A5 选"全自动" | "选'实习生'通常意味着希望盯着每一步——和'全自动'有点矛盾。请你解释或改一项。" |

---

## Layer 2 — 措辞污染 lint（扫**输出文档**）

适用场景：principles 文档（Mode A）输出生成后；SKILL.md（Mode B）正文 + Anti-patterns 段输出生成后。

| 陷阱 | 检测信号 | 改写规则 | 改写示例 |
|---|---|---|---|
| 否定型指令 | "不要……" / "不能……" / "Don't ……" 单独成条 | 改正向写法 | ❌ "不要写 bug" → ✅ "写代码前先列 3 个失败 case" |
| 模糊形容词 | "高质量""专业地""清晰地""完整地" | 拆成可验证规格 | ❌ "写得专业" → ✅ "函数 ≤ 30 行；每个 public 函数有 docstring；数据带来源链接" |
| 多重身份冲突 | Persona 段同时出现两种相互拮抗的人设 | 取一个为主，另一个降级为风格 modifier | ❌ "严谨的法律顾问 + 搞笑脱口秀" → ✅ "严谨的法律顾问，必要时可用一句俏皮话松弛气氛" |
| Persona / Examples 风格不一致 | 人设是 X 但 examples 是 Y 风 | 全部对齐 examples 风 | （需要改 Persona 或 examples，看哪个更代表用户）|
| 同段塞 5 个目标 | 一段里出现 ≥ 4 个不同动词 | 拆 sequential chain，每步一个目标 | ❌ "提取主题、分类、聚合、生成报告、发邮件" → ✅ 拆 5 个 phase |
| 收尾词模糊 | "等等""诸如此类""and so on""etc." | 改成穷举或写"上述"加范围 | ❌ "如检查日期、字数等" → ✅ "仅检查：① 日期格式 ② 字数 ③ 数据来源" |
| 引号嵌套混乱 | 用户原话里含有 `"`，套进 prompt 里破坏结构 | 用 XML 标签包裹 | `<user_input>...</user_input>` |
| 描述太抽象 | "理解用户意图""智能判断""根据情况" | 改成可执行规则 | ❌ "理解用户意图" → ✅ "如果用户句中含动词无对象，先反问对象" |
| 大写信号词缺失 | Hard Rules 段没有 MUST/NEVER/ALWAYS | 在每条 rule 前补一个大写信号词 | "用 MUST / NEVER / ALWAYS 开头" |

---

## Layer 3 — Schema 校验（按模式分别校）

### Mode A — Principles 文档 9 段必填项

```
[ ] ① Persona / Role            （必填，50–120 字）
[ ] ② Context / Background      （必填，100–250 字）
[ ] ③ Goals & Non-Goals         （必填，80–200 字）
[ ] ④ Hard Rules                （必填，50–200 字，每条用 MUST/NEVER/ALWAYS 开头）
[ ] ⑤ Workflow                  （必填，步骤化）
[ ] ⑥ Output Format             （必填，30–150 字，给 schema 或 heading 列表）
[ ] ⑦ Examples                  （强烈建议，至少 2 正 1 反）
[ ] ⑧ Self-Check                （可选，50–100 字）
[ ] ⑨ Escalation                （可选，30–80 字）
```

**追加校验**：
- [ ] 每条 principle 末尾有溯源标注（如 `[源: Memory]` / `[源: 触发要素]` / `[源: 动作要素]`），便于 dogfood 时排错
- [ ] Goals 段里至少有一个"动词 + 对象"格式的目标
- [ ] Guardrails 段至少包含 A8 用户给出的"最怕的事"（标红线）

### Mode B — SKILL.md 包必填项

```
[ ] frontmatter
    [ ] name (kebab-case, 与目录名一致)
    [ ] description (80–200 词，含 Use when / This includes / Trigger especially / Do NOT 四要素)
    [ ] description ≤ 1024 字符
    [ ] description 用动词开头（不是"This skill does..."描述句）
    [ ] description 含至少 3 条用户原话触发词
    [ ] description 含至少 1 条 "Do NOT use for ..." 反例
[ ] H1 标题
[ ] ## Overview （1–3 句）
[ ] ## When to use this skill 或 Quick Reference
[ ] ## Workflow （主体；用户的 SOP，1–N 个 phase）
[ ] ## Anti-patterns （至少 1 条用户原话保留的禁忌）
[ ] ## Reference files （指向 references/ 子目录的索引）
[ ] examples/good-1.md （至少 1 个用户原物）
[ ] references/glossary.md （术语表，至少 5 条；如果用户领域简单可省）
[ ] 正文 ≤ 500 行
```

**追加校验**：
- [ ] 用户给的模板原文进了 `assets/templates/` 或 `examples/`，**没有被 AI 改写**
- [ ] 触发词列表 / 禁忌句式 / 行话清单 全部是用户原话
- [ ] description 跑过 5 条假问题触发测试，准确率 ≥ 80%
- [ ] 跑过一次 dogfood，输出"像用户自己做的"

---

## Lint 失败处理流程

1. **Layer 1（偏误）失败** → 回到对应问题，让用户用"上一次实际…"重答。
2. **Layer 2（措辞污染）失败** → 把违规条目原文 + 改写建议丢给用户，让用户挑：用建议版 / 自己改 / 保留原版（保留需要勾"我知道这违反规则"）。
3. **Layer 3（Schema）失败** —
   - 必填字段缺失 → 回到对应问题补问
   - description 触发测试 < 80% → 回 B7，重新挖触发原话
   - dogfood 输出不像用户 → 补 `examples/good-N.md`，**先补例不改指令**

---

## 关于 lint 严格度的说明

skill-creator 原文："Explain the why, not heavy-handed musty MUSTs"。意思是：**lint 不是来惩罚用户的**——它是把违规点摆到用户面前让用户做决定。

每条 lint 失败的回写要包含：
1. 违规原文（用户原话）
2. 为什么这是问题（一句话解释）
3. 至少 2 个改写选项，最后给"保留原版"的选项

不要在用户没确认前替他改。
