#!/bin/bash

# VitaCast Release Build Script v2.0.1
# Este script compila y prepara VitaCast para release

set -e  # Salir si hay errores

echo "======================================"
echo "  VitaCast Release Build System"
echo "  Version 2.0.1"
echo "======================================"
echo ""

# Verificar que VitaSDK esté instalado
if [ -z "$VITASDK" ]; then
    echo "❌ ERROR: VITASDK no está configurado"
    echo "Por favor, configura la variable de entorno VITASDK"
    exit 1
fi

echo "✅ VitaSDK encontrado en: $VITASDK"
echo ""

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
make -f Makefile_final clean 2>/dev/null || true
echo "✅ Limpieza completada"
echo ""

# Compilar versión release
echo "🔨 Compilando VitaCast v2.0.1 (Release)..."
echo ""
make -f Makefile_final release

if [ $? -eq 0 ]; then
    echo ""
    echo "======================================"
    echo "  ✅ BUILD EXITOSO"
    echo "======================================"
    echo ""
    echo "Archivos generados:"
    echo "  📦 VitaCast.vpk"
    echo "  📄 eboot.bin"
    echo "  📄 param.sfo"
    echo ""
    
    # Verificar que el VPK existe
    if [ -f "VitaCast.vpk" ]; then
        VPK_SIZE=$(du -h VitaCast.vpk | cut -f1)
        echo "  Tamaño del VPK: $VPK_SIZE"
        echo ""
        echo "🎉 ¡VitaCast está listo para release!"
        echo ""
        echo "Próximos pasos:"
        echo "  1. Prueba el VPK en tu PS Vita"
        echo "  2. Verifica que funcione correctamente"
        echo "  3. Si todo está bien, súbelo a GitHub Releases"
        echo ""
        echo "Para instalar en tu Vita:"
        echo "  - Copia VitaCast.vpk a tu Vita via USB/FTP"
        echo "  - Instala con VitaShell"
        echo "  - ¡Disfruta!"
        echo ""
    else
        echo "❌ ERROR: VitaCast.vpk no se generó"
        exit 1
    fi
else
    echo ""
    echo "======================================"
    echo "  ❌ BUILD FALLÓ"
    echo "======================================"
    echo ""
    echo "Revisa los errores arriba y corrígelos"
    exit 1
fi

