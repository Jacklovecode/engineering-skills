#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PLUGIN_ROOT=$(dirname "$SCRIPT_DIR")
SKILL_PATH="$PLUGIN_ROOT/skills/start/SKILL.md"

CONTENT=$(cat "$SKILL_PATH")

python_cmd=""
if command -v python3 >/dev/null 2>&1; then
  python_cmd="python3"
elif command -v python >/dev/null 2>&1; then
  python_cmd="python"
fi

if [ -n "$python_cmd" ]; then
  ENGINEERING_SKILLS_START="$CONTENT" "$python_cmd" - <<'PY'
import json
import os

content = os.environ["ENGINEERING_SKILLS_START"]
context = f"""<ENGINEERING_SKILLS>
You have Engineering Skills.

Below is the routing entry skill. Use it in guided mode: if a task clearly matches another skill, activate that skill before taking action. If the match is uncertain, proceed normally for low-risk tasks.

{content}
</ENGINEERING_SKILLS>
"""

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": context,
    }
}))
PY
  exit 0
fi

{
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":'
  printf '%s' "<ENGINEERING_SKILLS>
You have Engineering Skills.

Below is the routing entry skill. Use it in guided mode. Read skills/start/SKILL.md first.

$CONTENT
</ENGINEERING_SKILLS>" | awk '
    BEGIN { printf "\"" }
    {
      gsub(/\\/, "\\\\")
      gsub(/"/, "\\\"")
      printf "%s\\n", $0
    }
    END { printf "\"" }
  '
  printf '}}\n'
}
