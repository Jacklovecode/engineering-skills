param(
  [string]$Command = "",
  [switch]$Help
)

$ErrorActionPreference = "Stop"

if ($Help -or [string]::IsNullOrWhiteSpace($Command)) {
  Write-Output "用法: .\guard.ps1 -Command '<git command>'"
  Write-Output "作用: 检查 git 命令是否包含危险操作。只检查，不执行命令。"
  exit 0
}

$dangerousPatterns = @(
  "git\s+reset\s+--hard",
  "git\s+clean\s+-[^\s]*f",
  "git\s+push\b.*--force",
  "git\s+push\b.*-f\b",
  "git\s+branch\s+-D\b",
  "git\s+tag\s+-d\b",
  "git\s+stash\s+drop\b",
  "git\s+stash\s+clear\b",
  "git\s+worktree\s+remove\b",
  "git\s+checkout\s+--\s+\.",
  "git\s+restore\s+--source\b",
  "git\s+restore\s+\."
)

foreach ($pattern in $dangerousPatterns) {
  if ($Command -match $pattern) {
    Write-Error "危险 git 命令已拦截：'$Command' 匹配 '$pattern'。请先列出影响范围并获得用户明确确认。"
    exit 2
  }
}

Write-Output "未发现已知危险 git 操作：$Command"
