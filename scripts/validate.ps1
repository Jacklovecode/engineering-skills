$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$errors = New-Object System.Collections.Generic.List[string]

function Add-Error {
  param([string]$Message)
  $errors.Add($Message) | Out-Null
}

function Test-RequiredFile {
  param([string]$RelativePath)
  $path = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Error "Missing required file: $RelativePath"
  }
}

$requiredFiles = @(
  "README.md",
  "INSTALL.md",
  "USAGE.md",
  "AGENTS.md",
  "CLAUDE.md",
  "GEMINI.md",
  "LICENSE",
  "README_EN.md",
  ".codex-plugin/plugin.json",
  ".claude-plugin/plugin.json",
  "gemini-extension.json",
  "hooks/hooks-codex.json",
  "hooks/hooks-codex.windows.json",
  "hooks/hooks-codex.unix.json",
  "hooks/run-hook.cmd",
  "hooks/run-hook.sh",
  "hooks/session-start-codex.ps1",
  "hooks/session-start-codex.sh",
  "scripts/simulate-pressure.ps1",
  "scripts/simulate-pressure.sh",
  "scripts/validate.ps1",
  "scripts/validate.sh",
  "validation/pressure-scenarios.json"
)

foreach ($file in $requiredFiles) {
  Test-RequiredFile $file
}

$skillsRoot = Join-Path $root "skills"
if (-not (Test-Path -LiteralPath $skillsRoot)) {
  Add-Error "Missing skills directory"
} else {
  $skillDirs = Get-ChildItem -LiteralPath $skillsRoot -Directory
  if ($skillDirs.Count -ne 13) {
    Add-Error "Expected 13 skill directories, found $($skillDirs.Count)"
  }

  foreach ($dir in $skillDirs) {
    $skillFile = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) {
      Add-Error "Missing SKILL.md in $($dir.Name)"
      continue
    }

    $text = Get-Content -Raw -LiteralPath $skillFile -Encoding UTF8
    $name = [regex]::Match($text, '(?m)^name:\s*([A-Za-z0-9-]+)\s*$').Groups[1].Value
    $description = [regex]::Match($text, '(?m)^description:\s*(.+)$').Groups[1].Value.Trim()

    if (-not $name) {
      Add-Error "Missing or invalid name in $($dir.Name)/SKILL.md"
    } elseif ($name -ne $dir.Name) {
      Add-Error "Skill name '$name' does not match directory '$($dir.Name)'"
    }

    if (-not $description) {
      Add-Error "Missing description in $($dir.Name)/SKILL.md"
    } elseif ($description -notmatch '[\u4e00-\u9fff]') {
      Add-Error "Description should be Chinese in $($dir.Name)/SKILL.md"
    }
  }
}

$jsonFiles = @(
  ".codex-plugin/plugin.json",
  ".claude-plugin/plugin.json",
  "gemini-extension.json",
  "validation/pressure-scenarios.json",
  "hooks/hooks-codex.json",
  "hooks/hooks-codex.windows.json",
  "hooks/hooks-codex.unix.json"
)

foreach ($file in $jsonFiles) {
  $path = Join-Path $root $file
  if (Test-Path -LiteralPath $path) {
    try {
      Get-Content -Raw -LiteralPath $path -Encoding UTF8 | ConvertFrom-Json | Out-Null
    } catch {
      Add-Error "Invalid JSON: $file"
    }
  }
}

