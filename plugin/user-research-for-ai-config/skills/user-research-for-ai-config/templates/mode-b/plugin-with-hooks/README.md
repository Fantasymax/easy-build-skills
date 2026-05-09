# Hook-driven Skill 模板（Mode B 架构 #4）

> ⚠ **V0.4 重要提示**：用户**不会主动选**"我要 hook"。本架构由 AI 在 Step 5.5 通过语义反推（见 `frameworks/intent-inference.md`）后**自动选定**。
> 用户拿到的方案是**人话**："每次你 [事件] 时，AI 会自动 [动作]。即使你忘了让它做，它也会自动跑" — 不会出现 "hook" / "PreToolUse" / "settings.json" 字眼，但**会告知额外配置成本**（"你需要把一段配置复制到一个文件里，这是这种方案的额外成本"）。

**何时由 AI 选定本架构**：raw_answers 里有强信号显示用户需要事件驱动 + **硬拦截**（不是软提醒）。触发条件是 ≥ 1 个强硬拦截信号 + ≥ 1 个事件触发信号同时出现。仅"想要 AI 提醒我"不算 — 那是 Hard Rules，写进 SKILL.md，不是 hook。

## 这个架构是什么

一个 **SKILL.md** 描述任务 + 一份 **hooks 配置片段**（用户合并到 `.claude/settings.json`）+ 一个 **hook 处理脚本**。Hook 在事件发生时**确定性触发**对应行为（拦截 / 通知 / 自动执行）。

**与单纯 skill 的本质区别**：
- Skill = 模型驱动（Claude 根据 description 决定何时用）
- Hook = 事件驱动（Claude Code runtime 在指定 event 一定执行）

**典型用例**（Alex 的"git diff 涉及敏感目录必问"）：
```
用户在主对话敲：bash "git push origin main"
        ↓
Claude Code runtime 触发 PreToolUse hook（matcher: Bash(git push *)）
        ↓
hook script 跑：解析 git diff → 检查 migrations/ api/ stripe/
        ↓
        ├─ 涉及敏感目录 → exit 0 + JSON {"permissionDecision": "ask", ...}
        │  → 弹权限对话框，让用户确认
        └─ 不涉及 → exit 0 + {"permissionDecision": "allow"}
            → push 直接放行
```

## 怎么用这个模板

```
my-hook-skill/
├── README.md                         ← 整体说明（即本文件）
├── SKILL.md                          ← skill 描述（任务部分）
├── hooks-config-snippet.json         ← 让用户合并到自己的 .claude/settings.json
├── hooks/
│   ├── {event-name}.sh               ← hook 处理脚本（如 pre-tool-check.sh）
│   └── {event-name}.example-output.json  ← 示例输出（让用户测试）
├── examples/
│   └── full-trigger-walkthrough.md   ← 一次完整触发链的实例
└── references/
    └── hook-events-reference.md      ← 关键 hook event 速查（截取自 notes/08）
```

## 部署位置

**SKILL.md** 走标准三层（`~/.claude/skills/<name>/SKILL.md` 或项目级或插件）。

**Hooks 配置**（关键差异）：

```
~/.claude/settings.json                  # 用户级（个人）
.claude/settings.json                    # 项目级（committable）
.claude/settings.local.json              # 项目本地（gitignored）
```

或在 plugin 里：`<plugin>/hooks/hooks.json`

或 scoped 到 skill 自己：在 `SKILL.md` frontmatter 加 `hooks: ...` 字段（仅在该 skill 激活时生效，自动卸载）

## SKILL.md frontmatter 加 hooks 字段（推荐 — 自包含）

```yaml
---
name: my-hook-skill
description: ...
hooks:
  PreToolUse:
    - matcher: "Bash(git push *)"
      hooks:
        - type: command
          command: "${CLAUDE_SKILL_DIR}/hooks/pre-push-check.sh"
          timeout: 30
---
```

**优点**：hook 与 skill 绑定，skill 卸载时 hook 自动消失，不会遗留。
**缺点**：仅在 skill 激活时生效（如果 skill `disable-model-invocation: true` 没被用户主动 `/`，hook 不会触发）。

## SKILL.md frontmatter VS settings.json hooks 决策

| 你的需求 | 用哪种 |
|---|---|
| Hook 永远生效，独立于任何 skill | `settings.json` 全局 hook |
| Hook 仅在某 skill 上下文激活时生效 | SKILL.md frontmatter `hooks` 字段 |
| Hook 要在团队 / 项目共享 | `.claude/settings.json` 项目级 |
| Hook 仅个人用 | `~/.claude/settings.json` 用户级 |

