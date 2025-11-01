# ?? Instalar vita2d en WSL

## Error: vita2d.h: No such file or directory

Este error significa que VitaSDK est? instalado pero falta la biblioteca **vita2d**.

---

## ? Soluci?n R?pida

```bash
# Instalar vita2d con vdpm (gestor de paquetes de VitaSDK)
sudo vdpm vita2d
```

---

## ?? Instalaci?n Completa de Todas las Bibliotecas Necesarias

```bash
# Instalar todas las bibliotecas que VitaCast necesita
sudo vdpm vita2d
sudo vdpm zlib
sudo vdpm libpng
sudo vdpm libjpeg-turbo
sudo vdpm freetype

# Verificar instalaci?n
ls $VITASDK/arm-vita-eabi/include/vita2d.h
# Debe mostrar el archivo
```

---

## ?? Si vdpm no est? instalado

```bash
# Verificar si vdpm existe
which vdpm

# Si no existe, instalarlo
cd /tmp
git clone https://github.com/vitasdk/vdpm
cd vdpm
./bootstrap-vitasdk.sh
sudo cp vdpm /usr/local/bin/
```

---

## ?? Instalar TODO lo que VitaCast Necesita

Copia y pega este bloque completo:

```bash
# Navegar al directorio de vitasdk
cd $VITASDK

# Instalar todas las bibliotecas necesarias
sudo vdpm install \
    vita2d \
    zlib \
    libpng \
    libjpeg-turbo \
    freetype \
    libzip \
    bzip2 \
    curl \
    openssl

# Verificar que vita2d est? instalado
ls -la $VITASDK/arm-vita-eabi/include/vita2d.h
ls -la $VITASDK/arm-vita-eabi/lib/libvita2d.a

# Deber?a mostrar ambos archivos
```

---

## ? Despu?s de Instalar

Una vez instalado vita2d, intenta compilar de nuevo:

```bash
cd ~/VitaCast
make -f Makefile_complete clean
make -f Makefile_complete
```

---

## ?? Verificar Instalaci?n de VitaSDK

Si siguen habiendo problemas:

```bash
# Verificar VITASDK
echo $VITASDK
# Debe mostrar: /usr/local/vitasdk

# Verificar PATH
echo $PATH | grep vitasdk
# Debe incluir: /usr/local/vitasdk/bin

# Verificar compilador
which arm-vita-eabi-gcc
# Debe mostrar: /usr/local/vitasdk/bin/arm-vita-eabi-gcc

# Ver bibliotecas instaladas
ls $VITASDK/arm-vita-eabi/lib/
```

---

## ?? Si Nada Funciona: Reinstalar VitaSDK Completo

```bash
# Eliminar VitaSDK anterior
sudo rm -rf /usr/local/vitasdk
sudo rm -rf ~/vitasdk

# Reinstalar desde cero
cd ~
mkdir vitasdk && cd vitasdk
wget https://raw.githubusercontent.com/vitasdk/vdpm/master/install-all.sh
chmod +x install-all.sh

# ESTO TOMA ~30-60 MINUTOS
./install-all.sh

# Configurar variables de entorno
echo 'export VITASDK=/usr/local/vitasdk' >> ~/.bashrc
echo 'export PATH=$VITASDK/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Instalar vita2d espec?ficamente
sudo vdpm vita2d
```

---

## ?? Comando Completo de Instalaci?n

Todo en uno (copia y pega):

```bash
# Asegurarse de que vdpm funciona
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Instalar vita2d y dependencias
sudo $VITASDK/bin/vita-libs-gen vita2d
sudo vdpm vita2d zlib libpng libjpeg-turbo freetype

# Verificar
ls $VITASDK/arm-vita-eabi/include/vita2d.h && echo "? vita2d instalado correctamente"
```

---

## ?? Checklist de Instalaci?n

- [ ] VitaSDK instalado en `/usr/local/vitasdk`
- [ ] Variable `$VITASDK` configurada
- [ ] PATH incluye `$VITASDK/bin`
- [ ] `vita2d.h` existe en `$VITASDK/arm-vita-eabi/include/`
- [ ] `libvita2d.a` existe en `$VITASDK/arm-vita-eabi/lib/`

Verifica cada punto:

```bash
[ -d /usr/local/vitasdk ] && echo "? VitaSDK instalado" || echo "? VitaSDK NO instalado"
[ ! -z "$VITASDK" ] && echo "? VITASDK configurado" || echo "? VITASDK NO configurado"
[ -f $VITASDK/arm-vita-eabi/include/vita2d.h ] && echo "? vita2d.h encontrado" || echo "? vita2d.h NO encontrado"
[ -f $VITASDK/arm-vita-eabi/lib/libvita2d.a ] && echo "? libvita2d.a encontrado" || echo "? libvita2d.a NO encontrado"
```

---

**Despu?s de instalar vita2d, intenta compilar de nuevo con:**

```bash
cd ~/VitaCast
make -f Makefile_complete clean
make -f Makefile_complete
```

?Deber?a funcionar! ??
