# Mode B 快速版问题清单（10 题，V0.7）

> **何时用**：Step 4，用户选了 Mode B 且选择"快速版"档位时。耗时 12–18 分钟（共享核心 4 题 3–5 分钟，合计 15–23 分钟）。
>
> **题序**（按 Game Complexity Arc）：
> - 任务选择（前置）
> - 暖场（事实）：B1 一句话定义 → B2 输入材料
> - 深挖（GOMS）：B3 手动 SOP → B4 判断节点 → B5 行内规矩
> - 原话保留：B6 术语+禁词 → B7 触发原话 → B8 好差范例
> - 收尾：B9 自检 → B10 开放 + description 起草
>
> **嵌入框架**：GOMS 四问 + Memory & Language 维度 + Anthropic skill-creator description 三要素 + 用户原话保留。
>
> **V0.7 关键**：每题加 metadata。AI 在支持原生选项工具的平台调原生工具（详见 SKILL.md §B8）。
>
> **追问规则**：每题答完按 SKILL.md §B2 自动追问 1–2 次。**特别强调 §B7 用户原话保留**：B6 / B7 / B8 必须逐字保留。

---

## 前置：任务选择

### 形式：原生工具单选

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："任务选择"
- `question`："我们要把你某一项重复任务抽成属于你的 skill。从哪个路径选？"
- `options`（4 + Other）：
  1. **label**：从共享核心 C2 任务清单挑
     **description**：从你勾的高频任务里挑 1 个
  2. **label**：AI 帮我项 5 个候选我选 (Recommended)
     **description**：基于 C2 + A4 反推
  3. **label**：我已经知道 — 直接告诉你
     **description**：进任务深挖
  4. **label**：先看任务筛选标准
     **description**：频次 ≥ 周 1 / 单次 ≥ 15 分钟 / 步骤可拆 / 知识密集

### 任务筛选标准（如用户选项 4 或犹豫）

- 重复频次：每周 ≥ 1 次（最好 ≥ 2 次）
- 单次时间：手工做 ≥ 15 分钟
- 步骤可拆：能讲出具体的几步
- 知识密集：里面有"我懂但 AI 默认不懂"的判断

### 追问候选

- 用户挑了一个但低频：`这个频次不高——抽成 skill 的回报偏低。还有更高频的吗？`
- 太琐碎（"改错别字"）：`这个用 AI 通用能力就够了——选个更需要"你的判断"的任务？`

---

## B1：一句话定义这个 skill — Goal

### 形式：动词类型（原生工具）+ 文本

#### 第一步（原生工具单选）— 与 Mode A A4 第一步同

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："动词类型"
- `options`（4 + Other）：
  1. **label**：整理 / 抽取
     **description**：从原料里拿出关键信息
  2. **label**：改写 / 润色
     **description**：已有版本 + 让 AI 调整
  3. **label**：起草 / 列大纲
     **description**：从无到有出一版
  4. **label**：找出 / 对比
     **description**：review / 对照 / 归类

#### 第二步（文本输入）

**主问**：用一句话定义——

```
"这个 skill 帮我把 [输入] [动词] 成 [输出]"
```

例：
- "把'本周日报草稿'整理成'符合公司格式的最终版日报'"
- "review 这个 PR，找出可能影响线上稳定性的 3 处改动"
- "把客户 Excel 数据 + 网银流水整理成 5 段诊断报告草稿"

### 写入

- frontmatter `description` 第一句 + Overview + H1

---

## B2：输入材料清单 — GOMS Operators

### 形式：分类列表（文本）+ 私货关键追问（原生工具）

#### 第一步（文本输入 — 类别多需要列）

**主问**：你做这件事时手边都有哪些类型的材料？请按下面分类列：

1. **数据 / 文件**：草稿 / Excel / 录音 / 截图 ...
2. **工具 / 平台**：Notion / 飞书 / Cursor / GitHub ...
3. **历史参考**：上周范例 / 同事的好版本 / 自己以前的好稿
4. **模板 / 固定结构**：开头 / 结尾 / 公式 / 报告模板（如有 → 必贴原文）
5. **标准 / 规范**：风格指南 / SOP / 监管要求（如有 → 必贴原文）

