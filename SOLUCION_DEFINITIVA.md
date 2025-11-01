# Soluci?n Definitiva: Error -lvita2d_vgl

## ? Confirmaci?n

Tu Makefile_complete est? **CORRECTO**:
- ? Tiene `vita2d_stub.o` en OBJS
- ? NO tiene `-lvita2d_vgl` en LIBS
- ? CONTENT_ID = `PCSE00001`

## ? El Problema Real

Si sigues viendo el error `cannot find -lvita2d_vgl`, es porque:

**Hay archivos `.o` antiguos compilados con el Makefile viejo** que tienen referencias a `vita2d_vgl` embebidas en el objeto compilado.

## ?? Soluci?n Definitiva

Ejecuta estos comandos en orden en tu WSL:

```bash
cd ~/VitaCast

# 1. Asegurar ?ltima versi?n
git pull

# 2. LIMPIEZA COMPLETA
make -f Makefile_complete clean
rm -f *.o */*.o */*/*.o
find . -name "*.o" -type f -delete

# 3. Verificar que no quedan .o
find . -name "*.o" ! -path "./.deps/*" ! -path "./.git/*"
# Debe estar vac?o ?

# 4. Compilar desde cero
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH
make -f Makefile_complete release
```

## ?? O Usa el Script Autom?tico

```bash
cd ~/VitaCast
git pull
bash LIMPIEZA_COMPLETA.sh
make -f Makefile_complete release
```

## ?? ?Por Qu? Pasa Esto?

Cuando compilas un `.o`, el linker puede embebir nombres de librer?as en los s?mbolos del objeto. Si compilaste con el Makefile viejo (que ten?a `-lvita2d_vgl`), esos objetos antiguos siguen buscando esa librer?a aunque el Makefile nuevo ya no la use.

**Soluci?n**: Eliminar TODOS los `.o` y recompilar desde cero.

## ? Confirmaci?n Final

Despu?s de limpiar y recompilar:
- ? No habr? error de `-lvita2d_vgl`
- ? Compilar? con `vita2d_stub.o`
- ? Generar? VPK con CONTENT_ID correcto
