# .cursorrules 导出模板（Cursor IDE 风格）

> **风格特点**：每条规则一句话祈使式 / 单文件 ≤ 500 行 / 不要塞 persona（Cursor 自带）/ 多个 .mdc 文件用 globs 匹配范围
>
> **填法**：把 `output-three-layer.md` Layer 3 拆成多条短规则，每条独立一行
>
> **存放位置**：项目根 `.cursorrules` 单文件，或 `.cursor/rules/*.mdc` 多文件结构

---

## 单文件版（推荐起步用）

存为项目根 `.cursorrules`：

```
# {用户名} 的项目协作规则

## 任务边界 (Decision Boundary)

# 直接做（无需确认）
- {A7 Do 第 1 条}
- {A7 Do 第 2 条}
- {A7 Do 第 3 条}

# 先问我（必须先 confirm）
- {A7 Ask 第 1 条}
- {A7 Ask 第 2 条}

# 绝不许做（直接拒绝）
- {A7 Don't 第 1 条}
- {A7 Don't 第 2 条}
- {A7 Don't 第 3 条}

## 硬规则 (Hard Rules)

- MUST 用术语原文：{A3 ① 3 个术语}，不解释、不替换
- MUST 在 {A5 岔口} 处停下来等用户确认
- NEVER {A8 红线 1}
- NEVER {A8 红线 2}
- NEVER 用 {A3 ② 不信任话术} 风格
- ALWAYS 长输出顶部放 {A6 ① 偏好}
- ALWAYS 拿不准时 {A9 选项}

## 输出风格

- 顶部：{A6 ①}
- 删除：{A6 ② 反向偏好}
- 长度：与 "{A2 角色比喻}" 风格匹配

## 上下文

- 用户：{C1 原话}
- 主要任务：{C2 任务清单一句话}
- 工具栈：{C3 关键工具列表}
- 失败案例参考：见 docs/CLAUDE.md 或 AGENTS.md 的 Examples 段

## 拒绝时的话术

如果用户请求触发 Don't 规则：
"{用户给的拒绝原话风格 / 或 AI 起草后用户审核}"

## 冲突仲裁

如规则冲突，优先级：Don't > Hard Rules > Ask > Workflow > Output preferences
```

---

## 多文件版（推荐成熟项目用）

随项目复杂度增长，把单文件拆成 `.cursor/rules/` 下多个 `.mdc` 文件，每个用 globs 限定生效范围：

```
.cursor/rules/
├── 00-global.mdc            # 全局：persona modifier、tone、Don't 栏
├── 10-frontend.mdc          # globs: src/components/**, *.tsx
├── 20-backend.mdc           # globs: src/server/**, *.ts
├── 30-tests.mdc             # globs: **/*.test.*, **/*.spec.*
└── 40-docs.mdc              # globs: docs/**, *.md
```

每个 `.mdc` 文件头部声明 globs（YAML frontmatter）：

```markdown
---
description: Frontend coding rules for this project
globs:
  - "src/components/**"
  - "*.tsx"
  - "*.jsx"
---

# Frontend rules

- ALWAYS 用 TypeScript strict mode
- NEVER 引入未在 package.json 里的依赖
- ...
```

---

## Cursor 特定的 Tips

1. **不要塞 persona** —— Cursor 自带"代码助手"人设，重复定义只会冲突。`.cursorrules` 只补**项目特定**约束。
2. **每条规则尽量一句话** —— Cursor 引擎在每个补全请求时会把 rules 全文塞 prompt，越短越省 context。
3. **避免大段 examples** —— Cursor 不擅长处理长 example，例子放在被引用的代码文件里、用 `@file` 引用。
4. **MUST/NEVER/ALWAYS 大写** —— Cursor 对大写信号词响应明显更准。
5. **`.cursorignore`** 配合用 —— 让 Cursor 不把某些目录纳入 context，对应"AI 应该看不到的"内容（A8 红线里的隐私文件）。

---

## 使用说明

1. 单文件起步：把上面 ``` 块拷贝到项目根 `.cursorrules`
2. 替换 `{...}` 占位符
3. 在 Cursor 里重启或 `Cmd+Shift+P` → "Reload Window"
4. 项目复杂后再拆成多文件
