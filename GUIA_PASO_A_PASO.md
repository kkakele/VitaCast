# 🚀 Guía Paso a Paso - Subir Release Completo desde GitHub Web

## ✅ PASO 1: Borrar Releases Anteriores

### 1.1 Ir a Releases
🔗 https://github.com/kkakele/VitaCast/releases

### 1.2 Borrar cada release:
- Verás una lista de releases (v2.0.1, v1.0.0, etc.)
- **Para cada uno:**
  1. Click en el **título del release**
  2. Scroll hasta abajo
  3. Click en **"Delete this release"** (botón rojo)
  4. Confirmar con **"Delete this release"** de nuevo

### 1.3 Borrar los tags también:
🔗 https://github.com/kkakele/VitaCast/tags

- Verás los tags (v2.0.1, v1.0.0, etc.)
- **Para cada uno:**
  1. Click en el **icono de tres puntos (...)** al lado derecho
  2. Click en **"Delete tag"**
  3. Confirmar

---

## ✅ PASO 2: Activar Compilación Automática

### 2.1 Ir a GitHub Actions
🔗 https://github.com/kkakele/VitaCast/actions/workflows/build-release.yml

### 2.2 Ejecutar el workflow:
1. Verás el botón **"Run workflow"** (azul, en la parte derecha)
2. **Click en "Run workflow"**
3. Se abrirá un menú desplegable:
   ```
   Use workflow from: main ▼
   Version to build: [2.0.1]
   ```
4. **CAMBIAR** el número de versión a: `1.0.0`
5. **Click en "Run workflow"** (botón verde de abajo)

### 2.3 Confirmar que se ejecutó:
- Verás un mensaje amarillo: "Workflow run was successfully requested"
- Aparecerá una nueva entrada en la lista con un círculo amarillo girando 🟡
- Click en esa entrada para ver el progreso en tiempo real

---

## ✅ PASO 3: Monitorear Progreso (15-20 minutos)

### 3.1 Ver logs en tiempo real:
En la página del workflow verás:
```
Setup VitaSDK          🟡 (5-10 minutos)
Install additional...  ⏸️ (esperando)
Build VitaCast         ⏸️ (esperando)
Generate checksums     ⏸️ (esperando)
Rename VPK            ⏸️ (esperando)
Create Release        ⏸️ (esperando)
```

### 3.2 Estados:
- 🟡 Amarillo girando = Ejecutándose
- ✅ Verde = Completado
- ❌ Rojo = Error

### 3.3 Si hay error:
- Click en el paso con ❌
- Lee el mensaje de error
- Copia y pégame el error completo

---

## ✅ PASO 4: Verificar Release Creado

### 4.1 Cuando todo esté verde (✅):
🔗 https://github.com/kkakele/VitaCast/releases

### 4.2 Verás el nuevo release:
```
📦 VitaCast v1.0.0 - Release
   Latest

Assets:
✅ VitaCast-v1.0.0.vpk
✅ VitaCast-v1.0.0.md5
✅ VitaCast-v1.0.0.sha256
✅ INSTALL.md
✅ RELEASE_NOTES.md
```

### 4.3 ¡Listo para descargar!
- Click en **VitaCast-v1.0.0.vpk** para descargar
- Transfiere a tu PS Vita
- Instala con VitaShell

---

## 🔧 Solución de Problemas

### Si el workflow falla:
1. Ve al paso con ❌
2. Click para expandir los logs
3. Busca líneas que digan "Error" o "Failed"
4. Cópiame el error completo

### Si no aparece el botón "Run workflow":
- Refresca la página (F5)
- Asegúrate de estar en: /actions/workflows/build-release.yml
- Verifica que estés logueado en GitHub

### Si dice "No workflows found":
- Ve a la pestaña "Actions" principal
- Busca "Build VitaCast Release"
- Click en el nombre del workflow

---

## 📝 Resumen Rápido

1. **Borrar releases** → https://github.com/kkakele/VitaCast/releases
2. **Borrar tags** → https://github.com/kkakele/VitaCast/tags  
3. **Run workflow** → https://github.com/kkakele/VitaCast/actions/workflows/build-release.yml
   - Cambiar versión a: `1.0.0`
   - Click "Run workflow"
4. **Esperar 15-20 min** ☕
5. **Descargar VPK** → https://github.com/kkakele/VitaCast/releases

---

## ❓ ¿Necesitas ayuda?

Si algo no funciona o ves un error, **cópiame exactamente** lo que aparece en pantalla y te ayudo a resolverlo.

¡Mucha suerte! 🎮

