# VitaCast - Podcast & Music App for PlayStation Vita

VitaCast es una aplicación completa de podcast y música para PlayStation Vita que combina la funcionalidad moderna de streaming con la estética clásica de la aplicación oficial de música de PS Vita.

## 🎵 Características Principales

### 🎧 Reproductor de Audio
- **Soporte para múltiples formatos**: MP3, AAC, OGG, WAV, M4A
- **Soporte nativo para ATRAC3 y ATRAC3plus** de Sony (optimizado para PS Vita)
- **Reproducción offline** de podcasts descargados
- **Control de volumen** y navegación por pistas
- **Barra de progreso** en tiempo real

### 🍎 Integración con Apple
- **Apple Music**: Acceso a tu biblioteca de música de Apple Music
- **Apple Podcasts**: Sincronización con podcasts suscritos
- **iCloud**: Sincronización de configuraciones y listas de reproducción
- **Autenticación OAuth 2.0** con Apple ID

### 🔍 Búsqueda y Descarga
- **Búsqueda de podcasts** usando la API de iTunes
- **Descarga automática** de episodios para escucha offline
- **Gestión de caché** inteligente
- **Cola de descargas** con progreso en tiempo real

### 🎨 Interfaz de Usuario
- **Diseño inspirado en la aplicación oficial de música de PS Vita**
- **Navegación intuitiva** con gamepad
- **Portadas de podcasts** descargadas automáticamente
- **Temas de colores** consistentes con el ecosistema PS Vita

## 🏗️ Arquitectura del Proyecto

```
VitaCast/
├── main.c                    # Punto de entrada principal
├── ui/                       # Gestión de interfaz de usuario
│   ├── ui_manager.h
│   └── ui_manager.c
├── audio/                    # Sistema de audio
│   ├── audio_player.h
│   ├── audio_player.c
│   ├── atrac_decoder.h
│   └── atrac_decoder.c
├── network/                  # Gestión de red y descargas
│   ├── network_manager.h
│   └── network_manager.c
├── apple/                    # Integración con Apple
│   ├── apple_sync.h
│   └── apple_sync.c
├── assets/                   # Recursos gráficos
│   ├── background.png
│   ├── icon0.png
│   ├── play.png
│   ├── pause.png
│   ├── next.png
│   ├── prev.png
│   └── fonts/
└── Makefile_complete         # Sistema de compilación
```

## 🛠️ Requisitos del Sistema

