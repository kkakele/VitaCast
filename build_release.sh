#!/bin/bash

# Script para construir el release de VitaCast
# Este script compila el proyecto y prepara el VPK para subirlo a releases

set -e

echo "?? VitaCast - Build Release"
echo "============================"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
}

# Verificar que estamos en el directorio correcto
if [ ! -f "main.c" ] || [ ! -f "Makefile_complete" ]; then
    print_error "Ejecuta este script desde el directorio ra?z de VitaCast"
    exit 1
fi

print_header "?? Limpiando compilaciones anteriores..."
make -f Makefile_complete clean 2>/dev/null || true
rm -f VitaCast.vpk eboot.bin param.sfo *.o ui/*.o audio/*.o network/*.o apple/*.o 2>/dev/null || true

print_header "?? Compilando proyecto..."
if ! make -f Makefile_complete release; then
    print_error "Error en la compilaci?n"
    exit 1
fi

print_header "? Verificando archivos generados..."
if [ ! -f "VitaCast.vpk" ]; then
    print_error "No se gener? el VPK"
    exit 1
fi

if [ ! -f "eboot.bin" ]; then
    print_error "No se gener? eboot.bin"
    exit 1
fi

# Obtener informaci?n del VPK
VPK_SIZE=$(du -h VitaCast.vpk | cut -f1)
VPK_CHECKSUM=$(sha256sum VitaCast.vpk | cut -d' ' -f1)

print_status "VPK creado: VitaCast.vpk (${VPK_SIZE})"
print_status "SHA256: ${VPK_CHECKSUM}"

print_header "?? Preparando release..."

# Crear directorio de release si no existe
mkdir -p release

# Copiar VPK al directorio de release
cp VitaCast.vpk release/VitaCast-$(date +%Y%m%d-%H%M%S).vpk
cp VitaCast.vpk release/VitaCast-latest.vpk

# Crear archivo de informaci?n del release
cat > release/RELEASE_INFO.txt << EOF
VitaCast Release Information
============================

Fecha: $(date)
Versi?n: 2.0.0
Tama?o VPK: ${VPK_SIZE}
SHA256: ${VPK_CHECKSUM}

Requisitos:
- PlayStation Vita con firmware 3.60+ (recomendado 3.65+)
- HENkaku/Enso instalado
- Almacenamiento: M?nimo 100MB

Instalaci?n:
1. Copia el archivo .vpk a tu PlayStation Vita
2. Instala usando VitaShell o VPK Installer
3. Abre la aplicaci?n desde LiveArea

Caracter?sticas:
- Interfaz inspirada en PS Vita Music App
- Soporte para m?ltiples formatos de audio (MP3, AAC, OGG, WAV, M4A)
- Soporte nativo para ATRAC3/ATRAC3plus
- Integraci?n con Apple Music
- Sincronizaci?n con iCloud
- B?squeda de podcasts
- Descarga para escucha offline

Notas:
- Algunas caracter?sticas pueden requerir configuraci?n adicional
- Se requiere conexi?n WiFi para funcionalidades online
EOF

print_header "?? Informaci?n del Release:"
cat release/RELEASE_INFO.txt

echo ""
print_status "? Release preparado en el directorio 'release/'"
print_status "Archivos listos para subir a GitHub Releases:"
echo "  - release/VitaCast-latest.vpk"
echo "  - release/RELEASE_INFO.txt"
echo ""
print_status "SHA256 para verificaci?n: ${VPK_CHECKSUM}"
