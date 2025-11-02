# Script para Subir VitaCast v2.0.1 a GitHub Releases
# Ejecutar después de compilar con INSTALAR_VITASDK_Y_COMPILAR.ps1

$ErrorActionPreference = "Stop"

$VERSION = "2.0.1"
$REPO_NAME = "VitaCast"  # Cambiar si tu repo tiene otro nombre
$VPK_FILE = "VitaCast-v$VERSION.vpk"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Subir VitaCast v$VERSION a GitHub" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# PASO 1: Verificar Archivos
# ==========================================

Write-Host "📦 PASO 1: Verificando archivos..." -ForegroundColor Green

if (-not (Test-Path $VPK_FILE)) {
    Write-Host "❌ Error: No se encontró $VPK_FILE" -ForegroundColor Red
    Write-Host ""
    Write-Host "Primero ejecuta: .\INSTALAR_VITASDK_Y_COMPILAR.ps1" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path "VitaCast-v$VERSION.md5")) {
    Write-Host "❌ Error: No se encontró VitaCast-v$VERSION.md5" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "VitaCast-v$VERSION.sha256")) {
    Write-Host "❌ Error: No se encontró VitaCast-v$VERSION.sha256" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Todos los archivos presentes" -ForegroundColor Green
Write-Host ""

# ==========================================
# PASO 2: Verificar/Instalar GitHub CLI
# ==========================================

Write-Host "📦 PASO 2: Verificando GitHub CLI..." -ForegroundColor Green

$ghInstalled = $false
try {
    $null = gh --version
    $ghInstalled = $true
    Write-Host "✅ GitHub CLI ya está instalado" -ForegroundColor Green
} catch {
    Write-Host "⚠️  GitHub CLI no está instalado" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Instalando GitHub CLI con winget..." -ForegroundColor Cyan
    
    try {
        winget install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements
        $ghInstalled = $true
        Write-Host "✅ GitHub CLI instalado" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠️  Cierra y vuelve a abrir PowerShell para usar 'gh'" -ForegroundColor Yellow
        Write-Host "Luego ejecuta este script nuevamente" -ForegroundColor Yellow
        exit 0
    } catch {
        Write-Host "❌ No se pudo instalar GitHub CLI automáticamente" -ForegroundColor Red
        Write-Host ""
        Write-Host "Instala manualmente desde:" -ForegroundColor Yellow
        Write-Host "  https://cli.github.com/" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "O descarga winget desde Microsoft Store" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""

# ==========================================
# PASO 3: Autenticar con GitHub
# ==========================================

Write-Host "📦 PASO 3: Verificando autenticación de GitHub..." -ForegroundColor Green

try {
    $authStatus = gh auth status 2>&1
    if ($authStatus -like "*Logged in*") {
        Write-Host "✅ Ya estás autenticado en GitHub" -ForegroundColor Green
    } else {
        throw "No autenticado"
    }
} catch {
    Write-Host "⚠️  No estás autenticado en GitHub" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Iniciando autenticación..." -ForegroundColor Cyan
    Write-Host "Se abrirá tu navegador para autenticarte" -ForegroundColor White
    Write-Host ""
    
    gh auth login
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error al autenticar" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ Autenticación completada" -ForegroundColor Green
}

Write-Host ""

# ==========================================
# PASO 4: Preparar Git
# ==========================================

Write-Host "📦 PASO 4: Preparando repositorio Git..." -ForegroundColor Green

# Verificar si es un repositorio git
if (-not (Test-Path ".git")) {
    Write-Host "⚠️  No es un repositorio Git. Inicializando..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Repositorio Git inicializado" -ForegroundColor Green
}

# Verificar si hay remoto configurado
$remotes = git remote 2>&1
if (-not $remotes -or $remotes -notlike "*origin*") {
    Write-Host ""
    Write-Host "⚠️  No hay remoto 'origin' configurado" -ForegroundColor Yellow
    Write-Host ""
    $repoUrl = Read-Host "Ingresa la URL de tu repositorio en GitHub (ej: https://github.com/usuario/VitaCast)"
    
    if ($repoUrl) {
        git remote add origin $repoUrl
        Write-Host "✅ Remoto 'origin' configurado" -ForegroundColor Green
    } else {
        Write-Host "❌ URL no proporcionada" -ForegroundColor Red
        exit 1
    }
}

# Add, commit y push
Write-Host ""
Write-Host "📤 Subiendo cambios a GitHub..." -ForegroundColor Cyan

git add .
git commit -m "Release v$VERSION - Stable version with all bug fixes" 2>$null
git push origin main 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Advertencia: Push falló o no hay cambios nuevos" -ForegroundColor Yellow
    Write-Host "Continuando con el release..." -ForegroundColor White
}

Write-Host "✅ Repositorio actualizado" -ForegroundColor Green
Write-Host ""

# ==========================================
# PASO 5: Crear Tag
# ==========================================

Write-Host "📦 PASO 5: Creando tag v$VERSION..." -ForegroundColor Green

# Eliminar tag local si existe
git tag -d "v$VERSION" 2>$null

# Crear nuevo tag
git tag -a "v$VERSION" -m "Release v$VERSION - Primera versión estable con correcciones críticas"

# Push del tag
git push origin "v$VERSION" --force 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al crear tag" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Tag v$VERSION creado y subido" -ForegroundColor Green
Write-Host ""

# ==========================================
# PASO 6: Crear Release
# ==========================================

Write-Host "📦 PASO 6: Creando release en GitHub..." -ForegroundColor Green
Write-Host ""

# Descripción del release
$releaseNotes = @"
# 🎮 VitaCast v$VERSION - Primera Versión Estable

## ✨ Primer release estable y funcional

Esta versión corrige el **error crítico 0x8010xxxx** que impedía que la aplicación se ejecutara en PS Vita.

## 🐛 Correcciones Principales

- ✅ **Error de crash corregido**: La app ahora inicia correctamente sin errores
- ✅ **Headers actualizados**: Uso correcto de headers psp2/* en lugar de vitasdk.h
- ✅ **Inicialización apropiada**: Configuración correcta de módulos del sistema con sceCtrlSetSamplingMode()
- ✅ **Template LiveArea válido**: Sintaxis XML corregida para LiveArea
- ✅ **Gestión de memoria**: Limpieza correcta de recursos con sceKernelExitProcess()

## 📥 Instalación Rápida

1. Descarga ``VitaCast-v$VERSION.vpk``
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
| **START** | Salir de la aplicación |

## 📊 Compatibilidad

- ✅ **PS Vita 1000** (OLED)
- ✅ **PS Vita 2000** (LCD)  
- ✅ **PS TV / Vita TV**
- ✅ **Firmware**: 3.60, 3.65, 3.68, 3.73
- ✅ **Requiere**: HENkaku/Enso/h-encore activado

## ⚠️ Importante

Si tienes **v1.0.0 o v2.0.0** instalada, desinstálala primero antes de instalar esta versión.

## 🔐 Verificación de Integridad

Los checksums están incluidos en los archivos .md5 y .sha256

## 📝 Changelog Completo

### Código Corregido
- Headers cambiados de ``<vitasdk.h>`` a ``<psp2/ctrl.h>``, ``<psp2/kernel/processmgr.h>``
- Añadida inicialización con ``sceCtrlSetSamplingMode(SCE_CTRL_MODE_ANALOG)``
- Verificación de errores en ``vita2d_init()``
- Salida limpia con ``sceKernelExitProcess(0)``
- Biblioteca ``-lSceLibKernel_stub`` añadida al Makefile

### Archivos Actualizados
- ✅ main_simple.c - Versión básica funcional
- ✅ main_final.c - Versión recomendada (usada en este build)
- ✅ main_complete.c - Versión completa
- ✅ Makefile_final - Sistema de build optimizado
- ✅ template.xml - Sintaxis XML válida

## 🐛 Reportar Problemas

Si encuentras algún problema:
1. Verifica que uses la versión **v$VERSION**
2. Lee la [guía de solución de problemas](INSTALL.md#-solución-de-problemas)
3. Abre un [issue](../../issues) con detalles del error

## 🙏 Agradecimientos

- **VitaSDK Team** - Por el increíble SDK de desarrollo
- **Comunidad PS Vita** - Por el soporte continuo
- **Sony** - Por crear la PlayStation Vita

---

**¡Gracias por probar VitaCast!** 🎮❤️

*Hecho con ❤️ para la comunidad PS Vita homebrew*
"@

# Guardar notas en archivo temporal
$releaseNotes | Out-File -FilePath "release_notes_temp.md" -Encoding UTF8

Write-Host "Creando release en GitHub..." -ForegroundColor Cyan

try {
    gh release create "v$VERSION" `
        --title "VitaCast v$VERSION - Stable Release" `
        --notes-file "release_notes_temp.md" `
        --latest `
        "$VPK_FILE" `
        "VitaCast-v$VERSION.md5" `
        "VitaCast-v$VERSION.sha256" `
        "INSTALL.md" `
        "RELEASE_NOTES.md"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host "  ✅ RELEASE PUBLICADO EXITOSAMENTE" -ForegroundColor Green
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host ""
        
        # Obtener URL del release
        $repoInfo = gh repo view --json url -q .url
        Write-Host "🎉 Release disponible en:" -ForegroundColor Cyan
        Write-Host "   $repoInfo/releases/tag/v$VERSION" -ForegroundColor White
        Write-Host ""
        
        Write-Host "Archivos subidos:" -ForegroundColor White
        Write-Host "  ✅ VitaCast-v$VERSION.vpk" -ForegroundColor Green
        Write-Host "  ✅ VitaCast-v$VERSION.md5" -ForegroundColor Green
        Write-Host "  ✅ VitaCast-v$VERSION.sha256" -ForegroundColor Green
        Write-Host "  ✅ INSTALL.md" -ForegroundColor Green
        Write-Host "  ✅ RELEASE_NOTES.md" -ForegroundColor Green
        Write-Host ""
        
    } else {
        throw "Error al crear release"
    }
    
} catch {
    Write-Host ""
    Write-Host "❌ Error al crear el release: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Intenta manualmente:" -ForegroundColor Yellow
    Write-Host "  gh release create v$VERSION --title 'VitaCast v$VERSION' $VPK_FILE" -ForegroundColor Cyan
    exit 1
} finally {
    # Limpiar archivo temporal
    Remove-Item -Path "release_notes_temp.md" -ErrorAction SilentlyContinue
}

Write-Host "🎊 ¡VitaCast v$VERSION ya está disponible para la comunidad!" -ForegroundColor Green
Write-Host ""

