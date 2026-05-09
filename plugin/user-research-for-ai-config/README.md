# user-research-for-ai-config (Plugin)

> Plugin packaging of `easy-build-skills` — install once, use across Claude Code projects.

## Install

```bash
# Copy this entire directory into your Claude plugins folder
cp -r user-research-for-ai-config ~/.claude/plugins/

# Or for project-level install
cp -r user-research-for-ai-config <your-project>/.claude/plugins/
```

Then restart Claude Code. The skill will auto-load and trigger on phrases like:

- "我想给自己定义 AI principles"
- "I want to build my own CLAUDE.md"
- "帮我把每周写日报抽成一个 skill"

## What's inside

```
user-research-for-ai-config/
├── .claude-plugin/
│   └── plugin.json       ← plugin metadata
└── skills/
    └── user-research-for-ai-config/
        ├── SKILL.md       ← main entry
        ├── question-bank/ ← ~15 questions
        ├── frameworks/    ← 9 core rules
        ├── references/    ← cross-platform tool mapping
        └── templates/     ← Mode A / Mode B output templates
```

## Documentation

Full docs: see project root [`README.md`](../../README.md) (English) or [`README.zh-CN.md`](../../README.zh-CN.md) (中文).

## License

[MIT with Attribution Requirement](../../LICENSE) © 2026 **FantasyMax**
