# 🎮 Guía SIMPLE - Compilar VitaCast en Windows 11

## Paso 1: Instalar VitaSDK (10 minutos)

### Opción A: Instalador Automático (MÁS FÁCIL) ⭐

1. Descarga el instalador: https://github.com/vitasdk/vdpm/releases/latest
2. Busca el archivo: `vdpm-windows.zip`
3. Descomprímelo en `C:\vitasdk`
4. Abre PowerShell como Administrador y ejecuta:

```powershell
cd C:\vitasdk
.\install-all.cmd
```

5. Espera 10-15 minutos mientras se instala todo

### Opción B: WSL2 con Ubuntu (alternativa)

Si la opción A no funciona:

1. Abre PowerShell como Administrador:
```powershell
wsl --install
```

2. Reinicia tu PC

3. Cuando arranque Ubuntu, crea usuario y contraseña

4. Dentro de Ubuntu ejecuta:
```bash
wget https://github.com/vitasdk/vdpm/releases/latest/download/install-vitasdk.sh
bash install-vitasdk.sh
```

---

## Paso 2: Descargar VitaCast (1 minuto)

### Si tienes Git instalado:

Abre CMD o PowerShell:
```cmd
cd %USERPROFILE%\Desktop
git clone https://github.com/kkakele/VitaCast
cd VitaCast
git checkout cursor/investigate-vitacast-vitashell-error-3d-1a3e
```

### Si NO tienes Git:

1. Ve a: https://github.com/kkakele/VitaCast
2. Click en "Code" → "Download ZIP"
3. Descomprime en tu Escritorio
4. Cambia a la rama correcta:
   - Ve a: https://github.com/kkakele/VitaCast/tree/cursor/investigate-vitacast-vitashell-error-3d-1a3e
   - Click "Code" → "Download ZIP"
   - Descomprime en `C:\VitaCast`

---

## Paso 3: Compilar (2 minutos)

### Opción A: Con VitaSDK en Windows

Abre CMD o PowerShell:

```cmd
cd C:\VitaCast
set VITASDK=C:\vitasdk
set PATH=%VITASDK%\bin;%PATH%

mkdir build
cd build
cmake ..
make
```

### Opción B: Con WSL2/Ubuntu

Abre Ubuntu desde el menú inicio:

```bash
cd /mnt/c/VitaCast
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

mkdir build
cd build
cmake ..
make
```

---

## Paso 4: Tu VPK está listo! 🎉

El archivo se llama: **`VitaCast.vpk`**

### Lo encuentras en:
- **Windows**: `C:\VitaCast\build\VitaCast.vpk`
- **WSL2**: `/mnt/c/VitaCast/build/VitaCast.vpk` (también en `C:\VitaCast\build\`)

### Ahora cópialo a tu PS Vita:

**Método 1 - USB** (más fácil):
1. Conecta PS Vita por USB
2. En la Vita: Abre VitaShell → Presiona SELECT
3. Modo USB activado
4. En tu PC: Copia `VitaCast.vpk` a `ux0:`
5. En la Vita: Presiona SELECT otra vez (desactivar USB)
6. Navega al VPK → Presiona X → Instalar

**Método 2 - FTP**:
1. En la Vita: Abre VitaShell → Presiona SELECT
2. Apunta la IP que aparece (ej: 192.168.1.100:1337)
3. En tu PC: Abre explorador de archivos
4. En la barra de direcciones escribe: `ftp://192.168.1.100:1337`
5. Copia `VitaCast.vpk` a `ux0:`
6. En la Vita: Instala el VPK

---

## ❌ Si algo falla:

### Error: "cmake no se reconoce"
**Solución**: Instala CMake desde https://cmake.org/download/

### Error: "make no se reconoce"  
**Solución**: En PowerShell usa:
```powershell
cmake --build . --config Release
```

### Error: "VITASDK not found"
**Solución**: Asegúrate de ejecutar:
```cmd
set VITASDK=C:\vitasdk
set PATH=%VITASDK%\bin;%PATH%
```

### El VPK sigue sin funcionar en la Vita
**Posibilidad**: El problema está en el código o configuración, no en la compilación.

---

## 🎯 Versión ULTRA RÁPIDA (Copiar y pegar)

Abre CMD como Administrador y copia TODO esto:

```cmd
cd %USERPROFILE%\Desktop
git clone https://github.com/kkakele/VitaCast
cd VitaCast
git checkout cursor/investigate-vitacast-vitashell-error-3d-1a3e
set VITASDK=C:\vitasdk
set PATH=%VITASDK%\bin;%PATH%
mkdir build
cd build
cmake ..
cmake --build . --config Release
echo.
echo ========================================
echo TU VPK ESTA EN:
echo %CD%\VitaCast.vpk
echo ========================================
```

---

## 📞 ¿Necesitas ayuda?

Si algo no funciona, dime en qué paso te atascaste y te ayudo.

**¡Buena suerte! 🚀**
