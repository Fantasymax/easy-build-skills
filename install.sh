#!/usr/bin/env bash
# easy-build-skills — one-line installer (Linux / macOS / Git Bash / WSL)
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Fantasymax/easy-build-skills/main/install.sh | bash

set -e

REPO_URL="https://github.com/Fantasymax/easy-build-skills.git"
SKILL_NAME="user-research-for-ai-config"
SKILLS_DIR="${HOME}/.claude/skills"
TMP_DIR="$(mktemp -d -t easy-build-skills-XXXXXX)"

cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

echo ""
echo "📥 Cloning easy-build-skills..."
git clone --depth=1 --quiet "${REPO_URL}" "${TMP_DIR}/repo"

echo "📂 Installing skill to ${SKILLS_DIR}/${SKILL_NAME}/"
mkdir -p "${SKILLS_DIR}"

# Remove existing install to avoid stale files
if [ -d "${SKILLS_DIR}/${SKILL_NAME}" ]; then
  echo "  (removing existing install)"
  rm -rf "${SKILLS_DIR}/${SKILL_NAME}"
fi

cp -r "${TMP_DIR}/repo/skill/${SKILL_NAME}" "${SKILLS_DIR}/"

echo ""
echo "✅ Installed."
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code (Cmd/Ctrl+Shift+P → Reload Window)"
echo "  2. Say to Claude one of:"
echo "     - \"I want to define AI principles for myself\" (Mode A — principles doc)"
echo "     - \"Help me design a custom skill from scratch\" (Mode B — design new skill)"
echo "     - \"Help me extract weekly-report writing into a skill\" (Mode B — extract existing task)"
echo "     - 中文: \"我想给自己定义 AI principles\" / \"帮我设计一个 skill\" / \"把我会的 X 抽成一个 skill\""
echo ""
echo "Optional — for auto-updates, run inside Claude Code:"
echo "  /plugin marketplace add Fantasymax/easy-build-skills"
echo "  /plugin install user-research-for-ai-config@easy-build-skills"
echo ""
echo "To uninstall: rm -rf ${SKILLS_DIR}/${SKILL_NAME}"
echo ""
