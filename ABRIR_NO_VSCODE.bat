@echo off
cd /d "%~dp0"
where code >nul 2>nul
if %errorlevel% neq 0 (
  echo VS Code nao foi encontrado no PATH.
  echo Abra esta pasta manualmente no VS Code.
  pause
  exit /b 1
)
code .
