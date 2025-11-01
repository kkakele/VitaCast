# Gu?a de Compilaci?n en WSL (Windows Subsystem for Linux)

## ?? Requisitos Previos

1. **WSL2 instalado** en Windows
2. **Distribuci?n Linux** (Ubuntu recomendada)
3. **Acceso a internet** para descargar el SDK

## ?? Paso 1: Instalar Dependencias Base

Abre una terminal de WSL y ejecuta:

```bash
# Actualizar paquetes
sudo apt-get update
sudo apt-get upgrade -y

# Instalar dependencias necesarias
sudo apt-get install -y \
    build-essential \
    git \
    wget \
    curl \
    cmake \
    python3 \
    python3-pip \
    libz-dev \
    libpng-dev \
    libfreetype6-dev
```

## ?? Paso 2: Instalar VitaSDK

```bash
# Establecer ruta de instalaci?n (recomendado: /usr/local/vitasdk)
export VITASDK=/usr/local/vitasdk

# Agregar al PATH permanentemente
echo 'export VITASDK=/usr/local/vitasdk' >> ~/.bashrc
echo 'export PATH=$VITASDK/bin:$PATH' >> ~/.bashrc

# Recargar configuraci?n
source ~/.bashrc

# Crear directorio de instalaci?n
sudo mkdir -p $VITASDK
sudo chown -R $USER:$USER $VITASDK
```

## ?? Paso 3: Descargar e Instalar VitaSDK

### Opci?n A: Script Autom?tico (Recomendado)

```bash
# Clonar el repositorio de vdpm (VitaSDK Package Manager)
cd ~
git clone https://github.com/vitasdk/vdpm.git
cd vdpm

# Ejecutar script de bootstrap
./bootstrap-vitasdk.sh

# Instalar todas las herramientas y librer?as
./install-all.sh
```

Este proceso puede tardar 15-30 minutos dependiendo de tu conexi?n.

### Opci?n B: Instalaci?n Manual (Si el script falla)

```bash
# Descargar toolchain precompilado
cd /tmp
wget https://github.com/vitasdk/autobuilds/releases/download/master-linux-v1053/vitasdk-x86_64-linux-gnu-20240101.tar.bz2

# Extraer en el directorio de instalaci?n
tar xf vitasdk-x86_64-linux-gnu-*.tar.bz2 -C $VITASDK --strip-components=1

# Instalar librer?as con vdpm
git clone https://github.com/vitasdk/vdpm.git
cd vdpm
./bootstrap-vitasdk.sh
./install-all.sh
```

## ? Paso 4: Verificar Instalaci?n

```bash
# Verificar que las herramientas est?n disponibles
arm-vita-eabi-gcc --version
vita-mksfoex --version
vita-pack-vpk --version

# Verificar variables de entorno
echo $VITASDK
echo $PATH | grep vitasdk
```

Si todos los comandos funcionan, ?VitaSDK est? instalado correctamente!

## ?? Paso 5: Compilar VitaCast

```bash
# Clonar el repositorio (si no lo tienes)
cd ~
git clone https://github.com/kkakele/VitaCast.git
cd VitaCast

# Asegurarse de que las variables de entorno est?n cargadas
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Limpiar compilaciones anteriores
make -f Makefile_complete clean

# Compilar el proyecto
make -f Makefile_complete release
```

## ?? Paso 6: Verificar el VPK Generado

```bash
# Verificar que se gener? el VPK
ls -lh VitaCast.vpk

# Verificar contenido del param.sfo
unzip -p VitaCast.vpk sce_sys/param.sfo | strings | grep -i "PCSE\|UP00"

# Debe mostrar: PCSE00001 (correcto)
# NO debe mostrar: UP0000 (incorrecto)
```

## ?? Paso 7: Transferir VPK a Windows

El VPK se generar? en WSL. Para transferirlo a Windows:

```bash
# El VPK estar? en: ~/VitaCast/VitaCast.vpk
# WSL monta la unidad C: en /mnt/c

# Copiar a Windows
cp ~/VitaCast/VitaCast.vpk /mnt/c/Users/TuUsuario/Desktop/VitaCast.vpk

# O usar desde PowerShell en Windows:
# \\wsl$\Ubuntu\home\tuusuario\VitaCast\VitaCast.vpk
```

## ?? Paso 8: Instalar en PS Vita

1. Copia `VitaCast.vpk` a tu PS Vita (por USB o FTP)
2. Abre VitaShell en tu PS Vita
3. Navega al VPK y presiona X para instalar
4. Debe instalar sin errores (0x8010113D resuelto)

## ?? Soluci?n de Problemas Comunes

### Error: "arm-vita-eabi-gcc: command not found"

```bash
# Verificar que VITASDK est? en PATH
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Verificar instalaci?n
ls $VITASDK/bin/arm-vita-eabi-gcc
```

### Error: "cannot find -lSceDisplay_stub"

```bash
# Las librer?as no est?n instaladas, ejecutar:
cd ~/vdpm
./install-all.sh

# O instalar librer?as espec?ficas:
vdpm install libvita2d
vdpm install libSceDisplay_stub
```

### Error: "vita-mksfoex: command not found"

```bash
# Instalar herramientas de VPK
vdpm install vita-toolchain
```

### WSL no tiene suficiente memoria

Si WSL se queda sin memoria durante la compilaci?n:

```bash
# Crear/editar ~/.wslconfig en Windows (en C:\Users\TuUsuario\.wslconfig)
[wsl2]
memory=4GB
processors=2
```

Luego reinicia WSL:
```powershell
# En PowerShell de Windows (como Administrador)
wsl --shutdown
```

## ?? Notas Adicionales

- **Tiempo de compilaci?n**: Primera vez ~30 min (incluye instalaci?n SDK)
- **Compilaciones posteriores**: ~2-5 minutos
- **Espacio necesario**: ~2GB para SDK completo
- **Recomendado**: Usar Ubuntu 20.04 o superior en WSL

## ?? Referencias

- [VitaSDK Documentaci?n](https://vitasdk.org)
- [vdpm GitHub](https://github.com/vitasdk/vdpm)
- [WSL Documentaci?n](https://docs.microsoft.com/en-us/windows/wsl/)

## ? Checklist de Verificaci?n

- [ ] WSL2 instalado y funcionando
- [ ] Dependencias base instaladas
- [ ] VitaSDK instalado en `/usr/local/vitasdk`
- [ ] Variables de entorno configuradas (`VITASDK`, `PATH`)
- [ ] Herramientas verificadas (`arm-vita-eabi-gcc`, `vita-mksfoex`, `vita-pack-vpk`)
- [ ] Repositorio clonado
- [ ] VPK compilado exitosamente
- [ ] VPK verificado (CONTENT_ID = `PCSE00001`)
- [ ] VPK transferido a Windows
- [ ] Instalado en PS Vita sin errores

?Listo! Con estos pasos deber?as poder compilar VitaCast correctamente en WSL.