$scenarioChecks = @(
  @{ File = 'skills/start/SKILL.md'; Pattern = '需求不清'; Label = 'start routes unclear requirements' },
  @{ File = 'skills/start/SKILL.md'; Pattern = '不能覆盖这些质量门禁'; Label = 'start protects quality gates from skip requests' },
  @{ File = 'skills/clarify/SKILL.md'; Pattern = '大型或战略变更'; Label = 'clarify handles large changes' },
  @{ File = 'skills/clarify/SKILL.md'; Pattern = '必须让用户审阅后再进入 `plan`'; Label = 'clarify requires review before large plans' },
  @{ File = 'skills/clarify/SKILL.md'; Pattern = '需求已清楚且只是小修改：进入 `tdd`'; Label = 'clarify routes small changes to tdd' },
  @{ File = 'skills/clarify/SKILL.md'; Pattern = '进入 `grill`'; Label = 'clarify routes uncertain design to grill' },
  @{ File = 'skills/clarify/SKILL.md'; Pattern = '进入 `plan`'; Label = 'clarify routes confirmed decisions to plan' },
  @{ File = 'skills/grill/SKILL.md'; Pattern = '建议进入 `plan`'; Label = 'grill hands off to plan' },
  @{ File = 'skills/plan/SKILL.md'; Pattern = '进入 `execute`'; Label = 'plan hands off to execute' },
  @{ File = 'skills/plan/SKILL.md'; Pattern = '进入 `grill`'; Label = 'plan rejects unclear plans' },
  @{ File = 'skills/execute/SKILL.md'; Pattern = '进入 `tdd`'; Label = 'execute invokes tdd' },
  @{ File = 'skills/execute/SKILL.md'; Pattern = '进入 `review`'; Label = 'execute invokes review' },
  @{ File = 'skills/execute/SKILL.md'; Pattern = '进入 `diagnose`'; Label = 'execute invokes diagnose on failure' },
  @{ File = 'skills/execute/SKILL.md'; Pattern = '进入 `finish`'; Label = 'execute ends at finish' },
  @{ File = 'skills/execute/SKILL.md'; Pattern = '先回到 `plan` 补齐'; Label = 'execute rejects incomplete plans' },
  @{ File = 'skills/tdd/SKILL.md'; Pattern = '实现完成后进入 `review`'; Label = 'tdd hands off to review' },
  @{ File = 'skills/tdd/SKILL.md'; Pattern = '不要让它决定测试写法'; Label = 'tdd prevents implementation-shaped tests' },
  @{ File = 'skills/tdd/SKILL.md'; Pattern = '撤回或隔离先写的实现'; Label = 'tdd isolates code written before tests' },
  @{ File = 'skills/review/SKILL.md'; Pattern = '下一步进入 `finish`'; Label = 'review hands off to finish when clear' },
  @{ File = 'skills/review/SKILL.md'; Pattern = '进入 `diagnose`'; Label = 'review routes unexplained failures to diagnose' },
  @{ File = 'skills/review/SKILL.md'; Pattern = '依据不足'; Label = 'review marks missing requirement source' },
  @{ File = 'skills/diagnose/SKILL.md'; Pattern = '进入 `review`，再进入 `finish`'; Label = 'diagnose returns to review and finish' },
  @{ File = 'skills/diagnose/SKILL.md'; Pattern = '进入 `deepen`'; Label = 'diagnose escalates architecture issues' },
  @{ File = 'skills/diagnose/SKILL.md'; Pattern = '必须评估是否进入 `deepen`'; Label = 'diagnose requires deepen evaluation after repeated failed fixes' },
  @{ File = 'skills/finish/SKILL.md'; Pattern = '进入 `diagnose`'; Label = 'finish routes failed verification to diagnose' },
  @{ File = 'skills/finish/SKILL.md'; Pattern = '等待用户明确确认'; Label = 'finish requires confirmation before cleanup' },
  @{ File = 'skills/finish/SKILL.md'; Pattern = '会删除的分支、提交、文件或 worktree'; Label = 'finish lists destructive cleanup targets' },
  @{ File = 'skills/git/SKILL.md'; Pattern = 'git rm --cached'; Label = 'git preserves local files while untracking' },
  @{ File = 'skills/git/SKILL.md'; Pattern = '不要直接强推'; Label = 'git rejects unsafe force push' },
  @{ File = 'skills/git/SKILL.md'; Pattern = '用户明确说某个目录不要上传'; Label = 'git honors excluded upload paths' },
  @{ File = 'skills/deepen/SKILL.md'; Pattern = '暂不建议重构'; Label = 'deepen can decline unnecessary refactors' },
  @{ File = 'skills/skill-edit/SKILL.md'; Pattern = '压力场景'; Label = 'skill-edit requires pressure scenarios' },
  @{ File = 'skills/skill-edit/SKILL.md'; Pattern = 'description` 只写触发条件'; Label = 'skill-edit enforces description trigger rule' }
)

foreach ($check in $scenarioChecks) {
  $path = Join-Path $root $check.File
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Error "Scenario check missing file: $($check.File)"
    continue
  }
  $text = Get-Content -Raw -LiteralPath $path -Encoding UTF8
  if (-not $text.Contains($check.Pattern)) {
    Add-Error "Scenario check failed: $($check.Label) [$($check.File)]"
  }
}

$forbidden = @(
  "deepthinkengine",
  "deeptihinkengine",
  "垂直切片",
  "仪器化",
  "Spec Review",
  "Engineering Review",
  "Critical",
  "Major",
  "Minor",
  "Question",
  "bugfix",
  "flaky",
  "query plan",
  "profiler",
  "红旗",
  "拷问门禁",
  "抽象上移门禁",
  "不何时使用"
)

$scanFiles = Get-ChildItem -LiteralPath $root -Recurse -File |
  Where-Object {
    $_.FullName -notmatch '\\.git\\' -and
    $_.FullName -notmatch '\\scripts\\validate\.(ps1|sh)$' -and
    $_.Extension -in @(".md", ".json", ".ps1", ".sh", ".cmd")
  }

foreach ($file in $scanFiles) {
  $text = Get-Content -Raw -LiteralPath $file.FullName -Encoding UTF8
  foreach ($term in $forbidden) {
    if ($text.Contains($term)) {
      $relative = Resolve-Path -LiteralPath $file.FullName -Relative
      Add-Error "Forbidden term '$term' found in $relative"
    }
  }
}

if ($errors.Count -gt 0) {
  Write-Error (($errors | ForEach-Object { "- $_" }) -join [Environment]::NewLine)
  exit 1
}

Write-Output "engineering-skills validation passed"
