#!/bin/bash

# VitaCast Release Preparation Script v2.0.1
# Este script prepara todo lo necesario para subir a GitHub Releases

set -e

VERSION="2.0.1"
VPK_NAME="VitaCast-v${VERSION}.vpk"

echo "================================================"
echo "  VitaCast v${VERSION} Release Preparation"
echo "================================================"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "Makefile_final" ]; then
    echo "❌ ERROR: No se encuentra Makefile_final"
    echo "¿Estás en el directorio correcto?"
    exit 1
fi

echo "✅ Directorio correcto"
echo ""

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
make -f Makefile_final clean 2>/dev/null || true
rm -f VitaCast*.vpk VitaCast*.md5 VitaCast*.sha256
echo "✅ Limpieza completada"
echo ""

# Compilar versión release
echo "🔨 Compilando VitaCast v${VERSION} (Release optimizado)..."
echo ""
make -f Makefile_final release

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ ERROR: La compilación falló"
    exit 1
fi

echo ""
echo "✅ Compilación exitosa"
echo ""

# Verificar que el VPK se generó
if [ ! -f "VitaCast.vpk" ]; then
    echo "❌ ERROR: VitaCast.vpk no se generó"
    exit 1
fi

# Renombrar VPK
echo "📦 Renombrando VPK..."
mv VitaCast.vpk "$VPK_NAME"
echo "✅ Renombrado a: $VPK_NAME"
echo ""

# Generar checksums
echo "🔐 Generando checksums..."
md5sum "$VPK_NAME" > "${VPK_NAME%.vpk}.md5"
sha256sum "$VPK_NAME" > "${VPK_NAME%.vpk}.sha256"
echo "✅ Checksums generados"
echo ""

# Mostrar información
echo "================================================"
echo "  ✅ RELEASE READY"
echo "================================================"
echo ""
echo "Archivos generados:"
echo "  📦 $VPK_NAME"
echo "  🔐 ${VPK_NAME%.vpk}.md5"
echo "  🔐 ${VPK_NAME%.vpk}.sha256"
echo ""

VPK_SIZE=$(du -h "$VPK_NAME" | cut -f1)
echo "Tamaño del VPK: $VPK_SIZE"
echo ""

echo "Checksums:"
echo "  MD5:    $(cat ${VPK_NAME%.vpk}.md5 | cut -d' ' -f1)"
echo "  SHA256: $(cat ${VPK_NAME%.vpk}.sha256 | cut -d' ' -f1)"
echo ""

echo "================================================"
echo "  Próximos pasos:"
echo "================================================"
echo ""
echo "1. Probar el VPK en tu PS Vita (¡MUY IMPORTANTE!)"
echo ""
echo "2. Si funciona correctamente, crear tag de Git:"
echo "   git tag -a v${VERSION} -m \"Release v${VERSION} - Stable\""
echo "   git push origin v${VERSION}"
echo ""
echo "3. Crear Release en GitHub:"
echo "   - Ir a: https://github.com/tuusuario/VitaCast/releases/new"
echo "   - Tag: v${VERSION}"
echo "   - Title: VitaCast v${VERSION} - Stable Release"
echo "   - Descripción: Ver README_RELEASE.md"
echo ""
echo "4. Subir estos archivos al Release:"
echo "   - $VPK_NAME (principal)"
echo "   - ${VPK_NAME%.vpk}.md5"
echo "   - ${VPK_NAME%.vpk}.sha256"
echo "   - INSTALL.md"
echo "   - RELEASE_NOTES.md"
echo ""
echo "5. Marcar como 'Latest release' y publicar"
echo ""
echo "================================================"
echo ""
echo "⚠️  IMPORTANTE: Prueba el VPK antes de publicar"
echo ""
echo "🎉 ¡Release preparado exitosamente!"
echo ""

