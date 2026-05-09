# 跨平台原生选项工具映射（V0.7）

> **何时读**：当 SKILL.md §B8 引用本文件 / AI 跑此 skill 但需要具体平台工具调用时。
> **来源**：WebSearch + 各平台官方文档 + 真实平台 UI 矩阵交叉验证（2026-05-09）。
> **维护**：V0.7+ 持续更新。

---

## 抽象需求（平台无关）

每次需要让用户从选项里挑时，调平台原生工具实现：

- **单选 / 多选检测**（multiSelect 字段）
- **2-4 个选项**（多于 4 拆题）
- **自动给 "Other / 自由输入" 出口**
- **短 header 标签**（≤ 12 字符）
- **每选项含 description**（5-15 字简短解释）

---

## 11 平台真实映射表

> ⚠ **关键发现**：MCP 是大多数 IDE 类平台的通用解 — 装 [`paulp-o/ask-user-questions-mcp`](https://github.com/paulp-o/ask-user-questions-mcp)（`npx -y auq-mcp-server server`）即可让 Cursor / Windsurf / Zed / OpenCode 等都获得交互式选择能力。

| 平台 | 选项 UI 支持 | 机制 | 来源 |
|---|---|---|---|
| **Claude Code 2.1.1+** | ✅ 原生 `AskUserQuestion` | 内置工具，4 question / 4 option / 自动 Other | [docs.claude.com](https://code.claude.com/docs/) |
| **Claude Desktop / Claude.ai / Cowork** | ✅ 原生 `AskUserQuestion` | 同上 | 同上 |
| **OpenAI Codex CLI** | ✅ 原生 `ask_user_question` | TUI 多 tab picker（行 tab + Submit + ←/→ 导航）；`codex exec` 非交互模式自动移除此工具 | [Codex Issue #9926](https://github.com/openai/codex/issues/9926) |
| **Cursor** | ✅ 通过 MCP | 装 `ask-user-questions-mcp`（`npx -y auq-mcp-server server`）| [paulp-o/ask-user-questions-mcp](https://github.com/paulp-o/ask-user-questions-mcp) |
| **Windsurf / VS Code + Copilot** | ✅ 通过 MCP | 同上；Cascade 原生支持 stdio / HTTP / SSE | [docs.windsurf.com/cascade/mcp](https://docs.windsurf.com/windsurf/cascade/mcp) |
| **Cline / Roo Code / Kilo Code** | ✅ 通过 MCP；Kilo 还有原生 `ask_followup_question`；Roo Code 有"Ask Mode" | 都支持 MCP server | [kilo.ai/docs](https://kilo.ai/docs/automate/tools/ask-followup-question) |
| **OpenCode** | ✅ 有专门 OpenCode plugin（auq-mcp 已集成）+ 原生 `question` tool | OpenCode plugin 版本 | [opencode.ai/docs](https://opencode.ai/docs/tools/) + auq-mcp |
| **Zed / Continue** | ✅ 通过 MCP | Zed 原生 MCP（tools + prompts，confirm / allow 模式）| [zed.dev/docs/ai/mcp](https://zed.dev/docs/ai/mcp) |
| **Gemini CLI** | 🟡 有 slash / @ picker（不是 MCP，需特定格式触发）；plan mode 有 `ask_user` 工具；通用多选 UI active development | 部分支持 | [google-gemini/gemini-cli#12659](https://github.com/google-gemini/gemini-cli/issues/12659) |
| **Trae / Qoder** | 🟡 通过 MCP（如平台支持 MCP）| 同 Cursor 路径；Trae 支持 MCP 协议 | [trae.ai](https://www.trae.ai/) |
| **自部署 LLM / Web ChatGPT** | ❌ 无 ask-user 工具 | CLI 精简编号 fallback（markdown 列表 + "请回复编号"）| — |

---

## 跨平台调用伪代码

```python
# AI 在跑此 skill 时根据当前平台选工具
if platform in ['claude-code', 'claude-desktop', 'claude.ai']:
    use_tool('AskUserQuestion', {'questions': [{...}]})

elif platform == 'codex-cli' and not non_interactive_mode:
    use_tool('ask_user_question', {...})  # tabbed picker UI

elif platform == 'kilo-code':
    use_tool('ask_followup_question', {...})  # 一次一题

elif platform == 'opencode':
    use_tool('question', {...})  # 或装 auq-mcp 的 plugin 版

elif platform in ['cursor', 'windsurf', 'zed', 'cline', 'roo-code',
                  'continue', 'trae', 'qoder']:
    # 装 ask-user-questions-mcp MCP server 后调用其工具
    use_mcp_tool('auq-mcp', 'ask_questions', {...})

elif platform == 'gemini-cli' and mode == 'plan':
    use_tool('ask_user', {...})

else:
    # 自部署 LLM / Web ChatGPT / 不支持 MCP 的环境
    print_markdown_options_list_with_numbered_reply()
```

---

## 部署建议（给本 skill 的用户）

如果你用 Cursor / Windsurf / Zed / OpenCode 等 IDE 类工具，一键装 MCP server 启用交互式选择：

### Cursor 配置示例

`~/.cursor/mcp.json` 或工作区 `.cursor/mcp.json`：

```json
{
  "mcpServers": {
    "auq": {
      "command": "npx",
      "args": ["-y", "auq-mcp-server", "server"]
    }
  }
}
```

### Windsurf / Zed / Continue / Roo Code / Cline 配置

格式相同（MCP 客户端通用）。装好后 reload 客户端，本 skill 自动检测可用并调用 auq 工具。

### OpenCode 专用 plugin

OpenCode 有 `paulp-o/ask-user-questions-mcp` 的官方 OpenCode plugin 版本（非 MCP），按 OpenCode 的 plugin 安装方式即可。

### Codex CLI

不需要任何额外配置 — `ask_user_question` 是 Codex CLI 的内置工具。仅需注意 `codex exec` 非交互模式会自动禁用此工具（fail-fast）。

### Claude Code

不需要任何额外配置 — `AskUserQuestion` 是 Claude Code 的内置工具。

---

## 维护说明

新增平台时按以下格式 append 表格：

```
| **平台名** | ✅/🟡/❌ + 工具名/机制 | 备注 / 配置 | [来源链接] |
```

每条记录必须有**来源链接**（官方文档 / GitHub issue / 通过测试的 commit），不接受"猜测 / 听说"。

---

## 版本

- **V1.0 (2026-05-09)** — 从 SKILL.md §B8 拆出（避免 SKILL.md 正文超 500 行硬上限）。基于 11 平台 WebSearch + 老板提供的真实 UI 矩阵交叉验证。
