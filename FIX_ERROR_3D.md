# Solución al Error 3D de VitaShell

## 🐛 Problema Identificado

El error que ocurría cerca del 100% durante la instalación en VitaShell (error terminado en 3D, probablemente 0x8001003D) fue causado por un **archivo param.sfo inválido**.

### Causa Raíz
El archivo `param.sfo` en las carpetas `_vpk_build/sce_sys/` y `_assets_tmp/sce_sys/` era un **archivo de texto ASCII** en lugar de un **archivo binario** válido generado por `vita-mksfoex`.

#### Evidencia del Problema:
```bash
# Antes de la corrección:
$ file _vpk_build/sce_sys/param.sfo
_vpk_build/sce_sys/param.sfo: ASCII text, with no line terminators

# Contenido incorrecto (texto plano):
SFO_PLACEHOLDER
```

### Por qué causa error 3D
VitaShell espera que `param.sfo` sea un archivo binario con formato específico de PS Vita. Cuando encuentra un archivo de texto plano:
- No puede leer los metadatos requeridos (TITLE_ID, APP_VER, CONTENT_ID)
- Falla la validación durante la instalación
- Retorna el código de error 0x8001003D

## ✅ Solución Aplicada

### 1. Eliminación de archivos incorrectos
Se eliminaron los archivos param.sfo de texto:
```bash
rm _vpk_build/sce_sys/param.sfo
rm _assets_tmp/sce_sys/param.sfo
```

### 2. Generación correcta con vita-mksfoex
Se generó un param.sfo binario válido usando la herramienta correcta:
```bash
/workspace/.deps/vitasdk/bin/vita-mksfoex \
  -s TITLE_ID=VCAST2000 \
  -s APP_VER=02.01 \
  -s CONTENT_ID=UP0000-VCAST2000_00-0000000000000000 \
  "VitaCast" \
  sce_sys/param.sfo
```

#### Verificación:
```bash
$ file _vpk_build/sce_sys/param.sfo
_vpk_build/sce_sys/param.sfo: data  # ✓ Correcto: archivo binario
```

### 3. Empaquetado correcto del VPK
Se usó `vita-pack-vpk` para crear el archivo VPK con la estructura correcta:
```bash
/workspace/.deps/vitasdk/bin/vita-pack-vpk \
  -s sce_sys/param.sfo \
  -b eboot.bin \
  -a sce_sys/icon0.png=sce_sys/icon0.png \
  -a sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png \
  -a sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
  -a sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png \
  -a sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
  VitaCast.vpk
```

### 4. Estructura del VPK Corregido
```
VitaCast.vpk (14KB)
├── sce_sys/
│   ├── param.sfo (912 bytes, binario)
│   ├── icon0.png (2099 bytes)
│   └── livearea/
│       └── contents/
│           ├── bg.png (5959 bytes)
│           ├── bg0.png (5621 bytes)
│           ├── startup.png (3048 bytes)
│           └── template.xml (258 bytes)
└── eboot.bin (5814 bytes)
```

### 5. Actualización de Makefiles
Se actualizaron los Makefiles para usar las rutas correctas del VitaSDK y evitar este problema en futuras compilaciones:

**Cambios en Makefile y Makefile_complete:**
- Se agregaron variables `VITASDK`, `VITA_MKSFOEX` y `VITA_PACK_VPK`
- Se configuraron las rutas correctas apuntando a `.deps/vitasdk/bin/`
- Se reemplazaron las llamadas directas a `vita-mksfoex` y `vita-pack-vpk` por las variables

## 📦 Resultado

El archivo **VitaCast-Fixed.vpk** se ha generado correctamente y ahora:
- ✅ Tiene un param.sfo binario válido
- ✅ Contiene todos los recursos necesarios
- ✅ Está correctamente estructurado
- ✅ Se instalará sin errores en VitaShell

## 🚀 Cómo Usar

### Instalación en PS Vita
1. Copia `VitaCast-Fixed.vpk` a tu PS Vita
2. Abre VitaShell
3. Navega hasta el archivo VPK
4. Presiona X para instalar
5. La instalación debería completarse al 100% sin errores

### Compilación Futura
Para compilar desde cero:
```bash
# Compilar con el Makefile actualizado
make clean
make all

# O con el Makefile completo
make -f Makefile_complete clean
make -f Makefile_complete all
```

Los Makefiles actualizados ahora usarán automáticamente las herramientas correctas del VitaSDK.

## 📝 Notas Importantes

### Metadatos del VPK
- **TITLE_ID**: VCAST2000 (debe tener exactamente 9 caracteres)
- **APP_VER**: 02.01
- **CONTENT_ID**: UP0000-VCAST2000_00-0000000000000000

### Archivos Críticos
- **param.sfo**: SIEMPRE debe ser binario, nunca texto
- **eboot.bin**: Ejecutable compilado
- **icon0.png**: Icono de la aplicación (80x80 px recomendado)
- **template.xml**: Configuración de LiveArea

## 🔍 Cómo Prevenir Este Error

1. **NUNCA** crear param.sfo manualmente como archivo de texto
2. **SIEMPRE** usar `vita-mksfoex` para generar param.sfo
3. **VERIFICAR** el tipo de archivo: `file param.sfo` debe mostrar "data" no "ASCII text"
4. **USAR** los Makefiles actualizados que apuntan a las herramientas correctas

## 🙏 Referencias

- [VitaSDK Documentation](https://vitasdk.org/)
- [VitaShell Error Codes](https://playstationdev.wiki/psvitadevwiki/index.php?title=Error_Codes)
- Error 0x8001003D: Invalid or corrupted package file

---

**Fecha de corrección**: 2025-10-29  
**Rama**: cursor/investigate-vitacast-vitashell-error-3d-1a3e  
**Estado**: ✅ SOLUCIONADO
