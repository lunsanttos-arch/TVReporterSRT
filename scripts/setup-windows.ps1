$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "TVReporterSRT - Windows setup" -ForegroundColor Cyan
Write-Host ""

function Has-Command($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

if (-not (Has-Command "git")) {
    Write-Host "Git nao encontrado." -ForegroundColor Yellow
    Write-Host "Instale em: https://git-scm.com/download/win"
    exit 1
}

if (-not (Has-Command "code")) {
    Write-Host "VS Code nao encontrado no PATH." -ForegroundColor Yellow
    Write-Host "Voce pode continuar, mas recomendo instalar o VS Code."
}

Write-Host "Git encontrado:" (git --version) -ForegroundColor Green

if (-not (Test-Path ".git")) {
    git init
    Write-Host "Repositorio Git inicializado." -ForegroundColor Green
}

Write-Host ""
Write-Host "Proximos comandos:" -ForegroundColor Cyan
Write-Host '  git add .'
Write-Host '  git commit -m "Primeira versao TVReporterSRT"'
Write-Host '  git branch -M main'
Write-Host '  git remote add origin https://github.com/SEU_USUARIO/TVReporterSRT.git'
Write-Host '  git push -u origin main'
Write-Host ""
Write-Host "Depois abra no GitHub: Actions > iOS Build Check" -ForegroundColor Cyan