#### 第二步（原生工具单选）— 私货模板（Mode B 关键）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："私货模板"
- `question`："你有没有自己写过给自己用的'模板 / 备忘 / SOP / 风格指南'？"
- `options`（4 + Other）：
  1. **label**：有，是文档型
     **description**：PDF / Word / Markdown
  2. **label**：有，是结构型
     **description**：Notion 数据库 / Airtable
  3. **label**：有，是私人辞典 / 词条库
     **description**：自己积累的语料 / 案例 / 句式
  4. **label**：没有，全靠脑子
     **description**：（如选这个跳过下一步）

如果选 1 / 2 / 3 → AI 必触发：`能贴一段原文给我吗？我们会一字不动地放进 skill。`（**Mode B 必触发**）

### 写入

- SKILL.md `## Quick Reference` + `references/` + `assets/templates/`

---

## B3：手动 SOP — 一步步告诉我你怎么做（GOMS Methods）

### 形式：步数预估（原生工具）+ 文本讲故事

#### 第一步（原生工具单选）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："步数预估"
- `question`："假设没有 AI，你做这个任务大概几步？"
- `options`（4 + Other）：
  1. **label**：1–3 步
     **description**：很简单的任务
  2. **label**：4–7 步 (Recommended)
     **description**：典型工作流
  3. **label**：8–12 步
     **description**：多 phase 复合任务
  4. **label**：不固定
     **description**：取决于输入

> 创意发散选 Other：13+ 步（值得拆 chain） / 其他

#### 第二步（文本输入）

**主问**：按时间线告诉我——你会一步步怎么做？不要省略"看起来很简单"的步骤。

例（写日报）：
1. 打开 Notion 找到上周日报模板
2. ...
13. ...

### 追问候选

- 给 2–3 步就停了：`不可能——你 B2 提了 N 种材料，那就至少有 N 步打开 / 读它们。`
- 跳过判断细节：`第三步你说"参考上周日报"，具体怎么参考？是抄结构、抄措辞、还是抄示例？`

### 写入

- SKILL.md 正文 `## Workflow` 段（按步骤数对应 1–N 个 phase）

---

## B4：判断节点 — 哪一步必须停下来思考（GOMS Selection rules）

### 形式：开放列表（文本）+ 判断依据（原生工具）

#### 第一步（文本输入）

**主问**：在 B3 那串步骤里，哪一步你**必须停下来思考**、不能机械完成？列出所有需要"做选择"的节点。

#### 第二步（原生工具多选）— 判断依据

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："判断依据"
- `question`："每个判断节点你靠什么决定？（多选）"
- `options`（4 + Other）：
  1. **label**：凭已有规则 / 标准
     **description**：如"对客户用'您'，对同事用'你'"
  2. **label**：凭对收件人 / 受众的了解
     **description**：每个对象不同对待
  3. **label**：凭专业经验
     **description**：说不出明确规则但能感觉对错
  4. **label**：凭今天的情绪 / 状态
     **description**：同一情况不同时段判断不同

> 创意发散：凭"AI 给的草稿"在草稿基础上调整 等

### 写入

- 节点 + 依据 → SKILL.md `## Workflow` 段标 `[需要用户判断]`
- 同时进 SKILL.md `## When to ask` 段
- "凭已有规则"部分 → V0.6 段 3.5 机械化检查点候选

---

## B5：行内规矩 — 你懂但 AI 不懂的"潜规则"（Memory 维度，隐性知识抽取核心题）

### 形式：3 子问

#### 子问 ①（原生工具单选）— 易错步骤识别

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："易错步骤"
- `question`："新人 / 外行 / 通用 AI 最容易在哪一步出错？"
- `options`（4 + Other）：
  1. **label**：抽取 / 解读阶段
     **description**：看错重点，把次要当主线
  2. **label**：决策 / 选择阶段
     **description**：判断节点拍错；用错风格或措辞
  3. **label**：超越任务的"前提"
     **description**：默认了某个不该默认的事
  4. **label**："做对了但做过头"
     **description**：过度优化 / 加了不该加的内容

#### 子问 ②（文本输入）

**主问**：你看过的"做得最差"的版本是什么样？差在哪里？

