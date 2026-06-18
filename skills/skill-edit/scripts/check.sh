#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SKILLS_ROOT="$ROOT/skills"
errors=()

if [[ ! -d "$SKILLS_ROOT" ]]; then
  errors+=("缺少 skills 目录")
else
  while IFS= read -r -d '' dir; do
    skill_name="$(basename "$dir")"
    skill_file="$dir/SKILL.md"
    if [[ ! -f "$skill_file" ]]; then
      errors+=("缺少 $skill_name/SKILL.md")
      continue
    fi

    name="$(grep -E '^name:[[:space:]]*[A-Za-z0-9-]+[[:space:]]*$' "$skill_file" | sed -E 's/^name:[[:space:]]*//; s/[[:space:]]*$//' || true)"
    description="$(grep -E '^description:' "$skill_file" | sed -E 's/^description:[[:space:]]*//; s/[[:space:]]*$//' || true)"

    if [[ -z "$name" ]]; then
      errors+=("$skill_name/SKILL.md 缺少有效 name")
    elif [[ "$name" != "$skill_name" ]]; then
      errors+=("$skill_name/SKILL.md 的 name '$name' 与目录名不一致")
    fi

    if [[ -z "$description" ]]; then
      errors+=("$skill_name/SKILL.md 缺少 description")
    elif ! printf '%s' "$description" | grep -q '[一-龥]'; then
      errors+=("$skill_name/SKILL.md 的 description 应使用中文触发条件")
    fi

    if printf '%s' "$description" | grep -Eq '流程|步骤|先.*再|然后'; then
      errors+=("$skill_name/SKILL.md 的 description 可能包含流程摘要，应只写触发条件")
    fi
  done < <(find "$SKILLS_ROOT" -mindepth 1 -maxdepth 1 -type d -print0)
fi

if (( ${#errors[@]} > 0 )); then
  echo "技能检查失败："
  printf -- '- %s\n' "${errors[@]}"
  exit 1
fi

echo "技能检查通过"
