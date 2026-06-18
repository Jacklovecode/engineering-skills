#!/usr/bin/env sh
set -eu

if [ "${1:-}" = "--help" ] || [ "$#" -eq 0 ]; then
  printf '%s\n' "用法: ./guard.sh '<git command>'"
  printf '%s\n' "作用: 检查 git 命令是否包含危险操作。只检查，不执行命令。"
  exit 0
fi

COMMAND="$*"

dangerous='git[[:space:]]+reset[[:space:]]+--hard
git[[:space:]]+clean[[:space:]]+-[^[:space:]]*f
git[[:space:]]+push.*--force
git[[:space:]]+push.*(^|[[:space:]])-f($|[[:space:]])
git[[:space:]]+branch[[:space:]]+-D
git[[:space:]]+tag[[:space:]]+-d
git[[:space:]]+stash[[:space:]]+drop
git[[:space:]]+stash[[:space:]]+clear
git[[:space:]]+worktree[[:space:]]+remove
git[[:space:]]+checkout[[:space:]]+--[[:space:]]+\.
git[[:space:]]+restore[[:space:]]+--source
git[[:space:]]+restore[[:space:]]+\.'

printf '%s\n' "$dangerous" | while IFS= read -r pattern; do
  [ -z "$pattern" ] && continue
  if printf '%s\n' "$COMMAND" | grep -Eq "$pattern"; then
    printf '%s\n' "危险 git 命令已拦截：'$COMMAND' 匹配 '$pattern'。请先列出影响范围并获得用户明确确认。" >&2
    exit 2
  fi
done

printf '%s\n' "未发现已知危险 git 操作：$COMMAND"
