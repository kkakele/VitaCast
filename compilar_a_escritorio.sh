#!/bin/bash

# Script para compilar VitaCast y dejar VPKs en el escritorio de Windows
# NO requiere GitHub ni contrase?as
# Uso: ./compilar_a_escritorio.sh

set -e

echo "????????????????????????????????????????????????????"
echo "?? VitaCast - Compilar a Escritorio"
echo "????????????????????????????????????????????????????"
echo ""

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Detectar ruta del escritorio de Windows desde WSL
WINDOWS_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
DESKTOP="/mnt/c/Users/$WINDOWS_USER/Desktop"

# Verificar que existe el escritorio
if [ ! -d "$DESKTOP" ]; then
    echo -e "${RED}? No se pudo encontrar el escritorio de Windows${NC}"
    echo "Intentando rutas alternativas..."
    
    # Probar otras rutas comunes
    if [ -d "/mnt/c/Users/$WINDOWS_USER/Escritorio" ]; then
        DESKTOP="/mnt/c/Users/$WINDOWS_USER/Escritorio"
    elif [ -d "/mnt/c/Users/$USER/Desktop" ]; then
        DESKTOP="/mnt/c/Users/$USER/Desktop"
    elif [ -d "/mnt/c/Users/$USER/Escritorio" ]; then
        DESKTOP="/mnt/c/Users/$USER/Escritorio"
    else
        echo -e "${RED}No se pudo detectar el escritorio autom?ticamente${NC}"
        echo -n "Ingresa la ruta a tu escritorio (ej: /mnt/c/Users/TuNombre/Desktop): "
        read DESKTOP
    fi
fi

echo -e "${BLUE}?? Escritorio detectado: $DESKTOP${NC}"
echo ""

# Verificar que VitaSDK est? instalado
if ! command -v arm-vita-eabi-gcc &> /dev/null; then
    echo -e "${RED}? Error: VitaSDK no est? instalado${NC}"
    echo "Por favor instala VitaSDK primero"
    exit 1
fi

# Verificar vita2d
if [ ! -f "$VITASDK/arm-vita-eabi/include/vita2d.h" ]; then
    echo -e "${YELLOW}??  Advertencia: vita2d no est? instalado${NC}"
    echo "Para instalarlo ejecuta:"
    echo "  cd /tmp && git clone https://github.com/xerpi/vita2d"
    echo "  cd vita2d/libvita2d && make -j4 && sudo make install"
    echo ""
    exit 1
fi

echo -e "${GREEN}? Pre-checks pasados${NC}"
echo ""

# Crear carpeta en el escritorio
FOLDER_NAME="VitaCast_$(date +%Y%m%d_%H%M%S)"
OUTPUT_DIR="$DESKTOP/$FOLDER_NAME"
mkdir -p "$OUTPUT_DIR"

echo -e "${BLUE}?? Carpeta creada: $FOLDER_NAME${NC}"
echo ""

# COMPILAR VERSI?N SIMPLE
echo -e "${BLUE}?? Paso 1/2: Compilando versi?n simple...${NC}"
make -f Makefile clean > /dev/null 2>&1 || true
if make -f Makefile; then
    if [ -f "VitaCast.vpk" ]; then
        cp VitaCast.vpk "$OUTPUT_DIR/VitaCast-Simple.vpk"
        SIZE=$(du -h "$OUTPUT_DIR/VitaCast-Simple.vpk" | cut -f1)
        echo -e "${GREEN}? VitaCast-Simple.vpk generado ($SIZE)${NC}"
        rm VitaCast.vpk
    else
        echo -e "${RED}? No se gener? VitaCast.vpk (versi?n simple)${NC}"
    fi
else
    echo -e "${RED}? Error al compilar versi?n simple${NC}"
fi
echo ""

# COMPILAR VERSI?N COMPLETA
echo -e "${BLUE}?? Paso 2/2: Compilando versi?n completa...${NC}"
make -f Makefile_complete clean > /dev/null 2>&1 || true
if make -f Makefile_complete; then
    if [ -f "VitaCast.vpk" ]; then
        cp VitaCast.vpk "$OUTPUT_DIR/VitaCast.vpk"
        SIZE=$(du -h "$OUTPUT_DIR/VitaCast.vpk" | cut -f1)
        echo -e "${GREEN}? VitaCast.vpk generado ($SIZE)${NC}"
    else
        echo -e "${RED}? No se gener? VitaCast.vpk (versi?n completa)${NC}"
    fi
else
    echo -e "${RED}? Error al compilar versi?n completa${NC}"
fi
echo ""

# Crear archivo README en la carpeta
cat > "$OUTPUT_DIR/LEEME.txt" << EOF
VitaCast - Compilado el $(date +"%Y-%m-%d %H:%M:%S")

ARCHIVOS INCLUIDOS:
==================

1. VitaCast.vpk (versi?n completa)
   - Incluye: UI Manager, Audio Player, Network Manager
   - Tama?o: ~210 KB

2. VitaCast-Simple.vpk (versi?n b?sica)
   - Solo funcionalidad b?sica
   - Tama?o: ~72 KB

INSTALACI?N EN PS VITA:
======================

1. Copia el VPK que prefieras a tu PS Vita
   - Usa USB, FTP o cualquier m?todo

2. Abre VitaShell en tu PS Vita

3. Navega al VPK y presiona X para instalar

4. ?Listo! Busca VitaCast en tu LiveArea

CONTROLES:
=========

- D-Pad: Navegar por men?s
- X: Seleccionar opci?n
- O: Volver al men? anterior
- START: Salir de la aplicaci?n

REQUISITOS:
==========

- PS Vita con firmware 3.60+
- HENkaku/Enso instalado
- ~100MB de espacio libre

?Disfruta de VitaCast! ????
EOF

# Resumen
echo -e "${GREEN}????????????????????????????????????????????????????${NC}"
echo -e "${GREEN}? ?Compilaci?n completada!${NC}"
echo -e "${GREEN}????????????????????????????????????????????????????${NC}"
echo ""
echo -e "${BLUE}?? Archivos generados en:${NC}"
echo "   $OUTPUT_DIR"
echo ""
echo -e "${BLUE}?? Contenido:${NC}"
ls -lh "$OUTPUT_DIR"
echo ""
echo -e "${YELLOW}?? Abre tu escritorio de Windows y busca la carpeta:${NC}"
echo -e "   ${GREEN}$FOLDER_NAME${NC}"
echo ""
echo -e "${BLUE}?? Pasos siguientes:${NC}"
echo "   1. Abre la carpeta en tu escritorio"
echo "   2. Copia VitaCast.vpk a tu PS Vita"
echo "   3. Instala con VitaShell"
echo "   4. ?Disfruta!"
echo ""

# Abrir explorador de Windows en la carpeta (opcional)
echo -n "?Quieres abrir la carpeta en el Explorador de Windows? (s/N): "
read OPEN_EXPLORER
if [[ $OPEN_EXPLORER =~ ^[Ss]$ ]]; then
    # Convertir ruta WSL a Windows
    WINDOWS_PATH=$(wslpath -w "$OUTPUT_DIR")
    explorer.exe "$WINDOWS_PATH" 2>/dev/null &
    echo -e "${GREEN}? Explorador abierto${NC}"
fi

echo ""
echo -e "${GREEN}?? ?Todo listo!${NC}"
