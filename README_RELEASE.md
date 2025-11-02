# 🎮 VitaCast v2.0.1 - RELEASE VERSION

![Version](https://img.shields.io/badge/version-2.0.1-blue.svg)
![Platform](https://img.shields.io/badge/platform-PS%20Vita-purple.svg)
![Status](https://img.shields.io/badge/status-stable-green.svg)

**Podcast y Reproductor de Música para PlayStation Vita**

---

## 🎉 ¡VERSIÓN ESTABLE!

Esta es la **primera versión estable y funcional** de VitaCast después de corregir el error crítico que impedía su ejecución en PS Vita.

### ✅ ¿Qué se arregló?
- **Error 0x8010xxxx corregido**: La app ahora inicia correctamente
- **Inicialización apropiada**: Todos los módulos se inicializan correctamente
- **Headers correctos**: Uso de psp2/* en lugar de vitasdk.h
- **Template válido**: LiveArea funciona perfectamente

---

## 📥 Descarga e Instalación

### Descarga Directa
👉 **[Descargar VitaCast-v2.0.1.vpk](../../releases/download/v2.0.1/VitaCast-v2.0.1.vpk)**

### Instalación Rápida
1. Descarga el archivo VPK
2. Cópialo a tu PS Vita via USB o FTP
3. Abre VitaShell y navega hasta el archivo
4. Presiona **X** para instalar
5. ¡Listo! Busca VitaCast en tu LiveArea

📖 **[Guía completa de instalación](INSTALL.md)**

---

## ✨ Características

### ✅ Actualmente Funcional
- 🎮 **Navegación por menús** con controles de PS Vita
- 🎨 **Interfaz gráfica** con vita2d
- 🕹️ **Control completo**: D-Pad, X, O, START
- 📱 **LiveArea funcional** con icono personalizado
- 💾 **Gestión de memoria** correcta sin leaks

### 🚧 En Desarrollo (v2.1+)
- 🎵 Reproducción de audio real
- 📻 Búsqueda y descarga de podcasts
- 🌐 Integración con servicios online
- 💿 Soporte para más formatos

---

## 🎮 Controles

| Botón | Acción |
|-------|--------|
| **D-Pad ↑/↓** | Navegar menú |
| **X (Cruz)** | Seleccionar |
| **O (Círculo)** | Volver |
| **START** | Salir |

---

## 🔧 Compilar desde Código Fuente

### Requisitos
- VitaSDK instalado
- Variable `$VITASDK` configurada
- Herramientas: make, gcc

### Compilación
```bash
# Linux/Mac
./build_release.sh

# Windows (PowerShell)
.\build_release.ps1

# O manualmente
make -f Makefile_final release
```

📖 **[Documentación de desarrollo](README.md)**

---

## 📊 Compatibilidad

| Dispositivo | Estado |
|-------------|--------|
| PS Vita 1000 (OLED) | ✅ Probado |
| PS Vita 2000 (LCD) | ✅ Probado |
| PS TV | ✅ Compatible |
| Firmware 3.60 | ✅ Funciona |
| Firmware 3.65+ | ✅ Funciona |

---

## 🐛 Problemas Conocidos

### No Críticos
- Los assets son placeholders (se mejorarán en futuras versiones)
- La reproducción de audio aún no está implementada
- Funciones de red son stubs por ahora

### Reportar Bugs
Si encuentras un problema:
1. Verifica que uses la versión **v2.0.1**
2. Revisa la [guía de solución de problemas](INSTALL.md#-solución-de-problemas)
3. Crea un [issue en GitHub](../../issues)

---

## 📄 Documentación

| Documento | Descripción |
|-----------|-------------|
| **[INSTALL.md](INSTALL.md)** | Guía detallada de instalación |
| **[RELEASE_NOTES.md](RELEASE_NOTES.md)** | Cambios y correcciones |
| **[README.md](README.md)** | Documentación técnica completa |
| **[RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)** | Checklist para releases |

---

## 🗺️ Roadmap

### v2.1.0 (Próxima)
- [ ] Reproducción de audio MP3/OGG
- [ ] Búsqueda básica de podcasts
- [ ] Descarga de episodios
- [ ] Caché offline

### v2.2.0 (Futuro)
- [ ] Integración con Apple Podcasts
- [ ] Sincronización con iCloud
- [ ] Listas de reproducción
- [ ] Temas personalizables

### v3.0.0 (Visión)
- [ ] Soporte completo de streaming
- [ ] Integración con Spotify
- [ ] Recomendaciones inteligentes
- [ ] Social features

---

## 🙏 Créditos

### Desarrollado con
- **VitaSDK** - SDK homebrew para PS Vita
- **vita2d** - Biblioteca de gráficos 2D
- **curl** - Transferencia de datos (futuro)

### Agradecimientos
- **VitaSDK Team** - Por el increíble SDK
- **Comunidad PS Vita** - Por el soporte continuo
- **Sony** - Por crear la PlayStation Vita

---

## 📜 Licencia

MIT License

```
Copyright (c) 2025 VitaCast

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🔗 Enlaces

- **GitHub**: https://github.com/tuusuario/VitaCast
- **Releases**: https://github.com/tuusuario/VitaCast/releases
- **Issues**: https://github.com/tuusuario/VitaCast/issues
- **VitaDB**: (Próximamente)

---

## 💬 Comunidad

¿Preguntas? ¿Sugerencias?
- 💬 Abre un [Discussion](../../discussions) en GitHub
- 🐛 Reporta bugs en [Issues](../../issues)
- ⭐ Dale una estrella si te gusta el proyecto

---

## 📱 Screenshots

_(Próximamente: Capturas de la app en funcionamiento)_

---

## ⚠️ Aviso Legal

Este es un proyecto homebrew de código abierto.
- **No afiliado** con Sony o Apple
- Solo para uso con **CFW/HENkaku**
- Úsalo bajo tu propio riesgo

---

## 🎯 Estado del Proyecto

```
┌──────────────────────────────────────────┐
│  VitaCast v2.0.1 - STABLE                │
├──────────────────────────────────────────┤
│  ✅ Core funcional                       │
│  ✅ UI básica implementada               │
│  ✅ Sin crashes críticos                 │
│  ✅ Listo para uso                       │
│  🚧 Audio en desarrollo                  │
│  🚧 Features avanzadas pending           │
└──────────────────────────────────────────┘
```

---

<div align="center">

**⭐ Si te gusta VitaCast, dale una estrella en GitHub ⭐**

**🎮 Hecho con ❤️ para la comunidad PS Vita 🎮**

</div>

---

### Changelog Rápido

```
v2.0.1 (2025-11-02) - ACTUAL
  ✅ FIX: Error crítico 0x8010xxxx corregido
  ✅ FIX: Inicialización de módulos
  ✅ FIX: Headers correctos psp2/*
  ✅ ADD: Documentación completa
  
v2.0.0 (DEPRECATED)
  ❌ BUG: Crash al inicio
  
v1.0.0 (DEPRECATED)
  ❌ BUG: No funcional
```

---

> **Nota**: Si estás viendo esto desde GitHub Releases, descarga el archivo `VitaCast-v2.0.1.vpk` de los assets de abajo. Si estás en el repositorio, ve a la sección [Releases](../../releases) para descargar.

