# 🎮 Compilar VitaCast en Windows 11 - Guía Actualizada

## ⚡ MÉTODO MÁS FÁCIL: WSL2 + Ubuntu

VitaSDK funciona MEJOR en Linux. Windows 11 tiene WSL2 que es Linux dentro de Windows.

### Paso 1: Instalar WSL2 (5 minutos)

1. **Abre PowerShell como Administrador** (botón derecho → "Ejecutar como administrador")

2. **Copia y pega esto:**
```powershell
wsl --install -d Ubuntu
```

3. **Reinicia tu PC** cuando te lo pida

4. **Después del reinicio**, se abrirá Ubuntu automáticamente
   - Te pedirá un nombre de usuario (ej: tu nombre)
   - Te pedirá una contraseña (escríbela, no se verá, es normal)

---

### Paso 2: Instalar VitaSDK en WSL2 (10 minutos)

**Dentro de Ubuntu** (la ventana que se abrió), copia y pega TODO esto:

```bash
# Instalar dependencias
sudo apt-get update
sudo apt-get install -y git cmake make

# Descargar e instalar VitaSDK
git clone https://github.com/vitasdk/vdpm
cd vdpm
./bootstrap-vitasdk.sh

# Configurar variables
echo 'export VITASDK=/usr/local/vitasdk' >> ~/.bashrc
echo 'export PATH=$VITASDK/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Espera 10-15 minutos mientras descarga y compila todo.

---

### Paso 3: Descargar VitaCast (1 minuto)

**En la misma ventana de Ubuntu:**

```bash
cd ~
git clone https://github.com/kkakele/VitaCast
cd VitaCast
git checkout cursor/investigate-vitacast-vitashell-error-3d-1a3e
```

---

### Paso 4: Compilar VitaCast (1 minuto)

**En Ubuntu:**

```bash
cd ~/VitaCast
mkdir build
cd build
cmake ..
make
```

**¡Listo!** El VPK se creó en: `~/VitaCast/build/VitaCast.vpk`

---

### Paso 5: Copiar el VPK a Windows (30 segundos)

**Desde Ubuntu, copia el VPK a tu Escritorio de Windows:**

```bash
cp ~/VitaCast/build/VitaCast.vpk /mnt/c/Users/$USER/Desktop/
```

**Ahora mira tu Escritorio de Windows** - ahí estará `VitaCast.vpk` ✅

---

## 📱 Paso 6: Instalar en PS Vita

### Método 1: USB (MÁS FÁCIL)

1. **Conecta tu PS Vita** por USB a tu PC
2. **En la Vita**: Abre VitaShell → Presiona **SELECT**
3. Verás "USB ON" en pantalla
4. **En tu PC**: Aparecerá como unidad de disco
5. **Copia** `VitaCast.vpk` a la raíz de la unidad
6. **En la Vita**: Presiona **SELECT** otra vez (desactivar USB)
7. **Navega** al VPK y presiona **X** → Instalar
8. ✅ **¡Listo!**

### Método 2: FTP (Alternativa)

1. **En la Vita**: VitaShell → Presiona **SELECT**
2. Anota la IP (ej: `192.168.1.100:1337`)
3. **En Windows**: Abre Explorador de Archivos
4. En la barra escribe: `ftp://192.168.1.100:1337`
5. Arrastra `VitaCast.vpk` a la carpeta `ux0:`
6. **En la Vita**: Instala el VPK

---

## 🎯 RESUMEN ULTRA CORTO

**Todo en 4 comandos (después de instalar WSL2):**

```bash
# 1. Instalar VitaSDK
git clone https://github.com/vitasdk/vdpm && cd vdpm && ./bootstrap-vitasdk.sh

# 2. Configurar
echo 'export VITASDK=/usr/local/vitasdk' >> ~/.bashrc
echo 'export PATH=$VITASDK/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 3. Descargar y compilar VitaCast
cd ~ && git clone https://github.com/kkakele/VitaCast && cd VitaCast
git checkout cursor/investigate-vitacast-vitashell-error-3d-1a3e
mkdir build && cd build && cmake .. && make

# 4. Copiar a Windows
cp VitaCast.vpk /mnt/c/Users/$USER/Desktop/
```

**El VPK estará en tu Escritorio de Windows** ✅

---

## ❌ Solución de Problemas

### "wsl --install" no funciona
- Asegúrate de abrir PowerShell **como Administrador**
- Si ya tienes WSL, solo ejecuta: `wsl -d Ubuntu`

### "bootstrap-vitasdk.sh" da error
- Ejecuta: `sudo apt-get install -y build-essential`
- Vuelve a intentar

### "cmake no se encuentra"
- Ejecuta: `sudo apt-get install cmake`

### No puedo copiar el VPK desde Ubuntu
- Desde Windows, ve a: `\\wsl$\Ubuntu\home\TU_USUARIO\VitaCast\build\`
- Copia `VitaCast.vpk` desde ahí

---

## 💡 ¿Por qué WSL2 y no Windows directo?

- VitaSDK está diseñado para Linux
- WSL2 es Linux real corriendo en Windows
- Es más fácil y confiable que intentar hacerlo funcionar en Windows nativo
- Todas las herramientas funcionan correctamente

---

## 📞 ¿Necesitas ayuda?

Si te atascas en algún paso, dime exactamente:
1. En qué paso estás
2. Qué error te sale (copia el mensaje exacto)
3. Te ayudaré a resolverlo

**¡Mucha suerte! 🚀**
