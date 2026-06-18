#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

echo "# Finish 证据收集"
echo
echo "## Git 状态"
git status --short --ignored || true
echo
echo "## 当前分支"
git branch --show-current || true
echo
echo "## Remote"
git remote -v || true
echo
echo "## 差异统计"
git diff --stat || true
echo
echo "## 暂存差异统计"
git diff --cached --stat || true
echo
echo "## 本地报告跟踪检查"
if git ls-files | grep '^\.local/' >/dev/null; then
  echo "发现已跟踪本地报告文件："
  git ls-files | grep '^\.local/'
else
  echo "未发现已跟踪本地报告文件"
fi
echo
echo "## 推荐验证命令"
[[ -f scripts/validate.sh ]] && echo "- ./scripts/validate.sh"
[[ -f scripts/simulate-pressure.sh ]] && echo "- ./scripts/simulate-pressure.sh"
echo
echo "## 提醒"
echo "本脚本只收集完成前证据线索，不代表验证已经通过。必须实际运行验证命令并读取结果。"
