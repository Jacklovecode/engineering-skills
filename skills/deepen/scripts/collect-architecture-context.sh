#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
用法: ./collect-architecture-context.sh [--path <project-root>] [--help]
作用: 只读收集架构深化需要的领域文档、ADR、入口文件、测试和 Git 差异。
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

printf '%s\n' "# Deepen 架构语境收集"

section "项目根目录"
printf '%s\n' "$ROOT"

section "Git 状态"
run_or_empty git status --short --ignored

section "当前分支"
run_or_empty git branch --show-current

section "差异文件"
run_or_empty git diff --name-only

section "领域文档"
found_domain=0
for file in CONTEXT.md CONTEXT-MAP.md README.md AGENTS.md CLAUDE.md GEMINI.md; do
  if [ -f "$file" ]; then
    printf -- '- %s\n' "$file"
    found_domain=1
  fi
done
[ "$found_domain" -eq 1 ] || printf '%s\n' "未发现常见领域文档"

section "ADR 候选"
found_adr=0
for dir in docs/adr doc/adr adr architecture/adr; do
  if [ -d "$dir" ]; then
    find "$dir" -type f | sort | head -n 30 | while IFS= read -r file; do
      printf -- '- %s\n' "$file"
    done
    found_adr=1
  fi
done
[ "$found_adr" -eq 1 ] || printf '%s\n' "未发现 ADR 目录"

section "入口与配置候选"
found_entry=0
for file in package.json pyproject.toml go.mod Cargo.toml pom.xml build.gradle requirements.txt Makefile justfile; do
  if [ -f "$file" ]; then
    printf -- '- %s\n' "$file"
    found_entry=1
  fi
done
[ "$found_entry" -eq 1 ] || printf '%s\n' "未发现常见入口或配置文件"

section "测试目录候选"
found_tests=0
for dir in test tests __tests__ spec e2e; do
  if [ -d "$dir" ]; then
    printf -- '- %s\n' "$dir"
    found_tests=1
  fi
done
[ "$found_tests" -eq 1 ] || printf '%s\n' "未发现常见测试目录"

section "提醒"
printf '%s\n' "本脚本只收集语境，不直接给出架构结论。使用 deepen 时仍必须判断真实摩擦、接口收益、改动集中度和测试收益。"
