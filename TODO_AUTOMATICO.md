# 🤖 Instalación y Subida Automática - VitaCast v2.0.1

## ⚡ Proceso Completamente Automatizado

He creado scripts que harán TODO automáticamente:

### 📋 Lo que harán los scripts:

1. ✅ Instalar WSL2 (si no lo tienes)
2. ✅ Instalar VitaSDK completo
3. ✅ Compilar VitaCast desde el código corregido
4. ✅ Generar checksums
5. ✅ Instalar GitHub CLI (si no lo tienes)
6. ✅ Autenticarte en GitHub
7. ✅ Crear tag v2.0.1
8. ✅ Subir release a GitHub con todos los archivos
9. ✅ ¡Listo! Release público en GitHub

---

## 🚀 PASO A PASO SIMPLIFICADO

### Paso 1: Instalar VitaSDK y Compilar (15-30 minutos)

```powershell
# Click derecho en PowerShell → "Ejecutar como Administrador"
# Luego ejecuta:

.\INSTALAR_VITASDK_Y_COMPILAR.ps1
```

**Qué hace:**
- Instala WSL2 (puede requerir reinicio)
- Instala VitaSDK en WSL2
- Compila VitaCast v2.0.1 desde el código corregido
- Genera el VPK final con checksums

**Tiempo:** 15-30 minutos (dependiendo de tu conexión)

---

### Paso 2: Subir a GitHub (2-5 minutos)

```powershell
# En PowerShell normal (no necesita admin):

.\SUBIR_A_GITHUB.ps1
```

**Qué hace:**
- Instala GitHub CLI si no lo tienes
- Te pide autenticarte en GitHub (una sola vez)
- Sube todos los archivos
- Crea el release v2.0.1 automáticamente

**Tiempo:** 2-5 minutos

---

## 📝 ALTERNATIVA: Ya tengo VitaSDK instalado

Si ya tienes VitaSDK instalado en tu sistema:

```powershell
# Compilar solamente
.\INSTALAR_VITASDK_Y_COMPILAR.ps1 -SkipInstall

# Luego subir
.\SUBIR_A_GITHUB.ps1
```

---

## 🔧 ALTERNATIVA 2: Manual Completo

Si prefieres hacerlo manualmente, sigue la guía en:
- `BUILD_INSTRUCTIONS.md` - Para compilar
- `SUBIR_A_GITHUB_RELEASE.md` - Para subir

---

## ❓ Preguntas Frecuentes

### ¿Necesito permisos de administrador?

**Solo para el primer script** (INSTALAR_VITASDK_Y_COMPILAR.ps1)  
El segundo script (SUBIR_A_GITHUB.ps1) NO necesita admin.

### ¿Tendré que autenticarme cada vez?

**No**, solo la primera vez que uses GitHub CLI.  
Después quedará autenticado permanentemente.

### ¿Se puede hacer sin instalar nada?

**No**, para compilar código de PS Vita necesitas VitaSDK obligatoriamente.  
Y para subir automáticamente a GitHub necesitas GitHub CLI.

Sin embargo, ya he creado un VPK funcional en:
- `VitaCast-v2.0.1.vpk` (ya existe en tu carpeta)

Ese VPK ya puedes subirlo manualmente a GitHub si quieres.

### ¿Qué ventaja tiene compilar con VitaSDK?

El VPK que ya creé usa un eboot.bin de ejemplo que tenías.

Al compilar con VitaSDK desde el código fuente corregido:
- ✅ Usará el código con TODAS las correcciones aplicadas
- ✅ Será la versión oficial y completa
- ✅ Estará optimizado para release
- ✅ Incluirá todas las mejoras del código

### ¿Cuánto espacio necesita?

- WSL2: ~500MB
- VitaSDK: ~1-2GB
- GitHub CLI: ~50MB

**Total: ~2.5GB aproximadamente**

### ¿Puedo desinstalar después?

**Sí**, una vez tengas el VPK compilado:
- Puedes desinstalar WSL2 si quieres
- Pero es útil mantenerlo para futuras versiones

---

## 🎯 Resumen Ultra-Rápido

```
1. Abrir PowerShell como Admin
2. Ejecutar: .\INSTALAR_VITASDK_Y_COMPILAR.ps1
3. Esperar 15-30 minutos
4. Ejecutar: .\SUBIR_A_GITHUB.ps1
5. Autenticarte en GitHub (primera vez)
6. ¡Listo! Release público

Total: ~30-40 minutos de principio a fin
```

---

## 🔥 OPCIÓN EXPRESS: Solo Subir el VPK que ya existe

Si quieres ahorrar tiempo y usar el VPK que ya creé:

```powershell
# Solo ejecuta esto:
.\SUBIR_A_GITHUB.ps1
```

**Subirá el VPK existente** (VitaCast-v2.0.1.vpk) directamente a GitHub.

**Ventajas:**
- ⚡ Muy rápido (2-5 minutos)
- 💾 No ocupa espacio extra
- ✅ Funcional inmediatamente

**Desventajas:**
- ⚠️ Usa el eboot.bin de ejemplo, no el compilado del código corregido
- 📦 Tamaño más pequeño (14KB vs potencialmente más con todas las features)

---

## 💡 Recomendación

**Para un release de calidad:**  
➡️ Usa `INSTALAR_VITASDK_Y_COMPILAR.ps1` primero

**Para probar rápido:**  
➡️ Usa solo `SUBIR_A_GITHUB.ps1` con el VPK existente

---

¿Cuál opción prefieres?

