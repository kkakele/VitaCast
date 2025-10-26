# Script de PowerShell para configurar VitaCast y obtener VPK
Write-Host " Configurando VitaCast para compilación automática..." -ForegroundColor Cyan

# Verificar si Git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host " Git no está instalado. Por favor instala Git primero." -ForegroundColor Red
    exit 1
}

Write-Host " Git encontrado" -ForegroundColor Green

# Inicializar Git si no existe
if (-not (Test-Path ".git")) {
    Write-Host " Inicializando repositorio Git..." -ForegroundColor Yellow
    git init
}

# Configurar Git
Write-Host " Configurando Git..." -ForegroundColor Yellow
git config user.name "VitaCast Developer"
git config user.email "developer@vitacast.com"

# Crear .gitignore
Write-Host " Creando .gitignore..." -ForegroundColor Yellow
@"
# Build artifacts
*.o
*.bin
*.vpk
param.sfo
eboot.bin

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS files
.DS_Store
Thumbs.db

# Temporary files
*.tmp
*.log
*.cache

# VitaSDK
vitasdk/
vita-headers/
vdpm/

# Dependencies
deps/
libs/
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# Hacer commit inicial
Write-Host " Haciendo commit inicial..." -ForegroundColor Yellow
git add .
git commit -m "feat: inicializar proyecto VitaCast"

Write-Host " Configuración completada!" -ForegroundColor Green
Write-Host ""
Write-Host " PRÓXIMOS PASOS:" -ForegroundColor Cyan
Write-Host "1. Crear repositorio en GitHub" -ForegroundColor White
Write-Host "2. Subir código con: git remote add origin URL" -ForegroundColor White
Write-Host "3. Ejecutar GitHub Actions para compilar" -ForegroundColor White
Write-Host "4. Descargar VPK desde Artifacts" -ForegroundColor White
