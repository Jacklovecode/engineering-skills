#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-"$HOME/.engineering-skills"}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "# Engineering Skills 安装"
echo
echo "源目录: $ROOT"
echo "目标目录: $TARGET"
echo

mkdir -p "$TARGET"

items=(
  "skills"
  "hooks"
  ".codex-plugin"
  ".claude-plugin"
  "AGENTS.md"
  "CLAUDE.md"
  "GEMINI.md"
  "gemini-extension.json"
  "INSTALL.md"
  "USAGE.md"
  "README.md"
  "README_EN.md"
  "LICENSE"
)

for item in "${items[@]}"; do
  source="$ROOT/$item"
  [[ -e "$source" ]] || continue
  rm -rf "$TARGET/$item"
  cp -R "$source" "$TARGET/$item"
done

echo "安装完成。"
echo
echo "建议入口："
echo "- 通用智能体: $TARGET/AGENTS.md"
echo "- Codex: $TARGET/.codex-plugin/plugin.json"
echo "- Claude: $TARGET/CLAUDE.md"
echo "- Gemini: $TARGET/GEMINI.md"
echo
echo "安装脚本不会执行 git 操作。"
