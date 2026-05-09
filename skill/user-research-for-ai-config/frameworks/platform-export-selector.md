# Mode A 平台导出智能筛选规则（V0.8 — Rules A-F）

> **何时读**：用户跑完 Mode A 标准版 / 快速版后，进入 Step 6 输出阶段时。
>
> **使命**：V0.1 不分情境一律导出 5 个平台模板（CLAUDE.md / AGENTS.md / CODEX.md / .cursorrules / system-prompt.md），对**不用代码工具的用户**（如自媒体小马）来说 4 个浪费。AI 应根据 C3 工具栈智能推荐 1–3 个平台，给用户 4 选项 + 自定义反馈选择最终导出。
>
> **核心设计哲学**：用户都是小白——他们不懂"AGENTS.md 和 CLAUDE.md 有什么区别"。AI 必须根据用户实际使用的工具自动选，并给"小白能懂的"导出建议。
>
> **来源**：从 cowork V0.4.1 platform-export-selector.md 借用 + V0.8 整合。

---

## Part 1 — 平台与场景映射

| 平台文件 | 适用工具 | 适用用户特征 | 必要 / 可选 |
|---|---|---|---|
| **CLAUDE.md** | Claude Code（CLI）/ Claude Desktop / Claude Cowork | 用 Claude 系列 | 用 Claude 必要 |
| **AGENTS.md** | OpenAI Codex CLI / Cursor / Aider / OpenCode / Trae / Qoder / Kilo Code 等多平台 | 用任何"非 Claude"AI 编码工具 | 跨平台主选 |
| **CODEX.md** | OpenAI Codex CLI（老版） | 用旧版 Codex CLI | 可选——AGENTS.md 通常已覆盖 |
| **.cursorrules** | Cursor IDE | 用 Cursor 编程 | 用 Cursor 必要 |
| **system-prompt.md**（通用版）| ChatGPT / Gemini / 自部署模型 / 其他不归类工具 | 用 ChatGPT 或非编程类 AI | 通用兜底 |

---

## Part 2 — 工具栈→推荐平台映射

按 C3 工具栈用户回答，AI 智能推断**默认推荐**集合（最多 3 个）：

### 规则 A：识别"主用 Claude 工具"

C3 中含以下任一关键词 → **必推 CLAUDE.md**：
- Claude Code / Claude Desktop / Claude Cowork
- "Anthropic" / "Claude"

### 规则 B：识别"主用 OpenAI / Cursor / 其他编码工具"

C3 中含以下任一关键词 → **推 AGENTS.md**：
- Cursor / Codex / Aider / OpenCode / Trae / Qoder / Kilo
- VS Code（虽然不直接读 AGENTS.md，但用户可能装了 Cursor / GitHub Copilot 等扩展）

### 规则 C：识别"Cursor 用户"

C3 含 "Cursor" → **额外推 .cursorrules**（Cursor 不读 AGENTS.md）

### 规则 D：识别"非编码 AI 用户"

C3 工具栈**不含任何编码工具**（如全是 Notion / 飞书 / Word / Excel / 微信）→
- **只推 system-prompt.md** 作为主导出
- 可选 CLAUDE.md（如果用户也用 Claude.ai 或 Cowork）

### 规则 E：识别"开发者 + 多 AI 用户"

C3 同时含编码工具 + Claude → **推 CLAUDE.md + AGENTS.md** 两个

### 规则 F：CODEX.md 的特殊处理

- **默认不推**——AGENTS.md 已覆盖 OpenAI Codex
- 仅当用户明确说"我必须用 CODEX.md"时再加（例：用旧版 OpenAI 工具链）

### 必推 vs 可选的默认勾选规则

AI 给用户的 5 选项反馈中"✅ 按推荐导出"的默认行为：

| 平台分类 | 默认勾选行为 |
|---|---|
| **必推**（按规则 A–F 强制推荐的）| ✅ 默认勾选——用户点"按推荐导出"会包含 |
| **可选**（"如果你以后想用 X" 类）| ☐ 默认不勾——用户需手动加（用 🔼 加导出 X 平台）|
| **不推**（明确提示"你不用这些工具"）| 不显示给用户（避免 5 选项过载）|

---

## Part 3 — 推荐结果呈现给用户的格式

### UI 模式（AskUserQuestion）

