# Demo Illustrations / 示意图

> 本目录的 4 对 **PNG 示意图**（中英版各 4 张）作为 GitHub 首页 demo，模拟 Claude Code 的真实 AskUserQuestion UI。

## 当前已有（V1.2.0）

| 文件 | 模拟内容 | 用于 |
|---|---|---|
| `demo-1-mode-selection.png` / `-en.png` | Step 1 选模式（A/B/C + Other 单选）| README.zh-CN.md / README.md |
| `demo-2-option-pattern.png` / `-en.png` | A2 角色比喻题 — 3 强相关 + 2 创意发散 | 同上 |
| `demo-3-feedback-loop.png` / `-en.png` | Step 5.5 形态反推 6 段呈现 + 5 选项反馈 | 同上 |
| `demo-4-self-validation.png` / `-en.png` | Step 7.5 AI 自测报告 + 4 检查 + 3 问题 | 同上 |

中文 README（`README.zh-CN.md`）引用 `demo-X.png`，英文 README（`README.md`）引用 `demo-X-en.png`。

---

## 想替换为真实截图？

如果你跑过真 skill 想贡献真实截图替换示意图，PR 欢迎。命名规范：保留 `demo-X[-en].png` 名字（替换内容即可），或用新命名 `screenshot-X[-en].png` + 同步更新 README 引用。

### 拍摄指南

| 文件 | 场景 | 怎么截 |
|---|---|---|
| demo-1 | Step 1 选模式 | 在 Claude Code 说"我想给自己定义 AI principles"→ 截 AskUserQuestion 选项卡 |
| demo-2 | A2 角色比喻题 | 跑到 A2 → 截 4 选项卡（label + description）|
| demo-3 | Step 5.5 6 段呈现 | Mode B 跑完 B1-B10 → 截 6 段输出（核心动作 / ✅ / ❌ / ⚙ / ⏸ / 📁）|
| demo-4 | Step 7.5 自测报告 | Mode B 输出后等 AI 跑 5 步自测 → 截最终报告 + 5 选项 |

### 命名 / 规格

- 全小写 + 连字符（kebab-case）
- 文件大小 ≤ 500 KB（GitHub 主页加载快）
- 推荐 PNG，截图分辨率 ≥ 1080p
- **隐私**：截前清空个人 chat history / 项目路径 / 用户名等敏感信息

### 拍摄环境

- **首选**：Claude Code 2.1.1+ CLI（原生 AskUserQuestion，UI 最规范）
- **次选**：Claude Desktop / Cowork
- **不推荐**：Cursor / Codex（UI 略有差异）

---

> By FantasyMax · 2026
