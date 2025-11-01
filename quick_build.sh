#!/bin/bash

# Script r?pido para compilar (sin crear release)
# Uso: ./quick_build.sh

set -e

echo "?? Compilando VitaCast..."

# Compilar versi?n simple
echo "? Versi?n simple..."
make -f Makefile clean
make -f Makefile
mv VitaCast.vpk VitaCast-Simple.vpk

# Compilar versi?n completa
echo "? Versi?n completa..."
make -f Makefile_complete clean
make -f Makefile_complete

echo ""
echo "? Compilaci?n completada"
echo ""
ls -lh VitaCast.vpk VitaCast-Simple.vpk
echo ""
echo "?? VPKs generados:"
echo "   - VitaCast.vpk (completo)"
echo "   - VitaCast-Simple.vpk (b?sico)"
