#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

echo "# Git 上传前检查"
echo
echo "## 当前分支"
git branch --show-current || true
echo
echo "## Remote"
git remote -v || true
echo
echo "## 分支跟踪"
git branch -vv || true
echo
echo "## 工作区状态"
git status --short --ignored || true
echo
echo "## 已修改文件"
git diff --name-only || true
echo
echo "## 暂存文件"
git diff --cached --name-only || true
echo
echo "## 未跟踪但未忽略文件"
git ls-files --others --exclude-standard || true
echo
echo "## 本地报告跟踪检查"
if git ls-files | grep '^\.local/' >/dev/null; then
  echo "发现已跟踪本地报告文件："
  git ls-files | grep '^\.local/'
else
  echo "未发现已跟踪本地报告文件"
fi
echo
echo "## 提醒"
echo "本脚本只读取仓库状态，不会暂存、提交或推送。"
echo "提交或推送前仍必须列出应上传、不应上传、需要用户确认的文件，并等待用户确认。"
