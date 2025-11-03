# VitaCast v3.0.3 - Release Notes

## 🎉 Nueva Versión - Corrección de Errores y Mejoras

Esta versión corrige el error crítico **0xFFFFFFFF** y aumenta significativamente el tamaño del VPK con recursos gráficos adicionales.

## 🐛 Correcciones

### Error 0xFFFFFFFF
- **Problema**: La aplicación fallaba al iniciar con error 0xFFFFFFFF
- **Solución**: Se añadió la carga del módulo `SCE_SYSMODULE_PGF` antes de inicializar `vita2d`
- **Detalles**: El módulo PGF (Portable Graphics Font) es necesario para las fuentes que usa vita2d. Sin este módulo, la inicialización de gráficos fallaba.

## 📦 Mejoras en Recursos

### Nuevos Assets Gráficos
- **Iconos de controles**: Se añadieron iconos para play, pause, next y prev
- **Fondo de aplicación**: Se incluyó `background.png` como recurso adicional
- **Tamaño del VPK**: Aumentó de ~116KB a ~340KB para incluir todos los recursos

### Recursos Incluidos
```
assets/
├── background.png      (~100KB)
└── icons/
    ├── play.png        (~25KB)
    ├── pause.png       (~25KB)
    ├── next.png        (~25KB)
    └── prev.png        (~25KB)
```

## 🔧 Cambios Técnicos

- **Versión**: 3.0.0 → 3.0.3
- **Makefile**: Actualizado para incluir todos los assets en el VPK
- **Inicialización**: Verificación de retorno de `vita2d_init()` y carga correcta de módulos

## 📋 Instalación

1. Descarga `VitaCast.vpk` desde la sección de releases
2. Transfiere el VPK a tu PS Vita usando VitaShell o FTP
3. Abre el VPK con VitaShell y presiona X para instalar
4. ¡Disfruta de VitaCast sin errores!

## ⚠️ Requisitos

- **Firmware**: PS Vita con firmware 3.60+ (recomendado 3.65+)
- **Homebrew**: HENkaku/Enso instalado
- **Almacenamiento**: ~1MB para la instalación

## 🎮 Uso

Una vez instalado:
- La aplicación debería iniciar sin errores
- Los recursos gráficos están disponibles para uso futuro
- La interfaz gráfica funciona correctamente con vita2d

## 🙏 Agradecimientos

Gracias por reportar el error y ayudarnos a mejorar VitaCast. Esta versión debería resolver completamente el problema de inicialización.

---

**VitaCast v3.0.3** - Corrección de errores y mejoras de recursos
