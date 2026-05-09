# 输出语言规则（V0.9 — Step 1.5 落地）

> **何时读**：Step 1.5 用户选完输出语言后；Step 6（Mode A）/ Step 6（Mode B）/ Step 7.5 自测验证 全程使用本文规则。
>
> **使命**：V0.7/V0.8 实测产物出现"骨架英文（Layer 1 / Workflow / Persona / Goals）+ 内容中文"的混杂问题。本文规定**哪些必须按选定语言 / 哪些强制保留英文 / 哪些保留用户原话**，让产出语言一致。

---

## Part 0 — 默认推断（V1.1 — 能推断就不强问，模糊才必问）

> **来源**：cowork V0.4.8 实测发现 — 每次跑 skill 都强问语言对老用户太繁琐。改为"能推断就用默认，模糊才必问"。

### 0.1 推断信号（按权重）

| 信号 | 权重 | 例 |
|---|---|---|
| 用户启动时第一句话的语言 | 最强 | "我想给自己定义 AI principles" → `zh-CN` |
| 用户 OS / Claude Code locale 设置 | 强 | `zh_CN.UTF-8` 默认中文 |
| 用户 C3 工具栈名称的语言 | 中 | "Notion / 飞书 / 公众号后台" → 偏中文用户 |

### 0.2 默认行为速查表

| 用户启动语言 | session 默认 output_language | 是否强问 |
|---|---|---|
| 全中文（"我想给自己定义 AI principles"）| `zh-CN` | **不问**，直接默认 |
| 全英文（"I want to build my own CLAUDE.md"）| `en` | **不问**，直接默认 |
| 中英混合（"build 我的 own CLAUDE.md"）| 不确定 → **必问**（4 选项）| **必问** |
| 完全模糊（短指令如"start"）| 默认中文（主用户群）| 不问，但提醒"可随时说'换英文'切换"|
| 其他语言（日 / 西 / 法 等）| 不确定 → **必问** | **必问** |

### 0.3 Session 存储

```yaml
# ${SESSION_DATA}/output_language.json
primary: zh-CN              # 主语言
preserve_original:           # 始终保留原文的内容类
  - domain_terms             # 用户给的行话术语
  - user_quotes              # 用户原话片段
  - file_paths               # 文件名 / 路径
  - code_identifiers         # 函数名 / 变量名
  - yaml_keys                # frontmatter 键名
  - anthropic_official_terms # atomic / orchestration 等
```

一次推断 / 询问后**全程沿用**（不要每个 Step 都问一次）。

---

## Part 1 — 三档分类（决定每个字符走哪个规则）

### 1.1 强制保留英文（任何输出语言下都不翻译）

| 类别 | 例子 | 理由 |
|---|---|---|
| **Anthropic 官方形态名** | atomic / orchestration / with-subagents / plugin-with-hooks / composite-plugin | 官方术语，翻译反而失真 |
| **文件名 / 协议名** | SKILL.md / CLAUDE.md / AGENTS.md / CODEX.md / .cursorrules / settings.json | 文件系统硬编码 |
| **配置字段 / 字段名** | frontmatter / description / multiSelect / header / options / label | 跨工具协议，必须英文 |
| **Claude Code 能力名** | Skills / Subagents / Hooks / Slash Commands / MCP / Plugins | 官方文档对齐 |
| **工具名 / 平台名** | Claude Code / Cursor / Codex CLI / Windsurf / Zed / VS Code | 不译人名地名同理 |
| **Lint 类型名** | Leading / Shallow / Personal bias / Unconscious bias / L1.1 / L1.2 / L2.1 | 内部分类码 |
| **常见技术词** | regex / grep / hook / API / JSON / YAML / Markdown / git diff | 行业惯用 |
| **方法论名** | GOMS / 9 段 / Variable Reward / Persona / Hard Rules 等公开框架名 | 引用源不译 |

> **判定逻辑**：如果一个词出现在文件路径、配置 schema、官方文档标题里 → 不翻译。

### 1.2 必须按选定语言（所有段标题 / 章节标题 / 说明文字）

| 中文 | 英文 | 用户选"中文"时 | 用户选"英文"时 |
|---|---|---|---|
| Layer 1 — 用户画像 | Layer 1 — User Profile | "第一层 — 用户画像" | "Layer 1 — User Profile" |
| Workflow | Workflow | "工作流程" | "Workflow" |
| Persona | Persona | "角色画像" | "Persona" |
| Goals | Goals | "目标" | "Goals" |
| Guardrails | Guardrails | "护栏 / 红线" | "Guardrails" |
| Hard Rules | Hard Rules | "硬规则" | "Hard Rules" |
| Anti-patterns | Anti-patterns | "反模式" | "Anti-patterns" |
| Examples | Examples | "范例" | "Examples" |
| Decision Logic | Decision Logic | "决策逻辑" | "Decision Logic" |
| Tools / Context | Tools / Context | "工具 / 上下文" | "Tools / Context" |
| Variable Reward | Variable Reward | "可变奖励" | "Variable Reward" |
| Investment | Investment | "投入" | "Investment" |
| Trigger | Trigger | "触发" | "Trigger" |

