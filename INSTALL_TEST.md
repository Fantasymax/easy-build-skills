# 安装与实测指南 / Installation & Testing Guide

> **必读**：这份指南帮你**真正地把 skill 加载进 Claude Code / Cowork / Cursor / Codex 跑起来**——不是模拟，是实测。
>
> Anthropic 官方文档：[code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills)
>
> 与 `frameworks/self-validation.md` 的分工：
> - **本文（用户实测）**：用户在真实平台上验证 skill 能加载 + 触发 + 跑通
> - **`self-validation.md`（AI 主动自测）**：skill 内嵌的 5 步自测流水线，跑完用户回答后 AI 主动检查产物质量

---

## Phase 0：发布前请先手动清理（仅 git push 第一次）

⚠️ 由于历史迭代，以下目录可能仍存在但已废弃，**请在 push 前手动删除**：

```bash
cd <repo-root>/

# 验证 mode-b 子目录已是 V0.8 后的 5 个 Anthropic 官方形态名
ls skill/user-research-for-ai-config/templates/mode-b/
# 应只有：atomic / orchestration / with-subagents / plugin-with-hooks / composite-plugin
# 如还有 skill-package / skill-chain / sub-agent-skill / hook-driven-skill / hybrid-skill，删掉
```

---

## Phase 1：安装到 Claude Code

### 方法 A：项目级安装（推荐——只在某个项目里启用）

```bash
# 在你的项目根目录
mkdir -p .claude/skills
cp -r path/to/<repo>/skill/user-research-for-ai-config .claude/skills/

# 重启 Claude Code 让它发现新 skill
# Mac: Cmd+Shift+P → "Reload Window"
# Win/Linux: Ctrl+Shift+P → "Reload Window"
```

### 方法 B：全局安装（推荐——对所有项目都启用）

```bash
mkdir -p ~/.claude/skills
cp -r path/to/<repo>/skill/user-research-for-ai-config ~/.claude/skills/
```

### 方法 C：作为 Plugin 安装

```bash
mkdir -p ~/.claude/plugins
cp -r path/to/<repo>/plugin/user-research-for-ai-config ~/.claude/plugins/
```

### 方法 D：Claude Cowork（桌面应用）

1. 打开 Cowork 设置
2. 找到"Skills 目录"或类似选项
3. 把 `<repo>/skill/user-research-for-ai-config/` 整个目录拖进去
4. 重启 Cowork

---

## Phase 2：验证 skill 被识别

在 Claude Code / Cowork 里说：

```
/help
```

或：

```
你能看到我的 user-research-for-ai-config skill 吗？描述一下它的作用。
```

**预期结果**：Claude 能看到 skill 并描述它（描述应来自 SKILL.md 的 description 字段）。

**如果 Claude 说看不到**：
- 检查 skills 目录路径是否正确
- 检查 SKILL.md 是否在 `<skill-name>/SKILL.md` 路径
- 检查 frontmatter 是否合规（`---\nname: ...\ndescription: ...\n---`）
- 重启 Claude Code 应用

---

## Phase 3：测试 description 触发率（5 pos + 5 neg 假问题）

这是 Anthropic skill-creator 推荐的标准触发测试。把下面 10 条**逐条**说给 Claude，看每条是否触发本 skill。

### 应触发的 5 条（命中率应 ≥ 4/5）

```
1. "我想给我用的 Claude Code 写一份属于我自己的 CLAUDE.md，让它真的懂我"
2. "帮我把每周写日报这件事抽成一个属于我的 skill"
3. "我用了好多 AI 工具但每个的输出都像别人写的——能让 AI 真正理解我吗？"
4. "I want to build my own AI principles document that fits my workflow"
5. "把我会的'写产品需求文档'这件事教给 AI"
```

### 不应触发的 5 条（误触率应 ≤ 1/5）

```
6. "帮我访谈 100 个用户做产品调研"  ← Do NOT trigger（针对其他用户的研究）
7. "写一个 system prompt 给 ChatGPT 用"  ← Do NOT trigger（generic）
8. "做市场调研报告"  ← Do NOT trigger
9. "怎么用 Cursor"  ← Do NOT trigger（通用使用问题）
10. "帮我写代码"  ← Do NOT trigger
```

### 通过标准

- 应触发命中率 ≥ 80%（5 条至少 4 条触发）
- 不应触发误触率 ≤ 20%（5 条至多 1 条误触）

### 未通过的处理

- 命中率低 → description 加更多触发词原话（修改 `skill/.../SKILL.md` 的 frontmatter）
- 误触率高 → description 的 "Do NOT use for..." 段加更具体的反例

---

## Phase 3.5：交互呈现验证（V0.7 — 跨平台真实测试）

