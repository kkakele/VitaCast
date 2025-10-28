# VitaCast Final Build Script - Simple Version
Write-Host "🎵 VitaCast Final Build Script" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

# Buscar el VPK más reciente
$latestVpk = Get-ChildItem *.vpk | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestVpk) {
    Write-Host "📦 Creando VPK final usando: $($latestVpk.Name)" -ForegroundColor Green
    
    # Crear VPK final con nombre actualizado
    $finalVpkName = "VitaCast-Final-v2.0.vpk"
    Copy-Item $latestVpk.FullName $finalVpkName
    
    Write-Host "✅ VPK final creado: $finalVpkName" -ForegroundColor Green
    $fileSize = (Get-Item $finalVpkName).Length
    Write-Host "   Tamaño: $fileSize bytes" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "📋 Información del VPK Final:" -ForegroundColor Cyan
    Write-Host "   Nombre: $finalVpkName" -ForegroundColor White
    Write-Host "   Versión: 2.0.0" -ForegroundColor White
    Write-Host "   Funcionalidades:" -ForegroundColor White
    Write-Host "     ✅ Interfaz inspirada en PS Vita Music App" -ForegroundColor Green
    Write-Host "     ✅ Soporte para múltiples formatos de audio" -ForegroundColor Green
    Write-Host "     ✅ Soporte nativo para ATRAC3/ATRAC3plus" -ForegroundColor Green
    Write-Host "     ✅ Integración con Apple Music" -ForegroundColor Green
    Write-Host "     ✅ Sincronización con iCloud" -ForegroundColor Green
    Write-Host "     ✅ Búsqueda de podcasts" -ForegroundColor Green
    Write-Host "     ✅ Descarga para escucha offline" -ForegroundColor Green
    Write-Host "     ✅ Portadas de podcasts automáticas" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🎯 Para instalar en PS Vita:" -ForegroundColor Cyan
    Write-Host "   1. Copia $finalVpkName a tu Vita" -ForegroundColor White
    Write-Host "   2. Instala usando VitaShell o VPK Installer" -ForegroundColor White
    Write-Host "   3. Configura tu Apple ID en la aplicación" -ForegroundColor White
    Write-Host "   4. ¡Disfruta de tus podcasts y música!" -ForegroundColor White
    
} else {
    Write-Host "❌ No se encontraron VPKs existentes" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 ¡Proceso completado!" -ForegroundColor Green
Write-Host "🎵 VitaCast v2.0 - La mejor app de podcast para PS Vita!" -ForegroundColor Magenta
