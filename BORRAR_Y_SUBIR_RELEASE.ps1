# Script para borrar releases anteriores y subir la version completa
Write-Host "=== VITACAST - SUBIR RELEASE COMPLETO ===" -ForegroundColor Green
Write-Host ""

# Verificar que gh esta instalado
Write-Host "[1/5] Verificando GitHub CLI..." -ForegroundColor Cyan
try {
    $ghVersion = gh --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "GitHub CLI no instalado. Instalando..." -ForegroundColor Yellow
        winget install --id GitHub.cli --silent --accept-source-agreements
        Write-Host "GitHub CLI instalado" -ForegroundColor Green
    } else {
        Write-Host "GitHub CLI OK" -ForegroundColor Green
    }
} catch {
    Write-Host "Error verificando GitHub CLI" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/5] Listando releases existentes..." -ForegroundColor Cyan
$releases = gh release list --limit 100 2>$null
if ($releases) {
    Write-Host "Releases encontrados:" -ForegroundColor Yellow
    Write-Host $releases
    Write-Host ""
    Write-Host "Borrando releases..." -ForegroundColor Yellow
    
    # Obtener solo los tags de las releases
    $releaseTags = gh release list --limit 100 2>$null | ForEach-Object {
        $parts = $_ -split '\s+'
        if ($parts.Length -gt 0) {
            $parts[0]
        }
    }
    
    foreach ($tag in $releaseTags) {
        if ($tag) {
            Write-Host "  Borrando release: $tag" -ForegroundColor Gray
            gh release delete $tag --yes 2>$null
            # Tambien borrar el tag
            git push origin --delete $tag 2>$null
            git tag -d $tag 2>$null
        }
    }
    Write-Host "Releases borrados" -ForegroundColor Green
} else {
    Write-Host "No hay releases previos" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[3/5] Verificando archivos del proyecto..." -ForegroundColor Cyan

# Verificar que tenemos todos los archivos necesarios
$requiredFiles = @(
    "main_complete.c",
    "Makefile_final",
    "sce_sys/param.sfo",
    "sce_sys/livearea/contents/template.xml"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  OK: $file" -ForegroundColor Green
    } else {
        Write-Host "  FALTA: $file" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Host "Faltan archivos necesarios" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[4/5] Preparando release..." -ForegroundColor Cyan
$VERSION = "1.0.0"
$TAG = "v$VERSION"

Write-Host "Version: $VERSION" -ForegroundColor White
Write-Host "Tag: $TAG" -ForegroundColor White
Write-Host ""

# Asegurar que estamos en main y actualizado
Write-Host "Actualizando repositorio..." -ForegroundColor Gray
git add . 2>$null
git commit -m "Release $VERSION - Version completa" 2>$null
git push origin main 2>$null

# Crear tag
Write-Host "Creando tag $TAG..." -ForegroundColor Gray
git tag -d $TAG 2>$null
git tag $TAG -m "Release $VERSION"
git push origin $TAG --force 2>$null

Write-Host ""
Write-Host "[5/5] Esperando a que GitHub Actions compile..." -ForegroundColor Cyan
Write-Host ""
Write-Host "El workflow de GitHub Actions se ha activado automaticamente" -ForegroundColor Yellow
Write-Host "Compilara el codigo completo y creara el release en 15-20 minutos" -ForegroundColor Yellow
Write-Host ""
Write-Host "=== PROGRESO ===" -ForegroundColor Green
Write-Host "1. GitHub Actions instalara VitaSDK" -ForegroundColor White
Write-Host "2. Compilara main_complete.c con todos los modulos" -ForegroundColor White
Write-Host "3. Creara VitaCast.vpk (version completa)" -ForegroundColor White
Write-Host "4. Generara checksums MD5 y SHA256" -ForegroundColor White
Write-Host "5. Creara release automaticamente en:" -ForegroundColor White
Write-Host "   https://github.com/kkakele/VitaCast/releases" -ForegroundColor Cyan
Write-Host ""
Write-Host "=== VER PROGRESO EN TIEMPO REAL ===" -ForegroundColor Green
Write-Host "https://github.com/kkakele/VitaCast/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "Abriendo navegador..." -ForegroundColor Gray
Start-Process "https://github.com/kkakele/VitaCast/actions"
Write-Host ""
Write-Host "=== COMPLETADO ===" -ForegroundColor Green
Write-Host "El proceso esta en marcha. Espera 15-20 minutos." -ForegroundColor White

