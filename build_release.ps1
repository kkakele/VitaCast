# VitaCast Release Build Script v2.0.1 (PowerShell)
# Este script compila y prepara VitaCast para release en Windows

$ErrorActionPreference = "Stop"

Write-Host "======================================"
Write-Host "  VitaCast Release Build System"
Write-Host "  Version 2.0.1"
Write-Host "======================================"
Write-Host ""

# Verificar que VitaSDK esté instalado
if (-not $env:VITASDK) {
    Write-Host "❌ ERROR: VITASDK no está configurado" -ForegroundColor Red
    Write-Host "Por favor, configura la variable de entorno VITASDK"
    exit 1
}

Write-Host "✅ VitaSDK encontrado en: $env:VITASDK" -ForegroundColor Green
Write-Host ""

# Limpiar builds anteriores
Write-Host "🧹 Limpiando builds anteriores..."
try {
    & make -f Makefile_final clean 2>$null
} catch {
    # Ignorar errores de limpieza
}
Write-Host "✅ Limpieza completada" -ForegroundColor Green
Write-Host ""

# Compilar versión release
Write-Host "🔨 Compilando VitaCast v2.0.1 (Release)..."
Write-Host ""

try {
    & make -f Makefile_final release
    
    Write-Host ""
    Write-Host "======================================"
    Write-Host "  ✅ BUILD EXITOSO" -ForegroundColor Green
    Write-Host "======================================"
    Write-Host ""
    Write-Host "Archivos generados:"
    Write-Host "  📦 VitaCast.vpk"
    Write-Host "  📄 eboot.bin"
    Write-Host "  📄 param.sfo"
    Write-Host ""
    
    # Verificar que el VPK existe
    if (Test-Path "VitaCast.vpk") {
        $VpkSize = (Get-Item "VitaCast.vpk").Length / 1KB
        Write-Host "  Tamaño del VPK: $([math]::Round($VpkSize, 2)) KB"
        Write-Host ""
        Write-Host "🎉 ¡VitaCast está listo para release!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Próximos pasos:"
        Write-Host "  1. Prueba el VPK en tu PS Vita"
        Write-Host "  2. Verifica que funcione correctamente"
        Write-Host "  3. Si todo está bien, súbelo a GitHub Releases"
        Write-Host ""
        Write-Host "Para instalar en tu Vita:"
        Write-Host "  - Copia VitaCast.vpk a tu Vita via USB/FTP"
        Write-Host "  - Instala con VitaShell"
        Write-Host "  - ¡Disfruta!"
        Write-Host ""
    } else {
        Write-Host "❌ ERROR: VitaCast.vpk no se generó" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host ""
    Write-Host "======================================"
    Write-Host "  ❌ BUILD FALLÓ" -ForegroundColor Red
    Write-Host "======================================"
    Write-Host ""
    Write-Host "Error: $_"
    Write-Host ""
    Write-Host "Revisa los errores arriba y corrígelos"
    exit 1
}

