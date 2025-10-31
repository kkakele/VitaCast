# ?? GitHub Actions - Configuraci?n Completa

## ? ?Todo Listo!

He configurado **GitHub Actions** para compilar autom?ticamente VitaCast y crear releases.

---

## ?? ?Qu? se Ha Creado?

### ?? Workflows (2)

1. **`.github/workflows/build-and-release.yml`**
   - ? Compila y crea releases p?blicos
   - ? Se ejecuta al crear tags `v*.*.*`
   - ? Tambi?n ejecutable manualmente
   - ? Genera VitaCast.vpk y VitaCast-Simple.vpk
   - ? Crea release en GitHub autom?ticamente

2. **`.github/workflows/build-dev.yml`**
   - ? Compila en cada push/PR
   - ? Verifica que el c?digo compila correctamente
   - ? Guarda artefactos por 30 d?as
   - ? Comenta en PRs con resultados

### ?? Documentaci?n (3)

1. **`.github/QUICK_START.md`**
   - ? Gu?a r?pida en 3 pasos
   - Para usuarios que quieren crear un release r?pido

2. **`.github/GITHUB_ACTIONS_GUIDE.md`**
   - ?? Gu?a completa y detallada
   - Para desarrolladores y maintainers
   - Incluye troubleshooting

3. **`.github/README.md`**
   - ?? Descripci?n de la carpeta .github
   - ?ndice de todos los workflows y docs

---

## ?? C?mo Usar (3 Opciones)

### Opci?n 1: Autom?tico con Tag (Recomendado) ?

```bash
git tag v2.0.0
git push origin v2.0.0
```

? En ~5 minutos tendr?s un release p?blico con VPKs descargables.

### Opci?n 2: Manual desde GitHub ???

1. Ve a tu repo en GitHub
2. Click en **Actions**
3. Selecciona **"Build VitaCast and Create Release"**
4. Click en **"Run workflow"**
5. Ingresa versi?n: `2.0.0`
6. Click en **"Run workflow"** (verde)

### Opci?n 3: Solo Compilar (Sin Release) ??

Simplemente haz push y el workflow de desarrollo compilar? autom?ticamente:

```bash
git push origin tu-rama
```

Los artefactos estar?n disponibles en la pesta?a Actions.

---

## ?? Estructura Completa

```
.github/
??? workflows/
?   ??? build-and-release.yml  # Crear releases p?blicos
?   ??? build-dev.yml           # Builds de desarrollo
??? GITHUB_ACTIONS_GUIDE.md     # Gu?a completa
??? QUICK_START.md              # Gu?a r?pida (3 pasos)
??? README.md                   # ?ndice de .github/
```

---

## ?? Flujo Completo

### Desarrollo Normal

```
git commit -m "Nueva funci?n"
    ?
git push origin develop
    ?
[GitHub Actions] Compila autom?ticamente
    ?
? Artefactos disponibles en Actions (30 d?as)
```

### Crear Release P?blico

```
git tag v2.0.0
    ?
git push origin v2.0.0
    ?
[GitHub Actions] Compila + Crea Release
    ?
? Release p?blico con VPKs en /releases
```

---

## ?? Verificar que Funciona

### 1. Ver Workflows Disponibles

```
GitHub Repo ? Actions ? Workflows (barra izquierda)
```

Deber?as ver:
- ? Build VitaCast and Create Release
- ? Build Development

### 2. Ejecutar Test Manual

1. Ve a Actions
2. Click en "Build VitaCast and Create Release"
3. Click en "Run workflow"
4. Ingresa versi?n: `2.0.0`
5. Ejecutar

En ~5 minutos ver?s el release en `/releases`.

---

## ?? Qu? Genera Cada Workflow

### Build and Release

**Output**:
```
Release v2.0.0
??? VitaCast.vpk (versi?n completa)
??? VitaCast-Simple.vpk (versi?n b?sica)
??? Notas del release (generadas autom?ticamente)
```

**Acceso**: `github.com/usuario/repo/releases/tag/v2.0.0`

