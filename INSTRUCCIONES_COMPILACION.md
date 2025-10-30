# Instrucciones para Compilar VitaCast Versión Completa

## Requisitos

Para compilar la versión completa de VitaCast necesitas un **VitaSDK completo** instalado en tu sistema.

### Instalación de VitaSDK

#### En Linux/macOS:
```bash
# Instalar vdpm (Vita Development Package Manager)
git clone https://github.com/vitasdk/vdpm
cd vdpm
./bootstrap-vitasdk.sh
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Instalar librerías adicionales
vdpm install vita2d libpng zlib curl
```

#### En Windows:
Descarga e instala VitaSDK desde: https://vitasdk.org/

## Compilación

### Opción 1: Makefile Principal (Versión Simple con fix)
```bash
make clean
make all
```

Genera un VPK simple pero funcional (~14KB)

### Opción 2: Makefile Complete (Versión Completa)
```bash
make -f Makefile_complete clean
make -f Makefile_complete all
```

Genera el VPK completo con todas las funcionalidades:
- Reproductor de audio (MP3, AAC, OGG, WAV, M4A, ATRAC3)
- Integración con Apple Music y Podcasts
- Búsqueda y descarga de podcasts
- Interfaz gráfica completa con vita2d
- Gestión de red con curl

**Tamaño estimado:** 2-5 MB (depende de las librerías enlazadas)

### Opción 3: Makefile Functional (Versión Intermedia)
```bash
make -f Makefile_functional clean
make -f Makefile_functional all
```

Versión con funcionalidades básicas pero sin todas las dependencias pesadas.

## Verificar el VPK

Después de compilar, verifica que el VPK sea válido:

```bash
# Ver tamaño
ls -lh VitaCast.vpk

# Verificar contenido
unzip -l VitaCast.vpk

# Verificar que param.sfo sea binario (no texto)
unzip -p VitaCast.vpk sce_sys/param.sfo | file -
# Debe mostrar: "data" (no "ASCII text")
```

## Instalar en PS Vita

### Método 1: VitaShell (Recomendado)
1. Copia `VitaCast.vpk` a tu PS Vita vía USB o FTP
2. Abre VitaShell
3. Navega hasta el archivo VPK
4. Presiona X para instalar
5. La instalación debe llegar al 100% sin errores

### Método 2: Instalación automática (si tienes la Vita conectada)
```bash
# Asegúrate de que FTP esté activo en VitaShell
make install
```

## Solución de Problemas

### Error durante compilación: "cannot find -lvita2d"
**Solución:** Instala las librerías faltantes con vdpm:
```bash
vdpm install vita2d
```

### Error: "cannot find crt0.o"
**Solución:** Tu VitaSDK está incompleto. Reinstala VitaSDK:
```bash
./bootstrap-vitasdk.sh
```

### Error 3D en VitaShell durante instalación
**Solución:** Este error ya está corregido en los Makefiles actualizados. El param.sfo ahora se genera correctamente como binario.

### VPK muy pequeño (~14KB)
**Solución:** Estás usando el Makefile simple. Usa `Makefile_complete` para la versión completa.

## Estructura del Proyecto

```
VitaCast/
├── main.c                    # Versión completa con todos los módulos
├── main_complete.c           # Versión con UI completa
├── main_simple.c             # Versión mínima
├── Makefile                  # Compilación versión simple (FIXED)
├── Makefile_complete         # Compilación versión completa (FIXED)
├── Makefile_functional       # Compilación versión intermedia
├── ui/                       # Módulos de interfaz
├── audio/                    # Módulos de audio
├── network/                  # Módulos de red
├── apple/                    # Integración con Apple
└── sce_sys/                  # Recursos del VPK
    ├── icon0.png
    ├── livearea/
    └── param.sfo (se genera automáticamente)
```

## Notas Importantes

- ✅ Los Makefiles ya están corregidos con el fix del error 3D
- ✅ El param.sfo se genera automáticamente como binario
- ✅ La estructura del VPK es correcta
- ⚠️ La compilación de la versión completa requiere ~500MB de VitaSDK
- ⚠️ La compilación puede tardar 2-5 minutos dependiendo del hardware

## Verificación Post-Instalación

Después de instalar en tu Vita:
1. Abre la aplicación VitaCast desde LiveArea
2. Deberías ver el menú principal con:
   - Podcasts
   - Apple Music
   - Reproductor
   - Configuración
3. Navega con D-Pad, selecciona con X, vuelve con O
4. Presiona START para salir

## Soporte

Si tienes problemas:
1. Verifica que VitaSDK esté completamente instalado
2. Asegúrate de tener todas las librerías necesarias
3. Revisa los logs de compilación en busca de errores específicos
4. El error 3D de VitaShell ya está solucionado en esta versión

---
**Última actualización:** 2025-10-29
**Versión:** 2.0.1-Fixed
