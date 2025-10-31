# Changelog - VitaCast

## [2.0.0] - 2025-10-31

### ?? Mejoras Mayores

Esta versi?n representa una revisi?n completa del c?digo siguiendo las mejores pr?cticas de [VitaSDK.org](https://vitasdk.org).

### ? A?adido

- **Fuentes PGF nativas**: Renderizado de texto con fuentes del sistema de PS Vita
- **UI Manager completo**: Sistema de men?s con navegaci?n funcional
- **Manejo de errores robusto**: Verificaci?n de c?digos de retorno y mensajes de log
- **Inicializaci?n de red**: Configuraci?n correcta de SceNet y SceNetCtl
- **Control de FPS**: Limitaci?n a ~60 FPS con `sceKernelDelayThread()`
- **Documentaci?n extensa**: MEJORAS_VITASDK.md con explicaciones detalladas

### ?? Cambiado

#### Archivos Modificados:

**main.c**:
- Headers PSP2 est?ndar en lugar de `vitasdk.h`
- Inicializaci?n de m?dulos del sistema (SceNet, SceSysmodule)
- Asignaci?n de memoria est?tica para red
- Soporte de fuentes PGF para texto
- Ciclo de vida correcto con `sceKernelExitProcess()`
- Control de FPS a 60fps
- Manejo de errores mejorado

**main_simple.c**:
- Versi?n simplificada con vita2d
- Renderizado de texto con fuentes PGF
- Interfaz b?sica funcional

**main_final.c**:
- UI mejorada con texto renderizado
- Navegaci?n por men? funcional
- Indicadores visuales de selecci?n

**ui/ui_manager.c**:
- Implementaci?n completa de renderizado con fuentes
- Sistema de navegaci?n con D-Pad
- Men?s funcionales para todos los estados
- Colores consistentes con el estilo PS Vita

**Makefile**:
- Bibliotecas actualizadas seg?n VitaSDK
- Flags de compilaci?n correctos (`-std=gnu11`, `-D__PSP2__`)
- Solo bibliotecas necesarias

**Makefile_complete**:
- Estructura de linking optimizada
- Bibliotecas vita2d est?ndar (sin vitaGL innecesario)
- Target `param.sfo` separado
- Empaquetado VPK con estructura correcta

**README.md**:
- Secci?n de mejoras v2.0.0
- Referencias a VitaSDK.org
- Recursos ?tiles para desarrolladores
- Documentaci?n actualizada

### ??? Eliminado

- **vita2d_stub.c**: Eliminado archivo con implementaciones vac?as
  - Ya no es necesario con vita2d real del VitaSDK

### ?? T?cnico

#### Headers Actualizados:
```c
// Antes:
#include <vitasdk.h>

// Despu?s:
#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>
#include <psp2/net/net.h>
#include <psp2/net/netctl.h>
#include <psp2/sysmodule.h>
#include <vita2d.h>
```

#### Bibliotecas Actualizadas:
```makefile
# Eliminado: vitaGL, TinyGL, vitashark
# A?adido: vita2d est?ndar, ScePgf, ScePvf
LIBS = -lvita2d -lSceDisplay_stub -lSceGxm_stub \
  -lSceSysmodule_stub -lSceCtrl_stub -lScePgf_stub \
  -lScePvf_stub -lSceCommonDialog_stub \
  -lfreetype -lpng -ljpeg -lz \
  -lSceNet_stub -lSceNetCtl_stub ...
```

#### Ciclo de Vida Mejorado:
```c
// Antes:
int main() {
    vita_cast_init();
    while (running) { ... }
    vita_cast_cleanup();
    return 0;
}

// Despu?s:
int main(int argc, char *argv[]) {
    if (vita_cast_init() < 0) {
        vita_cast_cleanup();
        sceKernelDelayThread(3 * 1000000);
        sceKernelExitProcess(0);
        return -1;
    }
    while (app && app->running) {
        update(); render();
        sceKernelDelayThread(16666); // 60 FPS
    }
    vita_cast_cleanup();
    sceKernelExitProcess(0); // ? Importante
    return 0;
}
```

### ?? Estad?sticas

- **Archivos modificados**: 8
- **Archivos creados**: 2 (MEJORAS_VITASDK.md, CHANGELOG.md)
- **Archivos eliminados**: 1 (vita2d_stub.c)
- **L?neas a?adidas**: ~500+
- **L?neas eliminadas**: ~100+
- **Mejoras aplicadas**: 7 principales

### ?? Bugs Corregidos

- **Memory leaks**: Liberaci?n correcta de fuentes y texturas
- **Crash al salir**: Uso de `sceKernelExitProcess()` para terminaci?n correcta
- **Texto no visible**: Implementaci?n de renderizado con fuentes PGF
- **FPS inconsistente**: Control de framerate a 60fps
- **Recursos sin liberar**: Orden correcto de limpieza

### ?? Documentaci?n

Nuevos documentos:
- **MEJORAS_VITASDK.md**: Gu?a detallada de todas las mejoras aplicadas
- **CHANGELOG.md**: Historial de cambios de la versi?n

### ?? Compatibilidad

- **VitaSDK**: Requiere VitaSDK actualizado (2024+)
- **Firmware PS Vita**: 3.60+ (recomendado 3.65+)
- **HENkaku/Enso**: Requerido
- **Bibliotecas**: vita2d, freetype, libpng (incluidas en VitaSDK)

### ?? Basado en

Todas las mejoras siguen las recomendaciones de:
- [VitaSDK.org](https://vitasdk.org) - Documentaci?n oficial
- [vita2d](https://github.com/xerpi/vita2d) - Biblioteca gr?fica
- [Vita Dev Wiki](https://vitadevwiki.com) - Comunidad
- [PSP2 SDK Docs](https://docs.vitasdk.org) - Referencia de APIs

---

## [1.0.0] - Versi?n Original

### Caracter?sticas Iniciales

- Estructura b?sica del proyecto
- UI Manager stub
- Audio Player stub
- Network Manager stub
- Apple Sync stub
- Makefiles b?sicos

---

**Desarrollado con ?? siguiendo las mejores pr?cticas de VitaSDK**
