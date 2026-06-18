$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
Set-Location -LiteralPath $root

$branch = git branch --show-current
$remote = git remote -v
$tracking = git branch -vv
$status = git status --short --ignored
$trackedDocs = git ls-files | Select-String -Pattern '^docs/'
$untracked = git ls-files --others --exclude-standard
$modified = git diff --name-only
$staged = git diff --cached --name-only

Write-Output "# Git 上传前检查"
Write-Output ""
Write-Output "## 当前分支"
Write-Output $branch
Write-Output ""
Write-Output "## Remote"
Write-Output $remote
Write-Output ""
Write-Output "## 分支跟踪"
Write-Output $tracking
Write-Output ""
Write-Output "## 工作区状态"
if ($status) { Write-Output $status } else { Write-Output "工作区干净" }
Write-Output ""
Write-Output "## 已修改文件"
if ($modified) { Write-Output $modified } else { Write-Output "无" }
Write-Output ""
Write-Output "## 暂存文件"
if ($staged) { Write-Output $staged } else { Write-Output "无" }
Write-Output ""
Write-Output "## 未跟踪但未忽略文件"
if ($untracked) { Write-Output $untracked } else { Write-Output "无" }
Write-Output ""
Write-Output "## docs 跟踪检查"
if ($trackedDocs) {
  Write-Output "发现已跟踪 docs 文件："
  Write-Output $trackedDocs
} else {
  Write-Output "未发现已跟踪 docs 文件"
}
Write-Output ""
Write-Output "## 提醒"
Write-Output "本脚本只读取仓库状态，不会暂存、提交或推送。"
Write-Output "提交或推送前仍必须列出应上传、不应上传、需要用户确认的文件，并等待用户确认。"
