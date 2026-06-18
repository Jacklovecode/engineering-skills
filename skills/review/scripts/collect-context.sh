#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

echo "# Review 上下文收集"
echo
echo "## Git 状态"
git status --short --ignored || true
echo
echo "## 当前分支"
git branch --show-current || true
echo
echo "## 最近提交"
git log --oneline --decorate -n 5 || true
echo
echo "## 已修改文件"
git diff --name-only || true
echo
echo "## 暂存文件"
git diff --cached --name-only || true
echo
echo "## 可能的规范来源"
for file in AGENTS.md CLAUDE.md GEMINI.md CONTRIBUTING.md README.md; do
  [[ -f "$file" ]] && echo "- $file"
done
echo
echo "## 提醒"
echo "本脚本只收集审查上下文，不判断需求是否满足，也不替代人工/智能体审查。"