### Build Development

**Output**:
```
Artefactos
??? vitacast-dev-[commit-hash]/
?   ??? VitaCast-Simple.vpk
?   ??? checksums.txt
```

**Acceso**: Actions ? Workflow espec?fico ? Artifacts

---

## ?? Configuraci?n Necesaria

### Permisos (Importante)

Ve a: **Settings ? Actions ? General ? Workflow permissions**

? Selecciona: **"Read and write permissions"**  
? Marca: **"Allow GitHub Actions to create and approve pull requests"**

### GitHub Actions Habilitado

Ve a: **Settings ? Actions ? General**

? Selecciona: **"Allow all actions and reusable workflows"**

---

## ?? Ventajas de Esta Setup

### ? Para Usuarios Finales
- VPKs compilados profesionalmente
- Descarga directa desde Releases
- No necesitan conocimientos t?cnicos
- Siempre la ?ltima versi?n disponible

### ? Para Desarrolladores
- No necesitan instalar VitaSDK localmente
- Compilaci?n en la nube (gratis)
- Verificaci?n autom?tica de c?digo
- Feedback r?pido sobre errores

### ? Para Maintainers
- CI/CD completamente automatizado
- Releases consistentes
- Menos trabajo manual
- Logs detallados para debugging

---

## ?? Tecnolog?as Utilizadas

- **GitHub Actions** - Plataforma de CI/CD
- **Docker** - Contenedor `vitasdk/vitasdk:latest`
- **VitaSDK** - SDK de desarrollo para PS Vita
- **vita-mksfoex** - Crear archivos SFO
- **vita-pack-vpk** - Empaquetar VPKs

---

## ?? Estad?sticas

| M?trica | Valor |
|---------|-------|
| Workflows creados | 2 |
| Documentos creados | 3 |
| Tiempo de compilaci?n | ~5 min |
| Artefactos por build | 2 VPKs |
| Retenci?n artefactos | 30 d?as |
| Costo | Gratis (GitHub Actions free tier) |

---

## ?? Pr?ximos Pasos

1. **Prueba el Workflow**
   ```bash
   git tag v2.0.0-test
   git push origin v2.0.0-test
   ```

2. **Verifica el Release**
   - Ve a la pesta?a Releases
   - Descarga el VPK
   - Pru?balo en tu PS Vita

3. **Itera**
   - Haz cambios en el c?digo
   - Push a tu rama
   - El workflow compila autom?ticamente
   - Cuando est?s listo, crea un nuevo tag

---

## ?? Documentaci?n de Referencia

- **[Quick Start](.github/QUICK_START.md)** - Empezar en 3 pasos
- **[GitHub Actions Guide](.github/GITHUB_ACTIONS_GUIDE.md)** - Gu?a completa
- **[.github README](.github/README.md)** - ?ndice de workflows

---

## ? Ejemplo Completo

```bash
# 1. Hacer cambios
nano main.c
git add main.c
git commit -m "Mejora en la UI"

# 2. Push (compila autom?ticamente)
git push origin main

# 3. Cuando est?s listo para release
git tag v2.0.0
git push origin v2.0.0

# 4. Espera 5 minutos

# 5. Descarga desde:
# https://github.com/usuario/repo/releases/tag/v2.0.0
```

---

## ? Checklist Final

Antes de crear tu primer release, verifica:

- [ ] Workflows est?n en `.github/workflows/`
- [ ] Permisos de GitHub Actions configurados
- [ ] Actions habilitado en el repo
- [ ] C?digo est? pushed a GitHub
- [ ] Makefile_complete funciona
- [ ] README.md actualizado

---

## ?? ?Listo!

Todo est? configurado. Ahora solo necesitas:

```bash
git tag v2.0.0
git push origin v2.0.0
```

Y en ~5 minutos tendr?s tu release p?blico con VPKs descargables. ????

---

**?? CI/CD Autom?tico para VitaCast** | **Compilado con VitaSDK** | **100% Open Source**
