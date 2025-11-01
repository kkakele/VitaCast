#!/bin/bash

# Script para limpieza COMPLETA y verificaci?n

echo "?? LIMPIEZA COMPLETA DE ARCHIVOS DE COMPILACI?N"
echo "================================================"
echo ""

cd ~/VitaCast || exit 1

echo "1?? Limpiando con make clean..."
make -f Makefile_complete clean 2>/dev/null || true

echo ""
echo "2?? Eliminando TODOS los archivos .o..."
find . -name "*.o" -type f ! -path "./.deps/*" ! -path "./.git/*" -delete
rm -f *.o */*.o */*/*.o 2>/dev/null || true

echo ""
echo "3?? Eliminando archivos de compilaci?n antiguos..."
rm -f eboot.bin param.sfo VitaCast.vpk 2>/dev/null || true

echo ""
echo "4?? Verificando que no queden .o..."
ARCHIVOS_O=$(find . -name "*.o" -type f ! -path "./.deps/*" ! -path "./.git/*" 2>/dev/null | wc -l)
if [ "$ARCHIVOS_O" -eq 0 ]; then
    echo "   ? No quedan archivos .o"
else
    echo "   ??  A?n quedan $ARCHIVOS_O archivos .o:"
    find . -name "*.o" -type f ! -path "./.deps/*" ! -path "./.git/*" | head -5
fi

echo ""
echo "5?? Verificando Makefile..."
if grep -q "vita2d_vgl" Makefile_complete; then
    echo "   ? Makefile TODAV?A tiene vita2d_vgl - necesita actualizaci?n"
else
    echo "   ? Makefile NO tiene vita2d_vgl (correcto)"
fi

if grep -q "vita2d_stub" Makefile_complete; then
    echo "   ? Makefile tiene vita2d_stub (correcto)"
else
    echo "   ? Makefile NO tiene vita2d_stub - necesita actualizaci?n"
fi

echo ""
echo "? Limpieza completada. Ahora ejecuta:"
echo "   make -f Makefile_complete release"
