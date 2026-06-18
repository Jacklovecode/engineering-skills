param(
  [string]$Path = ".",
  [switch]$Help
)

$ErrorActionPreference = "Stop"

if ($Help) {
  Write-Output "用法: .\collect-architecture-context.ps1 [-Path <project-root>]"
  Write-Output "作用: 只读收集架构深化需要的领域文档、ADR、入口文件、测试和 Git 差异。"
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

Write-Output "# Deepen 架构语境收集"

Write-Section "项目根目录"
Write-Output $root

Write-Section "Git 状态"
Write-Command { git status --short --ignored }

Write-Section "当前分支"
Write-Command { git branch --show-current }

Write-Section "差异文件"
Write-Command { git diff --name-only }

Write-Section "领域文档"
$domainFiles = @("CONTEXT.md", "CONTEXT-MAP.md", "README.md", "AGENTS.md", "CLAUDE.md", "GEMINI.md")
$foundDomain = $false
foreach ($file in $domainFiles) {
  if (Test-Path -LiteralPath (Join-Path $root $file)) {
    Write-Output "- $file"
    $foundDomain = $true
  }
}
if (-not $foundDomain) { Write-Output "未发现常见领域文档" }

Write-Section "ADR 候选"
$adrDirs = @("docs\adr", "doc\adr", "adr", "architecture\adr")
$foundAdr = $false
foreach ($dir in $adrDirs) {
  $full = Join-Path $root $dir
  if (Test-Path -LiteralPath $full) {
    Get-ChildItem -LiteralPath $full -File -Recurse -ErrorAction SilentlyContinue |
      Select-Object -First 30 |
      ForEach-Object {
        $relative = Resolve-Path -LiteralPath $_.FullName -Relative
        Write-Output "- $relative"
        $script:foundAdr = $true
      }
  }
}
if (-not $foundAdr) { Write-Output "未发现 ADR 目录" }

Write-Section "入口与配置候选"
$entryPatterns = @("package.json", "pyproject.toml", "go.mod", "Cargo.toml", "pom.xml", "build.gradle", "requirements.txt", "Makefile", "justfile")
$foundEntry = $false
foreach ($pattern in $entryPatterns) {
  Get-ChildItem -LiteralPath $root -File -Filter $pattern -ErrorAction SilentlyContinue |
    ForEach-Object {
      Write-Output "- $($_.Name)"
      $script:foundEntry = $true
    }
}
if (-not $foundEntry) { Write-Output "未发现常见入口或配置文件" }

Write-Section "测试目录候选"
$testDirs = @("test", "tests", "__tests__", "spec", "e2e")
$foundTests = $false
foreach ($dir in $testDirs) {
  $full = Join-Path $root $dir
  if (Test-Path -LiteralPath $full) {
    Write-Output "- $dir"
    $foundTests = $true
  }
}
if (-not $foundTests) { Write-Output "未发现常见测试目录" }

Write-Section "提醒"
Write-Output "本脚本只收集语境，不直接给出架构结论。使用 deepen 时仍必须判断真实摩擦、接口收益、改动集中度和测试收益。"
