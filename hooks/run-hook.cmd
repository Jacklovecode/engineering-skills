@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "HOOK_NAME=%~1"

if "%HOOK_NAME%"=="session-start-codex" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%session-start-codex.ps1"
  exit /b %ERRORLEVEL%
)

exit /b 0