## 关键 Hook events（从 notes/08 摘）

最常用 5 个：

| Event | 何时触发 | 适合场景 |
|---|---|---|
| `PreToolUse` | 工具调用之前（如 Bash / Edit / Write）| 安全网关 / 拦截危险命令 / 涉及敏感目录强制 ASK |
| `PostToolUse` | 工具成功之后 | 自动格式化 / 自动 lint / 写日志 |
| `UserPromptSubmit` | 用户消息进来时 | 预处理用户输入 / 自动 inject 上下文 |
| `Stop` | Claude 结束响应时 | 触发归档 / 写交接 / 通知 |
| `SessionStart` | 会话启动时 | 自动加载 ACTIVE_SESSION / 跑健康检查 |

**完整 28 个 event**：见 `references/hook-events-reference.md` 或 `notes/08` Part 1.3。

## Hook handler 类型（5 种）

| Type | 用 |
|---|---|
| `command` | shell 命令（最常用；用户写 .sh / .py 脚本）|
| `http` | POST 到 endpoint |
| `mcp_tool` | 调 MCP server 的某个 tool |
| `prompt` | 单 turn LLM 评估（短决策"yes/no"）|
| `agent` | 派 subagent 验证（experimental）|

## stdin / stdout 契约

**Hook 收到的 stdin JSON**（PreToolUse 例）：
```json
{
  "session_id": "abc123",
  "transcript_path": "/path",
  "cwd": "/current/dir",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "git push origin main",
    "description": "Push to remote"
  }
}
```

**Hook 输出（PreToolUse 用 hookSpecificOutput）**：
```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask|defer",
    "permissionDecisionReason": "shown to user",
    "updatedInput": { "command": "modified" }
  }
}
```

**Exit code**：
- `0` = 成功 + stdout 解析为 JSON
- `2` = blocking error（PreToolUse 时 = 阻止 tool）
- 其它 = non-blocking error

## 与 Single Skill 的成本对比

| 维度 | Single Skill | Hook-driven Skill |
|---|---|---|
| 用户配置 | 拷贝 SKILL.md | 拷贝 SKILL.md + **手动合并 settings.json** + chmod hook 脚本 |
| 触发可靠性 | 模型决策（可能漏）| **确定性触发**（不会漏）|
| 调试 | 看 conversation | 还要看 hook 脚本日志（stderr） |
| 场景覆盖 | 任何用户语义匹配的请求 | 只覆盖 hook event 范围内的事件 |
| 适合场景 | 用户主动调用的任务 | 安全网关 / 自动化触发 / 确定性边界 |

## 字段映射（来自 question-bank）

| Question | Maps to |
|---|---|
| B1 一句话定义 | SKILL.md Overview |
| B2 输入材料 | SKILL.md Quick Reference |
| **B13 ①②③④⑤⑥ 触发场景** | **决定 hook event + matcher** |
| B5 行内规矩（属于"硬拦截"的部分）| **hook 脚本的检查逻辑**（不是 skill 的 Hard Rules）|
| B7 触发原话 | SKILL.md description（如 skill 也走自然语言触发）|
| B8 好 / 差范例 | examples/full-trigger-walkthrough.md |
| B9 自检 | SKILL.md Self-check（hook 触发后的任务自检）|

## 模板文件

- `SKILL.md` — skill 描述
- `hooks-config-snippet.json` — 让用户拷到 settings.json
- `hooks/pre-tool-check.sh.example` — 示例 hook 脚本（按 B13 选项设计）

## 部署 Checklist（用户拿到模板后必跑）

1. [ ] SKILL.md 拷到 `~/.claude/skills/<name>/SKILL.md` 或项目级
2. [ ] `hooks-config-snippet.json` 内容**合并**到自己的 `.claude/settings.json`（不要覆盖）
3. [ ] hook 脚本拷到 `${CLAUDE_SKILL_DIR}/hooks/` 或 `.claude/hooks/`
4. [ ] `chmod +x hook 脚本`
5. [ ] 用 `/hooks` 命令在 Claude Code 里查 hook 已注册
6. [ ] 模拟触发一次（敲一条会触发 matcher 的命令），看 hook 是否执行
7. [ ] 看 stderr / debug log 确认无错

## 质检

- description 触发测试（如 SKILL.md 也支持自然语言触发）
- **hook 触发测试（关键）**：手动敲 5 条假命令，看 matcher 命中 / 不命中是否符合预期；命中时 hook 决策（allow/deny/ask）是否符合预期
- dogfood：跑一次完整工作流（含真触发的 hook）