> **判定逻辑**：如果一个词出现在用户**最终读到的文档正文**里且**有清晰对译** → 按选定语言。

### 1.3 用户原话保留（按 §B10，任何语言下不动）

按 `frameworks/interview-basics.md` §B10：
1. 触发原话片段（"我老板会跟我说……"）
2. 行业行话 / 术语
3. 好范例原物
4. 固定模板（开头结尾、签名）
5. 禁忌原话（"我从来不写……"）

→ 用户原话保留为**用户输入时的语言**，无论 Step 1.5 选了什么。

> **示例**：用户选了"英文输出"，但他给的好范例是中文公众号开篇 "上周三晚上，我闺蜜阿芮……"——examples/good-1.md 仍然保留中文原文，只在文档其他段（Anti-patterns / Goals / Workflow 等）用英文。

---

## Part 2 — 双语对照模式的详细规则

用户选 "双语对照" 时：

### 2.1 段标题双语

```
## Layer 1 — 用户画像 / User Profile
## Layer 2 — 需求规格 / Requirements
## Workflow / 工作流程
## Hard Rules / 硬规则
```

→ 中文 / 英文用 `/` 隔开，按用户答题语言决定哪个在前。

### 2.2 说明文字按用户答题语言

如果用户答题用中文 → 说明文字中文为主，英文段标题作辅助
如果用户答题用英文 → 说明文字英文为主，中文段标题作辅助

### 2.3 列表项不双语

避免双语爆炸：
- ❌ "- 钝感力 / Insensitivity（渡边淳一意义上的迟钝）"
- ✅ 按用户答题语言写："- 钝感力（渡边淳一意义上的迟钝；不是抗压能力）"

### 2.4 frontmatter 仍然按选定主语言

YAML frontmatter `description` 字段太长不双语，按用户答题语言一份即可。

---

## Part 3 — 实施清单（生成各文档时检查）

### Mode A `output-three-layer.md`

| 元素 | 处理 |
|---|---|
| 标题（"小马的 AI Principles — 三层合一文档"）| 按选定语言 |
| 元数据字段名（"生成日期" / "版本" / "目标平台"）| 按选定语言 |
| 段标题（Layer 1 / Layer 2 / Workflow / Persona ...）| 按选定语言 |
| 字段值（具体内容）| 按选定语言；用户原话 § Part 1.3 不动 |
| 文件路径（`02_lint_report.md`）| 永远英文 |
| 平台名（CLAUDE.md / AGENTS.md）| 永远英文 |

### Mode B `SKILL.md`

| 元素 | 处理 |
|---|---|
| frontmatter `name` 字段 | kebab-case 英文（用户给的 skill 名）|
| frontmatter `description` 字段 | 按选定语言（Use this skill when ... / 这个 skill 用于...）|
| `## Overview` 段标题 | 按选定语言 |
| `## When to use` 段标题 | 按选定语言 |
| `## Quick Reference` / `## Workflow` / `## Anti-patterns` 段标题 | 按选定语言 |
| `## 访谈基本功` / `## 引用文件索引` 段标题 | 按选定语言 |
| 表格内字段值 | 按选定语言 |
| 用户原话片段（描述触发场景）| 用户原话不动 |

### Mode A exports/*.md（5 平台模板）

每平台模板内的 H1 / H2 标题、说明文字按选定语言。但**部分平台有约定**：
- `CLAUDE.md` Anthropic 官方文档默认英文 / 中文都接受 — 按用户选定
- `AGENTS.md` OpenAI Codex 文档惯用英文 — 用户选中文也尊重用户选择
- `.cursorrules` 简短规则文件 — 按用户选定
- `system-prompt.md` 通用 — 按用户选定

---

## Part 4 — 反例（V0.7/V0.8 实测错误）

```
# ❌ V0.7 小马的 03_output_three_layer.md（混杂）
## Layer 1 — 用户画像     ← Layer 英文 + 用户画像 中文
### 协作触发场景           ← 中文
- **AI 角色比喻**：**资深编辑**

# ✅ V0.9 修复后（用户选"中文"）
## 第一层 — 用户画像
### 协作触发场景
- **AI 角色比喻**：**资深编辑**

# ✅ V0.9 修复后（用户选"英文"）
## Layer 1 — User Profile
### Trigger Scenarios
- **AI Persona**: **Senior Editor**

# ✅ V0.9 修复后（用户选"双语对照"，答题中文）
## 第一层 — 用户画像 / Layer 1 — User Profile
### 协作触发场景 / Trigger Scenarios
- **AI 角色比喻**：**资深编辑**
```

---

## Part 4.5 — 其他语言支持（V1.1）

用户选 ④ 输入语言名（如"日本語" / "Español" / "Français" / "Deutsch"）→ AI 切换全流程到该语言。

