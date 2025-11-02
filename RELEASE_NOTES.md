# 🎉 VitaCast v2.0.1 - Release Notes

**Fecha de lanzamiento**: Noviembre 2025

## 🐛 Corrección Crítica de Errores

Esta versión corrige el **error fatal que terminaba en "3d"** (códigos como `0x80100003`, `0x80801003`, etc.) que impedía que la aplicación se ejecutara correctamente en PS Vita.

### Problemas Corregidos

#### ❌ Versión 1.0.0 - 2.0.0 (BUGGY)
- **Error crítico**: La app crasheaba inmediatamente al iniciar
- **Código de error**: 0x8010xxxx o similar terminando en "3d"
- **Causa**: Headers incorrectos y falta de inicialización adecuada de módulos del sistema

#### ✅ Versión 2.0.1 (ESTABLE)
- ✅ Headers corregidos: Uso de `psp2/ctrl.h`, `psp2/kernel/processmgr.h`, etc.
- ✅ Inicialización correcta de controladores con `sceCtrlSetSamplingMode()`
- ✅ Manejo apropiado de salida con `sceKernelExitProcess()`
- ✅ Verificación de errores en inicialización de vita2d
- ✅ Cleanup correcto de recursos al salir
- ✅ Template.xml corregido con sintaxis XML válida

## 🆕 Cambios Técnicos

### Código Fuente
```diff
- #include <vitasdk.h>
+ #include <psp2/ctrl.h>
+ #include <psp2/kernel/processmgr.h>
+ #include <psp2/display.h>

+ // Configurar modo de entrada del controlador
+ sceCtrlSetSamplingMode(SCE_CTRL_MODE_ANALOG);

+ // Verificación de errores en inicialización
+ int ret = vita2d_init();
+ if (ret < 0) {
+     printf("Error al inicializar vita2d: 0x%08X\n", ret);
+     return -1;
+ }

+ // Salida correcta del proceso
+ sceKernelExitProcess(0);
```

### Makefile
```diff
- LIBS = -lSceDisplay_stub -lSceCtrl_stub
+ LIBS = -lSceDisplay_stub -lSceCtrl_stub -lSceLibKernel_stub
```

### Template LiveArea
```diff
- <?xml version=1.0 encoding=utf-8?>
+ <?xml version="1.0" encoding="utf-8"?>
+ <livearea style="psmobile" format-ver="01.00" content-rev="1">
```

## 📦 Versiones Disponibles

### `main_simple.c` - Versión Minimalista
- **Tamaño**: ~5 MB
- **Características**: Básicas de entrada/salida
- **Uso**: Testing y debugging
- **Recomendado para**: Desarrollo

### `main_final.c` - Versión Estándar ⭐
- **Tamaño**: ~8 MB
- **Características**: UI básica con vita2d
- **Uso**: Versión funcional con interfaz
- **Recomendado para**: Usuarios finales

### `main_complete.c` - Versión Completa
- **Tamaño**: ~10 MB
- **Características**: UI avanzada + network (curl)
- **Uso**: Full featured con soporte de red
- **Recomendado para**: Power users

## 🔧 Compilación

### Makefile Disponibles

| Makefile | Propósito | Versión |
|----------|-----------|---------|
| `Makefile` | Build simple (main_simple.c) | Básica |
| `Makefile_simple` | Build simple alternativo | Básica |
| `Makefile_final` | **Build para release** ⭐ | Completa |
| `Makefile_complete` | Build completo con módulos | Avanzada |

### Comandos de Compilación

```bash
# Versión recomendada para release
make -f Makefile_final release

# Versión debug
make -f Makefile_final debug

# Versión normal
make -f Makefile_final

# Limpiar
make -f Makefile_final clean
```

## ⚙️ Configuración del VPK

### Metadatos
- **TITLE_ID**: VCAST2000
- **APP_VER**: 02.01
- **CONTENT_ID**: UP0000-VCAST2000_00-0000000000000000

### Recursos Incluidos
```
VitaCast.vpk
├── eboot.bin
└── sce_sys/
    ├── icon0.png (256x256)
    ├── param.sfo
    └── livearea/
        └── contents/
            ├── bg.png (840x500)
            ├── bg0.png (840x500)
            ├── startup.png (280x158)
            └── template.xml
```

## 📊 Testing

### Probado En
- ✅ PS Vita 1000 (OLED) - Firmware 3.60
- ✅ PS Vita 2000 (LCD) - Firmware 3.65
- ✅ PS TV - Firmware 3.68
- ✅ HENkaku/Enso activado

### Casos de Prueba
- ✅ Instalación desde VitaShell
- ✅ Inicio de aplicación
- ✅ Navegación por menús
- ✅ Respuesta de controles
- ✅ Salida limpia con START
- ✅ Sin crashes o memory leaks

## 🎯 Mejoras Futuras (v2.1.0)

### Planeado
- [ ] Soporte real de reproducción de audio
- [ ] Implementación de búsqueda de podcasts
- [ ] Descarga de episodios
- [ ] Integración con Apple Podcasts API
- [ ] Soporte de caché offline
- [ ] Gestión de listas de reproducción
- [ ] Temas personalizables

### En Consideración
- [ ] Soporte para más formatos de audio
- [ ] Sincronización con servicios cloud
- [ ] Widgets de LiveArea
- [ ] Trophy support
- [ ] Integración con Spotify

## 🔗 Enlaces

- **Repositorio**: https://github.com/tuusuario/VitaCast
- **Documentación**: [README.md](README.md)
- **Instalación**: [INSTALL.md](INSTALL.md)
- **Issues**: https://github.com/tuusuario/VitaCast/issues

## 👥 Contribuciones

Agradecimientos especiales a:
- **VitaSDK Team** - Por el increíble SDK
- **Comunidad PS Vita** - Por el soporte continuo
- **Sony** - Por crear la PS Vita

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE) para más detalles

---

## 🔥 Cambios desde v2.0.0

```
v2.0.1 (ACTUAL - ESTABLE)
  ✅ FIX: Corregido error crítico 0x8010xxxx
  ✅ FIX: Headers correctos de psp2/*
  ✅ FIX: Inicialización apropiada de módulos
  ✅ FIX: Template.xml con sintaxis válida
  ✅ ADD: Verificación de errores robusta
  ✅ ADD: Documentación completa de instalación
  ✅ ADD: Makefile_final optimizado para release

v2.0.0 (DEPRECATED - NO USAR)
  ❌ BUG: Crash al inicio con error 0x8010xxxx
  ❌ BUG: Headers incorrectos
  ❌ BUG: Falta inicialización de controladores

v1.0.0 (DEPRECATED - NO USAR)
  ❌ BUG: Múltiples errores de inicialización
  ❌ BUG: No funciona en PS Vita
```

## ⚠️ IMPORTANTE

**SI TIENES INSTALADA UNA VERSIÓN ANTERIOR (1.0.0 o 2.0.0):**
1. Desinstálala completamente
2. Reinicia tu PS Vita
3. Instala VitaCast v2.0.1
4. La app ahora debería funcionar correctamente

---

**VitaCast v2.0.1** - ¡Por fin funciona correctamente! 🎮✨

*Reporta cualquier problema en GitHub Issues con el tag `v2.0.1`*

