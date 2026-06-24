#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
用法: ./collect-project-context.sh [--path <project-root>] [--help]
作用: 只读收集 setup 需要的协作入口、领域文档、ADR、issue tracker、验证命令和忽略规则。
USAGE
}

ROOT="."
while [ "$#" -gt 0 ]; do
  case "$1" in
    --path)
      ROOT="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "未知参数: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

ROOT="$(cd "$ROOT" && pwd)"
cd "$ROOT"

section() {
  printf '\n## %s\n' "$1"
}

run_or_empty() {
  if output="$("$@" 2>/dev/null)" && [ -n "$output" ]; then
    printf '%s\n' "$output"
  else
    printf '%s\n' "无"
  fi
}

existing_paths() {
  fallback="$1"
  shift
  found=0
  for item in "$@"; do
    if [ -e "$item" ]; then
      printf -- '- %s\n' "$item"
      found=1
    fi
  done
  [ "$found" -eq 1 ] || printf '%s\n' "$fallback"
}

printf '%s\n' "# Setup 项目约定收集"

section "项目根目录"
printf '%s\n' "$ROOT"

section "Git 状态"
run_or_empty git status --short --ignored

section "协作入口"
existing_paths "未发现常见智能体入口" AGENTS.md CLAUDE.md GEMINI.md .codex-plugin/plugin.json .claude-plugin/plugin.json gemini-extension.json

section "领域文档"
existing_paths "未发现常见领域文档" CONTEXT.md CONTEXT-MAP.md README.md README_EN.md

section "ADR 或决策记录"
existing_paths "未发现 ADR 或决策记录目录" docs/adr docs/decisions adr architecture/adr

section "Issue / PR 约定"
existing_paths "未发现 issue 或 PR 模板" .github/ISSUE_TEMPLATE .github/PULL_REQUEST_TEMPLATE.md docs/issues issues

section "验证命令候选"
existing_paths "未发现常见验证入口" scripts/validate.ps1 scripts/validate.sh scripts/simulate-pressure.ps1 scripts/simulate-pressure.sh package.json pyproject.toml Makefile justfile

section "忽略规则"
existing_paths "未发现 .gitignore 或 .gitattributes" .gitignore .gitattributes

section "远程仓库"
run_or_empty git remote -v

section "提醒"
printf '%s\n' "本脚本只收集 setup 语境，不修改文件，不创建约定。使用 setup 时仍必须区分已发现事实、推荐默认值和需要用户确认的决策。"
