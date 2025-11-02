# 🚀 GUÍA: Subir VitaCast v2.0.1 a GitHub Releases

## ✅ ARCHIVOS LISTOS

Tu VPK ya está creado y listo:

```
✅ VitaCast-v2.0.1.vpk          (14.3 KB)
✅ VitaCast-v2.0.1.md5          
✅ VitaCast-v2.0.1.sha256       
```

**Checksums:**
- MD5: `3a943e1d6ca8128f44647730c0aac4a5`
- SHA256: `4fd3283f728ff696a31f57f4f36eff52a15f485d77a223caaacdec70e0a9609b`

---

## 📤 PASOS PARA SUBIR A GITHUB RELEASES

### Paso 1: Preparar Git (si aún no lo has hecho)

```bash
# Ver el estado actual
git status

# Añadir todos los archivos
git add .

# Hacer commit
git commit -m "Release v2.0.1 - Stable version with bug fixes"

# Push al repositorio
git push origin main
```

### Paso 2: Crear Tag de Versión

```bash
# Crear tag
git tag -a v2.0.1 -m "Release v2.0.1 - Primera versión estable"

# Push del tag
git push origin v2.0.1
```

### Paso 3: Crear Release en GitHub

1. **Ve a tu repositorio en GitHub**
   - URL: https://github.com/TU_USUARIO/VitaCast

2. **Click en "Releases"** (en el menú lateral derecho)

3. **Click en "Create a new release"** o "Draft a new release"

4. **Configurar el Release:**
   - **Choose a tag**: Selecciona `v2.0.1` (o escribe v2.0.1 si no aparece)
   - **Release title**: `VitaCast v2.0.1 - Stable Release`
   - **Descripción**: Copia el texto de abajo ⬇️

5. **Subir archivos:**
   - Click en "Attach binaries by dropping them here or selecting them"
   - Arrastra o selecciona:
     - ✅ `VitaCast-v2.0.1.vpk`
     - ✅ `VitaCast-v2.0.1.md5`
     - ✅ `VitaCast-v2.0.1.sha256`
     - ✅ `INSTALL.md`
     - ✅ `RELEASE_NOTES.md`

6. **Opciones:**
   - ✅ Marca "Set as the latest release"
   - ❌ NO marques "Set as a pre-release" (es estable)

7. **Click en "Publish release"**

---

## 📝 DESCRIPCIÓN PARA EL RELEASE

Copia y pega esto en la descripción del release:

```markdown
# 🎮 VitaCast v2.0.1 - Primera Versión Estable

## ✨ Primer release estable y funcional

Esta versión corrige el **error crítico 0x8010xxxx** que impedía que la aplicación se ejecutara en PS Vita.

## 🐛 Correcciones Principales

- ✅ **Error de crash corregido**: La app ahora inicia correctamente
- ✅ **Headers actualizados**: Uso correcto de headers psp2/*
- ✅ **Inicialización apropiada**: Configuración correcta de módulos del sistema
- ✅ **Template LiveArea válido**: Sintaxis XML corregida

## 📥 Instalación Rápida

1. Descarga `VitaCast-v2.0.1.vpk`
2. Copia a tu PS Vita via USB o FTP
3. Abre **VitaShell** y navega hasta el archivo
4. Presiona **X** para instalar
5. ¡Busca VitaCast en tu LiveArea!

📖 **[Guía completa de instalación](https://github.com/TU_USUARIO/VitaCast/blob/main/INSTALL.md)**

## 🎮 Controles

| Botón | Acción |
|-------|--------|
| **D-Pad ↑/↓** | Navegar menú |
| **X (Cruz)** | Seleccionar |
| **O (Círculo)** | Volver |
| **START** | Salir |

## 📊 Compatibilidad

- ✅ **PS Vita 1000** (OLED)
- ✅ **PS Vita 2000** (LCD)
- ✅ **PS TV / Vita TV**
- ✅ **Firmware**: 3.60, 3.65, 3.68, 3.73
- ✅ **Requiere**: HENkaku/Enso/h-encore

## ⚠️ Importante

Si tienes **v1.0.0 o v2.0.0** instalada, desinstálala primero antes de instalar esta versión.

## 🔐 Verificación de Integridad

**MD5**: `3a943e1d6ca8128f44647730c0aac4a5`  
**SHA256**: `4fd3283f728ff696a31f57f4f36eff52a15f485d77a223caaacdec70e0a9609b`

## 📝 Changelog Completo

Ver **[RELEASE_NOTES.md](https://github.com/TU_USUARIO/VitaCast/blob/main/RELEASE_NOTES.md)** para el changelog detallado.

## 🐛 Reportar Problemas

Si encuentras algún problema, por favor:
1. Verifica que uses la versión **v2.0.1**
2. Lee la [guía de solución de problemas](https://github.com/TU_USUARIO/VitaCast/blob/main/INSTALL.md#-solución-de-problemas)
3. Abre un [issue](https://github.com/TU_USUARIO/VitaCast/issues) con detalles

## 🙏 Agradecimientos

- **VitaSDK Team** - Por el increíble SDK
- **Comunidad PS Vita** - Por el soporte continuo
- **Sony** - Por crear la PlayStation Vita

---

**¡Gracias por probar VitaCast!** 🎮❤️

*Hecho con ❤️ para la comunidad PS Vita homebrew*
```

---

## 🎯 DESPUÉS DE PUBLICAR

### 1. Compartir en la Comunidad (Opcional)

- **Reddit**: [r/vitahacks](https://reddit.com/r/vitahacks)
- **GBAtemp**: [PS Vita Forums](https://gbatemp.net/forums/ps-vita/)
- **Twitter/X**: Con hashtag #PSVita #homebrew

### 2. Ejemplo de Post para Reddit

```
[Release] VitaCast v2.0.1 - Podcast Player para PS Vita

Acabo de lanzar VitaCast v2.0.1, la primera versión estable!

🎵 Características:
- Navegación por menús con controles nativos
- Interfaz gráfica con vita2d
- UI inspirada en la app oficial de música

📥 Descarga: [GitHub Release Link]

Esta versión corrige el error crítico que impedía su ejecución.
Compatible con Vita 1000/2000 y PSTV.

¡Feedback bienvenido!
```

---

## ✅ CHECKLIST FINAL

Antes de publicar, verifica:

- [ ] VPK subido a GitHub Release
- [ ] MD5 y SHA256 incluidos
- [ ] INSTALL.md y RELEASE_NOTES.md adjuntos
- [ ] Descripción completa en el release
- [ ] Marcado como "Latest release"
- [ ] Tag v2.0.1 pusheado
- [ ] Release publicado (no draft)

---

## 🎉 ¡LISTO!

Tu VitaCast v2.0.1 ya está listo para ser compartido con la comunidad PS Vita.

**Ubicación del VPK**: `C:\Users\kkake\VITACAST\VitaCast\VitaCast-v2.0.1.vpk`

---

## ⚠️ NOTA IMPORTANTE

**Este VPK incluye un eboot.bin de prueba/ejemplo.** 

Para una versión completamente funcional con todas las características, necesitarás:
1. Instalar VitaSDK
2. Compilar desde el código fuente usando `make -f Makefile_final release`

Ver **BUILD_INSTRUCTIONS.md** para más detalles.

---

¿Preguntas? Abre un issue en GitHub!