> ⚠️ V0.7 加 §B9 平台原生 UI 工具规则。详见 `skill/.../frameworks/ux-interaction-rules.md`。

### 测试 A：Claude 全家桶（原生 AskUserQuestion）

在 Claude Code 2.1.1+ / Claude Desktop / Claude.ai / Cowork 任一环境跑：

```
我想给自己定义 AI principles
```

**预期**：Claude 调用 `AskUserQuestion` 工具——你看到**多 tab 选项卡 / 单选钮 / 复选框 UI**。

✅ 通过 / ❌ 失败 → 报 issue

### 测试 B：Codex CLI（内置 TUI picker）

在 Codex CLI 跑相同请求。

**预期**：Codex 渲染**多 tab picker UI**——支持 ←/→ 切 tab、↑↓ 移动选项、单选/多选自动检测、自定义文字、Submit 提交。

✅ 通过 / ❌ 失败（如降级为 markdown）→ 报 issue（说明 Codex 没识别我们的输出格式）

### 测试 C：MCP 客户端 + ask-user-questions-mcp（Cursor / Windsurf / Cline / Kilo / VS Code+Copilot / Zed 等）

**前提**：先装 `ask-user-questions-mcp`，详见 https://github.com/paulp-o/ask-user-questions-mcp

装完后跑：

```
我想给自己定义 AI principles
```

**预期**：客户端调用 MCP `ask_user_question` tool，呈现选项 UI（具体外观因客户端而异）。

✅ 通过 / ❌ 失败 → 检查 MCP server 是否正确连接

### 测试 D：MCP 客户端但没装 MCP server（推荐安装提示）

跑相同请求，但事先**不装** ask-user-questions-mcp。

**预期**：skill 主动给你**一次性安装建议**：

```
🔍 我发现你的环境里没有 AskUserQuestion 工具，会让选项体验差一些。

如果你用的是 Cursor / Windsurf / Cline / VS Code+Copilot / Zed / Kilo Code 等：
强烈建议安装 ask-user-questions-mcp 这个 MCP server，5 分钟搞定。

要现在装吗？
[✅ 现在装] [⏭ 用 CLI 文字模式继续] [❓ 这是啥]
```

✅ 通过：给了安装建议（不是默默 fallback 到 CLI）
❌ 失败：直接走 markdown fallback 不提建议 → 报 issue

### 测试 E：自部署 LLM / Web ChatGPT（CLI 精简编号 fallback）

在自部署 Llama / Qwen / GLM / Web ChatGPT 跑。

**预期**：CLI 精简编号格式（≤ 10 行），格式如：

```
🤔 你做什么 + 给谁交付？
  1. 文字内容创作（公众号/Newsletter/视频）
  2. 软件产品（Indie Hacker/SaaS）
  3. 知识服务（顾问/教练）
  4. 多重身份并行
  5. 转型期/探索期
  6. 自定义（请说）
→ 回数字 1–5 或自由文字
```

✅ 通过 / ❌ 失败 → 报 issue

### 测试 F：单选 vs 多选标注（所有平台）

UI 模式：选择钮 vs 复选框 UI 区分
CLI 模式：明确标 "回 1 个数字" vs "回多个数字 1,3,5"

✅ 通过 / ❌ 失败 → 报 issue

---

## Phase 4：实际跑一遍 Mode A 完整流程

跑完触发测试后，让 Claude **实际**进入 skill 流程：

```
我想给自己定义 AI principles
```

**预期 Claude 的反应**（按 Step 序）：
1. 触发本 skill
2. 给你 3 个模式选项（A / B / C）让你选 → 你选 A
3. **Step 1.5（V0.9 新）**：让你选输出语言（中文 / 英文 / 双语 / 其他）
4. Step 2 让你选档位
5. Step 3 跑 shared-core 5 题（C1 + C2 + C3 + C4a + C4b）
6. Step 4 跑 express-mode-a 10 题
7. Step 5 跑三层 lint
8. **Step 5.5** AI 不会问你形态（Mode A 没形态）但仍会按 9 段合成
9. Step 6 输出 + 按你 C3 工具栈智能选 1–3 个平台导出
10. **Step 7.5（V0.9 新）**：AI 跑 5 步自测（Schema / 触发 / Dogfood / 覆盖率 / 报告）

**如果 Claude 没按预期走**：
- 第 1 步失败 → description 触发问题（回 Phase 3）
- 第 3 步失败（V0.9 关键）→ Step 1.5 没加进 SKILL.md，检查
- 第 9 步无智能筛选 → `frameworks/platform-export-selector.md` 没读 / 没生效
- 第 10 步无自测 → `frameworks/self-validation.md` 没读 / 没生效

---

## Phase 5：实际跑 Mode B 完整流程（最重）

让 Claude 跑 Mode B：