```python
AskUserQuestion(questions=[{
    "question": "我看了你的工具栈，建议导出这几份。怎么选？",
    "header": "导出平台",
    "multiSelect": False,
    "options": [
        {"label": "按推荐导出", "description": "仅必推 — {platform-1} {platform-2}"},
        {"label": "加导出可选项", "description": "包含可选 — {platform-3}"},
        {"label": "减少 X 平台", "description": "请说哪个去掉"},
        {"label": "全部 5 个都要", "description": "不管推不推都导"}
    ]  # AskUserQuestion 自动加 Other（"我自己定"）
}])
```

### CLI 模式（fallback）

```
🔍 我看了你的工具栈，建议导出这几份：

✅ **必推**：{platform-1}
   理由：你说{C3 原话片段}——{platform-1}是给{tool}用的

✅ **必推**：{platform-2}（如有第二个）
   理由：...

🟡 **可选**：{platform-3}（如有）
   理由：...

🔘 **不推**：{其它平台}（不显示——避免选项过多）

──
你怎么选？
[✅ 按推荐导出] [🔼 加导出 X 平台] [🔽 减少 X 平台] [🖊 我自己定（可输入想要的平台）]

（选完任意一项，都可以再补一句话："还想说……"）
```

---

## Part 4 — 5 类用户的推荐示例

### 类型 1：自媒体小马（仅用 Notion / 飞书 / 剪映 / ChatGPT）

C3 关键词：Notion, 飞书, 剪映, 小红书, ChatGPT

→ **推 system-prompt.md**（通用版，给 ChatGPT 用）+ 可选 **CLAUDE.md**（如果小马以后也想用 Claude.ai）

```
推荐：
✅ system-prompt.md - 给你的 ChatGPT / 通用 AI 用
🟡 CLAUDE.md - 如果你以后也想用 Claude.ai，可以一并生成

不推：AGENTS.md / CODEX.md / .cursorrules（你不用编程类 AI 工具）
```

### 类型 2：Indie Hacker Alex（用 Cursor + Claude Code + GitHub）

C3 关键词：Cursor, Claude Code, GitHub, Linear, Mintlify, Stripe

→ **推 CLAUDE.md + AGENTS.md + .cursorrules**

```
推荐：
✅ CLAUDE.md - 给你的 Claude Code 用
✅ AGENTS.md - 给 GitHub Copilot / Aider 等其它工具用（也是跨平台主选）
✅ .cursorrules - 给 Cursor 用（必须独立配，AGENTS.md 不能完全替代）

不推：CODEX.md（AGENTS.md 已覆盖）/ system-prompt.md（你不用 ChatGPT 类工具）
```

### 类型 3：财务顾问林女士（用 Excel / Word / 微信 / 网银 / 税务系统）

C3 关键词：Excel, Word, 微信, 网银, 税务局系统

→ **只推 system-prompt.md**（她基本不用 AI 编码工具）

```
推荐：
✅ system-prompt.md - 给你以后想用的任何 AI（ChatGPT / Claude.ai / Gemini）

不推：所有编码类平台
```

### 类型 4：Power user（同时用 Claude Code + Cursor + ChatGPT + Codex）

C3 全部覆盖

→ **推 CLAUDE.md + AGENTS.md + .cursorrules + system-prompt.md**（4 个，跳过 CODEX.md）

```
推荐：
✅ CLAUDE.md - 给 Claude Code
✅ AGENTS.md - 给 OpenAI Codex / Aider / OpenCode 等
✅ .cursorrules - 给 Cursor
✅ system-prompt.md - 给 ChatGPT 等通用 AI

不推：CODEX.md（AGENTS.md 已覆盖；如你必须用旧版 Codex 工具链请勾"加"）
```

### 类型 5：完全没说工具栈的用户

C3 答得很模糊或为空

→ AI 反问："你最常找 AI 干活时用什么工具？是 Claude / ChatGPT / Cursor / 别的？"
→ 等用户回答后再走规则 A–F

如用户说"都不太用 AI"→ 默认 **system-prompt.md** + 推荐"先做小工具试用"

---

## Part 5 — 用户反馈处理

### ✅ 按推荐导出
- 直接按 AI 推荐的 1–3 个平台导出
- 进入实际填充模板

