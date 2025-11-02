# Script Simplificado para Subir a GitHub Releases
# VitaCast v2.0.1

$ErrorActionPreference = "Stop"

$VERSION = "2.0.1"
$VPK_FILE = "VitaCast-v$VERSION.vpk"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Subir VitaCast v$VERSION a GitHub" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar archivos
Write-Host "Verificando archivos..." -ForegroundColor Green

if (-not (Test-Path $VPK_FILE)) {
    Write-Host "ERROR: No se encontro $VPK_FILE" -ForegroundColor Red
    exit 1
}

Write-Host "OK: Archivos presentes" -ForegroundColor Green
Write-Host ""

# Verificar GitHub CLI
Write-Host "Verificando GitHub CLI..." -ForegroundColor Green

try {
    $null = gh --version 2>$null
    Write-Host "OK: GitHub CLI instalado" -ForegroundColor Green
} catch {
    Write-Host "GitHub CLI no esta instalado" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Instalando con winget..." -ForegroundColor Cyan
    
    try {
        winget install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements
        Write-Host ""
        Write-Host "GitHub CLI instalado!" -ForegroundColor Green
        Write-Host "Cierra y vuelve a abrir PowerShell, luego ejecuta de nuevo" -ForegroundColor Yellow
        exit 0
    } catch {
        Write-Host ""
        Write-Host "No se pudo instalar automaticamente" -ForegroundColor Red
        Write-Host "Descarga desde: https://cli.github.com/" -ForegroundColor Cyan
        exit 1
    }
}

Write-Host ""

# Autenticar
Write-Host "Verificando autenticacion..." -ForegroundColor Green

try {
    $authStatus = gh auth status 2>&1
    if ($authStatus -like "*Logged in*") {
        Write-Host "OK: Autenticado en GitHub" -ForegroundColor Green
    } else {
        throw "No autenticado"
    }
} catch {
    Write-Host "Necesitas autenticarte en GitHub" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Se abrira tu navegador..." -ForegroundColor Cyan
    Start-Sleep -Seconds 2
    
    gh auth login
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error al autenticar" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Autenticacion completada!" -ForegroundColor Green
}

Write-Host ""

# Preparar Git
Write-Host "Preparando Git..." -ForegroundColor Green

if (-not (Test-Path ".git")) {
    git init
    Write-Host "Repositorio Git inicializado" -ForegroundColor Green
}

$remotes = git remote 2>&1
if (-not $remotes -or $remotes -notlike "*origin*") {
    Write-Host ""
    $repoUrl = Read-Host "URL del repositorio GitHub (ej: https://github.com/usuario/VitaCast)"
    
    if ($repoUrl) {
        git remote add origin $repoUrl
        Write-Host "Remoto configurado" -ForegroundColor Green
    } else {
        Write-Host "URL no proporcionada" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Subiendo cambios..." -ForegroundColor Cyan

git add .
git commit -m "Release v$VERSION - Stable version" 2>$null
git push origin main 2>&1 | Out-Null

Write-Host "OK" -ForegroundColor Green
Write-Host ""

# Crear tag
Write-Host "Creando tag v$VERSION..." -ForegroundColor Green

git tag -d "v$VERSION" 2>$null
git tag -a "v$VERSION" -m "Release v$VERSION - Stable"
git push origin "v$VERSION" --force 2>&1 | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al crear tag" -ForegroundColor Red
    exit 1
}

Write-Host "OK: Tag creado" -ForegroundColor Green
Write-Host ""

# Crear archivo de release notes
$notes = @"
VitaCast v$VERSION - Primera version estable

CORRECCIONES:
- Error critico 0x8010xxxx corregido
- Headers correctos (psp2/*)
- Inicializacion apropiada de modulos
- Template LiveArea valido

INSTALACION:
1. Descarga VitaCast-v$VERSION.vpk
2. Copia a tu PS Vita via USB/FTP
3. Instala con VitaShell
4. Disfruta!

COMPATIBILIDAD:
- PS Vita 1000/2000/TV
- Firmware 3.60+
- Requiere HENkaku/Enso

Ver INSTALL.md para mas detalles.
"@

$notes | Out-File -FilePath "release_notes.txt" -Encoding UTF8

# Crear release
Write-Host "Creando release en GitHub..." -ForegroundColor Green
Write-Host ""

try {
    gh release create "v$VERSION" `
        --title "VitaCast v$VERSION - Stable Release" `
        --notes-file "release_notes.txt" `
        --latest `
        "$VPK_FILE" `
        "VitaCast-v$VERSION.md5" `
        "VitaCast-v$VERSION.sha256" `
        "INSTALL.md" `
        "RELEASE_NOTES.md"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host "  RELEASE PUBLICADO!" -ForegroundColor Green
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host ""
        
        $repoInfo = gh repo view --json url -q .url
        Write-Host "URL: $repoInfo/releases/tag/v$VERSION" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Archivos subidos:" -ForegroundColor White
        Write-Host "  - VitaCast-v$VERSION.vpk" -ForegroundColor Green
        Write-Host "  - Checksums MD5 y SHA256" -ForegroundColor Green
        Write-Host "  - INSTALL.md" -ForegroundColor Green
        Write-Host "  - RELEASE_NOTES.md" -ForegroundColor Green
        Write-Host ""
    }
    
} catch {
    Write-Host ""
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
} finally {
    Remove-Item -Path "release_notes.txt" -ErrorAction SilentlyContinue
}

Write-Host "Listo! VitaCast v$VERSION publicado" -ForegroundColor Green
Write-Host ""

