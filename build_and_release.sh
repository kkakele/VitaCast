#!/bin/bash

# Script para compilar VitaCast y subir autom?ticamente a GitHub Releases
# Uso: ./build_and_release.sh

set -e  # Salir si hay error

echo "????????????????????????????????????????????????????"
echo "?? VitaCast - Build & Release Autom?tico"
echo "????????????????????????????????????????????????????"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verificar que estamos en el directorio correcto
if [ ! -f "Makefile" ] || [ ! -f "Makefile_complete" ]; then
    echo -e "${RED}? Error: No est?s en el directorio de VitaCast${NC}"
    echo "Por favor ejecuta este script desde la ra?z del proyecto"
    exit 1
fi

# Verificar que VitaSDK est? instalado
if ! command -v arm-vita-eabi-gcc &> /dev/null; then
    echo -e "${RED}? Error: VitaSDK no est? instalado${NC}"
    echo "Por favor instala VitaSDK primero (ver COMPILAR_EN_WSL.md)"
    exit 1
fi

# Verificar que gh est? instalado
if ! command -v gh &> /dev/null; then
    echo -e "${RED}? Error: GitHub CLI (gh) no est? instalado${NC}"
    echo "Instala con: sudo apt install gh"
    exit 1
fi

# Verificar autenticaci?n de gh
if ! gh auth status &> /dev/null; then
    echo -e "${RED}? Error: No est?s autenticado con GitHub CLI${NC}"
    echo "Ejecuta: gh auth login"
    exit 1
fi

echo -e "${BLUE}?? Pre-checks pasados ?${NC}"
echo ""

# Pedir versi?n
echo -e "${YELLOW}? ?Qu? versi?n quieres crear?${NC}"
echo "   Formato: X.Y.Z (sin 'v')"
echo "   Ejemplo: 2.7.3"
echo -n "   Versi?n: "
read VERSION

# Validar formato de versi?n
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}? Error: Formato de versi?n inv?lido${NC}"
    echo "Debe ser: X.Y.Z (ej: 2.7.3)"
    exit 1
fi

TAG="v$VERSION"

# Verificar si el tag ya existe
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo -e "${YELLOW}??  El tag $TAG ya existe${NC}"
    echo -n "?Quieres recrearlo? (s/N): "
    read RECREATE
    if [[ $RECREATE =~ ^[Ss]$ ]]; then
        echo "Eliminando tag existente..."
        git tag -d $TAG
        git push --delete origin $TAG 2>/dev/null || true
    else
        echo "Saliendo..."
        exit 0
    fi
fi

echo ""
echo -e "${BLUE}?? Paso 1/5: Compilando versi?n simple...${NC}"
make -f Makefile clean
make -f Makefile
if [ ! -f "VitaCast.vpk" ]; then
    echo -e "${RED}? Error: No se gener? VitaCast.vpk${NC}"
    exit 1
fi
mv VitaCast.vpk VitaCast-Simple.vpk
echo -e "${GREEN}? VitaCast-Simple.vpk generado${NC}"

echo ""
echo -e "${BLUE}?? Paso 2/5: Compilando versi?n completa...${NC}"
make -f Makefile_complete clean
make -f Makefile_complete
if [ ! -f "VitaCast.vpk" ]; then
    echo -e "${RED}? Error: No se gener? VitaCast.vpk${NC}"
    exit 1
fi
echo -e "${GREEN}? VitaCast.vpk generado${NC}"

echo ""
echo -e "${BLUE}?? Paso 3/5: Verificando archivos...${NC}"
ls -lh VitaCast.vpk VitaCast-Simple.vpk
echo ""

# Calcular tama?os
SIZE_FULL=$(du -h VitaCast.vpk | cut -f1)
SIZE_SIMPLE=$(du -h VitaCast-Simple.vpk | cut -f1)

echo -e "${GREEN}? Archivos listos:${NC}"
echo "   - VitaCast.vpk: $SIZE_FULL"
echo "   - VitaCast-Simple.vpk: $SIZE_SIMPLE"

echo ""
echo -e "${BLUE}???  Paso 4/5: Creando tag y commit...${NC}"

# Verificar si hay cambios sin commitear
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}??  Hay cambios sin commitear${NC}"
    echo -n "?Quieres commitearlos? (s/N): "
    read COMMIT_CHANGES
    if [[ $COMMIT_CHANGES =~ ^[Ss]$ ]]; then
        git add .
        echo -n "Mensaje del commit: "
        read COMMIT_MSG
        git commit -m "$COMMIT_MSG"
        git push origin $(git branch --show-current)
    fi
fi

# Crear tag
git tag -a $TAG -m "VitaCast $TAG

Release compilado localmente en WSL

Archivos incluidos:
- VitaCast.vpk ($SIZE_FULL) - Versi?n completa
- VitaCast-Simple.vpk ($SIZE_SIMPLE) - Versi?n b?sica"

git push origin $TAG
echo -e "${GREEN}? Tag $TAG creado y pusheado${NC}"

echo ""
echo -e "${BLUE}?? Paso 5/5: Creando release en GitHub...${NC}"

# Crear notas del release
RELEASE_NOTES="# ?? VitaCast $TAG

## ?? Descargas

- **VitaCast.vpk** ($SIZE_FULL) - Versi?n completa
- **VitaCast-Simple.vpk** ($SIZE_SIMPLE) - Versi?n b?sica

## ?? Instalaci?n

1. Descarga el VPK que prefieras
2. Transfiere a tu PS Vita con VitaShell
3. Instala el VPK
4. ?Disfruta!

## ?? Controles

- **D-Pad**: Navegar
- **X**: Seleccionar
- **O**: Volver
- **START**: Salir

## ?? Compilado con

- **VitaSDK**: $(arm-vita-eabi-gcc --version | head -1)
- **Plataforma**: WSL / Ubuntu
- **Fecha**: $(date +'%Y-%m-%d %H:%M:%S')

---

**Compilado localmente** ????"

# Crear release
gh release create $TAG \
    VitaCast.vpk \
    VitaCast-Simple.vpk \
    --title "VitaCast $TAG" \
    --notes "$RELEASE_NOTES"

echo ""
echo -e "${GREEN}????????????????????????????????????????????????????${NC}"
echo -e "${GREEN}? ?Release $TAG creado exitosamente!${NC}"
echo -e "${GREEN}????????????????????????????????????????????????????${NC}"
echo ""
echo -e "${BLUE}?? URL del release:${NC}"
gh release view $TAG --web --repo kkakele/VitaCast 2>/dev/null || \
    echo "https://github.com/kkakele/VitaCast/releases/tag/$TAG"
echo ""
echo -e "${BLUE}?? Descargas directas:${NC}"
echo "   VitaCast.vpk:"
echo "   https://github.com/kkakele/VitaCast/releases/download/$TAG/VitaCast.vpk"
echo ""
echo "   VitaCast-Simple.vpk:"
echo "   https://github.com/kkakele/VitaCast/releases/download/$TAG/VitaCast-Simple.vpk"
echo ""
echo -e "${GREEN}?? ?Listo para instalar en PS Vita!${NC}"
