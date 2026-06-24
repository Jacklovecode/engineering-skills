param(
  [string]$Path = ".",
  [switch]$Help
)

$ErrorActionPreference = "Stop"

if ($Help) {
  Write-Output "用法: .\collect-project-context.ps1 [-Path <project-root>]"
  Write-Output "作用: 只读收集 setup 需要的协作入口、领域文档、ADR、issue tracker、验证命令和忽略规则。"
  exit 0
}

$root = (Resolve-Path $Path).Path
Set-Location -LiteralPath $root

function Write-Section {
  param([string]$Title)
  Write-Output ""
  Write-Output "## $Title"
}

function Write-Command {
  param([scriptblock]$Block, [string]$Fallback = "无")
  try {
    $output = & $Block
    if ($output) {
      Write-Output $output
    } else {
      Write-Output $Fallback
    }
  } catch {
    Write-Output "无法读取：$($_.Exception.Message)"
  }
}

function Write-ExistingPaths {
  param([string[]]$Paths, [string]$Fallback)
  $found = $false
  foreach ($item in $Paths) {
    $full = Join-Path $root $item
    if (Test-Path -LiteralPath $full) {
      Write-Output "- $item"
      $found = $true
    }
  }
  if (-not $found) { Write-Output $Fallback }
}

Write-Output "# Setup 项目约定收集"

Write-Section "项目根目录"
Write-Output $root

Write-Section "Git 状态"
Write-Command { git status --short --ignored }

Write-Section "协作入口"
Write-ExistingPaths @("AGENTS.md", "CLAUDE.md", "GEMINI.md", ".codex-plugin/plugin.json", ".claude-plugin/plugin.json", "gemini-extension.json") "未发现常见智能体入口"

Write-Section "领域文档"
Write-ExistingPaths @("CONTEXT.md", "CONTEXT-MAP.md", "README.md", "README_EN.md") "未发现常见领域文档"

Write-Section "ADR 或决策记录"
$adrPaths = @("docs/adr", "docs/decisions", "adr", "architecture/adr")
Write-ExistingPaths $adrPaths "未发现 ADR 或决策记录目录"

Write-Section "Issue / PR 约定"
Write-ExistingPaths @(".github/ISSUE_TEMPLATE", ".github/PULL_REQUEST_TEMPLATE.md", "docs/issues", "issues") "未发现 issue 或 PR 模板"

Write-Section "验证命令候选"
Write-ExistingPaths @("scripts/validate.ps1", "scripts/validate.sh", "scripts/simulate-pressure.ps1", "scripts/simulate-pressure.sh", "package.json", "pyproject.toml", "Makefile", "justfile") "未发现常见验证入口"

Write-Section "忽略规则"
Write-ExistingPaths @(".gitignore", ".gitattributes") "未发现 .gitignore 或 .gitattributes"

Write-Section "远程仓库"
Write-Command { git remote -v }

Write-Section "提醒"
Write-Output "本脚本只收集 setup 语境，不修改文件，不创建约定。使用 setup 时仍必须区分已发现事实、推荐默认值和需要用户确认的决策。"
