param(
  [string]$OutputPath = "",
  [switch]$Help
)

$ErrorActionPreference = "Stop"

if ($Help) {
  Write-Output "用法: .\hitl-loop.ps1 [-OutputPath <path>]"
  Write-Output "作用: 结构化记录必须人工参与的复现步骤、输入和观察结果。"
  exit 0
}

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
Set-Location -LiteralPath $root

function Read-Text {
  param([string]$Prompt, [string]$Default = "")
  $value = Read-Host $Prompt
  if ([string]::IsNullOrWhiteSpace($value) -and $Default) {
    return $Default
  }
  return $value
}

function Read-Block {
  param([string]$Prompt)
  Write-Output $Prompt
  Write-Output "输入空行结束。"
  $lines = New-Object System.Collections.Generic.List[string]
  while ($true) {
    $line = Read-Host "> "
    if ([string]::IsNullOrWhiteSpace($line)) {
      break
    }
    $lines.Add($line) | Out-Null
  }
  if ($lines.Count -eq 0) {
    return "未记录"
  }
  return ($lines -join [Environment]::NewLine)
}

if (-not $OutputPath) {
  $dir = Join-Path $root ".local\diagnose"
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $OutputPath = Join-Path $dir "hitl-$stamp.md"
}

$title = Read-Text "问题标题" "未命名问题"
$environment = Read-Block "记录复现环境，例如系统、浏览器、账号、分支、配置"
$precondition = Read-Block "记录前置条件"
$steps = Read-Block "逐行记录人工操作步骤"
$expected = Read-Block "记录预期结果"
$actual = Read-Block "记录实际结果、错误信息或异常现象"
$artifacts = Read-Block "记录截图、日志、HAR、录屏或其他证据位置"

$content = @(
  "# HITL 复现记录",
  "",
  "## 问题标题",
  $title,
  "",
  "## 记录时间",
  (Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz"),
  "",
  "## 复现环境",
  $environment,
  "",
  "## 前置条件",
  $precondition,
  "",
  "## 人工操作步骤",
  $steps,
  "",
  "## 预期结果",
  $expected,
  "",
  "## 实际结果",
  $actual,
  "",
  "## 证据位置",
  $artifacts,
  "",
  "## 下一步",
  "- 将本记录转化为可重复的反馈循环。"
  "- 如果仍需要人工参与，继续缩小步骤并保留关键观察点。"
)

$content | Set-Content -LiteralPath $OutputPath -Encoding UTF8
Write-Output "HITL 复现记录已写入: $OutputPath"