### 🔼 加导出 X 平台
- 用户说"加 .cursorrules" → AI 加上，但**警告**："你 C3 没说用 Cursor——确定要导吗？"
- 防止用户盲目"全选"

### 🔽 减少 X 平台
- 用户说"不要 CLAUDE.md" → AI 减掉，但**反问**："你 C3 提到 Claude Code——确定不要给 Claude Code 用的版本？"
- 防止用户误删

### 🖊 我自己定
- 用户用自由文字描述："给我 X / Y 平台"
- AI 解析关键词 → 匹配规则 A–F → 给最终清单
- 仍提示用户审核

### 追加补充
- 任意选项后允许追加 ≤ 50 字
- 例："还想说……我每天还用 Slack AI"——AI 把 Slack 加入考虑

---

## Part 5.5 — 导出文件命名规则（V1.0 — 加用户名前缀）

> **来源**：cowork V0.4.1 的实测发现 — 5 个 .md 文件不加前缀容易让用户混淆，特别是同时给多个客户/项目做 principles 时。

### 规则 A：默认加用户名前缀

所有 Mode A 导出文件**自动加用户名前缀**（kebab-case）：

```
xiaoma-system-prompt.md         ← 小马的（自媒体）
alex-CLAUDE.md                   ← Alex 的（独立开发）
alex-AGENTS.md                   ← Alex 的
alex-.cursorrules                ← Alex 的
lin-system-prompt.md             ← 林女士的（财务顾问）
```

用户名来源：
- 优先用 C1 第二步（用户自报身份）的简短代号（如"小马"→ `xiaoma`）
- 无简短代号 → 让用户在 Step 6 输出前问一次："给这套配置起个英文短名（≤ 8 字符 kebab-case）"

### 规则 B：同用户多项目时用 sub-prefix

如同一项目混用多个 principles（如小马同时做"写作"和"视频"两个 AI 配置）：

```
xiaoma-writing-CLAUDE.md         ← 小马的写作场景
xiaoma-video-CLAUDE.md           ← 小马的视频场景
xiaoma-writing-system-prompt.md
xiaoma-video-system-prompt.md
```

格式：`{用户}-{场景}-{平台}.{ext}`

### 规则 C：Cursor / Claude Code 配置文件特殊处理

`.cursorrules` 和 `CLAUDE.md` 是工具自动读取的固定文件名，**不能加前缀**（否则 Cursor / Claude Code 找不到）：

```
.cursorrules            ← 直接放项目根（Cursor 读这个）
CLAUDE.md               ← 直接放项目根或 ~/.claude/（Claude Code 读这个）
```

但导出阶段可以保留前缀版本作为**参考备份**（用户决定哪份去掉前缀真用）：

```
导出文件夹/
├── xiaoma-CLAUDE.md         ← 备份版（带前缀，方便归档）
├── CLAUDE.md → xiaoma-CLAUDE.md  ← symlink 或副本（实际生效）
```

或者更简单：**只导带前缀版**，让用户手动 cp/rename 到目标路径，避免误覆盖。

---

## Part 6 — 与 Mode B 形态推断的边界

⚠ **重要**：本文件的导出筛选**只对 Mode A 适用**（principles 文档导出）。

**Mode B 的形态判断引擎**（V0.4 intent-inference.md）已经决定了输出形态——Atomic / Orchestration / Skill with Subagents / Plugin with Hooks / Composite Plugin——**不需要再走平台筛选**。Mode B 的输出是一个 SKILL.md 包，部署在 `~/.claude/skills/` 或 plugin 目录，本身就是跨平台的（Claude Code / Desktop / Cowork 都读同一个 skill）。

如果用户**同时**做了 Mode A 和 Mode B（路径 C），两套输出独立：
- Mode A → 5 个 principles 平台模板（按本文 Rules A–F 筛选）
- Mode B → 1 个 SKILL.md 包（按 intent-inference.md 形态推断）

---

## 版本

- **V0.8 (2026-05-09)** — 从 cowork V0.4.1 platform-export-selector.md 借用 + 与我们 V0.8 体系合并：
  - 形态名统一为 Anthropic 官方术语（Atomic / Orchestration / Skill with Subagents / Plugin with Hooks / Composite Plugin）
  - 补全 Part 6 与 Mode B 形态推断的边界说明（cowork 原文截断在此）
  - UI 模式适配 AskUserQuestion 4 选项硬限制
