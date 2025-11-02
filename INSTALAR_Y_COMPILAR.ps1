# Script Simplificado para Instalar VitaSDK y Compilar VitaCast
# Ejecutar como Administrador

param(
    [switch]$SkipInstall = $false
)

$ErrorActionPreference = "Stop"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  VitaCast - Instalacion y Compilacion" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar permisos de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin -and -not $SkipInstall) {
    Write-Host "Este script necesita ejecutarse como Administrador" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Click derecho en PowerShell -> Ejecutar como administrador" -ForegroundColor White
    Write-Host "Luego ejecuta: .\INSTALAR_VITASDK_Y_COMPILAR.ps1" -ForegroundColor White
    exit 1
}

# Verificar WSL
if (-not $SkipInstall) {
    Write-Host "PASO 1: Verificando WSL2..." -ForegroundColor Green
    
    try {
        $wslStatus = wsl --status 2>&1
        Write-Host "OK: WSL2 ya instalado" -ForegroundColor Green
    } catch {
        Write-Host "WSL2 no esta instalado. Instalando..." -ForegroundColor Yellow
        Write-Host "Esto puede tomar varios minutos y requerir reinicio" -ForegroundColor Yellow
        
        $response = Read-Host "Continuar? (S/N)"
        if ($response -ne 'S' -and $response -ne 's') {
            Write-Host "Instalacion cancelada" -ForegroundColor Red
            exit 1
        }
        
        Write-Host "Instalando WSL2..." -ForegroundColor Cyan
        wsl --install -d Ubuntu
        
        Write-Host ""
        Write-Host "REINICIO REQUERIDO" -ForegroundColor Yellow
        Write-Host "Despues de reiniciar, ejecuta este script de nuevo" -ForegroundColor White
        exit 0
    }
}

# Instalar VitaSDK en WSL
Write-Host ""
Write-Host "PASO 2: Instalando VitaSDK en WSL..." -ForegroundColor Green
Write-Host "(Esto puede tomar 15-30 minutos)" -ForegroundColor Yellow
Write-Host ""

$vitasdkScript = @'
#!/bin/bash
set -e

echo "Instalando VitaSDK..."
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Actualizar sistema
sudo apt-get update -qq
sudo apt-get install -y -qq make git cmake python3 wget curl build-essential

# Crear directorio
if [ ! -d "$VITASDK" ]; then
    sudo mkdir -p $VITASDK
    sudo chown -R $USER:$USER $VITASDK
fi

# Clonar vdpm
if [ ! -d "$HOME/vdpm" ]; then
    cd $HOME
    git clone https://github.com/vitasdk/vdpm
fi

# Instalar VitaSDK
cd $HOME/vdpm
./bootstrap-vitasdk.sh

# Instalar paquetes adicionales
./vdpm vita2d

# Añadir al bashrc
if ! grep -q "VITASDK" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# VitaSDK" >> ~/.bashrc
    echo "export VITASDK=/usr/local/vitasdk" >> ~/.bashrc
    echo "export PATH=\$VITASDK/bin:\$PATH" >> ~/.bashrc
fi

echo "VitaSDK instalado correctamente"
arm-vita-eabi-gcc --version
'@

$scriptPath = "/tmp/install_vitasdk.sh"
$vitasdkScript | wsl bash -c "cat > $scriptPath && chmod +x $scriptPath"

Write-Host "Ejecutando instalacion de VitaSDK..." -ForegroundColor Cyan
wsl bash /tmp/install_vitasdk.sh

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Error al instalar VitaSDK" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "OK: VitaSDK instalado" -ForegroundColor Green
Write-Host ""

# Compilar VitaCast
Write-Host "PASO 3: Compilando VitaCast v2.0.1..." -ForegroundColor Green
Write-Host ""

$currentDir = Get-Location
$wslPath = wsl wslpath -a $currentDir

$compileScript = @"
#!/bin/bash
set -e

export VITASDK=/usr/local/vitasdk
export PATH=\$VITASDK/bin:\$PATH

cd '$wslPath'

echo "Limpiando builds anteriores..."
make -f Makefile_final clean 2>/dev/null || true

echo ""
echo "Compilando version release..."
echo ""

make -f Makefile_final release

if [ \$? -eq 0 ]; then
    echo ""
    echo "COMPILACION EXITOSA"
    echo ""
    ls -lh VitaCast.vpk
else
    echo "Error en la compilacion"
    exit 1
fi
"@

$compileScript | wsl bash

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Error al compilar" -ForegroundColor Red
    exit 1
}

# Preparar release
Write-Host ""
Write-Host "PASO 4: Preparando archivos de release..." -ForegroundColor Green
Write-Host ""

if (Test-Path "VitaCast.vpk") {
    Move-Item -Path "VitaCast.vpk" -Destination "VitaCast-v2.0.1.vpk" -Force
    
    $md5 = Get-FileHash -Path "VitaCast-v2.0.1.vpk" -Algorithm MD5
    $sha256 = Get-FileHash -Path "VitaCast-v2.0.1.vpk" -Algorithm SHA256
    
    $md5.Hash.ToLower() + "  VitaCast-v2.0.1.vpk" | Out-File -FilePath "VitaCast-v2.0.1.md5" -Encoding ASCII
    $sha256.Hash.ToLower() + "  VitaCast-v2.0.1.vpk" | Out-File -FilePath "VitaCast-v2.0.1.sha256" -Encoding ASCII
    
    Write-Host "OK: Archivos preparados" -ForegroundColor Green
    Write-Host "  VitaCast-v2.0.1.vpk" -ForegroundColor White
    Write-Host "  Checksums MD5 y SHA256" -ForegroundColor White
    
    $vpkSize = (Get-Item "VitaCast-v2.0.1.vpk").Length / 1KB
    Write-Host ""
    Write-Host "Tamaño: $([math]::Round($vpkSize, 2)) KB" -ForegroundColor Cyan
    Write-Host ""
    
} else {
    Write-Host "Error: No se encontro VitaCast.vpk" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  COMPILACION COMPLETADA" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Proximo paso:" -ForegroundColor White
Write-Host "  .\SUBIR_RELEASE_SIMPLE.ps1" -ForegroundColor Cyan
Write-Host "  Para subir el release a GitHub" -ForegroundColor White
Write-Host ""

