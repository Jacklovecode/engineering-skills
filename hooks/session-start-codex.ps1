$ErrorActionPreference = "Stop"

$pluginRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$skillPath = Join-Path $pluginRoot "skills/start/SKILL.md"
$content = Get-Content -LiteralPath $skillPath -Raw -Encoding UTF8

$context = @"
<ENGINEERING_SKILLS>
You have Engineering Skills.

Below is the routing entry skill. Use it in guided mode: if a task clearly matches another skill, activate that skill before taking action. If the match is uncertain, proceed normally for low-risk tasks.

$content
</ENGINEERING_SKILLS>
"@

$payload = @{
  hookSpecificOutput = @{
    hookEventName = "SessionStart"
    additionalContext = $context
  }
} | ConvertTo-Json -Depth 4

Write-Output $payload