**风险提示**：
- skill 自带的 question-bank 题目 / framework 文档大多中文写 — AI 在呈现时**实时翻译**到目标语言（不要要求用户读源中文）
- 输出文件按目标语言写
- 用户原话保留原始语言（即使与目标语言不同 — 如英文用户给的好范例是中文，仍保留中文）
- 跨语言 lint：英文 / 西语 / 法语等使用同一套 ASCII 字符集，混杂检测更困难 — 需依赖关键词列表而非纯 unicode 扫描

---

## Part 5 — 合成阶段 Lint 语言混杂扫描（V1.1 高价值补丁）

> **来源**：cowork V0.4.8 实测高价值补丁 — 仅靠 LLM 自觉很难保证不混杂，必须程序化扫描。
>
> **何时跑**：所有输出文件生成后（Step 6 完成、Step 7.5 之前）。

### 5.1 扫描伪代码

```python
import re

target_lang = session_data['output_language']['primary']
preserve_list = session_data['output_language']['preserve_original']

def scan_language_mix(file_path):
    text = read(file_path)
    # 去掉应保留的内容（代码块 / frontmatter / 用户原话标注）
    cleaned = remove_preserved_items(text, preserve_list)

    if target_lang == 'zh-CN':
        # 检查英文字母占比（除外保留项）
        en_chars = len(re.findall(r'[a-zA-Z]', cleaned))
        zh_chars = len(re.findall(r'[一-鿿]', cleaned))
        total = en_chars + zh_chars
        if total > 0 and en_chars / total > 0.20:  # 英文占比 > 20%
            return ('mixed', f'英文占比 {en_chars/total:.0%}（阈值 20%）')

    elif target_lang == 'en':
        # 检查中文字符是否出现
        zh_chars = re.findall(r'[一-鿿]', cleaned)
        if zh_chars:
            return ('mixed', f'出现 {len(zh_chars)} 处中文字符（应全英文）')

    return ('ok', None)
```

### 5.2 阈值（V1.1）

| 目标语言 | 容忍非目标语言占比 | 触发条件 |
|---|---|---|
| `zh-CN` | ≤ 20% 英文（保留 Anthropic 术语 / 文件名 / 代码会占一些）| > 20% → 警告 |
| `en` | 0 中文字符（除链接 / 用户原话）| 任何中文 → 警告 |
| `双语对照` | 不扫（设计就是混的）| — |
| 其他语言 | ≤ 30% 非目标语言（更宽松）| > 30% → 警告 |

### 5.3 命中混杂的处理（4 选项）

```
🔍 检测到 file_X.md 出现语言混杂：
   {具体描述：英文占比 45% / 出现 12 处中文字符 / ...}

预览前 3 处：
  Line 12: "## Layer 1 — 用户画像"  ← Layer 1 是英文骨架
  Line 25: "Workflow / 工作流程"
  Line 88: "Hard Rules"

你怎么处理？
[✅ 没问题（这些都是保留项）]
[🔄 重译这些段]
[🔼 整体重译这个文件]
[🖊 我自己改]
```

**用户选 ✅** → 把这些 line 加到 `preserve_list` 白名单，下次扫描跳过
**用户选 🔄** → AI 只重译命中的段落
**用户选 🔼** → AI 重译整个文件
**用户选 🖊** → 用户自由编辑，AI 协助落地

### 5.4 扫描范围

- ✅ 必扫：Mode A `output-three-layer.md` + 5 平台 exports / Mode B `SKILL.md`
- ✅ 应扫：Mode B `examples/good-*.md` / `references/*.md`
- ❌ 不扫：用户原话保留区（已知会含其他语言）/ 代码块

---

## Part 6 — 与 ux-interaction-rules 的衔接

UX 交互规则规定**怎么呈现**（AskUserQuestion / CLI 编号），本规则规定呈现的**语言** — 两者正交：

- AskUserQuestion 的 `question` / `label` / `description` 全部用**目标语言**
- CLI fallback 的题目 + 选项也用**目标语言**
- "其它（自定义）"始终保留 — 无论何种语言

---

## Part 7 — Step 7.5 自测验证集成

`frameworks/self-validation.md` Step 1（Schema 自检）必须包含**语言一致性检查**：

```
□ 所有段标题语言是否一致（不混杂 Layer 1 + 用户画像）？
□ Anthropic 官方形态名是否保留英文？
□ 文件路径是否保留英文？
□ 用户原话是否未被翻译篡改？
```

任一失败 → 阻塞输出，回到生成阶段修正。

---

## 版本

- **V0.9 (2026-05-09)** — 创建。基于老板对 V0.8 实测反馈："小马的 03_output 里 Layer 1 是英文，用户画像是中文，骨架英文 + 内容中文混杂"。Step 1.5 加输出语言询问，本文规定 3 档分类（强制英文 / 必须翻译 / 用户原话保留）+ 双语对照模式 + 实施清单。
