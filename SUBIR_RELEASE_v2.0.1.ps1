# Script para subir VitaCast v2.0.1 a GitHub Releases
# Ejecutar en PowerShell como Administrador

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  VitaCast v2.0.1 - Deploy a GitHub Releases               ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Variables
$VERSION = "v2.0.1"
$TAG_NAME = $VERSION
$RELEASE_NAME = "VitaCast $VERSION - Versión Completa"

Write-Host "📋 Configuración:" -ForegroundColor Yellow
Write-Host "   • Versión: $VERSION"
Write-Host "   • Tag: $TAG_NAME"
Write-Host "   • Branch: main"
Write-Host ""

# Paso 1: Verificar que estamos en el repositorio correcto
Write-Host "[1/6] Verificando repositorio..." -ForegroundColor Green
$repoPath = Get-Location
Write-Host "   📂 Path: $repoPath"

$gitStatus = git status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ ERROR: No es un repositorio Git válido" -ForegroundColor Red
    exit 1
}
Write-Host "   ✅ Repositorio Git válido" -ForegroundColor Green
Write-Host ""

# Paso 2: Verificar que no haya cambios sin commit
Write-Host "[2/6] Verificando cambios pendientes..." -ForegroundColor Green
$changes = git status --porcelain
if ($changes) {
    Write-Host "   ⚠️  Hay cambios sin commit:" -ForegroundColor Yellow
    Write-Host $changes
    Write-Host ""
    
    $response = Read-Host "   ¿Deseas hacer commit de estos cambios? (s/n)"
    if ($response -eq 's' -or $response -eq 'S') {
        Write-Host "   📝 Haciendo commit..." -ForegroundColor Cyan
        
        git add .
        git commit -m "Release v2.0.1 - Versión completa con todos los módulos implementados"
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "   ❌ ERROR en commit" -ForegroundColor Red
            exit 1
        }
        
        Write-Host "   ✅ Commit realizado" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Continuando sin commit..." -ForegroundColor Yellow
    }
} else {
    Write-Host "   ✅ No hay cambios pendientes" -ForegroundColor Green
}
Write-Host ""

# Paso 3: Push de cambios a main
Write-Host "[3/6] Subiendo cambios a GitHub..." -ForegroundColor Green
Write-Host "   📤 git push origin main"

git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ ERROR al hacer push" -ForegroundColor Red
    Write-Host "   Verifica tu conexión y permisos en GitHub" -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✅ Cambios subidos correctamente" -ForegroundColor Green
Write-Host ""

# Paso 4: Eliminar tag antiguo si existe (local y remoto)
Write-Host "[4/6] Gestionando tags..." -ForegroundColor Green

# Eliminar tag local
$localTag = git tag -l $TAG_NAME
if ($localTag) {
    Write-Host "   🗑️  Eliminando tag local $TAG_NAME..."
    git tag -d $TAG_NAME
}

# Intentar eliminar tag remoto
Write-Host "   🗑️  Intentando eliminar tag remoto $TAG_NAME..."
git push origin --delete $TAG_NAME 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Tag remoto eliminado" -ForegroundColor Green
} else {
    Write-Host "   ℹ️  Tag remoto no existía o ya fue eliminado" -ForegroundColor Cyan
}
Write-Host ""

# Paso 5: Crear nuevo tag
Write-Host "[5/6] Creando nuevo tag..." -ForegroundColor Green
Write-Host "   🏷️  Creando tag $TAG_NAME"

git tag $TAG_NAME -m "Release $VERSION - Versión completa con arquitectura modular

Características principales:
- ✅ Sistema de UI completo con navegación
- ✅ Reproductor de audio funcional
- ✅ Network Manager con WiFi
- ✅ Apple Sync Manager
- ✅ Arquitectura modular escalable
- ✅ Sin dependencias externas problemáticas
- ✅ Demo mode para testing

Ver RELEASE_NOTES_v2.0.1.md para detalles completos."

if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ ERROR al crear tag" -ForegroundColor Red
    exit 1
}
Write-Host "   ✅ Tag $TAG_NAME creado localmente" -ForegroundColor Green
Write-Host ""

# Paso 6: Push del tag
Write-Host "[6/6] Subiendo tag a GitHub..." -ForegroundColor Green
Write-Host "   📤 git push origin $TAG_NAME"

git push origin $TAG_NAME --force
if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ ERROR al subir tag" -ForegroundColor Red
    exit 1
}
Write-Host "   ✅ Tag subido correctamente" -ForegroundColor Green
Write-Host ""

# Resumen final
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ Deploy completado exitosamente                          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Próximos pasos:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1️⃣  GitHub Actions está compilando automáticamente" -ForegroundColor Cyan
Write-Host "       🔗 https://github.com/kkakele/VitaCast/actions" -ForegroundColor Blue
Write-Host ""
Write-Host "   2️⃣  Espera 15-20 minutos para que termine la compilación" -ForegroundColor Cyan
Write-Host ""
Write-Host "   3️⃣  El release se creará automáticamente en:" -ForegroundColor Cyan
Write-Host "       🔗 https://github.com/kkakele/VitaCast/releases" -ForegroundColor Blue
Write-Host ""
Write-Host "   4️⃣  Archivos que se generarán:" -ForegroundColor Cyan
Write-Host "       📦 VitaCast-v2.0.1.vpk" -ForegroundColor White
Write-Host "       🔐 VitaCast-v2.0.1.md5" -ForegroundColor White
Write-Host "       🔐 VitaCast-v2.0.1.sha256" -ForegroundColor White
Write-Host "       📄 INSTALL.md" -ForegroundColor White
Write-Host "       📄 RELEASE_NOTES.md" -ForegroundColor White
Write-Host ""
Write-Host "   5️⃣  Una vez listo, descarga el VPK e instálalo en PS Vita" -ForegroundColor Cyan
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║  🎮 VitaCast v2.0.1 - En camino a tu PS Vita!              ║" -ForegroundColor Magenta
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# Abrir navegador en GitHub Actions
Write-Host "¿Quieres abrir GitHub Actions en el navegador? (s/n): " -NoNewline -ForegroundColor Yellow
$openBrowser = Read-Host
if ($openBrowser -eq 's' -or $openBrowser -eq 'S') {
    Start-Process "https://github.com/kkakele/VitaCast/actions"
}

Write-Host ""
Write-Host "✨ Script completado. ¡Gracias por usar VitaCast!" -ForegroundColor Green
Write-Host ""

