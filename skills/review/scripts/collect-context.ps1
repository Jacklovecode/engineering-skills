$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
Set-Location -LiteralPath $root

Write-Output "# Review 上下文收集"
Write-Output ""
Write-Output "## Git 状态"
git status --short --ignored
Write-Output ""
Write-Output "## 当前分支"
git branch --show-current
Write-Output ""
Write-Output "## 最近提交"
git log --oneline --decorate -n 5
Write-Output ""
Write-Output "## 已修改文件"
$modified = git diff --name-only
if ($modified) { Write-Output $modified } else { Write-Output "无" }
Write-Output ""
Write-Output "## 暂存文件"
$staged = git diff --cached --name-only
if ($staged) { Write-Output $staged } else { Write-Output "无" }
Write-Output ""
Write-Output "## 可能的规范来源"
$candidates = @("AGENTS.md", "CLAUDE.md", "GEMINI.md", "CONTRIBUTING.md", "README.md")
foreach ($file in $candidates) {
  if (Test-Path -LiteralPath (Join-Path $root $file)) {
    Write-Output "- $file"
  }
}
Write-Output ""
Write-Output "## 提醒"
Write-Output "本脚本只收集审查上下文，不判断需求是否满足，也不替代人工/智能体审查。"
