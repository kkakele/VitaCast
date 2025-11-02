# Script para Instalar VitaSDK y Compilar VitaCast v2.0.1
# Ejecutar como Administrador en PowerShell

param(
    [switch]$SkipInstall = $false
)

$ErrorActionPreference = "Stop"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  VitaCast - Instalación de VitaSDK" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin -and -not $SkipInstall) {
    Write-Host "⚠️  Este script necesita ejecutarse como Administrador" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opciones:" -ForegroundColor White
    Write-Host "1. Click derecho en PowerShell → 'Ejecutar como administrador'" -ForegroundColor White
    Write-Host "2. Luego ejecuta: .\INSTALAR_VITASDK_Y_COMPILAR.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "O si ya tienes VitaSDK instalado:" -ForegroundColor White
    Write-Host "  .\INSTALAR_VITASDK_Y_COMPILAR.ps1 -SkipInstall" -ForegroundColor White
    exit 1
}

# ==========================================
# PASO 1: Verificar/Instalar WSL2
# ==========================================

if (-not $SkipInstall) {
    Write-Host "📦 PASO 1: Verificando WSL2..." -ForegroundColor Green
    
    try {
        $wslStatus = wsl --status 2>&1
        Write-Host "✅ WSL2 ya está instalado" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  WSL2 no está instalado. Instalando..." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Esto puede tomar varios minutos y requerirá reiniciar." -ForegroundColor Yellow
        
        $response = Read-Host "¿Continuar con la instalación? (S/N)"
        if ($response -ne 'S' -and $response -ne 's') {
            Write-Host "Instalación cancelada." -ForegroundColor Red
            exit 1
        }
        
        Write-Host "Instalando WSL2..." -ForegroundColor Cyan
        wsl --install -d Ubuntu
        
        Write-Host ""
        Write-Host "=============================================" -ForegroundColor Yellow
        Write-Host "  ⚠️  REINICIO REQUERIDO" -ForegroundColor Yellow
        Write-Host "=============================================" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "WSL2 se ha instalado pero necesitas reiniciar tu PC." -ForegroundColor White
        Write-Host ""
        Write-Host "Después de reiniciar:" -ForegroundColor White
        Write-Host "1. Abre Ubuntu desde el menú inicio" -ForegroundColor White
        Write-Host "2. Configura usuario y contraseña" -ForegroundColor White
        Write-Host "3. Ejecuta este script nuevamente" -ForegroundColor White
        Write-Host ""
        
        $restart = Read-Host "¿Reiniciar ahora? (S/N)"
        if ($restart -eq 'S' -or $restart -eq 's') {
            Restart-Computer
        }
        exit 0
    }
}

# ==========================================
# PASO 2: Instalar VitaSDK en WSL
# ==========================================

Write-Host ""
Write-Host "📦 PASO 2: Instalando VitaSDK en WSL..." -ForegroundColor Green
Write-Host ""

$vitasdkScript = @'
#!/bin/bash
set -e

echo "============================================="
echo "  Instalando VitaSDK"
echo "============================================="
echo ""

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt-get update -qq

# Instalar dependencias
echo "📦 Instalando dependencias..."
sudo apt-get install -y -qq make git cmake python3 wget curl build-essential

# Configurar variables de entorno
echo "🔧 Configurando variables de entorno..."
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Crear directorio si no existe
if [ ! -d "$VITASDK" ]; then
    echo "📁 Creando directorio VitaSDK..."
    sudo mkdir -p $VITASDK
    sudo chown -R $USER:$USER $VITASDK
fi

# Clonar vdpm si no existe
if [ ! -d "$HOME/vdpm" ]; then
    echo "📥 Clonando vdpm..."
    cd $HOME
    git clone https://github.com/vitasdk/vdpm
fi

# Instalar VitaSDK
echo "🔨 Instalando VitaSDK (esto puede tomar 15-30 minutos)..."
cd $HOME/vdpm
./bootstrap-vitasdk.sh

# Instalar paquetes adicionales
echo "📦 Instalando paquetes adicionales..."
./vdpm vita2d

# Añadir al bashrc
if ! grep -q "VITASDK" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# VitaSDK" >> ~/.bashrc
    echo "export VITASDK=/usr/local/vitasdk" >> ~/.bashrc
    echo "export PATH=\$VITASDK/bin:\$PATH" >> ~/.bashrc
