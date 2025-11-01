#!/bin/bash

# Script de diagn?stico completo para encontrar el problema

echo "?? DIAGN?STICO COMPLETO DE COMPILACI?N"
echo "========================================"
echo ""

cd ~/VitaCast || exit 1

echo "1?? Verificando Makefile_complete..."
echo "   OBJS:"
grep "^OBJS" Makefile_complete
echo ""
echo "   LIBS:"
grep "LIBS" Makefile_complete | head -3
echo ""

echo "2?? Buscando vita2d_vgl en TODOS los archivos..."
if grep -r "vita2d_vgl" . --include="*.mk" --include="Makefile*" --exclude-dir=.deps --exclude-dir=.git 2>/dev/null; then
    echo "   ? ENCONTRADO vita2d_vgl en alg?n archivo!"
else
    echo "   ? NO encontrado en Makefiles"
fi
echo ""

echo "3?? Verificando archivos .o antiguos..."
echo "   Archivos .o encontrados:"
find . -name "*.o" ! -path "./.deps/*" ! -path "./.git/*" | head -10
if [ $? -eq 0 ] && [ -n "$(find . -name "*.o" ! -path "./.deps/*" ! -path "./.git/*" | head -1)" ]; then
    echo "   ??  Hay archivos .o antiguos que pueden causar problemas"
    echo "   Ejecuta: make -f Makefile_complete clean"
else
    echo "   ? No hay archivos .o antiguos"
fi
echo ""

echo "4?? Verificando vita2d_stub.c..."
if [ -f "vita2d_stub.c" ]; then
    echo "   ? vita2d_stub.c existe"
    ls -lh vita2d_stub.c
else
    echo "   ? vita2d_stub.c NO existe"
fi
echo ""

echo "5?? Verificando m?dulos ATRAC y Apple..."
echo "   ATRAC:"
ls -lh audio/atrac_decoder.c audio/atrac_decoder.h 2>/dev/null || echo "   ? No encontrado"
echo ""
echo "   Apple:"
ls -lh apple/apple_sync.c apple/apple_sync.h 2>/dev/null || echo "   ? No encontrado"
echo ""

echo "6?? ?ltimo commit:"
git log --oneline -1
echo ""

echo "7?? Estado del repositorio:"
git status --short | head -5
echo ""

echo "=== RECOMENDACIONES ==="
echo ""
echo "Si sigues teniendo el error de vita2d_vgl:"
echo "1. Limpia TODO: make -f Makefile_complete clean && rm -f *.o */*.o"
echo "2. Prueba Makefile_minimal: make -f Makefile_minimal clean && make -f Makefile_minimal"
echo "3. Si Makefile_minimal funciona, el problema est? en ATRAC o Apple"
echo "4. Si Makefile_minimal tambi?n falla, el problema es m?s b?sico (librer?as, SDK, etc.)"