### Desarrollo
- **VitaSDK** instalado y configurado (https://vitasdk.org)
- **arm-vita-eabi-gcc** compilador
- **vita-mksfoex** y **vita-pack-vpk** para crear VPKs
- **vita2d** para gráficos 2D
- **Bibliotecas**: libpng, freetype, zlib (incluidas en VitaSDK)

### PlayStation Vita
- **Firmware 3.60+** (recomendado 3.65+)
- **HENkaku/Enso** instalado
- **Almacenamiento**: Mínimo 100MB para caché
- **Red WiFi** para funcionalidades online

## 🚀 Instalación y Compilación

### Compilación

```bash
# Compilar versión completa con todas las funcionalidades
make -f Makefile_complete

# Compilar versión simple (básica, sin dependencias extras)
make -f Makefile

# Compilar versión de debug
make -f Makefile_complete debug

# Compilar versión optimizada
make -f Makefile_complete release

# Limpiar archivos de compilación
make -f Makefile_complete clean
```

### Versiones Disponibles

- **main.c**: Versión completa con audio, red, Apple sync, UI manager
- **main_simple.c**: Versión básica de demostración
- **main_final.c**: Versión con UI mejorada sin dependencias externas

### Instalación en PS Vita
```bash
# Instalar VPK (requiere vita-install-vpk)
make -f Makefile_complete install

# O instalar manualmente
vita-install-vpk VitaCast.vpk
```

## 📱 Uso de la Aplicación

### Navegación Principal
- **D-Pad**: Navegar por menús
- **X**: Seleccionar opción
- **O**: Volver al menú anterior
- **Start**: Salir de la aplicación

### Funcionalidades por Pantalla

#### 🏠 Menú Principal
- **Podcasts**: Acceder a podcasts suscritos
- **Apple Music**: Biblioteca de música sincronizada
- **Reproductor**: Control de reproducción actual
- **Buscar**: Buscar nuevos podcasts
- **Descargas**: Gestionar descargas offline
- **Configuración**: Ajustes de la aplicación

#### 🎧 Reproductor
- **Controles de reproducción**: Play/Pause, Anterior/Siguiente
- **Información de pista**: Título, artista, álbum
- **Barra de progreso**: Posición actual y duración
- **Portada del álbum**: Visualización de artwork

#### 🔍 Búsqueda
- **Búsqueda por texto**: Encuentra podcasts por nombre
- **Resultados de iTunes**: Integración con base de datos oficial
- **Suscripción rápida**: Suscribirse desde resultados de búsqueda

## ⚙️ Configuración

### Cuenta de Apple
1. Ve a **Configuración > Apple ID**
2. Ingresa tu **email** y **contraseña** de Apple ID
3. Autoriza **Apple Music** y **iCloud**
4. La sincronización comenzará automáticamente

### Configuración de Red
- **WiFi**: Conecta a tu red WiFi
- **Caché**: Configura tamaño máximo de caché (por defecto 1GB)
- **Descargas**: Habilita/deshabilita descarga automática

### Configuración de Audio
- **Volumen**: Ajusta volumen por defecto
- **Formato preferido**: Selecciona formato de descarga
- **Calidad**: Configura calidad de audio

## 🔧 Desarrollo y Contribución

### Estructura del Código
- **Modular**: Cada funcionalidad en su propio módulo
- **Manejo de errores**: Verificación robusta de errores
- **Memoria**: Gestión cuidadosa de memoria para PS Vita
- **Threading**: Uso eficiente de threads para audio y red

### Agregar Nuevas Funcionalidades
1. **Crear archivos de cabecera** (.h) con interfaces
2. **Implementar funcionalidad** (.c) con lógica
3. **Actualizar Makefile** con nuevos archivos
4. **Integrar en main.c** con inicialización

### Debugging
```bash
# Compilar con símbolos de debug
make -f Makefile_complete debug

# Usar vita-remote-debugger para debugging
vita-remote-debugger VitaCast.elf
```

## 📋 Roadmap Futuro

### Versión 1.1
- [ ] **Soporte para más formatos**: FLAC, ALAC
- [ ] **Temas personalizables**: Múltiples esquemas de color
- [ ] **Listas de reproducción**: Crear y gestionar playlists
- [ ] **Modo oscuro**: Interfaz con tema oscuro

### Versión 1.2
- [ ] **Streaming en vivo**: Soporte para radio online
- [ ] **Sincronización con PC**: Transferencia de archivos
- [ ] **Widgets**: Información rápida en LiveArea
- [ ] **Trophy support**: Logros por uso de la aplicación

### Versión 2.0
- [ ] **Integración con Spotify**: Acceso a biblioteca de Spotify
- [ ] **Podcast recommendations**: Recomendaciones inteligentes
- [ ] **Social features**: Compartir podcasts con amigos
- [ ] **Cloud backup**: Respaldo automático en la nube

## ✅ Mejoras Aplicadas (v2.0.0)

### Basadas en VitaSDK.org

Esta versión incluye mejoras significativas siguiendo las mejores prácticas de [VitaSDK.org](https://vitasdk.org):

- ✅ **Headers PSP2 estándar** en lugar de `vitasdk.h` genérico
- ✅ **Inicialización correcta de módulos del sistema** (SceNet, SceSysmodule)
- ✅ **Manejo robusto de memoria** con liberación adecuada de recursos
- ✅ **Fuentes PGF** para renderizado de texto nativo
- ✅ **Control de FPS a 60fps** con `sceKernelDelayThread()`
- ✅ **Terminación correcta** con `sceKernelExitProcess()`
- ✅ **Makefiles optimizados** con solo bibliotecas necesarias
- ✅ **Manejo de errores** con códigos de retorno y mensajes de log

Ver [MEJORAS_VITASDK.md](./MEJORAS_VITASDK.md) para detalles completos.

## 🐛 Problemas Conocidos

- **ATRAC3plus**: Algunos archivos pueden requerir conversión
- **Red lenta**: Descargas pueden fallar en conexiones lentas
- **Memoria**: Aplicaciones grandes pueden causar problemas de memoria
- **iCloud**: Sincronización puede ser lenta en primera configuración

**Nota**: Muchos problemas de estabilidad se han resuelto en v2.0.0 con las mejoras de VitaSDK.

## 📞 Soporte

### Reportar Bugs
- **GitHub Issues**: Reporta bugs en el repositorio
- **Logs**: Incluye logs de vita-remote-debugger
- **Pasos**: Describe pasos para reproducir el problema

### Contribuciones
- **Pull Requests**: Envía mejoras y correcciones
- **Documentación**: Mejora la documentación del proyecto
- **Testing**: Ayuda a probar en diferentes configuraciones

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver archivo LICENSE para más detalles.

## 🙏 Agradecimientos

- **Sony**: Por crear la PlayStation Vita y sus APIs
- **[VitaSDK Team](https://vitasdk.org)**: Por el SDK de desarrollo homebrew
- **xerpi**: Por la biblioteca vita2d
- **Apple**: Por las APIs de Apple Music y Podcasts
- **Comunidad PS Vita**: Por el soporte y feedback continuo

## 📚 Recursos Útiles

- **VitaSDK**: https://vitasdk.org - SDK oficial
- **vita2d**: https://github.com/xerpi/vita2d - Biblioteca de gráficos 2D
- **Vita Dev Wiki**: https://vitadevwiki.com - Documentación comunitaria
- **PSP2 SDK Docs**: https://docs.vitasdk.org - Referencia de APIs

---

**VitaCast** - Llevando la experiencia moderna de podcast y música a PlayStation Vita 🎮🎵
