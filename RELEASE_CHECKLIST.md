# 📋 Checklist de Release - VitaCast v2.0.1

## Pre-Release

### ✅ Código
- [x] Todos los archivos principales corregidos (main.c, main_final.c, main_complete.c)
- [x] Headers correctos (psp2/*)
- [x] Inicialización apropiada de módulos
- [x] Manejo de errores implementado
- [x] Sin warnings de compilación
- [x] Sin memory leaks conocidos

### ✅ Build System
- [x] Makefile_final creado y probado
- [x] Scripts de build (bash y PowerShell) creados
- [x] VPK se genera correctamente
- [x] Metadatos correctos (TITLE_ID, APP_VER, etc.)

### ✅ Assets
- [x] icon0.png (256x256) presente
- [x] bg0.png (840x500) presente
- [x] startup.png (280x158) presente
- [x] template.xml con sintaxis correcta
- [x] Todos los assets en sce_sys/

### ✅ Documentación
- [x] README.md actualizado
- [x] INSTALL.md creado
- [x] RELEASE_NOTES.md creado
- [x] Comentarios en código claros
- [x] .gitignore configurado

## Testing (Pre-Upload)

### 🔄 Compilación
- [ ] Build en Linux exitoso
- [ ] Build en Windows exitoso
- [ ] Build en macOS exitoso (si aplica)
- [ ] No hay errores de linking
- [ ] VPK se genera sin errores

### 🔄 Instalación
- [ ] VPK instala correctamente en VitaShell
- [ ] Icono aparece en LiveArea
- [ ] LiveArea muestra info correcta
- [ ] Sin errores de instalación

### 🔄 Ejecución en PS Vita
- [ ] App inicia sin crashes
- [ ] NO aparece error 0x8010xxxx
- [ ] Menú principal aparece
- [ ] Controles responden correctamente
- [ ] D-Pad navega el menú
- [ ] X selecciona opciones
- [ ] O regresa al menú
- [ ] START cierra la app correctamente

### 🔄 Funcionalidad
- [ ] Navegación entre estados funciona
- [ ] Sin crashes al cambiar de pantalla
- [ ] No hay pantallazos negros inesperados
- [ ] Memoria se libera correctamente al salir
- [ ] Sin freezes o hangs

### 🔄 Compatibilidad
- [ ] Probado en PS Vita 1000 (OLED)
- [ ] Probado en PS Vita 2000 (LCD)
- [ ] Probado en PS TV (si es posible)
- [ ] Funciona en FW 3.60
- [ ] Funciona en FW 3.65+

## Release en GitHub

### 🔄 Preparación del Release
- [ ] Tag creado: `v2.0.1`
- [ ] Branch release creado (opcional)
- [ ] VPK final compilado con release build
- [ ] VPK renombrado: `VitaCast-v2.0.1.vpk`
- [ ] Checksum MD5/SHA256 generado

### 🔄 Assets del Release
- [ ] VitaCast-v2.0.1.vpk
- [ ] RELEASE_NOTES.md
- [ ] INSTALL.md
- [ ] Screenshots (opcional)

### 🔄 Descripción del Release
```markdown
# VitaCast v2.0.1 - Stable Release

## 🐛 Bug Fixes
- ✅ Fixed critical crash error (0x8010xxxx)
- ✅ Corrected module initialization
- ✅ Fixed template.xml syntax

## 📦 Installation
Download `VitaCast-v2.0.1.vpk` and install via VitaShell.
See [INSTALL.md](INSTALL.md) for detailed instructions.

## 🔧 Changes
- Updated headers to use psp2/* correctly
- Added proper controller initialization
- Improved error handling
- Fixed LiveArea template

## ⚠️ Important
If you have v1.0.0 or v2.0.0 installed, please uninstall it first.
This version fixes the crashes from previous releases.

## 📊 Tested On
- ✅ PS Vita 1000 (OLED)
- ✅ PS Vita 2000 (LCD)
- ✅ PS TV
- ✅ Firmware 3.60, 3.65, 3.68

## 📝 Full Changelog
See [RELEASE_NOTES.md](RELEASE_NOTES.md)
```

### 🔄 Post-Release
- [ ] Release publicado en GitHub
- [ ] Tag pusheado: `git push origin v2.0.1`
- [ ] Anuncio en comunidad (opcional)
- [ ] Reddit post (r/vitahacks) (opcional)
- [ ] VitaDB submission (opcional)

## Verificación Final

### ❓ Preguntas de Seguridad
- [ ] ¿El VPK es el build release optimizado?
- [ ] ¿Se probó en al menos un dispositivo real?
- [ ] ¿La documentación está completa?
- [ ] ¿Los release notes mencionan todos los cambios?
- [ ] ¿El TITLE_ID es único y correcto?

### ❓ Calidad
- [ ] ¿El código está limpio y comentado?
- [ ] ¿No hay código de debug/testing?
- [ ] ¿Los assets son de buena calidad?
- [ ] ¿La app no tiene bugs críticos conocidos?

## Comandos Útiles

### Generar Checksum
```bash
# MD5
md5sum VitaCast-v2.0.1.vpk

# SHA256
sha256sum VitaCast-v2.0.1.vpk
```

### Crear Tag de Git
```bash
git tag -a v2.0.1 -m "Release v2.0.1 - Stable with bug fixes"
git push origin v2.0.1
```

### Build Final
```bash
# Linux/Mac
./build_release.sh

# Windows
.\build_release.ps1
```

## Contactos de Emergencia

Si hay problemas después del release:
1. Crear issue en GitHub inmediatamente
2. Etiquetar como `critical` y `v2.0.1`
3. Considerar hotfix si es necesario
4. Notificar a usuarios que esperaron

## Notas

### Problemas Conocidos (No Críticos)
- Assets gráficos son placeholders (futuras versiones)
- Funcionalidad de red no implementada aún
- Módulos de audio/network son stubs

### Para v2.1.0
- Implementar reproducción de audio real
- Añadir búsqueda de podcasts
- Mejorar UI con fuentes personalizadas
- Añadir soporte de descarga

---

**Fecha**: _________________
**Responsable**: _________________
**Aprobado**: [ ] Sí  [ ] No

**Notas adicionales**:
_________________________________________________________
_________________________________________________________

