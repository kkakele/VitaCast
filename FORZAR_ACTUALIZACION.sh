#!/bin/bash

# Script para forzar actualizaci?n y verificar Makefile

echo "?? Forzando actualizaci?n del repositorio..."

cd ~/VitaCast || exit 1

# 1. Verificar estado actual
echo ""
echo "=== ESTADO ACTUAL ==="
echo "Contenido de LIBS en Makefile_complete:"
grep "LIBS" Makefile_complete | head -3

echo ""
echo "OBJS en Makefile_complete:"
grep "^OBJS" Makefile_complete

echo ""
echo "=== BUSCANDO vita2d_vgl ==="
if grep -q "vita2d_vgl" Makefile_complete; then
    echo "? ERROR: Makefile_complete TODAV?A tiene vita2d_vgl"
    echo ""
    echo "?? Forzando actualizaci?n..."
    
    # Resetear completamente
    git fetch origin
    git reset --hard origin/cursor/investigar-y-arreglar-errores-de-vitacast-y-vitasdk-fd06
    
    echo ""
    echo "? Repositorio actualizado"
else
    echo "? Makefile_complete NO tiene vita2d_vgl"
fi

echo ""
echo "=== VERIFICACI?N FINAL ==="
echo "LIBS actual:"
grep "LIBS" Makefile_complete | head -3

echo ""
echo "OBJS actual:"
grep "^OBJS" Makefile_complete

echo ""
echo "=== STUB VERIFICADO ==="
if [ -f "vita2d_stub.c" ]; then
    echo "? vita2d_stub.c existe"
else
    echo "? vita2d_stub.c NO existe"
fi

echo ""
echo "=== LISTO PARA COMPILAR ==="
echo "Ahora ejecuta:"
echo "  make -f Makefile_complete clean"
echo "  make -f Makefile_complete release"
