# Easy Build Skills

> **Let AI research you back — answer ~15 multiple-choice questions to get YOUR AI config, instead of copy-pasting someone else's template.**

[中文](./README.zh-CN.md) · **English**

[![License](https://img.shields.io/badge/License-MIT%20with%20Attribution-blue.svg)](./LICENSE)
[![Author](https://img.shields.io/badge/Author-FantasyMax-purple.svg)](./AUTHORS.md)
[![Status](https://img.shields.io/badge/Status-V1.0--public-success.svg)](#)

---

## 🎯 Do these problems sound familiar?

```
😩 "I copied someone's CLAUDE.md but AI output still feels like theirs, not mine"
😩 "Every new chat I have to re-explain my preferences, rules, taboos"
😩 "I know I have specific needs, but I can't articulate what they are"
😩 "I have a specialty work (writing/PR review/client reports) but AI never nails it"
😩 "I read 10 'how to write AI principles' guides — every one says different things"
```

If **any 2 ring true**, this skill is for you.

---

## 💡 What this gives you

After answering ~15 **multiple-choice questions** (not open-ended), you get one or both:

### Mode A — An "AI collaboration principles" doc

Make the AI tools you use daily (Claude Code / Cursor / Codex / OpenCode etc.) actually "get you":

```
✓ Collaborate like your senior colleague (not generic assistant)
✓ Knows your taboos, jargon, fixed templates (verbatim preserved)
✓ Knows your red lines (when AI auto-pauses to ask)
✓ Knows your work rhythm (emotional triggers, autonomy levels)
```

**Define once, applies everywhere**: auto-exports 1–3 platform templates matched to your tool stack (CLAUDE.md / AGENTS.md / .cursorrules / system-prompt.md).

### Mode B — A "custom skill of your own"

Extract one of your **repetitive specialty tasks** into an AI-executable skill / plugin:

```
Xiaoma (content creator)  →  Editing skill (preserves her "anti-AI-tone" voice)
Alex (indie developer)    →  PR review skill (with verified patches + no sensitive dirs)
Lin (financial advisor)   →  Excel→report skill (4-paragraph format + regulation-ASK)
```

AI auto-selects 1 of 5 shapes (from simplest "atomic skill" to most complex "composite plugin"). **You don't need to understand technical details.**

---

## 🆚 Different from "writing your own CLAUDE.md"?

| DIY | Easy Build Skills |
|---|---|
| Stare at a blank doc | ~15 **multiple-choice questions** to let AI infer what you need |
| Copy from others → output sounds like others | Your original words **preserved verbatim** — output truly sounds like you |
| Assume you know what you want | **No assumption** — uses behavioral probing to surface preferences you didn't realize |
| One template fits all | AI picks shape based on your tool stack / collaboration depth / task complexity |
| Believes whatever you say | Built-in **bias detection** — when you say "I should X" AI asks "what did you actually do?" |
| Throws result at you to test | AI **proactively** runs 5-step self-validation + suggests optimizations (V1.0 new) |
| Mixed CN/EN skeleton or hardcoded language | Asks output language at startup — Chinese / English / Bilingual / Other |

---

## 📸 What it looks like in action

> Below are 4 **illustrative SVGs** (AI-generated, simulating Claude Code's real UI). **Real screenshots** see [`docs/img/`](./docs/img/) (V1 uses illustrations, real screenshot contributions welcome).

### 1️⃣ Mode selection at startup (uses Claude's native option tabs, no typing)

![Step 1 — Mode selection demo](./docs/img/demo-1-mode-selection-en.svg)

```
┌─ What do you want? ────────────────────┐
│                                         │
│  ① Define "my AI principles"            │
│     Cross-task collaboration style      │
│                                         │
│  ② Build a "custom skill"               │
│     Extract one repetitive task into AI │
│                                         │
│  ③ Both (recommended)                   │
│     ① first, then ②                     │
│                                         │
└─────────────────────────────────────────┘
```

### 2️⃣ Each question = 3 strong-related + 2 creative-divergent + free-input

![A2 — 3+2+1 option pattern demo](./docs/img/demo-2-option-pattern-en.svg)

```
┌─ Who should the AI be like? ──────────┐
│                                        │
│  ① Senior colleague (pushes back)     │
│  ② Personal assistant (won't overstep)│
│  ③ Coach (drives you forward)         │
│  ④ Like my cat (called when needed)  ←creative│
│  ⑤ Other (you say)                    │
│                                        │
└────────────────────────────────────────┘
```

### 3️⃣ AI reverse-engineers a proposal (you don't judge tech details)

![Step 5.5 — 6-segment proposal + 5-option feedback demo](./docs/img/demo-3-feedback-loop-en.svg)

```
🔍 Based on your answers, here's what I'm building:

【A complete intelligent toolkit】

✓ What AI auto-does...
✗ What AI never does (your red lines)...
⚙ Mechanical checkpoints (program-judged, not model-guessed)...
⏸ When AI pauses to ask you...
📁 File listing you'll receive...

──
What do you think?
[① Good]  [② Missing]  [③ Too complex]  [④ Too simple]  [⑤ I'll say]
```

### 4️⃣ AI auto-runs 5-step self-validation, proactively reports issues

![Step 7.5 — AI self-validation report demo](./docs/img/demo-4-self-validation-en.svg)

```
✅ Schema check (frontmatter / line count / required sections)
✅ Trigger test (5 should-trigger + 5 should-not-trigger fake questions)
✅ Dogfood simulation (run similar task, compare against your good-1.md)
✅ Coverage check (your red lines / jargon / templates all captured?)
✅ Proactive report

🔴 Critical 1 / 🟡 Medium 2 / 🟢 Minor 0
[① Accept all] [② Partial] [③ Reject] [④ I'll fix] [⑤ Detailed reasoning]
```

→ Full 8-Phase test guide: [`INSTALL_TEST.md`](./INSTALL_TEST.md)

---

## 👥 Who is this for?

### ✅ Good fit

```
• Content creators / writers / video creators
  Make "anti-AI-tone" writing preferences explicit, AI editing keeps your voice

• Indie developers / Indie Hackers
  Auto-write project commit conventions / red lines / workflows into AI config

• Solo founders / consultants / freelancers
  Extract client-delivery's implicit rules (jargon / templates / taboos) into AI workflows

• Any "AI output sounds like someone else" beginner
  This is what you need
```

### ❌ Not a fit

```
• Want to do "user research about your customers"
  → This is a "user researches themselves" tool, not "research your clients"
  → For client research use dovetail / Notably or similar professional tools

• Already know you want atomic / orchestration / hooks specific shapes
  → Our inference engine is redundant; just write SKILL.md directly
  → But you can use our methodology as reference (see below)

• Want a "universal generic AI principles"
  → We do the opposite: each person's output is unique
```

---

## 📊 How much can we cover? (Honest)

| Scenario | Coverage | Notes |
|---|---|---|
| Solo beginner doing principles | **~90%** | Primary use case, validated by 3-role dogfood |
| Solo extracting recurring task into skill | **~80%** | 5 shapes cover most common needs |
| Complex multi-person team principles | **~50%** | Not the design goal; can serve as starting point but needs extension |
| Enterprise / multi-role RBAC skills | **~30%** | Beyond scope; recommend building your own |
| Real-time data streams / large-scale distributed | **0%** | Completely out of scope |

**Honest limitations**:
- **Currently only Express version** is fully supported (10–15 min run); Standard (30–45 min) and Deep version (7–10 days lean iteration) methodologies exist but MVP doesn't implement them
- AskUserQuestion needs **MCP server installation** for Cursor / Windsurf / Cline etc. — without it, falls back to typing mode
- Auto-exports 5 platform templates, but **project-level install path still requires manual cp** (not one-click install)

---

## 🎓 How different users should use this

### Beginner / target audience

Simplest path:

```bash
# 1. clone
git clone https://github.com/Fantasymax/easy-build-skills.git
cd easy-build-skills

# 2. Install to Claude Code (recommended)
cp -r plugin/user-research-for-ai-config ~/.claude/plugins/

# 3. In Claude Code, say one trigger phrase:
# "I want to define AI principles for myself" or
# "Help me extract weekly report writing into a skill"

# 4. Follow AI's option tabs through ~15 questions, ~15 min total
```

**Issues**: Run [`INSTALL_TEST.md`](./INSTALL_TEST.md) 8-Phase verification.

### Advanced AI users / professional AI engineers

If you already understand atomic / orchestration / hooks / MCP concepts, 2 ways to use:

**Way A: Use as methodology reference**

Read 4 core rule documents directly:
- [`frameworks/interview-basics.md`](./skill/user-research-for-ai-config/frameworks/interview-basics.md) — B1–B10 interview fundamentals (behavioral probing / bias detection / option pattern)
- [`frameworks/intent-inference.md`](./skill/user-research-for-ai-config/frameworks/intent-inference.md) — Shape inference engine (core innovation)
- [`frameworks/lint-rules.md`](./skill/user-research-for-ai-config/frameworks/lint-rules.md) — Three-layer quality check
- [`frameworks/self-validation.md`](./skill/user-research-for-ai-config/frameworks/self-validation.md) — AI proactive 5-step self-validation pipeline

Apply these methodologies to your **own** skill design.

**Way B: Run the flow and use ⑤ self-input escape hatch**

Any feedback loop accepts `⑤ I'll say: [terminology]` to override AI's inference. For example:

```
AI recommends atomic skill.
You say: "Not atomic, give me orchestration + 3 sub-skills"
→ AI skips inference, produces what you said.
```

Power user only — see SKILL.md §Step 5.5.

---

## 🚀 Quick Start (one-paragraph version)

```bash
# Claude Code (recommended Plugin install)
git clone https://github.com/Fantasymax/easy-build-skills.git
cp -r easy-build-skills/plugin/user-research-for-ai-config ~/.claude/plugins/

# Then in Claude Code, say: "I want to define AI principles for myself"
```

Other tools: see [`INSTALL_TEST.md`](./INSTALL_TEST.md) Phase 1.

---

## 📚 More info

| What you want | Go here |
|---|---|
| **Full 8-Phase test guide** | [`INSTALL_TEST.md`](./INSTALL_TEST.md) |
| **5 output shapes detail** | [`skill/.../templates/mode-b/`](./skill/user-research-for-ai-config/templates/mode-b/) |
| **Cross-platform 11-tool mapping** | [`skill/.../references/cross-platform-tool-mapping.md`](./skill/user-research-for-ai-config/references/cross-platform-tool-mapping.md) |

---

## 🤝 Contributing / Feedback

Issues / PRs welcome. But please respect the [LICENSE](./LICENSE) attribution requirement — **when forking, you MUST credit FantasyMax in your README**.

If you complete a run and feel "this really sounds like me", we welcome:
- ⭐ Star the repo
- 💬 Share your output in Issues (anonymized)
- 📢 Mention us in your channels (blog / Twitter / Substack) + link back

---

## 📄 License

[MIT with Attribution Requirement](./LICENSE) © 2026 **FantasyMax**

Contact: **HiFantasyMax**
