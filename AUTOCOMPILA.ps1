Write-Host "VITACAST - COMPILACION AUTOMATICA" -ForegroundColor Green
Write-Host ""

# Paso 1: Borrar releases
Write-Host "[1/5] Borrando releases antiguos..." -ForegroundColor Cyan
gh release list --limit 100 2>$null | ForEach-Object { 
    $tag = $_ -split '\s+' | Select-Object -First 1
    if ($tag) {
        Write-Host "  Eliminando: $tag"
        gh release delete $tag --yes 2>$null
    }
}

# Paso 2: Limpiar tags
Write-Host "[2/5] Limpiando tags..." -ForegroundColor Cyan
git push origin --delete v1.0.0 v2.0.1 2>$null
git tag -d v1.0.0 v2.0.1 2>$null

# Paso 3: Commit
Write-Host "[3/5] Preparando cambios..." -ForegroundColor Cyan
git add .
git commit -m "Release v1.0.0 - Version completa" 2>$null
git push origin main 2>$null

# Paso 4: Tag
Write-Host "[4/5] Creando tag v1.0.0..." -ForegroundColor Cyan
git tag v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0 --force 2>$null

# Paso 5: Confirmacion
Write-Host "[5/5] Workflow activado" -ForegroundColor Green
Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "✅ COMPILACION EN MARCHA" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub Actions compilará en 15-20 minutos" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ver aquí: https://github.com/kkakele/VitaCast/actions" -ForegroundColor Cyan
Write-Host ""

Start-Process "https://github.com/kkakele/VitaCast/actions"
