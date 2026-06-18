#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ERRORS_FILE=$(mktemp)
trap 'rm -f "$ERRORS_FILE"' EXIT

add_error() {
  printf '%s\n' "$1" >> "$ERRORS_FILE"
}

required_files='
README.md
INSTALL.md
USAGE.md
AGENTS.md
CLAUDE.md
GEMINI.md
LICENSE
README_EN.md
.codex-plugin/plugin.json
.claude-plugin/plugin.json
gemini-extension.json
hooks/hooks-codex.json
hooks/hooks-codex.windows.json
hooks/hooks-codex.unix.json
hooks/run-hook.cmd
hooks/run-hook.sh
hooks/session-start-codex.ps1
hooks/session-start-codex.sh
scripts/simulate-pressure.ps1
scripts/simulate-pressure.sh
scripts/validate.ps1
scripts/validate.sh
validation/pressure-scenarios.json
'

printf '%s\n' "$required_files" | while IFS= read -r file; do
  [ -z "$file" ] && continue
  [ -f "$ROOT/$file" ] || add_error "Missing required file: $file"
done

if [ ! -d "$ROOT/skills" ]; then
  add_error "Missing skills directory"
else
  skill_count=$(find "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
  [ "$skill_count" = "13" ] || add_error "Expected 13 skill directories, found $skill_count"

  find "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d | sort | while IFS= read -r dir; do
    skill_file="$dir/SKILL.md"
    dir_name=$(basename "$dir")
    if [ ! -f "$skill_file" ]; then
      add_error "Missing SKILL.md in $dir_name"
      continue
    fi

    name=$(sed -n 's/^name:[[:space:]]*\([A-Za-z0-9-][A-Za-z0-9-]*\)[[:space:]]*$/\1/p' "$skill_file" | head -n 1)
    description=$(sed -n 's/^description:[[:space:]]*//p' "$skill_file" | head -n 1)

    [ -n "$name" ] || add_error "Missing or invalid name in $dir_name/SKILL.md"
    [ "$name" = "$dir_name" ] || add_error "Skill name '$name' does not match directory '$dir_name'"
    [ -n "$description" ] || add_error "Missing description in $dir_name/SKILL.md"
    printf '%s' "$description" | grep -q '[一-龥]' || add_error "Description should be Chinese in $dir_name/SKILL.md"
  done
fi

json_files='
.codex-plugin/plugin.json
.claude-plugin/plugin.json
gemini-extension.json
validation/pressure-scenarios.json
hooks/hooks-codex.json
hooks/hooks-codex.windows.json
hooks/hooks-codex.unix.json
'

python_cmd=""
if command -v python3 >/dev/null 2>&1; then
  python_cmd="python3"
elif command -v python >/dev/null 2>&1; then
  python_cmd="python"
fi

if [ -n "$python_cmd" ]; then
  printf '%s\n' "$json_files" | while IFS= read -r file; do
    [ -z "$file" ] && continue
    [ -f "$ROOT/$file" ] || continue
    "$python_cmd" -m json.tool "$ROOT/$file" >/dev/null || add_error "Invalid JSON: $file"
  done

else
  add_error "Cannot validate JSON because python3/python is not available"
fi

scenario_checks='skills/start/SKILL.md|需求不清|start routes unclear requirements
skills/start/SKILL.md|不能覆盖这些质量门禁|start protects quality gates from skip requests
skills/clarify/SKILL.md|大型或战略变更|clarify handles large changes
skills/clarify/SKILL.md|必须让用户审阅后再进入 `plan`|clarify requires review before large plans
skills/clarify/SKILL.md|需求已清楚且只是小修改：进入 `tdd`|clarify routes small changes to tdd
skills/clarify/SKILL.md|进入 `grill`|clarify routes uncertain design to grill
skills/clarify/SKILL.md|进入 `plan`|clarify routes confirmed decisions to plan
skills/grill/SKILL.md|建议进入 `plan`|grill hands off to plan
skills/plan/SKILL.md|进入 `execute`|plan hands off to execute
skills/plan/SKILL.md|进入 `grill`|plan rejects unclear plans
skills/execute/SKILL.md|进入 `tdd`|execute invokes tdd
skills/execute/SKILL.md|进入 `review`|execute invokes review
skills/execute/SKILL.md|进入 `diagnose`|execute invokes diagnose on failure
skills/execute/SKILL.md|进入 `finish`|execute ends at finish
skills/execute/SKILL.md|先回到 `plan` 补齐|execute rejects incomplete plans
skills/tdd/SKILL.md|实现完成后进入 `review`|tdd hands off to review
skills/tdd/SKILL.md|不要让它决定测试写法|tdd prevents implementation-shaped tests
skills/tdd/SKILL.md|撤回或隔离先写的实现|tdd isolates code written before tests
skills/review/SKILL.md|下一步进入 `finish`|review hands off to finish when clear
skills/review/SKILL.md|进入 `diagnose`|review routes unexplained failures to diagnose
skills/review/SKILL.md|依据不足|review marks missing requirement source
skills/diagnose/SKILL.md|进入 `review`，再进入 `finish`|diagnose returns to review and finish
skills/diagnose/SKILL.md|进入 `deepen`|diagnose escalates architecture issues
skills/diagnose/SKILL.md|必须评估是否进入 `deepen`|diagnose requires deepen evaluation after repeated failed fixes
skills/finish/SKILL.md|进入 `diagnose`|finish routes failed verification to diagnose
skills/finish/SKILL.md|等待用户明确确认|finish requires confirmation before cleanup
skills/finish/SKILL.md|会删除的分支、提交、文件或 worktree|finish lists destructive cleanup targets
skills/git/SKILL.md|git rm --cached|git preserves local files while untracking
skills/git/SKILL.md|不要直接强推|git rejects unsafe force push
skills/git/SKILL.md|用户明确说某个目录不要上传|git honors excluded upload paths
skills/git/SKILL.md|获得用户最终确认|git requires final user confirmation before upload
skills/git/SKILL.md|应上传、不应上传、需要用户确认|git requires upload classification
skills/deepen/SKILL.md|暂不建议重构|deepen can decline unnecessary refactors
skills/skill-edit/SKILL.md|压力场景|skill-edit requires pressure scenarios
skills/skill-edit/SKILL.md|description` 只写触发条件|skill-edit enforces description trigger rule'

printf '%s\n' "$scenario_checks" | while IFS='|' read -r file pattern label; do
  [ -z "$file" ] && continue
  if [ ! -f "$ROOT/$file" ]; then
    add_error "Scenario check missing file: $file"
    continue
  fi
  grep -F -q "$pattern" "$ROOT/$file" || add_error "Scenario check failed: $label [$file]"
done

forbidden='deepthinkengine
deeptihinkengine
垂直切片
仪器化
Spec Review
Engineering Review
Critical
Major
Minor
Question
bugfix
flaky
query plan
profiler
红旗
拷问门禁
抽象上移门禁
不何时使用'

printf '%s\n' "$forbidden" | while IFS= read -r term; do
  [ -z "$term" ] && continue
  matches=$(find "$ROOT" -type f \( -name '*.md' -o -name '*.json' -o -name '*.ps1' -o -name '*.sh' -o -name '*.cmd' \) -print0 |
    xargs -0 grep -F -n "$term" 2>/dev/null |
    grep -v '/scripts/validate\.ps1:' |
    grep -v '/scripts/validate\.sh:' || true)
  if [ -n "$matches" ]; then
    add_error "Forbidden term '$term' found: $matches"
  fi
done

if [ -s "$ERRORS_FILE" ]; then
  sed 's/^/- /' "$ERRORS_FILE" >&2
  exit 1
fi

printf '%s\n' "engineering-skills validation passed"
