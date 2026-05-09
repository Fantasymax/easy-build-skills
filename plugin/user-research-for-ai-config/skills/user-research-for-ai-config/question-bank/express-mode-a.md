# Mode A 快速版问题清单（10 题，V0.7）

> **何时用**：Step 4，用户选了 Mode A 且选择"快速版"档位时。耗时 7–10 分钟（共享核心 4 题已花 3–5 分钟，合计 10–15 分钟）。
>
> **题序**：按 Game Complexity Arc 续接共享核心。
>
> **嵌入框架**：习惯回路四要素（Trigger / Action 两要素优先）+ 认知心理学 3 维（Memory / Decision Making / Emotion）+ Agent Contract 关键字段（Goals / Guardrails / Autonomy / Escalation）。
>
> **V0.7 关键**：每题加 metadata。AI 在支持原生选项工具的平台调原生工具（详见 SKILL.md §B8），不让用户打字。每题选项 ≤ 4 + 平台自动给 Other。
>
> **追问规则**：每题答完按 SKILL.md §B2 自动追问 1–2 次。每 3 题做一次 §B3 偏误自检。

---

## A1：触发场景 — 上一次想用 AI 之前那 5 分钟（中等，触发要素）

### 形式：1 次原生工具调用，3 个 question 子问

#### 子问 ① — 你当时在做什么？

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："情境"
- `options`（4 + Other）：
  1. **label**：写东西卡住了
     **description**：找不到下一句怎么写
  2. **label**：翻资料没找到方向
     **description**：读了好多但角度没出来
  3. **label**：收到一条要回的消息
     **description**：要起草一段沟通
  4. **label**：在 review 已有版本
     **description**：自己 / 别人写的产物找问题

#### 子问 ② — 心里什么感觉？

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："情绪"
- `options`（4 + Other）：
  1. **label**：烦躁
     **description**：事多 + 手乱
  2. **label**：截止前慌
     **description**：时间不够
  3. **label**：卡住了 / 走不动
     **description**：思路堵了
  4. **label**：兴奋
     **description**：突然有个想法想验证

#### 子问 ③ — 是什么让你"决定要找 AI 帮忙"？

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："为何找 AI"
- `options`（4 + Other）：
  1. **label**：自己想了很久没思路
     **description**：投入 ≥ 15 分钟仍卡
  2. **label**：想要"另一个角度"对照
     **description**：已有自己版本，想看 AI 怎么看
  3. **label**：量太大想加速
     **description**：纯效率考虑
  4. **label**：想要思维伙伴
     **description**：假装自己不是一个人在做

### 为什么问

定位 AI 必须出现在用户哪个生活/工作切片。情绪词是关键——习惯回路模型证明用户的内部触发往往是情绪驱动。**子问 ③ 选 ②"另一个角度对照"= 对照镜模式信号**（见 02_methodology §2.6）。

### 写入

- Mode A → Layer 1 用户画像"触发场景"段
- principles → Context 段

---

## A2：角色比喻 — 你希望 AI 像谁（Memory 维度）

### 形式：原生工具单选 + 文本补一句

#### 第一步（原生工具单选）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："角色比喻"
- `options`（4 + Other）：
  1. **label**：资深同事 (Recommended)
     **description**：比我有经验，会指出我哪里偷懒
  2. **label**：私人助理
     **description**：默默处理琐事，不让我操心
  3. **label**：教练
     **description**：先反问我"为什么这样想"，再给建议
  4. **label**：编辑
     **description**：指出问题但不替我下笔

> 如不像上面 4 个 → 选 Other 输入（如"哲学家 / 苏格拉底式对手 / 田野调查的人类学家 / 老朋友" 等）

#### 第二步（文本输入）

**主问**：选完之后，加一句话——它和"普通 AI 助手"最大的不同是什么？

### 为什么问

Memory 维度 维度最强信号——用户对 AI 的心智模型决定它"应该有的默认行为"。

### 追问候选

- 用户选了但理由空泛：`再具体——它会做什么、不会做什么？`
- 抽象答案（"聪明的助手"）：`你身边有没有真人符合这个描述？这个真人具体会怎么帮你？`

### 写入

- Persona 段 + Hard Rules（角色对应的默认行为）

---

## A3：语言偏好（Language 维度）

### 形式：3 子问 — ① 文本，②③ 原生工具

#### 子问 ①（文本输入）

**主问**：写下来——你最常找 AI 干活的领域里，**3 个外行听不懂但你天天用**的术语 / 缩写：

```
1. __________
2. __________
3. __________
```

