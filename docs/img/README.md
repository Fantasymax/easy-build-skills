# Demo Illustrations / 示意图说明

> 本目录的 4 张 **SVG 示意图**（AI 生成）已作为 V1 的首页 demo。**真实截图**待用户跑 skill 后贡献。

## 当前已有

| 文件 | 模拟内容 | 状态 |
|---|---|---|
| `demo-1-mode-selection.svg` | Step 1 选模式（A/B/C + Other 单选）| ✅ V1 上线 |
| `demo-2-option-pattern.svg` | A2 角色比喻题 — 3 强相关 + 2 创意发散 | ✅ V1 上线 |
| `demo-3-feedback-loop.svg` | Step 5.5 形态反推 6 段呈现 + 5 选项反馈 | ✅ V1 上线 |
| `demo-4-self-validation.svg` | Step 7.5 AI 自测报告 + 4 检查 + 3 问题 | ✅ V1 上线 |

## 真实截图待补（V1.1 目标）

如有用户跑了真 skill 想贡献截图，按下面规范命名提交 PR：

| 文件名 | 截图什么 |
|---|---|
| `screenshot-1-mode-selection.png` | Step 1 真实 AskUserQuestion 选项卡 |
| `screenshot-2-option-pattern.png` | A2 题真实呈现 |
| `screenshot-3-intent-inference.png` | Step 5.5 真实 6 段输出 |
| `screenshot-4-self-validation.png` | Step 7.5 真实自测报告 |

合并后 README 引用从 `demo-X.svg` 切换为 `screenshot-X.png`。

---

## 拍摄真实截图的指南（如你想贡献）

按 README 中引用顺序：

### 1. `askuserquestion-mode-selection.png`
**场景**：Step 1 选模式（A/B/C）时的 AskUserQuestion 选项卡。
**怎么截**：
1. 在 Claude Code 里说："我想给自己定义 AI principles"
2. 等 Claude 调用 AskUserQuestion 工具呈现"你想要什么"3 选项
3. 截图整个对话框（含选项卡 + tab 导航条）

### 2. `askuserquestion-option-pattern.png`
**场景**：3 强相关 + 2 创意发散选项的实际呈现。
**怎么截**：
1. 任意走到 A2 题"AI 应该像谁"
2. 截图 AskUserQuestion 的 4 选项卡（label + description）

### 3. `intent-inference-6-segment.png`
**场景**：Step 5.5 形态反推后的 6 段呈现（含段 3.5 机械化检查点 + ASCII preview 树）。
**怎么截**：
1. 跑完 Mode B B1-B10
2. 等 Claude 输出 6 段呈现（核心动作 / ✅ / ❌ / ⚙ / ⏸ / 📁）
3. 滚动截图整段（可能需要拼接）

### 4. `self-validation-report.png`
**场景**：Step 7.5 AI 自测后的报告（🔴🟡🟢 + 5 选项）。
**怎么截**：
1. Mode B 输出生成后等 Claude 自动跑 5 步自测
2. 截图最终报告 + 5 选项反馈

### 5. `feedback-loop-5-options.png`
**场景**：5 选项反馈循环（① 够用 / ② 不够 / ③ 太复杂 / ④ 太简单 / ⑤ 自行输入）。
**怎么截**：
1. 任意 Step 5.5 / Step 7.5 反馈环节
2. 截图 AskUserQuestion 的 5 选项

---

## 命名规范

- 全小写 + 连字符（kebab-case）
- 描述清楚场景：`{step}-{feature}-{detail}.png`
- 文件大小 ≤ 500 KB（GitHub 主页加载快）
- 推荐 PNG，截图分辨率 ≥ 1080p

---

## 拍摄环境建议

- **首选**：Claude Code 2.1.1+ CLI（原生 AskUserQuestion，UI 最规范）
- **次选**：Claude Desktop / Cowork
- **不推荐**：Cursor / Codex（因为 UI 略有差异，不如 Claude 全家桶规范）

---

## 隐私 / 脱敏

截图前清空个人 chat history / 项目路径 / 用户名等敏感信息。如截图含具体内容（如真实 SKILL.md），打码处理。

---

## 截好后

1. 把 PNG 文件直接放到本目录
2. 删除本 README.md 里"待补"标注（说明已补齐）
3. 在 README.md / README.en.md 里把对应 `![alt](docs/img/xxx.png)` 占位替换为实际链接

---

> By FantasyMax (幻想主义麦克斯) · 2026
