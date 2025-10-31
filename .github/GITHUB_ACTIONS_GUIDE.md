# ?? Gu?a de GitHub Actions para VitaCast

## ?? Workflows Configurados

Este proyecto tiene **2 workflows** de GitHub Actions:

### 1. ??? Build Development (`build-dev.yml`)

**Se ejecuta autom?ticamente en**:
- Push a ramas: `main`, `develop`, `feature/*`, `cursor/*`
- Pull Requests a `main` o `develop`

**Qu? hace**:
- ? Compila VitaCast con VitaSDK
- ? Genera VPK de desarrollo
- ? Verifica la estructura del VPK
- ? Genera checksums SHA256
- ? Guarda artefactos por 30 d?as
- ? Comenta en PRs con resultados

### 2. ?? Build and Release (`build-and-release.yml`)

**Se ejecuta**:
- Autom?ticamente al crear un **tag** tipo `v*.*.*` (ej: `v2.0.0`)
- Manualmente desde GitHub Actions UI

**Qu? hace**:
- ? Compila versi?n completa y simple
- ? Genera ambos VPKs
- ? Crea un **Release** en GitHub
- ? Sube los VPKs al release
- ? Genera notas del release autom?ticamente

---

## ?? C?mo Usar

### Opci?n 1: Crear Release Autom?tico (Recomendado)

```bash
# 1. Hacer commit de tus cambios
git add .
git commit -m "Release v2.0.0"

# 2. Crear y push del tag
git tag v2.0.0
git push origin v2.0.0

# 3. GitHub Actions autom?ticamente:
#    - Compila el proyecto
#    - Crea el release
#    - Sube los VPKs
```

**Resultado**: Release p?blico en https://github.com/TU_USUARIO/TU_REPO/releases

### Opci?n 2: Release Manual

1. Ve a tu repositorio en GitHub
2. Click en **Actions** (en la barra superior)
3. Selecciona **"Build VitaCast and Create Release"**
4. Click en **"Run workflow"** (bot?n azul a la derecha)
5. Ingresa la versi?n (ej: `2.0.0`)
6. Click en **"Run workflow"** (verde)

**Resultado**: Se compila y crea el release autom?ticamente.

### Opci?n 3: Solo Compilar (Sin Release)

Simplemente haz push a cualquier rama y el workflow de desarrollo compilar? autom?ticamente:

```bash
git add .
git commit -m "Nuevas mejoras"
git push origin cursor/fix-vitacast-app-and-study-vitasdk-org-1952
```

**Resultado**: Artefactos disponibles en la pesta?a Actions por 30 d?as.

---

## ?? Qu? se Genera

Cada release incluye:

| Archivo | Descripci?n | T?pico Tama?o |
|---------|-------------|---------------|
| `VitaCast.vpk` | Versi?n completa con todas las funcionalidades | ~500 KB |
| `VitaCast-Simple.vpk` | Versi?n b?sica simplificada | ~200 KB |

Ambos archivos incluyen:
- Ejecutable compilado (`eboot.bin`)
- Metadatos (`param.sfo`)
- Recursos gr?ficos (iconos, LiveArea)

---

## ?? Verificar el Estado

### Ver Builds en Progreso

1. Ve a tu repositorio en GitHub
2. Click en **Actions**
3. Ver?s todos los workflows ejecut?ndose o completados

### Ver Logs Detallados

1. Click en cualquier workflow
2. Click en el job (ej: "build" o "release")
3. Expande cada paso para ver logs detallados

### Descargar Artefactos

**Desde la pesta?a Actions**:
1. Click en un workflow completado
2. Scroll hasta abajo
3. Secci?n "Artifacts"
4. Click para descargar el ZIP

---

## ?? Troubleshooting

### Error: "arm-vita-eabi-gcc: No such file or directory"

**Causa**: El contenedor de VitaSDK no se carg? correctamente.

**Soluci?n**: El workflow ya usa `vitasdk/vitasdk:latest`, deber?a funcionar autom?ticamente.

### Error: "VitaCast.vpk not found"

**Causa**: Error en la compilaci?n.

**Soluci?n**: 
1. Revisa los logs del paso "Compilar VitaCast"
2. Verifica que `Makefile_complete` est? correcto
3. Verifica que todos los archivos fuente existan

### Release no se crea

**Causa**: Permisos insuficientes.

**Soluci?n**: El workflow necesita `permissions: contents: write`, que ya est? configurado.

### Tag ya existe

```bash
# Si necesitas recrear un tag:
git tag -d v2.0.0           # Eliminar local
git push --delete origin v2.0.0  # Eliminar remoto
git tag v2.0.0              # Crear nuevo
git push origin v2.0.0      # Push nuevo tag
```

---

## ?? Configuraci?n Avanzada

### Cambiar la Versi?n de VitaSDK

Edita `.github/workflows/build-and-release.yml`:

```yaml
container:
  image: vitasdk/vitasdk:latest  # Cambiar a una versi?n espec?fica si es necesario
```

### Compilar Solo en Tags Espec?ficos

```yaml
on:
  push:
    tags:
      - 'v2.*.*'  # Solo tags v2.x.x
```

### Agregar Tests

A?ade un paso antes de compilar:

```yaml
- name: Ejecutar tests
  run: |
    # Tus comandos de test aqu?
    make test
```

### Compilar para M?ltiples Configuraciones

```yaml
strategy:
  matrix:
    config: [debug, release]

- name: Compilar ${{ matrix.config }}
  run: make -f Makefile_complete ${{ matrix.config }}
```

---

## ?? Estado de los Workflows

Puedes agregar badges al README:

```markdown
![Build Status](https://github.com/TU_USUARIO/TU_REPO/workflows/Build%20Development/badge.svg)
![Release](https://github.com/TU_USUARIO/TU_REPO/workflows/Build%20VitaCast%20and%20Create%20Release/badge.svg)
```

---

## ?? Recursos

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [VitaSDK Docker Hub](https://hub.docker.com/r/vitasdk/vitasdk)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)

---

## ?? Ejemplo Completo: Crear Release v2.0.0

```bash
# 1. Aseg?rate de que todos los cambios est?n commiteados
git status

# 2. Crear el tag
git tag -a v2.0.0 -m "VitaCast v2.0.0 - Mejoras basadas en VitaSDK.org"

# 3. Push del tag
git push origin v2.0.0

# 4. Espera ~5 minutos

# 5. Visita: https://github.com/TU_USUARIO/TU_REPO/releases/tag/v2.0.0
```

?Y listo! El release estar? disponible p?blicamente con los VPKs descargables. ??

---

## ? Checklist para el Primer Release

- [ ] Todos los archivos est?n commiteados
- [ ] Makefile_complete funciona localmente (opcional)
- [ ] README.md est? actualizado
- [ ] CHANGELOG.md refleja los cambios
- [ ] Tag sigue formato semver (v2.0.0)
- [ ] Push del tag realizado
- [ ] Workflow completado exitosamente
- [ ] Release visible en GitHub
- [ ] VPKs descargables

---

**?? ?Ahora VitaCast se compila autom?ticamente en cada release! ??**
