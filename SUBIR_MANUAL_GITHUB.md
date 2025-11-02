# 📤 Guía Manual - Subir VitaCast v2.0.1 a GitHub Releases

## ✅ Archivos Listos para Subir

Ya tienes todo preparado:
- ✅ `VitaCast-v2.0.1.vpk` (14.3 KB)
- ✅ `VitaCast-v2.0.1.md5`
- ✅ `VitaCast-v2.0.1.sha256`
- ✅ `INSTALL.md`
- ✅ `RELEASE_NOTES.md`

---

## 🚀 PASOS SIMPLES (5-10 minutos)

### Paso 1: Subir Código a GitHub (si no lo has hecho)

1. Abre PowerShell en la carpeta del proyecto
2. Ejecuta:

```powershell
git init
git add .
git commit -m "Release v2.0.1 - Stable version with all bug fixes"
```

3. Ve a GitHub.com y crea un nuevo repositorio llamado `VitaCast`

4. Copia la URL y ejecuta:

```powershell
git remote add origin https://github.com/TU_USUARIO/VitaCast.git
git branch -M main
git push -u origin main
```

---

### Paso 2: Crear Release en GitHub

1. **Ve a tu repositorio en GitHub:**
   - https://github.com/TU_USUARIO/VitaCast

2. **Click en "Releases"** (en el menú lateral derecho)

3. **Click en "Create a new release"**

4. **Configurar el Release:**

   **Tag version:** `v2.0.1`
   - Click en "Choose a tag"
   - Escribe: `v2.0.1`
   - Click en "Create new tag: v2.0.1 on publish"

   **Release title:** `VitaCast v2.0.1 - Stable Release`

   **Description:** Copia y pega esto:

```markdown
# 🎮 VitaCast v2.0.1 - Primera Versión Estable

## ✨ Primer release estable y funcional

Esta versión corrige el **error crítico 0x8010xxxx** que impedía que la aplicación se ejecutara en PS Vita.

## 🐛 Correcciones Principales

- ✅ **Error de crash corregido**: La app ahora inicia correctamente sin errores
- ✅ **Headers actualizados**: Uso correcto de headers psp2/* en lugar de vitasdk.h
- ✅ **Inicialización apropiada**: Configuración correcta de módulos del sistema
- ✅ **Template LiveArea válido**: Sintaxis XML corregida para LiveArea
- ✅ **Gestión de memoria**: Limpieza correcta de recursos

## 📥 Instalación Rápida

1. Descarga `VitaCast-v2.0.1.vpk`
2. Copia a tu PS Vita via USB o FTP
3. Abre **VitaShell** y navega hasta el archivo
4. Presiona **X** para instalar
5. ¡Busca VitaCast en tu LiveArea!

📖 **[Guía completa de instalación](INSTALL.md)**

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

Los checksums están incluidos en los archivos .md5 y .sha256

## 📝 Changelog Completo

Ver **[RELEASE_NOTES.md](RELEASE_NOTES.md)** para detalles técnicos completos.

## 🐛 Reportar Problemas

Si encuentras algún problema:
1. Verifica que uses la versión **v2.0.1**
2. Lee la [guía de solución de problemas](INSTALL.md#-solución-de-problemas)
3. Abre un [issue](../../issues) con detalles del error

## 🙏 Agradecimientos

- **VitaSDK Team** - Por el increíble SDK de desarrollo
- **Comunidad PS Vita** - Por el soporte continuo
- **Sony** - Por crear la PlayStation Vita

---

**¡Gracias por probar VitaCast!** 🎮❤️

*Hecho con ❤️ para la comunidad PS Vita homebrew*
```

5. **Subir archivos:**
   - Arrastra o click en "Attach binaries..."
   - Selecciona estos 5 archivos:
     - ✅ `VitaCast-v2.0.1.vpk`
     - ✅ `VitaCast-v2.0.1.md5`
     - ✅ `VitaCast-v2.0.1.sha256`
     - ✅ `INSTALL.md`
     - ✅ `RELEASE_NOTES.md`

6. **Opciones finales:**
   - ✅ Marca: "Set as the latest release"
   - ❌ NO marques: "Set as a pre-release"

7. **Click en "Publish release"**

---

## 🎉 ¡LISTO!

Tu release estará disponible en:
`https://github.com/TU_USUARIO/VitaCast/releases/tag/v2.0.1`

---

## 📊 Resumen de lo que Subiste

```
📦 VitaCast v2.0.1
├─ VitaCast-v2.0.1.vpk (14.3 KB) - El archivo principal
├─ VitaCast-v2.0.1.md5 - Checksum de seguridad
├─ VitaCast-v2.0.1.sha256 - Checksum de seguridad
├─ INSTALL.md - Guía de instalación
└─ RELEASE_NOTES.md - Changelog completo
```

**Checksums:**
- MD5: `3a943e1d6ca8128f44647730c0aac4a5`
- SHA256: `4fd3283f728ff696a31f57f4f36eff52a15f485d77a223caaacdec70e0a9609b`

---

## 💡 Consejos Adicionales

### Compartir el Release
Una vez publicado, comparte en:
- Reddit: r/vitahacks
- GBAtemp: PS Vita forums
- Twitter con #PSVita #homebrew

### Post de Ejemplo para Reddit
```
[Release] VitaCast v2.0.1 - Podcast Player para PS Vita

Primera versión estable ya disponible!

🎵 Características:
- Navegación intuitiva con controles nativos
- UI inspirada en la app oficial de música
- Corregidos todos los errores críticos

📥 Descarga: [GitHub Release Link]

Compatible con Vita 1000/2000 y PSTV
```

---

## ❓ Problemas Comunes

**"No puedo crear un tag"**
- Los tags se crean automáticamente al publicar el release
- Solo escribe `v2.0.1` en el campo de tag

**"Los archivos no se suben"**
- Arrastra los archivos directamente al área de "Attach binaries"
- Deben ser menos de 2GB en total (tu VPK es 14KB, perfecto)

**"No encuentro mi repositorio"**
- Asegúrate de haber creado el repositorio en GitHub primero
- El nombre debe coincidir con el que usas localmente

---

## 🎯 TIEMPO TOTAL: 5-10 minutos

Es MÁS RÁPIDO que configurar la autenticación de CLI! 🚀

---

¿Necesitas ayuda con algún paso? ¡Pregunta!

