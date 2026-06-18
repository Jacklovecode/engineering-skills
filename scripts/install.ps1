param(
  [string]$Target = "$HOME\.engineering-skills"
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$targetPath = [System.IO.Path]::GetFullPath($Target)

Write-Output "# Engineering Skills 安装"
Write-Output ""
Write-Output "源目录: $root"
Write-Output "目标目录: $targetPath"
Write-Output ""

if (-not (Test-Path -LiteralPath $targetPath)) {
  New-Item -ItemType Directory -Path $targetPath | Out-Null
}

$items = @(
  "skills",
  "hooks",
  ".codex-plugin",
  ".claude-plugin",
  "AGENTS.md",
  "CLAUDE.md",
  "GEMINI.md",
  "gemini-extension.json",
  "INSTALL.md",
  "USAGE.md",
  "README.md",
  "README_EN.md",
  "LICENSE"
)

foreach ($item in $items) {
  $source = Join-Path $root $item
  if (-not (Test-Path -LiteralPath $source)) {
    continue
  }

  $destination = Join-Path $targetPath $item
  if (Test-Path -LiteralPath $destination) {
    Remove-Item -LiteralPath $destination -Recurse -Force
  }

  Copy-Item -LiteralPath $source -Destination $destination -Recurse
}

Write-Output "安装完成。"
Write-Output ""
Write-Output "建议入口："
Write-Output "- 通用智能体: $targetPath\AGENTS.md"
Write-Output "- Codex: $targetPath\.codex-plugin\plugin.json"
Write-Output "- Claude: $targetPath\CLAUDE.md"
Write-Output "- Gemini: $targetPath\GEMINI.md"
Write-Output ""
Write-Output "安装脚本不会执行 git 操作。"
