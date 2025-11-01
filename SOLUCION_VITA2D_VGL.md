# Soluci?n: Error "cannot find -lvita2d_vgl"

## Problema

Error al compilar:
```
cannot find -lvita2d_vgl
collect2: error: ld returned 1 exit status
```

## Soluci?n Aplicada

He modificado el Makefile para usar **vita2d_stub.c** en lugar de la librer?a vita2d. Esto permite compilar sin necesidad de instalar la librer?a completa.

### Cambios Realizados

1. **Makefile_complete actualizado:**
   - Removida dependencia de `-lvita2d`
   - Agregado `vita2d_stub.o` a los objetos de compilaci?n
   - El stub proporciona funciones m?nimas de vita2d

2. **vita2d_stub.c:**
   - Proporciona stubs (funciones vac?as) para todas las funciones de vita2d
   - Permite que el c?digo compile sin la librer?a real

## Compilar Ahora

```bash
cd ~/VitaCast
git pull  # Para obtener los cambios
make -f Makefile_complete clean
make -f Makefile_complete release
```

## Nota Importante

El stub hace que el c?digo compile, pero **las funciones gr?ficas no funcionar?n**. Para funcionalidad completa necesitar?s:

```bash
vdpm install libvita2d
```

Y luego agregar `-lvita2d` de nuevo al Makefile (reemplazando el stub).

## Alternativa: Instalar libvita2d

Si quieres la funcionalidad completa de gr?ficos:

```bash
# Instalar librer?a
vdpm install libvita2d

# Verificar instalaci?n
ls /usr/local/vitasdk/arm-vita-eabi/lib/libvita2d*
```

Luego modifica el Makefile para usar la librer?a real en lugar del stub.

## Verificaci?n

Despu?s de compilar con el stub:

```bash
# El VPK deber?a generarse
ls -lh VitaCast.vpk

# Verificar param.sfo
unzip -p VitaCast.vpk sce_sys/param.sfo | strings | grep -i "PCSE"
# Debe mostrar: PCSE00001
```

El VPK compilar? correctamente ahora, aunque sin funcionalidad gr?fica completa hasta que instales libvita2d.
