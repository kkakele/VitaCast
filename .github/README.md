# ?? .github Directory

Esta carpeta contiene la configuraci?n de **GitHub Actions** y documentaci?n relacionada para VitaCast.

## ?? Contenido

### ?? Workflows (`.github/workflows/`)

| Archivo | Descripci?n | Cu?ndo se Ejecuta |
|---------|-------------|-------------------|
| `build-and-release.yml` | Compilar y crear releases p?blicos | Al crear tags `v*.*.*` o manualmente |
| `build-dev.yml` | Compilar builds de desarrollo | Push a ramas principales o PRs |

### ?? Documentaci?n

| Archivo | Descripci?n | Para Qui?n |
|---------|-------------|------------|
| `QUICK_START.md` | ? Gu?a r?pida (3 pasos) | Usuarios que quieren crear un release r?pido |
| `GITHUB_ACTIONS_GUIDE.md` | ?? Gu?a completa de CI/CD | Desarrolladores y maintainers |
| `README.md` | ?? Este archivo | Referencia general |

---

## ?? Uso R?pido

### Para Usuarios: Crear un Release

```bash
git tag v2.0.0
git push origin v2.0.0
```

? Release creado autom?ticamente en ~5 minutos

### Para Desarrolladores: Ver Estado

1. Ve a la pesta?a **Actions** en GitHub
2. Ver?s todos los workflows ejecut?ndose
3. Click en cualquiera para ver logs detallados

---

## ?? Workflows Explicados

### 1. Build and Release

**Archivo**: `build-and-release.yml`

**Funci?n**: 
- Compila VitaCast con VitaSDK
- Genera VPK completo y simple
- Crea release en GitHub
- Sube VPKs al release
- Genera notas autom?ticas

**Trigger**:
```yaml
on:
  push:
    tags: ['v*.*.*']
  workflow_dispatch:
```

**Pasos**:
1. Checkout del c?digo
2. Compilar con `vitasdk/vitasdk:latest`
3. Generar VPKs
4. Crear release
5. Subir archivos

### 2. Build Development

**Archivo**: `build-dev.yml`

**Funci?n**:
- Compilar en cada push/PR
- Verificar que el c?digo compila
- Generar artefactos de desarrollo
- Comentar en PRs con resultados

**Trigger**:
```yaml
on:
  push:
    branches: [main, develop, feature/**, cursor/**]
  pull_request:
    branches: [main, develop]
```

**Pasos**:
1. Checkout del c?digo
2. Compilar con VitaSDK
3. Verificar VPKs
4. Generar checksums
5. Subir artefactos (30 d?as)

---

## ?? Ventajas de Esta Configuraci?n

### ? Para Usuarios
- VPKs compilados autom?ticamente
- Releases p?blicos en GitHub
- No necesitan instalar VitaSDK
- Descarga directa y f?cil

### ? Para Desarrolladores
- Compilaci?n autom?tica en cada push
- Verificaci?n de PRs
- Artefactos de desarrollo disponibles
- Feedback r?pido sobre errores

### ? Para Maintainers
- CI/CD completamente automatizado
- Releases consistentes
- Logs detallados
- F?cil de mantener

---

## ?? Troubleshooting

### ?El workflow no se ejecuta?

**Soluci?n**: Ve a Settings ? Actions ? General ? Allow all actions

### ?No aparece el release?

**Soluci?n**: Ve a Actions y revisa si el workflow complet? exitosamente

### ?Error de permisos?

**Soluci?n**: Settings ? Actions ? Workflow permissions ? Read and write

---

## ?? Documentaci?n Completa

Para m?s detalles, consulta:

- **[QUICK_START.md](QUICK_START.md)** - Empezar en 3 pasos
- **[GITHUB_ACTIONS_GUIDE.md](GITHUB_ACTIONS_GUIDE.md)** - Gu?a completa

---

## ?? Actualizar los Workflows

Para modificar los workflows:

1. Edita los archivos `.yml` en `workflows/`
2. Commit y push
3. Los cambios se aplican autom?ticamente

Ejemplo:
```bash
nano .github/workflows/build-and-release.yml
git add .github/workflows/build-and-release.yml
git commit -m "Update workflow"
git push
```

---

## ?? Recursos

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [VitaSDK Docker Image](https://hub.docker.com/r/vitasdk/vitasdk)

---

**?? Automatizaci?n completa para VitaCast** ????
