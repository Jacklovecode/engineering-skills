#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

python_cmd=""
if command -v python3 >/dev/null 2>&1; then
  python_cmd="python3"
elif command -v python >/dev/null 2>&1; then
  python_cmd="python"
fi

if [ -z "$python_cmd" ]; then
  printf '%s\n' "Cannot validate because python3/python is not available" >&2
  exit 1
fi

"$python_cmd" - "$ROOT" <<'PY'
import json
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
errors = []

def add_error(message):
    errors.append(message)

rules_path = root / "validation" / "rules.json"
if not rules_path.exists():
    print("- Missing validation rules: validation/rules.json", file=sys.stderr)
    sys.exit(1)

try:
    rules = json.loads(rules_path.read_text(encoding="utf-8"))
except Exception as exc:
    print(f"- Invalid JSON: validation/rules.json ({exc})", file=sys.stderr)
    sys.exit(1)

for relative in rules["required_files"]:
    if not (root / relative).is_file():
        add_error(f"Missing required file: {relative}")

skills_root = root / "skills"
if not skills_root.is_dir():
    add_error("Missing skills directory")
else:
    skill_dirs = sorted(path for path in skills_root.iterdir() if path.is_dir())
    expected_count = int(rules["skill_count"])
    if len(skill_dirs) != expected_count:
        add_error(f"Expected {expected_count} skill directories, found {len(skill_dirs)}")

    for directory in skill_dirs:
        skill_file = directory / "SKILL.md"
        if not skill_file.is_file():
            add_error(f"Missing SKILL.md in {directory.name}")
            continue

        text = skill_file.read_text(encoding="utf-8")
        name_match = re.search(r"^name:\s*([A-Za-z0-9-]+)\s*$", text, re.MULTILINE)
        description_match = re.search(r"^description:\s*(.+)$", text, re.MULTILINE)
        name = name_match.group(1) if name_match else ""
        description = description_match.group(1).strip() if description_match else ""

        if not name:
            add_error(f"Missing or invalid name in {directory.name}/SKILL.md")
        elif name != directory.name:
            add_error(f"Skill name '{name}' does not match directory '{directory.name}'")

        if not description:
            add_error(f"Missing description in {directory.name}/SKILL.md")
        elif not re.search(r"[\u4e00-\u9fff]", description):
            add_error(f"Description should be Chinese in {directory.name}/SKILL.md")

for relative in rules["json_files"]:
    path = root / relative
    if not path.is_file():
        continue
    try:
        json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        add_error(f"Invalid JSON: {relative}")

for check in rules["scenario_checks"]:
    path = root / check["file"]
    if not path.is_file():
        add_error(f"Scenario check missing file: {check['file']}")
        continue
    text = path.read_text(encoding="utf-8")
    if check["pattern"] not in text:
        add_error(f"Scenario check failed: {check['label']} [{check['file']}]")

if errors:
    for error in errors:
        print(f"- {error}", file=sys.stderr)
    sys.exit(1)

print("engineering-skills validation passed")
PY
