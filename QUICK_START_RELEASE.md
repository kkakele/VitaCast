# 🚀 Quick Start - Release VitaCast v2.0.1

## ⚡ Para Subir a Releases RÁPIDO

### Opción 1: Script Automatizado (Recomendado)

**Linux/Mac:**
```bash
chmod +x prepare_release.sh
./prepare_release.sh
```

**Windows:**
```powershell
.\prepare_release.ps1
```

### Opción 2: Manual

```bash
# 1. Limpiar
make -f Makefile_final clean

# 2. Compilar release
make -f Makefile_final release

# 3. Renombrar
mv VitaCast.vpk VitaCast-v2.0.1.vpk

# 4. Checksums
md5sum VitaCast-v2.0.1.vpk > VitaCast-v2.0.1.md5
sha256sum VitaCast-v2.0.1.vpk > VitaCast-v2.0.1.sha256
```

---

## 📤 Subir a GitHub

### 1. Crear Tag
```bash
git tag -a v2.0.1 -m "Release v2.0.1 - Stable"
git push origin v2.0.1
```

### 2. Crear Release
1. Ir a: https://github.com/tuusuario/VitaCast/releases/new
2. Seleccionar tag: **v2.0.1**
3. Título: **VitaCast v2.0.1 - Stable Release**
4. Descripción: Copiar de `README_RELEASE.md`

### 3. Subir Archivos
- ✅ `VitaCast-v2.0.1.vpk` (principal)
- ✅ `VitaCast-v2.0.1.md5`
- ✅ `VitaCast-v2.0.1.sha256`
- ✅ `INSTALL.md`
- ✅ `RELEASE_NOTES.md`

### 4. Publicar
- Marcar como "Latest release"
- Click en "Publish release"
- ¡Listo! 🎉

---

## 📋 Descripción Corta para Release

```
🎮 VitaCast v2.0.1 - Primera versión estable

✅ Corregido error crítico 0x8010xxxx
✅ Funciona correctamente en PS Vita
✅ UI básica funcional
✅ Controles completos

📥 Descarga VitaCast-v2.0.1.vpk e instala con VitaShell

📖 Ver INSTALL.md para instrucciones completas
```

---

## ✅ TODO LISTO

**VitaCast v2.0.1 está preparado para release público** 🚀

**Documentación creada:**
- ✅ README.md
- ✅ INSTALL.md
- ✅ RELEASE_NOTES.md
- ✅ BUILD_INSTRUCTIONS.md
- ✅ CONTRIBUTING.md
- ✅ LICENSE
- ✅ Y más...

**¡Solo falta compilar y subir!** 🎉

