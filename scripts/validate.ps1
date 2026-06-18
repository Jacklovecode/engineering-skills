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

$rulesPath = Join-Path $root "validation/rules.json"
if (-not (Test-Path -LiteralPath $rulesPath)) {
  Write-Error "Missing validation rules: validation/rules.json"
  exit 1
}

$rules = Get-Content -Raw -LiteralPath $rulesPath -Encoding UTF8 | ConvertFrom-Json
$requiredFiles = @($rules.required_files | ForEach-Object { [string]$_ })

foreach ($file in $requiredFiles) {
  Test-RequiredFile $file
}

$skillsRoot = Join-Path $root "skills"
if (-not (Test-Path -LiteralPath $skillsRoot)) {
  Add-Error "Missing skills directory"
} else {
  $skillDirs = Get-ChildItem -LiteralPath $skillsRoot -Directory
  $expectedSkillCount = [int]$rules.skill_count
  if ($skillDirs.Count -ne $expectedSkillCount) {
    Add-Error "Expected $expectedSkillCount skill directories, found $($skillDirs.Count)"
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

$jsonFiles = @($rules.json_files | ForEach-Object { [string]$_ })

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

$scenarioChecks = @($rules.scenario_checks)

foreach ($check in $scenarioChecks) {
  $path = Join-Path $root $check.file
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Error "Scenario check missing file: $($check.file)"
    continue
  }
  $text = Get-Content -Raw -LiteralPath $path -Encoding UTF8
  if (-not $text.Contains([string]$check.pattern)) {
    Add-Error "Scenario check failed: $($check.label) [$($check.file)]"
  }
}

if ($errors.Count -gt 0) {
  Write-Error (($errors | ForEach-Object { "- $_" }) -join [Environment]::NewLine)
  exit 1
}

Write-Output "engineering-skills validation passed"
