# VitaCast Release Preparation Script v2.0.1 (PowerShell)
# Este script prepara todo lo necesario para subir a GitHub Releases

$ErrorActionPreference = "Stop"

$VERSION = "2.0.1"
$VPK_NAME = "VitaCast-v$VERSION.vpk"

Write-Host "================================================"
Write-Host "  VitaCast v$VERSION Release Preparation"
Write-Host "================================================"
Write-Host ""

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "Makefile_final")) {
    Write-Host "❌ ERROR: No se encuentra Makefile_final" -ForegroundColor Red
    Write-Host "¿Estás en el directorio correcto?"
    exit 1
}

Write-Host "✅ Directorio correcto" -ForegroundColor Green
Write-Host ""

# Limpiar builds anteriores
Write-Host "🧹 Limpiando builds anteriores..."
try {
    & make -f Makefile_final clean 2>$null
} catch {}

Remove-Item -Path "VitaCast*.vpk" -ErrorAction SilentlyContinue
Remove-Item -Path "VitaCast*.md5" -ErrorAction SilentlyContinue
Remove-Item -Path "VitaCast*.sha256" -ErrorAction SilentlyContinue

Write-Host "✅ Limpieza completada" -ForegroundColor Green
Write-Host ""

# Compilar versión release
Write-Host "🔨 Compilando VitaCast v$VERSION (Release optimizado)..."
Write-Host ""

try {
    & make -f Makefile_final release
    
    Write-Host ""
    Write-Host "✅ Compilación exitosa" -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "❌ ERROR: La compilación falló" -ForegroundColor Red
    exit 1
}

# Verificar que el VPK se generó
if (-not (Test-Path "VitaCast.vpk")) {
    Write-Host "❌ ERROR: VitaCast.vpk no se generó" -ForegroundColor Red
    exit 1
}

# Renombrar VPK
Write-Host "📦 Renombrando VPK..."
Move-Item -Path "VitaCast.vpk" -Destination $VPK_NAME -Force
Write-Host "✅ Renombrado a: $VPK_NAME" -ForegroundColor Green
Write-Host ""

# Generar checksums
Write-Host "🔐 Generando checksums..."

# MD5
$md5 = Get-FileHash -Path $VPK_NAME -Algorithm MD5
$md5.Hash.ToLower() + "  " + $VPK_NAME | Out-File -FilePath "$($VPK_NAME -replace '.vpk$','').md5" -Encoding ASCII

# SHA256
$sha256 = Get-FileHash -Path $VPK_NAME -Algorithm SHA256
$sha256.Hash.ToLower() + "  " + $VPK_NAME | Out-File -FilePath "$($VPK_NAME -replace '.vpk$','').sha256" -Encoding ASCII

Write-Host "✅ Checksums generados" -ForegroundColor Green
Write-Host ""

# Mostrar información
Write-Host "================================================"
Write-Host "  ✅ RELEASE READY" -ForegroundColor Green
Write-Host "================================================"
Write-Host ""
Write-Host "Archivos generados:"
Write-Host "  📦 $VPK_NAME"
Write-Host "  🔐 $($VPK_NAME -replace '.vpk$','').md5"
Write-Host "  🔐 $($VPK_NAME -replace '.vpk$','').sha256"
Write-Host ""

$VpkSize = (Get-Item $VPK_NAME).Length / 1KB
Write-Host "Tamaño del VPK: $([math]::Round($VpkSize, 2)) KB"
Write-Host ""

Write-Host "Checksums:"
$md5Content = Get-Content "$($VPK_NAME -replace '.vpk$','').md5"
$sha256Content = Get-Content "$($VPK_NAME -replace '.vpk$','').sha256"
Write-Host "  MD5:    $($md5Content.Split(' ')[0])"
Write-Host "  SHA256: $($sha256Content.Split(' ')[0])"
Write-Host ""

Write-Host "================================================"
Write-Host "  Próximos pasos:"
Write-Host "================================================"
Write-Host ""
Write-Host "1. Probar el VPK en tu PS Vita (¡MUY IMPORTANTE!)"
Write-Host ""
Write-Host "2. Si funciona correctamente, crear tag de Git:"
Write-Host "   git tag -a v$VERSION -m `"Release v$VERSION - Stable`""
Write-Host "   git push origin v$VERSION"
Write-Host ""
Write-Host "3. Crear Release en GitHub:"
Write-Host "   - Ir a: https://github.com/tuusuario/VitaCast/releases/new"
Write-Host "   - Tag: v$VERSION"
Write-Host "   - Title: VitaCast v$VERSION - Stable Release"
Write-Host "   - Descripción: Ver README_RELEASE.md"
Write-Host ""
Write-Host "4. Subir estos archivos al Release:"
Write-Host "   - $VPK_NAME (principal)"
Write-Host "   - $($VPK_NAME -replace '.vpk$','').md5"
Write-Host "   - $($VPK_NAME -replace '.vpk$','').sha256"
Write-Host "   - INSTALL.md"
Write-Host "   - RELEASE_NOTES.md"
Write-Host ""
Write-Host "5. Marcar como 'Latest release' y publicar"
Write-Host ""
Write-Host "================================================"
Write-Host ""
Write-Host "⚠️  IMPORTANTE: Prueba el VPK antes de publicar" -ForegroundColor Yellow
Write-Host ""
Write-Host "🎉 ¡Release preparado exitosamente!" -ForegroundColor Green
Write-Host ""

