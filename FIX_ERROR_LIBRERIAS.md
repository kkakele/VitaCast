# Soluci?n: Error "cannot find -lvita2d_vgl"

## Problema

Al compilar aparece el error:
```
cannot find -lvita2d_vgl
collect2: error: ld returned 1 exit status
```

## Causa

El Makefile_complete ten?a referencias a librer?as que no existen o tienen nombres diferentes en VitaSDK est?ndar.

## Soluci?n Aplicada

He corregido el `Makefile_complete` para usar las librer?as correctas:

**Antes (incorrecto):**
```makefile
LIBS = -lvita2d_vgl -lvitaGL ...
```

**Despu?s (correcto):**
```makefile
LIBS = -lvita2d -lSceGxm_stub -lSceDisplay_stub ...
```

## Verificar Instalaci?n de Librer?as

Si a?n tienes errores, verifica que las librer?as est?n instaladas:

```bash
# Verificar librer?as instaladas
ls /usr/local/vitasdk/arm-vita-eabi/lib/libvita2d*
ls /usr/local/vitasdk/arm-vita-eabi/lib/libSceGxm_stub*

# Si faltan, instalar:
vdpm install libvita2d
vdpm install libSceGxm_stub
```

## Librer?as Necesarias

Aseg?rate de tener instaladas estas librer?as con `vdpm`:

```bash
vdpm install libvita2d
vdpm install taihen
vdpm install curl
vdpm install openssl
vdpm install libpng
vdpm install freetype
```

## Recompilar

Despu?s de corregir el Makefile y verificar librer?as:

```bash
cd ~/VitaCast
git pull  # Para obtener el Makefile corregido
make -f Makefile_complete clean
make -f Makefile_complete release
```

## Verificar VPK Generado

```bash
# Verificar que el VPK tiene el CONTENT_ID correcto
unzip -p VitaCast.vpk sce_sys/param.sfo | strings | grep -i "PCSE"

# Debe mostrar: PCSE00001
```

## Si Persisten Errores

Si sigues teniendo errores de librer?as faltantes:

1. **Listar librer?as disponibles:**
   ```bash
   ls /usr/local/vitasdk/arm-vita-eabi/lib/*.a | grep -i "sce\|vita"
   ```

2. **Instalar librer?as faltantes:**
   ```bash
   vdpm install <nombre-libreria>
   ```

3. **Verificar que VitaSDK est? completo:**
   ```bash
   vdpm install-all
   ```

El Makefile ahora est? corregido y deber?a compilar sin este error espec?fico.