#### 子问 ②（原生工具多选）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："禁词"
- `question`："AI 用什么口吻你立刻不信任？（多选）"
- `options`（4 + Other）：
  1. **label**：鸡汤腔
     **description**："亲爱的""相信自己～"
  2. **label**：过度道歉
     **description**："非常抱歉刚才的回复..."
  3. **label**：堆叠 emoji
     **description**：一段 ≥ 3 个 emoji
  4. **label**：装专家开头
     **description**："Great question! As an AI..."

#### 子问 ③（原生工具单选）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："首选口吻"
- `question`："AI 用什么口吻你最舒服？"
- `options`（4 + Other）：
  1. **label**：同事式
     **description**：平视，不卑不亢
  2. **label**：教练式
     **description**：先反问，再给方案
  3. **label**：编辑式
     **description**：指出问题但不替我下笔
  4. **label**：朋友式
     **description**：口语 + 偶尔吐槽

### 写入

- Hard Rules 段（必用术语 / 禁用句式 / 默认口吻）+ Persona 风格半句

---

## A4：最小可执行动作 — 你最希望 AI 一次性接管什么？（动作要素）

### 形式：动词预选（原生工具）+ 文本输入

#### 第一步（原生工具单选）

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

**主问**：用 "[动词] + [对象]" 写一句具体动作。

例：
- "整理这周读的 10+ 本书的卡片，整理成下一篇深度长文的 3 个候选选题角度"
- "review 这个 PR，找出可能影响线上稳定性的 3 处改动"
- "对比这家公司近 3 个月的现金流，找出 2 处异常"

#### 第三步（文本输入）

**主问**：每次它输出，应该带哪些固定字段？

### 写入

- Goals 段（顶部第一条）+ Mode B 任务候选池

---

## A5：自治度等级（Decision 维度 + Agent Autonomy）

### 形式：原生工具单选 + 必要时文本补充

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："自治度"
- `options`（4 + Other）：
  1. **label**：全自动
     **description**：从输入到输出一气呵成，结果交给我看
  2. **label**：关键岔口请示 (Recommended)
     **description**：能自己决定的就做，岔路口停下来问
  3. **label**：每步请示
     **description**：每完成一步给我看
  4. **label**：双轨模式
     **description**：草拟阶段全自动；定稿前每步请示

> 创意发散 / 草拟模式：选 Other 输入（如"永远只给草稿，绝不直接交付"）

**如选 ② 或 ④**：文本输入"两个具体岔路口"。

### 写入

- Workflow 段（自治度声明）+ Handoff 段

---

## A6：输出视觉偏好（Vision/Attention 维度）

### 形式：2 子问

#### 子问 ①（原生工具单选）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："最先跳读"
- `options`（4 + Other）：
  1. **label**：顶部 TL;DR
     **description**：先看总结再看细节
  2. **label**：代码块 / 表格 / 列表
     **description**：数据 / 结构化为先
  3. **label**：末尾结论
     **description**：从下往上看
  4. **label**：两条线
     **description**：先 1 行结论再展开推理

#### 子问 ②（原生工具多选）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："最看不见"
- `options`（4 + Other）：
  1. **label**：免责声明
     **description**："以下分析仅供参考"
  2. **label**：过度道歉
     **description**："很抱歉..."
  3. **label**："以下是…"开头
     **description**：半句废话铺垫
  4. **label**：总结性收尾段
     **description**：已经讲完又来一句"综上所述..."

### 写入

- Output Format 段

---

## A7：决策边界三栏 — Do / Ask / Don't（核心，Agent Guardrails）

### 形式：3 个原生工具多选（每栏一个 question）

> **设计**：1 次工具调用带 3 个 questions（每栏一个），每个 question 多选 4 候选 + Other 让用户自定义具体场景。

#### 子问 1 — Do（直接做）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："Do"
- `options`（4 + Other）：
  1. **label**：改错别字 / 修语病
     **description**：纯校对
  2. **label**：抽取关键信息 / 做对比表格
     **description**：从原料找模式
  3. **label**：列候选选项（≥ 2 版）
     **description**：给我挑
  4. **label**：补脚注 / 加引用 / 标 source
     **description**：填充辅助信息

#### 子问 2 — Ask（先问我）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："Ask"
- `options`（4 + Other）：
  1. **label**：替我下结论 / 加观点
     **description**：任何"立场"动作
  2. **label**：删掉某段 / 大幅删减
     **description**：减少内容
  3. **label**：调换论证 / 段落顺序
     **description**：改结构
  4. **label**：调用我的私货素材 / 知识库
     **description**：动用我的资产

#### 子问 3 — Don't（绝不许做）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："Don't"
- `options`（4 + Other）：
  1. **label**：直接发出去
     **description**：发邮件 / 提交 PR / 公众号发文
  2. **label**：登录我账号 / 处理鉴权
     **description**：账号安全
  3. **label**：用我口气写定稿
     **description**：替我成稿
  4. **label**：处理涉密信息
     **description**：客户数据 / API key / 财务隐私

