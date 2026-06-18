#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
用法: ./hitl-loop.sh [--output <path>] [--help]
作用: 结构化记录必须人工参与的复现步骤、输入和观察结果。
USAGE
}

OUTPUT_PATH=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --output)
      OUTPUT_PATH="$2"
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

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

read_text() {
  prompt="$1"
  default="$2"
  printf '%s: ' "$prompt"
  IFS= read -r value || value=""
  if [ -z "$value" ] && [ -n "$default" ]; then
    printf '%s\n' "$default"
  else
    printf '%s\n' "$value"
  fi
}

read_block() {
  prompt="$1"
  printf '%s\n' "$prompt" >&2
  printf '%s\n' "输入空行结束。" >&2
  block=""
  while true; do
    printf '> ' >&2
    IFS= read -r line || break
    [ -z "$line" ] && break
    if [ -z "$block" ]; then
      block="$line"
    else
      block="${block}
${line}"
    fi
  done
  if [ -z "$block" ]; then
    printf '%s\n' "未记录"
  else
    printf '%s\n' "$block"
  fi
}

if [ -z "$OUTPUT_PATH" ]; then
  mkdir -p "$ROOT/.local/diagnose"
  OUTPUT_PATH="$ROOT/.local/diagnose/hitl-$(date +%Y%m%d-%H%M%S).md"
fi

TITLE="$(read_text "问题标题" "未命名问题")"
ENVIRONMENT="$(read_block "记录复现环境，例如系统、浏览器、账号、分支、配置")"
PRECONDITION="$(read_block "记录前置条件")"
STEPS="$(read_block "逐行记录人工操作步骤")"
EXPECTED="$(read_block "记录预期结果")"
ACTUAL="$(read_block "记录实际结果、错误信息或异常现象")"
ARTIFACTS="$(read_block "记录截图、日志、HAR、录屏或其他证据位置")"

cat > "$OUTPUT_PATH" <<EOF
# HITL 复现记录

## 问题标题
$TITLE

## 记录时间
$(date '+%Y-%m-%d %H:%M:%S %z')

## 复现环境
$ENVIRONMENT

## 前置条件
$PRECONDITION

## 人工操作步骤
$STEPS

## 预期结果
$EXPECTED

## 实际结果
$ACTUAL

## 证据位置
$ARTIFACTS

## 下一步
- 将本记录转化为可重复的反馈循环。
- 如果仍需要人工参与，继续缩小步骤并保留关键观察点。
EOF

printf '%s\n' "HITL 复现记录已写入: $OUTPUT_PATH"
