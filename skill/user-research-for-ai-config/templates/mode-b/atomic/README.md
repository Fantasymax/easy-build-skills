# Mode B Skill 包模板 — 使用说明

这是 `user-research-for-ai-config` skill 的 Mode B 输出骨架。当用户跑完 Mode B 快速版 10 题后，按以下流程把骨架填成完整的"用户专属 skill"。

---

## 目录结构

```
{user-skill-name}/
├── SKILL.md                       ← 主文件，frontmatter + 正文
├── examples/
│   ├── good-example.md            ← 用户的好范例原物（B8 ①）
│   └── bad-example-with-fix.md    ← 差范例 + 修订（B8 ②，可选）
└── references/
    ├── glossary.md                ← 领域术语表（B6）
    └── checklist.md               ← 交付前自检（B9，≥5 条时单独放）
```

可按需追加：
- `assets/templates/` — 用户给的固定模板原文（B2 ④ / B6 ②）
- `assets/styles/` — 视觉样式 / CSS / 字体（如该 skill 涉及视觉产物）
- `scripts/` — 可执行脚本（仅当用户给确定性命令时；多数 Mode B skill 不需要）

---

## 填法步骤

### 1. 重命名根目录
把 `atomic/` 改成用户给的 skill 名（kebab-case），比如 `weekly-report-writer/`。

### 2. 填 SKILL.md
按文件里的 `{...}` 占位符注入 B1–B10 的回答。**严格遵守**用户原话保留规则（详见 `outputs/skill/user-research-for-ai-config/SKILL.md` §B7）。

### 3. 填 examples/
- `good-example.md` 内的 `{用户原物}` 段必须**逐字粘贴**用户给的好范例
- 如有 B8 ② 差范例，填 `bad-example-with-fix.md`；没有就删除该文件

### 4. 填 references/
- `glossary.md` 按 B6 ① 术语表填，`{...}` 占位符替换为用户原话
- `checklist.md` 按 B9 自检项填；如果用户只给了 ≤ 4 条，把这些条直接挪到 SKILL.md 末尾，删除本文件

### 5. （如需）填 assets/
如果 B2 用户给了固定模板原文，新建 `assets/templates/<name>.md` 把原文贴进去。**禁止 AI 改写。**

### 6. 跑两道质检（必跑）
1. **description 触发测试**：
   - 起草 5 条假冒"来访的用户提问"
   - 逐条问用户："这条该不该触发你的 skill？"
   - 计算准确率：≥ 80% 才放行；< 80% 回到 B7 重挖触发原话
2. **dogfood**：
   - 用刚生成的 skill 跑用户的一道真实任务（最好是 B8 那个场景）
   - 看 Claude 输出像不像用户自己做的
   - 不像 → 第一时间往 `examples/` 加新的 good-N.md，**不要先改 SKILL.md**

### 7. 投放
把整个 skill 目录放到用户的 `skills/` 或对应工具的 skill 路径下。具体路径：
- **Claude Cowork / Claude Code**：用户机器上的 skills 目录
- **Cursor**：可作为 `.cursor/rules/` 引用 / 或单独的 docs/skills/ 文件夹
- **OpenCode / 其它**：参考各工具文档

---

## 常见问题

**Q1: 用户的好范例很长（几千字），SKILL.md 是否要嵌进去？**
A: 不要。SKILL.md 只放 H1 标题 + Overview + Workflow。好范例放 `examples/good-1.md`，SKILL.md 用一句"参见 examples/good-1.md"指向。Progressive Disclosure 原则。

**Q2: description 字段超过 1024 字符怎么办？**
A: 砍触发词列表的重复项；保留最具代表性的 3 条用户原话。如还超，把"This includes"列表压缩到 3 项。

**Q3: 用户在 B5 给了 10+ 条行内规矩，全塞 SKILL.md 会超 500 行吗？**
A: 把 ≤ 5 条最关键的留 SKILL.md 主体，其余拆 `references/anti-patterns.md`，SKILL.md 里加一行"完整反模式见 references/anti-patterns.md"。

**Q4: Mode B 完成后用户要不要再走 Mode A？**
A: 看情况——如果用户原本是 C（先 A 后 B）的路径已走过 Mode A，不需要重走。如果只走了 Mode B，建议提议跑一次 Mode A 形成全局 principles，让这个 skill 与"整体 AI 协作风格"对齐。
