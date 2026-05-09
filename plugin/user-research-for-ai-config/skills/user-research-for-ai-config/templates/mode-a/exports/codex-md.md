# CODEX.md 导出模板（OpenAI Codex 风格）

> **风格特点**：与 AGENTS.md 高度同源（OpenAI Codex 实际推荐用 AGENTS.md），但保留 CODEX.md 作为 OpenAI 工具链友好命名。
>
> **何时用**：用户明确指定要 CODEX.md（部分老 OpenAI 工具或自定义 wrapper 仍读 CODEX.md）。
>
> **填法**：与 `agents-md.md` 内容**完全相同**，只是文件名不同。可直接将 AGENTS.md 复制为 CODEX.md，或同时维护两份硬链接。

---

## 推荐做法

**方案 A（推荐）**：项目根目录只放一份 `AGENTS.md`，加一个 `CODEX.md` 作为 symlink/简单引用：

```markdown
<!-- CODEX.md 内容（极简）-->
# CODEX.md

This project's AI agent contract is in [AGENTS.md](./AGENTS.md).

Codex / OpenAI tools should read AGENTS.md.
```

**方案 B**：同时维护两份独立的同步文件——耗时但有些工具链会优先读 CODEX.md。

---

## 与 AGENTS.md 的差异（如需独立维护）

如果你需要独立维护 CODEX.md，与 AGENTS.md 的差异点：

1. **标题改成** `# CODEX.md`
2. **Tools & Commands 段** 可以更激进地用 OpenAI Codex CLI 的具体语法（如果用户用的是 Codex CLI）：
   ```bash
   # Codex CLI 风格示例
   codex run "{任务描述}" --tool {工具}
   ```
3. **Self-Check 段** 可以加入 OpenAI 风格的"先想再答"提示：
   ```
   - [ ] 先在 scratchpad 内推理
   - [ ] 把结论标 <final> 标签后输出
   ```

其它字段（Persona / Context / Goals / Hard Rules / Decision Boundary / Workflow / Output Format / Examples / Escalation）**字字相同**，从 `output-three-layer.md` Layer 3 取。

---

## 实操：直接采用 AGENTS.md 模板

打开 `agents-md.md`，复制其中代码块内容，把第一行 `# AGENTS.md` 改成 `# CODEX.md`，保存为项目根目录 `CODEX.md`。完成。