#### 子问 ③（文本输入）

**主问**：有没有"看起来该这样做但实际不能这样做"的反直觉规则？

### 为什么问

Mode B 最值钱的一题——隐性知识就是这里挖出来的。

### 追问候选

- 给了规则但很笼统（"要专业"）：`不行——必须能说出"什么是专业、什么是不专业"。`
- 规则可分硬规则 vs 软偏好：`这条听起来是硬规则（违反了就是错），这条是软偏好——分一下？`

### 写入

- SKILL.md `## Anti-patterns` 段（"做得最差"那条）
- SKILL.md 正文步骤里的"注意"提示框
- `references/glossary.md`（如是术语类）
- **用户原话保留**：禁忌句式逐字进 Anti-patterns 段

---

## B6：术语表 + 固定句式 + 禁词（Language 维度，原话保留）

### 形式：术语 / 句式开放（文本），禁词原生工具

#### 子问 ①（文本输入）— 5 个领域术语

```
1. __________ → __________
2. __________ → __________
3. __________ → __________
4. __________ → __________
5. __________ → __________
```

#### 子问 ②（文本输入）— 固定句式 / 模板碎片

**主问**：开头怎么写 / 结尾怎么写 / 署名怎么写——**必须贴原文**。

#### 子问 ③（原生工具多选）— 禁词

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："禁词"
- `question`："AI 用什么口吻 / 词你绝不允许？（多选）"
- `options`（4 + Other）：
  1. **label**：鸡汤腔
     **description**："亲爱的""相信自己～"
  2. **label**：过度道歉
     **description**："非常抱歉..."
  3. **label**：装专家开头
     **description**："Great question! As an AI..."
  4. **label**：堆叠 emoji
     **description**：一段 ≥ 3 个 emoji

> 自定义禁词（特定行业空话 / 大词 / 政治套话）选 Other 输入原文

### 写入

- `references/glossary.md`（用户原话）
- `assets/templates/intro.md` / `outro.md` / `signature.md`（用户原文）
- SKILL.md Hard Rules 段（禁词清单）

---

## B7：触发场景与原话（description 素材，原话保留）

### 形式：原话开放（文本）+ 文件后缀（原生工具）+ 反例开放（文本）

#### 子问 ①（文本输入）— ≥ 3 句触发原话

```
1. "__________"
2. "__________"
3. "__________"
```

例：
- "帮我把这周的事整理成日报"
- "review PR #X like our team would"
- "帮我做 [客户名] 的本月诊断报告"

#### 子问 ②（原生工具多选）— 文件 / 关键词触发

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："文件触发"
- `question`："哪些文件名 / 关键词出现时该自动触发？（多选）"
- `options`（4 + Other）：
  1. **label**：文件后缀
     **description**：如 *_台账.xlsx / *_诊断报告*.docx / *.diff
  2. **label**：关键词前缀
     **description**：如"日报-" / "周报草稿" / "[客户名]"
  3. **label**：目录路径
     **description**：如 migrations/ 下所有文件
  4. **label**：git diff 涉及某些目录
     **description**：如 stripe/ / api/

#### 子问 ③（文本输入）— 不该触发的反例

**主问**：什么样的请求看起来像，但其实不该触发？

### 写入

- frontmatter `description`（用三要素公式拼装）
- **用户原话片段强制保留**

---

## B8：好范例 + 差范例（Examples，原物保留）

### 形式：两份文本（必须用户原物）

#### 子问 ①（文本输入）— 好范例（必给）

**主问**：贴一份你做过的、自己最满意的那一份的**全文**。

#### 子问 ②（文本输入，可选但强烈推荐）— 差范例

**主问**：你做过 / 见过 / 被改过的"差的那一版"，给原文 + 你心里"哪里差、应该怎么改"的简短注解。

### 为什么问

Anthropic skill-creator 的发现——**examples 比 instructions 更高效**。dogfood 阶段发现 AI 输出不像用户时，第一时间补 examples 而不是改指令。

### 追问候选

- 没保留好作品：`找一份最近做的——任何质量都行。`
- 嫌好范例太长：`没关系，全文贴——AI 会按需读。`
- 没差范例：`OK 跳过——但记住后续 dogfood 时如果发现 AI 输出有典型错误，把那次的输出 + 你的修订记成第一个差范例。`

