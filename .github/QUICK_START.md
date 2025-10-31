# ? Quick Start - Crear tu Primer Release

## ?? Objetivo

Crear un release de VitaCast v2.0.0 con GitHub Actions en **3 pasos**.

---

## ?? Requisitos Previos

- ? C?digo pushed a GitHub
- ? GitHub Actions habilitado en tu repo
- ? Nada m?s (VitaSDK se instala autom?ticamente)

---

## ?? M?todo 1: Autom?tico (Recomendado)

### Paso 1: Crear el Tag

```bash
git tag v2.0.0
git push origin v2.0.0
```

### Paso 2: Esperar

GitHub Actions autom?ticamente:
1. Compila VitaCast ? (~5 min)
2. Crea el release ??
3. Sube los VPKs ??

### Paso 3: Descargar

Visita: `https://github.com/TU_USUARIO/TU_REPO/releases/tag/v2.0.0`

---

## ??? M?todo 2: Manual (Desde la Web)

### Paso 1: Ir a Actions

1. Abre tu repo en GitHub
2. Click en **"Actions"** (arriba)

### Paso 2: Ejecutar Workflow

1. Click en **"Build VitaCast and Create Release"** (izquierda)
2. Click en **"Run workflow"** (bot?n azul, derecha)
3. Escribe la versi?n: `2.0.0`
4. Click en **"Run workflow"** (verde)

### Paso 3: Esperar y Descargar

- Espera ~5 minutos
- El release aparecer? autom?ticamente

---

## ?? ?Qu? Obtienes?

Cada release incluye:

```
?? VitaCast v2.0.0/
??? ?? VitaCast.vpk (versi?n completa)
??? ?? VitaCast-Simple.vpk (versi?n b?sica)
??? ?? Notas del release (autom?ticas)
```

---

## ?? ?C?mo Instalar en PS Vita?

1. Descarga `VitaCast.vpk` del release
2. Transfiere a tu PS Vita con VitaShell
3. Instala el VPK
4. ?Listo!

---

## ?? Verificar que Funciona

### Ver el Workflow Ejecut?ndose

```
GitHub Repo ? Actions ? "Build VitaCast and Create Release"
```

Ver?s:
- ? Pasos completados en verde
- ?? Tiempo de ejecuci?n
- ?? Logs detallados

### Ver el Release Creado

```
GitHub Repo ? Releases ? v2.0.0
```

Ver?s:
- ?? Archivos VPK descargables
- ?? Notas del release
- ??? Tag del release

---

## ?? Problemas Comunes

### "El workflow no se ejecuta"

**Causa**: GitHub Actions no habilitado.

**Soluci?n**:
1. Repo ? Settings ? Actions ? General
2. "Allow all actions" ? Save

### "No aparece el release"

**Causa**: El workflow est? en progreso o fall?.

**Soluci?n**:
1. Ve a Actions
2. Revisa si hay errores (? rojo)
3. Click en el workflow ? Lee los logs

### "Error de permisos"

**Causa**: Permisos de workflow incorrectos.

**Soluci?n**:
1. Repo ? Settings ? Actions ? General
2. Scroll a "Workflow permissions"
3. Selecciona "Read and write permissions"
4. Save

---

## ?? Pr?ximos Pasos

Una vez que tengas tu primer release:

- [ ] Compartir el link del release
- [ ] Probar el VPK en tu PS Vita
- [ ] Reportar issues si los hay
- [ ] Iterar con nuevas versiones

---

## ?? M?s Informaci?n

- **Gu?a Completa**: Ver `.github/GITHUB_ACTIONS_GUIDE.md`
- **Documentaci?n**: Ver `README.md`
- **Mejoras T?cnicas**: Ver `MEJORAS_VITASDK.md`

---

## ? Ejemplo Real

```bash
# Terminal
$ git tag v2.0.0
$ git push origin v2.0.0

# Espera 5 minutos...

# Navegador
# https://github.com/tu-usuario/vitacast/releases/tag/v2.0.0
# ? Descarga VitaCast.vpk
```

**?Eso es todo! ??**

---

**?? Tiempo total**: ~5 minutos  
**?? Dificultad**: F?cil  
**?? Resultado**: VPK listo para instalar  