> 所有自定义 Don't 必须避免模糊形容词（"不要做不专业的事"会触发 lint L2.1）

### 写入

- Hard Rules + Guardrails 段
- Layer 2 需求规格"决策边界三栏"段

---

## A8：情绪红线（Emotion 维度）

### 形式：原生工具多选 + 1 个具体回忆

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：true
- `header`："最怕失误"
- `question`："AI 帮你做这件事，你最怕它哪里失误？（多选 1-3 个）"
- `options`（4 + Other）：
  1. **label**：替我做了我自己的判断
     **description**：替我下结论 / 选立场
  2. **label**：让我看起来不专业
     **description**：输出像别人写的、像 AI 写的
  3. **label**：暴露隐私 / 跨上下文串联
     **description**：把内部信息说出去
  4. **label**：稀释我的语感
     **description**：反复改稿，文风越来越像 AI

> 创意发散选 Other：数据丢失 / 操作错文件 / 占用太多时间 等

**追问**：举一次"幸亏发现了"的瞬间——上次差点没发现 AI 错了什么的时候，那个细节是什么？（文本输入）

### 写入

- Guardrails 段最高优先级 + Hard Rules 末尾"红线"标注

---

## A9：拿不准时怎么办（Agent Escalation）

### 形式：原生工具单选 + 必要时补判断标准

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："拿不准"
- `options`（4 + Other）：
  1. **label**：直接停下来问我
     **description**：reactive
  2. **label**：给我多个方案让我选
     **description**：A/B/C 单选
  3. **label**：先按它的判断做，标"这里我拿不准"
     **description**：输出后用户复核
  4. **label**：看任务大小决定 (Recommended)
     **description**：小事自己定，大事问我

> 创意发散选 Other：直接出最佳猜测 等

**如选 ④**：文本输入"大事 / 小事"判断标准。例：「会不会改变这篇的'立场'或'骨架'。改变 → 必问；不改变 → 自己定」

### 写入

- Escalation / Fallback 段 + Workflow 段尾段

---

## A10：收尾开放问（永远是最后一题）

### 形式：原生工具单选（话题）+ 文本输入（具体内容）

#### 第一步（原生工具单选）

**metadata**：
- `工具`：原生选择工具
- `multiSelect`：false
- `header`："收尾话题"
- `question`："关于这个 AI 配置，还有什么你想说但前面没问到的？如果不知道从哪说起，挑一个话题作引子："
- `options`（4 + Other）：
  1. **label**：以前给同事的"工作建议"备忘
     **description**：你写过的"教别人怎么做你这行"的话
  2. **label**：贴一段你不喜欢的 AI 输出
     **description**：让我直观感受
  3. **label**：心里有但没说的 deal-breaker
     **description**：一旦发生你就抛弃 AI
  4. **label**：6 个月后希望 AI 帮你做到什么程度
     **description**：一句愿景

> 创意发散选 Other：每周固定花 30 分钟训练 AI 的方向 / 自由发挥

#### 第二步（文本输入）

**主问**：基于上面挑的话题，自由展开。任何形式都可以——一句话、一段话、贴一段你以前发过的群消息、贴一段你不喜欢的 AI 输出片段。

### 为什么问

用户访谈方法论 验证 — 这是访谈最后一题"留白价值最高"。用户被问了 9 题之后会主动给出"你刚才没问但我觉得最重要"的内容。

### 写入

- Context 段尾段 / 或新增"用户备注"段
- 出现频次高的关键词同时进 Persona 段

---

## 跑完 10 题后

1. **跑三层 lint**（详见 SKILL.md §Step 5）
2. **Step 5.5：架构反推**（V0.6 起，AI 自动反推 + V0.6 6 段呈现 + 5 选项反馈）
3. **填三层合一文档**：用 `templates/mode-a/output-three-layer.md`
4. **导出 5 平台 principles**（默认全部 5 个）
5. **询问是否继续 Mode B**：从 C2 任务清单 + A4 最小动作推荐 1–2 个最高频任务作 Mode B 候选

---

## 版本

- **V0.7 (2026-05-09)** — 全部 10 题加 metadata（工具 / multiSelect / header / options 含 description）。AI 在支持原生选项工具的平台必调原生工具。每题选项 ≤ 4（V0.6 的 5 选项超限），删手动"⑥ 其他"。完全开放题（A2 第二步 / A4 第二/三步 / A8 追问 / A10 第二步）保留文本输入。A7 三栏拆 3 questions per call。
- V0.2 / V0.3.1 / V0.4 之前的演进 → 见上一版历史