### 写入

- `examples/good-1.md`（用户原物，**禁止改写任何字**）
- `examples/bad-with-fix.md`（差范例 + 修订注解）

---

## B9：交付前自检清单

### 形式：自检维度（原生工具多选）+ 具体项（文本）

#### 第一步（原生工具多选）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："自检维度"
- `question`："做完这件事交出去之前，你会下意识地查哪几类？（多选）"
- `options`（4 + Other）：
  1. **label**：格式 / 结构
     **description**：字数 / 行数 / 必填字段
  2. **label**：内容准确
     **description**：数字带来源 / 引用正确
  3. **label**：风格 / 措辞
     **description**：不出现禁词 / 用对术语
  4. **label**：意图对位
     **description**：是否真的解决了 trigger 提的问题

#### 第二步（文本输入）

**主问**：每个勾选维度补 1–2 条具体可勾选项（用户原话）。

例（写日报）：
- 格式：字数 ≤ 500 字 / 第一行有 TL;DR
- 内容：数字必须有出处
- 风格：不出现"大量""很多"

### 写入

- `references/checklist.md`（用户原话）
- SKILL.md 末尾 `## Self-check before delivery` 段

---

## B10：收尾开放问 + description 起草确认

### 第一步（原生工具单选 — 引子话题）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："收尾话题"
- `question`："关于这个 skill，还有什么你想补充？挑一个引子："
- `options`（4 + Other）：
  1. **label**：以前给同事的"工作建议"备忘
     **description**：你写过的教别人怎么做你这行的话
  2. **label**：贴一段你不喜欢的 AI 输出
     **description**：让我直观感受
  3. **label**：心里有但没说的 deal-breaker
     **description**：一旦发生你就抛弃 AI
  4. **label**：6 个月后希望 AI 帮你做到什么程度
     **description**：一句愿景 + ROI 测量

> 创意发散选 Other：自由发挥 / 跳过

### 第二步（文本输入 — 自由展开）

基于挑的引子，自由展开。

### 第三步（必跑）— description 现场起草确认

skill 在 B7 + B1 基础上现场拼出 description 草稿（按三要素公式），逐字念给用户听：

```
草稿（约 100–150 词）：
Use this skill when {B1 一句话定义}. This includes: {B7 ② 列举}.
Trigger especially when the user mentions {B7 ① 触发原话} or files matching {B7 ② 文件}.
Do NOT use for: {B7 ③ 反例 + general writing requests where ...}.
```

向用户问（文本）：
> "这段 description 念出来能让 AI 在该用的时候用、不该用的时候不用吗？哪里该改？"

修改 1–2 轮直到用户认可。

### 为什么必须现场审核

description 是 skill 触发的命门，AI 起草的话很容易丢用户语感；让用户当场审是 Anthropic skill-creator 的官方建议。

### 写入

- frontmatter `description` 最终版
- 收尾开放回答 → SKILL.md `## Notes from author` 段

---

## 跑完 10 题后

1. **跑三层 lint**（详见 SKILL.md §Step 5）
2. **Step 5.5：架构反推**（V0.6 起，AI 自动反推）
3. **填 skill 包**：AI 反推完成后**自动**拷对应 5 种架构模板之一，按 B1–B10 字段映射填入
4. **质检 1**：description 触发测试 — 5 假问，准确率 ≥ 80%
5. **质检 2**：dogfood 跑 1 次 — 输出"像用户自己做的"
6. **询问下一个 skill**：从 C2 高频任务里挑（最多再抽 2 个）

---

## 版本

- **V0.7 (2026-05-09)** — 全部 10 题加 metadata。AI 在支持原生选项工具的平台必调原生工具。每题选项 ≤ 4，删手动"⑥ 其他"（原生工具自动加 Other）。完全开放题（B1 第二步 / B3 第二步讲故事 / B4 第一步 / B5 子问 ②③ / B6 子问 ①② / B7 子问 ①③ / B8 全 / B9 第二步 / B10 第二步）保留文本输入。
- V0.6 / V0.4 / V0.2 之前的演进 → 见上一版历史