fi

echo ""
echo "============================================="
echo "  ✅ VitaSDK instalado correctamente"
echo "============================================="
echo ""
echo "Verifica la instalación:"
arm-vita-eabi-gcc --version
'@

$scriptPath = "/tmp/install_vitasdk.sh"
$vitasdkScript | wsl bash -c "cat > $scriptPath && chmod +x $scriptPath"

Write-Host "Ejecutando instalación de VitaSDK en WSL..." -ForegroundColor Cyan
Write-Host "(Esto puede tomar 15-30 minutos)" -ForegroundColor Yellow
Write-Host ""

wsl bash /tmp/install_vitasdk.sh

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Error al instalar VitaSDK" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ VitaSDK instalado exitosamente" -ForegroundColor Green
Write-Host ""

# ==========================================
# PASO 3: Compilar VitaCast
# ==========================================

Write-Host "📦 PASO 3: Compilando VitaCast v2.0.1..." -ForegroundColor Green
Write-Host ""

$currentDir = Get-Location
$wslPath = wsl wslpath -a $currentDir

$compileScript = @"
#!/bin/bash
set -e

export VITASDK=/usr/local/vitasdk
export PATH=\$VITASDK/bin:\$PATH

cd '$wslPath'

echo "🧹 Limpiando builds anteriores..."
make -f Makefile_final clean 2>/dev/null || true

echo ""
echo "🔨 Compilando versión release optimizada..."
echo ""

make -f Makefile_final release

if [ \$? -eq 0 ]; then
    echo ""
    echo "============================================="
    echo "  ✅ COMPILACIÓN EXITOSA"
    echo "============================================="
    echo ""
    ls -lh VitaCast.vpk
    echo ""
else
    echo ""
    echo "❌ Error en la compilación"
    exit 1
fi
"@

$compileScript | wsl bash

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Error al compilar" -ForegroundColor Red
    exit 1
}

# ==========================================
# PASO 4: Preparar Release
# ==========================================

Write-Host ""
Write-Host "📦 PASO 4: Preparando archivos de release..." -ForegroundColor Green
Write-Host ""

if (Test-Path "VitaCast.vpk") {
    # Renombrar
    Move-Item -Path "VitaCast.vpk" -Destination "VitaCast-v2.0.1.vpk" -Force
    
    # Generar checksums
    $md5 = Get-FileHash -Path "VitaCast-v2.0.1.vpk" -Algorithm MD5
    $sha256 = Get-FileHash -Path "VitaCast-v2.0.1.vpk" -Algorithm SHA256
    
    $md5.Hash.ToLower() + "  VitaCast-v2.0.1.vpk" | Out-File -FilePath "VitaCast-v2.0.1.md5" -Encoding ASCII
    $sha256.Hash.ToLower() + "  VitaCast-v2.0.1.vpk" | Out-File -FilePath "VitaCast-v2.0.1.sha256" -Encoding ASCII
    
    Write-Host "✅ Archivos preparados:" -ForegroundColor Green
    Write-Host "  📦 VitaCast-v2.0.1.vpk" -ForegroundColor White
    Write-Host "  🔐 VitaCast-v2.0.1.md5" -ForegroundColor White
    Write-Host "  🔐 VitaCast-v2.0.1.sha256" -ForegroundColor White
    
    $vpkSize = (Get-Item "VitaCast-v2.0.1.vpk").Length / 1KB
    Write-Host ""
    Write-Host "  Tamaño: $([math]::Round($vpkSize, 2)) KB" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  MD5:    $($md5.Hash.ToLower())" -ForegroundColor Cyan
    Write-Host "  SHA256: $($sha256.Hash.ToLower())" -ForegroundColor Cyan
    
} else {
    Write-Host "❌ No se encontró VitaCast.vpk" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  ✅ ¡TODO COMPLETADO!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Próximo paso:" -ForegroundColor White
Write-Host "  Ejecuta: .\SUBIR_A_GITHUB.ps1" -ForegroundColor Cyan
Write-Host "  Para subir el release a GitHub automáticamente" -ForegroundColor White
Write-Host ""

