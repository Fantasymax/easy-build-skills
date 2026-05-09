---
name: {kebab-hook-skill-name}
description: {B1 一句话定义动词} {B1 对象}, with deterministic enforcement on {B13 触发事件，如 git push / file save / session start}. Use when {B7 ① 触发原话；如自然语言也支持触发}. The hook ensures {B13 + B5 转化的硬拦截规则}, even if Claude Code's model-side reasoning forgets. Do NOT use for: {B7 ③ 反例}.
hooks:
  {EventName}:
    - matcher: "{tool / 资源 matcher}"
      hooks:
        - type: command
          command: "${CLAUDE_SKILL_DIR}/hooks/{hook-script-name}.sh"
          timeout: 30
---

# {Skill 标题}

> 这是 {用户名} 的 {B1 一句话定义} skill — **hook 驱动**版。
> 即使 Claude 模型层面忘了规则，hook 层面也会硬拦截。
> 生成日期 {YYYY-MM-DD} | V1

## Overview

{B1 一句话定义原话}

**这个 skill 的两层防御**：
1. **软层（Skill description）**：用户主动 `/` 触发或自然语言触发；Claude 用 SKILL.md 内容指导任务
2. **硬层（Hook）**：Claude Code runtime 在 `{EventName}` 事件触发时执行 hook 脚本，做**确定性**检查 / 拦截

## When the skill triggers (软层)

- 用户敲 `/{kebab-hook-skill-name}`
- 用户自然语言说 {B7 ① 触发原话}

**不该触发**：
- {B7 ③ 反例}

## When the hook fires (硬层)

每次发生 `{EventName}` 事件 + matcher `{matcher pattern}` 命中时。

例（matcher = `Bash(git push *)`）：
- 用户在主对话敲 `git push origin main` → hook 触发
- 用户敲 `git status` → matcher 不命中，hook 不触发

## Workflow（合二为一）

```
[场景 A：用户主动触发]
1. 用户敲 /{name} 或说 {B7 ① 触发原话}
2. SKILL.md 加载到 context
3. Claude 按 SKILL.md 指令做任务
4. （任务里如果触及 hook 监控的事件，hook 也会触发，做硬层校验）

[场景 B：用户没主动触发，只是做了别的事]
1. 用户做某个动作（如 git push / 编辑 .md / 启动会话）
2. 该动作触发 {EventName} matcher 命中
3. hook 脚本跑：
   ├─ pass：返回 allow，不打扰用户
   └─ fail：返回 ask 或 deny，弹权限对话 / 拦截
4. 用户决定后继续
```

## Hard Rules（软层 — Skill 描述）

> 这些是 Claude 在跑这个 skill 时必须遵守的指令

- MUST {B5 行内规矩 1，软层}
- MUST {B5 行内规矩 2}
- NEVER {B6 ③ 禁词 / 禁句}
- NEVER 在 hook 已经拒绝的情况下自动重试相同动作（避免与 hook 对抗）
- ALWAYS 在出现 hook ask 弹窗时**等用户决策**，不要替用户拍板

## Hook Rules（硬层 — Hook 脚本）

> 这些规则在 `hooks/{hook-script-name}.sh` 里实现，**确定性触发**

- 检查 1：{B13 + B5 转化的硬规则 1，如 "git diff 涉及 migrations/ api/ stripe/ → ask"}
- 检查 2：{硬规则 2}

⚠ **Hook 规则的特点**：
- 不依赖 Claude 模型决策（不会漏）
- 实现是 shell / Python，需要确定性逻辑
- 失败时返回 stderr + exit code 2 阻断

## Reference files

- `hooks-config-snippet.json` — 用户拷贝合并到 `.claude/settings.json`（如果选不写在 skill frontmatter 而写在 settings 里）
- `hooks/{hook-script-name}.sh.example` — hook 脚本示例
- `examples/full-trigger-walkthrough.md` — 完整触发链实例
- `references/hook-events-reference.md` — 关键 hook event 速查

## Self-check before delivery（合软硬两层）

完成前自查：
- [ ] 软层：SKILL.md 输出符合 {B9 第 1 条原话}
- [ ] 软层：用没用 {B6 ③ 禁词}
- [ ] **硬层：hook 是否注册成功**（用 `/hooks` 命令检查）
- [ ] **硬层：hook 触发测试**（敲一条会命中 matcher 的命令，看 hook 是否如期返回）

## Notes for the user

⚠ **部署 hook 后必须验证**：

```bash
# 1. 看 hook 是否注册
/hooks
# 期待：能看到 {EventName} → {matcher} 这一项

# 2. 触发一次测试（如 matcher 是 Bash(git push *)）
# 在 Claude Code 里跑：bash "echo 'test' && git push --dry-run origin main"
# 期待：hook 脚本被调用，stderr 看到日志

# 3. 看 hook 决策是否符合预期
# 如果 hook 返回 ask，期待 Claude Code 弹权限对话框
```

## Notes from author

{B10 ① 收尾原话；如有用户重要补充}