```
我想构建一个属于我自己的 skill
```

**预期 Claude 应**（按 Step 序）：
1. 触发本 skill
2. 提示选模式（你选 B）
3. **Step 1.5** 选输出语言
4. Step 2 选档位
5. Step 3 跑 shared-core 5 题
6. **前置 1（任务项目化）**—— 按 `task-shortlist-rules.md` 5 维评分给你 5 候选 + 2 创意发散 + 1 自定义
7. Step 4 跑 express-mode-b B1–B10
8. **Step 5.5 形态判断引擎**——按 `intent-inference.md` 反推
9. 给你 6 段式形态预览（含段 3.5 机械化检查点 + ASCII preview 树）
10. 让你 5 选项反馈（① 够用 / ② 不够 / ③ 太复杂 / ④ 太简单 / ⑤ 自行输入）
11. 按形态选模板路径填占位符
12. 输出 skill 包到指定路径
13. **Step 7.5（V0.9 新）**：AI 跑 5 步自测 + 主动报告 + 5 选项反馈

**任一步骤失败时**：
- 把失败的步骤 + Claude 的实际反应 **截图**
- 提交到本仓库 GitHub Issues
- 标题格式：`[V1.0 实测] Phase X 失败：<简短描述>`

---

## Phase 6：sub-agent / hooks 实测（高级，仅 Plugin 形态时）

如果 Mode B 形态推断给你的是 Plugin with Hooks 或 Composite Plugin：

### 测 sub-agent

```bash
# 在 Claude Code 里说
"使用我的 [skill 名] 跑一道任务，看它会不会调 sub-agent"
```

**预期**：Claude 在执行到需要专家判断的步骤时**显式 fork 到 sub-agent**——你应该能看到"正在调 X 专家..."类似提示。

### 测 hooks

```bash
# 触发 hook 配置的事件（如保存某个文件）
echo "test content" > triggers-hook.md  # 或对应的 matcher 触发条件

# 看 Claude Code 是否真的调用 main-skill
```

**预期**：触发 matcher 事件时 hook 真的执行（看 Claude Code 日志或得到 hook 输出）。

---

## Phase 7：常见问题排查

### Q1：Claude 完全看不到 skill
- 检查路径：`ls ~/.claude/skills/user-research-for-ai-config/SKILL.md` 文件存在？
- 检查 frontmatter：第一行必须是 `---`，最后是 `---`
- 检查 YAML 有效性：可用在线 YAML lint 工具
- 检查 description 字符数 ≤ 1024（V1.0 已合规）

### Q2：Skill 加载但 description 不触发
- 复述用户原话和 description 中的触发词关键词重叠度——如果原话完全没碰触发词，触发引擎会跳过
- 修 description：把用户最常说的原话加进去

### Q3：Skill 触发但跑到中途卡住
- 多半是 SKILL.md 主体太长（V1.0 合规为 ≤ 500 行）—— 拆 references/
- 或者 frameworks / question-bank 等支持文件没被找到 → 检查 SKILL.md 中的相对路径

### Q4：输出语言混杂（V0.9 应已修复）
- Step 1.5 是否真的有问语言？没有 → SKILL.md 没加 Step 1.5
- 用户选了"中文"但出现"## Layer 1"骨架英文 → `frameworks/output-language-rules.md` 没读 / 没生效

### Q5：Mode B 形态推断给的形态不对
- 看 `frameworks/intent-inference.md` 的信号打分规则
- 你的 B1–B10 答案是否真的符合该形态的信号定义？
- 如果你坚持要换形态，用 🔼/🔽/🖊 反馈给 AI

### Q6：sub-agent 调用失败
- 检查 `.claude/agents/<expert-name>.md` 是否存在且 frontmatter 合法
- 检查 SKILL.md 的 `agent:` 字段值是否与 sub-agent 文件名一致

### Q7：Step 7.5 自测没跑（V0.9 新）
- 看 SKILL.md 末尾 Step 7.5 段是否存在
- 看 `frameworks/self-validation.md` 是否被引用 / 是否能被 Claude 读到
- 如 AI 直接跳过自测进入 final → 报 issue

---

## Phase 8：把测试结果反馈

跑完上述所有 Phase 后：
- 通过率高 → 在仓库 README 加一个"已实测通过"badge + ⭐ 仓库
- 有问题 → 提 Issue（按上面 Phase 5 末尾的格式）

---

## License Reminder

本 skill 受 [MIT with Attribution Requirement](./LICENSE) 保护。fork / 修改 / 二次开发**必须**：
- 在你的 README 中署名 **FantasyMax (幻想主义麦克斯)**
- 保留 **HiFantasyMax** 联系号在 AUTHORS 文件
- 链接回原始仓库

未署名 = 违约。
