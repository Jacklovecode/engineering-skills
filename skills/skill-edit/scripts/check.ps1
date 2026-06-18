$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
$skillsRoot = Join-Path $root "skills"
$errors = New-Object System.Collections.Generic.List[string]

function Add-Error {
  param([string]$Message)
  $errors.Add($Message) | Out-Null
}

if (-not (Test-Path -LiteralPath $skillsRoot)) {
  Add-Error "缺少 skills 目录"
} else {
  $skillDirs = Get-ChildItem -LiteralPath $skillsRoot -Directory
  foreach ($dir in $skillDirs) {
    $skillFile = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) {
      Add-Error "缺少 $($dir.Name)/SKILL.md"
      continue
    }

    $text = Get-Content -Raw -LiteralPath $skillFile -Encoding UTF8
    $name = [regex]::Match($text, '(?m)^name:\s*([A-Za-z0-9-]+)\s*$').Groups[1].Value
    $description = [regex]::Match($text, '(?m)^description:\s*(.+)$').Groups[1].Value.Trim()

    if (-not $name) {
      Add-Error "$($dir.Name)/SKILL.md 缺少有效 name"
    } elseif ($name -ne $dir.Name) {
      Add-Error "$($dir.Name)/SKILL.md 的 name '$name' 与目录名不一致"
    }

    if (-not $description) {
      Add-Error "$($dir.Name)/SKILL.md 缺少 description"
    } elseif ($description -notmatch '[\u4e00-\u9fff]') {
      Add-Error "$($dir.Name)/SKILL.md 的 description 应使用中文触发条件"
    }

    if ($description -match '流程|步骤|先.*再|然后') {
      Add-Error "$($dir.Name)/SKILL.md 的 description 可能包含流程摘要，应只写触发条件"
    }
  }
}

if ($errors.Count -gt 0) {
  Write-Output "技能检查失败："
  $errors | ForEach-Object { Write-Output "- $_" }
  exit 1
}

Write-Output "技能检查通过"
