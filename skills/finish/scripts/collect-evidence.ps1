$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
Set-Location -LiteralPath $root

Write-Output "# Finish 证据收集"
Write-Output ""
Write-Output "## Git 状态"
git status --short --ignored
Write-Output ""
Write-Output "## 当前分支"
git branch --show-current
Write-Output ""
Write-Output "## Remote"
git remote -v
Write-Output ""
Write-Output "## 差异统计"
git diff --stat
Write-Output ""
Write-Output "## 暂存差异统计"
git diff --cached --stat
Write-Output ""
Write-Output "## docs 跟踪检查"
$trackedDocs = git ls-files | Select-String -Pattern '^docs/'
if ($trackedDocs) {
  Write-Output "发现已跟踪 docs 文件："
  Write-Output $trackedDocs
} else {
  Write-Output "未发现已跟踪 docs 文件"
}
Write-Output ""
Write-Output "## 推荐验证命令"
if (Test-Path -LiteralPath (Join-Path $root "scripts/validate.ps1")) {
  Write-Output "- .\scripts\validate.ps1"
}
if (Test-Path -LiteralPath (Join-Path $root "scripts/simulate-pressure.ps1")) {
  Write-Output "- .\scripts\simulate-pressure.ps1"
}
Write-Output ""
Write-Output "## 提醒"
Write-Output "本脚本只收集完成前证据线索，不代表验证已经通过。必须实际运行验证命令并读取结果。"
