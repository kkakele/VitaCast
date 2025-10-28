# Script para crear VPK funcional para VitaShell
# Soluciona problemas de instalación

Write-Host "🔧 Creando VPK funcional para VitaShell..." -ForegroundColor Cyan

# Verificar archivos necesarios
if (-not (Test-Path "eboot.bin")) {
    Write-Host "❌ eboot.bin no encontrado" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "param.sfo")) {
    Write-Host "❌ param.sfo no encontrado" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Archivos base encontrados" -ForegroundColor Green

# Crear directorio temporal para VPK
$tempDir = "temp_vpk"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

# Copiar archivos necesarios
Copy-Item "eboot.bin" "$tempDir/"
Copy-Item "param.sfo" "$tempDir/"

# Crear directorio de assets si no existe
if (-not (Test-Path "assets")) {
    New-Item -ItemType Directory -Path "assets" | Out-Null
}

# Copiar assets si existen
if (Test-Path "assets") {
    Copy-Item "assets" "$tempDir/" -Recurse
}

Write-Host "📦 Creando VPK funcional..." -ForegroundColor Yellow

# Crear VPK usando PowerShell (método simple)
$vpkName = "VitaCast-Functional.vpk"

# Crear archivo ZIP como base (VPK es básicamente un ZIP)
Compress-Archive -Path "$tempDir/*" -DestinationPath "$vpkName" -Force

# Limpiar directorio temporal
Remove-Item $tempDir -Recurse -Force

# Verificar VPK creado
if (Test-Path $vpkName) {
    $size = (Get-Item $vpkName).Length
    Write-Host "✅ VPK funcional creado: $vpkName" -ForegroundColor Green
    Write-Host "   Tamaño: $size bytes" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "📋 Instrucciones para VitaShell:" -ForegroundColor Cyan
    Write-Host "1. Copia $vpkName a tu Vita" -ForegroundColor White
    Write-Host "2. En VitaShell, navega al archivo" -ForegroundColor White
    Write-Host "3. Presiona X para instalar" -ForegroundColor White
    Write-Host "4. Si sigue dando error, prueba:" -ForegroundColor White
    Write-Host "   - Reiniciar la Vita" -ForegroundColor Yellow
    Write-Host "   - Verificar que tienes HENkaku activo" -ForegroundColor Yellow
    Write-Host "   - Usar VPK Installer en lugar de VitaShell" -ForegroundColor Yellow
    
} else {
    Write-Host "❌ Error creando VPK" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎵 VitaCast - VPK funcional listo!" -ForegroundColor Magenta
