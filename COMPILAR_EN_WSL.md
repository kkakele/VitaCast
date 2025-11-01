# ?? Compilar VitaCast en WSL y Subir a Releases

Gu?a completa para compilar localmente en WSL y subir autom?ticamente a GitHub Releases.

---

## ?? Parte 1: Instalar VitaSDK en WSL

### 1.1 Instalar Dependencias

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias necesarias
sudo apt install -y \
    build-essential \
    git \
    cmake \
    libssl-dev \
    libzip-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    wget \
    curl \
    python3 \
    python3-pip
```

### 1.2 Instalar VitaSDK

```bash
# Crear directorio para VitaSDK
cd ~
mkdir vitasdk
cd vitasdk

# Descargar script de instalaci?n
wget https://raw.githubusercontent.com/vitasdk/vdpm/master/install-all.sh

# Hacer ejecutable
chmod +x install-all.sh

# EJECUTAR (esto toma ~30-60 minutos)
./install-all.sh
```

### 1.3 Configurar Variables de Entorno

```bash
# Agregar al final de ~/.bashrc
echo 'export VITASDK=/usr/local/vitasdk' >> ~/.bashrc
echo 'export PATH=$VITASDK/bin:$PATH' >> ~/.bashrc

# Recargar bashrc
source ~/.bashrc

# Verificar instalaci?n
arm-vita-eabi-gcc --version
vita-mksfoex --help
```

---

## ?? Parte 2: Instalar GitHub CLI

```bash
# Instalar GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

# Autenticar con GitHub
gh auth login
# Selecciona: GitHub.com ? HTTPS ? Yes ? Login with a web browser
```

---

## ?? Parte 3: Clonar el Proyecto

```bash
# Ir a tu directorio de proyectos
cd ~

# Clonar VitaCast
git clone https://github.com/kkakele/VitaCast.git
cd VitaCast

# Cambiar a tu rama
git checkout cursor/fix-vitacast-app-and-study-vitasdk-org-1952
```

---

## ?? Parte 4: Script de Compilaci?n Autom?tica

Voy a crear un script que compile y suba autom?ticamente.

### 4.1 Usar el Script Autom?tico (RECOMENDADO)

```bash
# Hacer ejecutable el script
chmod +x build_and_release.sh

# Ejecutar (esto compila, crea tag y sube a releases)
./build_and_release.sh
```

El script te pedir? la versi?n y har? todo autom?ticamente.

### 4.2 Compilaci?n Manual (Si Prefieres)

```bash
# Compilar versi?n simple
make -f Makefile clean
make -f Makefile

# Compilar versi?n completa
make -f Makefile_complete clean
make -f Makefile_complete

# Los VPKs estar?n en: VitaCast.vpk y VitaCast-Simple.vpk
```

---

## ?? Parte 5: Subir a Releases Manualmente

```bash
# Crear tag y release
VERSION="v2.7.2"
git tag -a $VERSION -m "VitaCast $VERSION"
git push origin $VERSION

# Crear release con GitHub CLI
gh release create $VERSION \
    VitaCast.vpk \
    VitaCast-Simple.vpk \
    --title "VitaCast $VERSION" \
    --notes "Release compilado localmente en WSL"
```

---

## ?? Flujo Completo de Trabajo

### Workflow Recomendado:

```bash
# 1. Hacer cambios en el c?digo
nano main_simple.c

# 2. Compilar y probar
make -f Makefile clean
make -f Makefile

# 3. Si funciona, usar el script autom?tico
./build_and_release.sh
# ? Ingresa versi?n: 2.7.3
# ? Script compila todo, crea tag y sube a releases
```

---

## ? Script R?pido (Una L?nea)

```bash
# Compilar todo de una vez
make -f Makefile clean && make -f Makefile && \
make -f Makefile_complete clean && make -f Makefile_complete && \
echo "? Compilaci?n completada. VPKs listos!"
```

---

## ?? Verificar Todo Funciona

```bash
# Verificar VitaSDK
which arm-vita-eabi-gcc
which vita-mksfoex
which vita-pack-vpk

# Verificar GitHub CLI
gh auth status

# Probar compilaci?n
cd ~/VitaCast
make -f Makefile clean
make -f Makefile

# Deber?a generar: VitaCast.vpk
ls -lh VitaCast.vpk
```

---

## ?? Soluci?n de Problemas

### Error: "arm-vita-eabi-gcc: command not found"

```bash
# Verificar VITASDK
echo $VITASDK
# Debe mostrar: /usr/local/vitasdk

# Si no, agregar a ~/.bashrc
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH
source ~/.bashrc
```

### Error: "vita-mksfoex: command not found"

```bash
# Reinstalar vdpm
cd ~/vitasdk
./install-all.sh
```

### Error: "gh: command not found"

```bash
# Reinstalar GitHub CLI
sudo apt update
sudo apt install gh -y
gh auth login
```

### Error al compilar: "undefined reference"

```bash
# Limpiar y recompilar
make -f Makefile clean
make -f Makefile
```

---

## ?? Comparaci?n: WSL vs GitHub Actions

| Aspecto | WSL Local | GitHub Actions |
|---------|-----------|----------------|
| **Velocidad** | ? Muy r?pido (~1 min) | ?? Lento (~5 min) |
| **Control** | ? Total | ?? Limitado |
| **Debugging** | ? F?cil | ? Dif?cil |
| **Automatizaci?n** | ?? Manual | ? Autom?tico |
| **Requiere Setup** | ? S? (una vez) | ? No |

**Recomendaci?n**: 
- Usa **WSL** para desarrollo y testing r?pido
- Usa **GitHub Actions** para releases oficiales

---

## ?? Tips Avanzados

### Alias ?tiles

Agrega a `~/.bashrc`:

```bash
# Alias para VitaCast
alias vitacast='cd ~/VitaCast'
alias vitabuild='make -f Makefile clean && make -f Makefile'
alias vitabuild-full='make -f Makefile_complete clean && make -f Makefile_complete'
alias vitarelease='./build_and_release.sh'

# Recargar
source ~/.bashrc
```

Ahora puedes usar:
```bash
vitacast      # Ir al directorio
vitabuild     # Compilar versi?n simple
vitarelease   # Crear release autom?tico
```

### Compilaci?n en Paralelo

```bash
# Compilar ambas versiones en paralelo
(make -f Makefile clean && make -f Makefile) & \
(make -f Makefile_complete clean && make -f Makefile_complete) & \
wait
echo "? Ambas versiones compiladas"
```

---

## ? Checklist Final

Antes de crear un release, verifica:

- [ ] C?digo compila sin errores
- [ ] VPKs generados correctamente
- [ ] Probado en PS Vita (si es posible)
- [ ] README actualizado
- [ ] CHANGELOG actualizado
- [ ] Tag/versi?n incrementada

---

## ?? Ejemplo Completo

```bash
# 1. Setup inicial (solo una vez)
cd ~
git clone https://github.com/kkakele/VitaCast.git
cd VitaCast

# 2. Hacer cambios
nano main_simple.c

# 3. Compilar y probar
make -f Makefile clean && make -f Makefile

# 4. Si funciona, crear release
./build_and_release.sh
# Ingresa: 2.7.3

# 5. ?Listo! Release subido autom?ticamente
```

---

**?? ?Ahora puedes compilar VitaCast localmente y subir a releases autom?ticamente!**
