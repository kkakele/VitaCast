# 🔨 Instrucciones de Compilación - VitaCast v2.0.1

Guía detallada para compilar VitaCast desde el código fuente.

## 📋 Requisitos Previos

### Sistema Operativo
- ✅ **Linux** (Ubuntu 20.04+, Debian, Arch, etc.)
- ✅ **Windows 10/11** (con MSYS2 o WSL)
- ✅ **macOS** (10.14+)

### Software Necesario

#### VitaSDK
VitaSDK es **obligatorio** para compilar aplicaciones de PS Vita.

**Linux/macOS:**
```bash
# Instalar dependencias (Ubuntu/Debian)
sudo apt-get install cmake git wget python3

# Instalar VitaSDK usando vdpm
git clone https://github.com/vitasdk/vdpm
cd vdpm
./bootstrap-vitasdk.sh
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Añadir a ~/.bashrc o ~/.zshrc
echo "export VITASDK=/usr/local/vitasdk" >> ~/.bashrc
echo "export PATH=\$VITASDK/bin:\$PATH" >> ~/.bashrc
```

**Windows (MSYS2):**
```bash
# Instalar MSYS2 desde https://msys2.org

# En MSYS2 terminal:
pacman -Syu
pacman -S base-devel git cmake python

# Instalar VitaSDK
git clone https://github.com/vitasdk/vdpm
cd vdpm
./bootstrap-vitasdk.sh

# Configurar variables
export VITASDK=/opt/vitasdk
export PATH=$VITASDK/bin:$PATH
```

#### Herramientas Adicionales
```bash
# Verificar instalación
which arm-vita-eabi-gcc
which vita-mksfoex
which vita-pack-vpk

# Si falta algo, instalar:
vdpm gcc
vdpm binutils
vdpm vita-headers
```

---

## 🚀 Compilación Rápida

### Método 1: Script Automatizado (Recomendado)

**Linux/macOS:**
```bash
chmod +x build_release.sh
./build_release.sh
```

**Windows (PowerShell como Administrador):**
```powershell
Set-ExecutionPolicy Bypass -Scope Process
.\build_release.ps1
```

### Método 2: Make Manual

**Versión Release (Recomendada):**
```bash
make -f Makefile_final release
```

**Versión Debug:**
```bash
make -f Makefile_final debug
```

**Versión Normal:**
```bash
make -f Makefile_final
```

---

## 🔧 Opciones de Compilación

### Archivos Principales Disponibles

| Archivo | Descripción | Uso |
|---------|-------------|-----|
| `main_simple.c` | Versión mínima | Testing básico |
| `main_final.c` | Versión estándar | **Recomendado para release** |
| `main_complete.c` | Versión completa | Features avanzados |

### Cambiar Versión a Compilar

Edita `Makefile_final` línea 3:
```makefile
# Para versión simple
OBJS = main_simple.o

# Para versión estándar (recomendado)
OBJS = main_final.o

# Para versión completa
OBJS = main_complete.o
```

O usa comandos:
```bash
# Cambiar a versión simple
make -f Makefile_final simple

# Cambiar a versión completa
make -f Makefile_final complete
```

---

## 🎯 Targets del Makefile

### Build Targets
```bash
# Build normal
make -f Makefile_final

# Build optimizado para release
make -f Makefile_final release

# Build con símbolos de debug
make -f Makefile_final debug

# Limpiar archivos de compilación
make -f Makefile_final clean

# Mostrar información
make -f Makefile_final info
```

### Flags de Compilación

**Release Build:**
- Optimización: `-O3`
- Define: `-DNDEBUG`
- Strip símbolos: Sí

**Debug Build:**
- Optimización: `-O0`
- Define: `-DDEBUG`
- Símbolos debug: `-g`

---

## 📦 Salida de la Compilación

Después de una compilación exitosa, tendrás:

```
VitaCast/
├── VitaCast.vpk      ← El archivo principal (instala este)
├── eboot.bin         ← Ejecutable de Vita
├── param.sfo         ← Metadatos
├── main_*.o          ← Archivos objeto (temporales)
└── ...
```

### Verificar el VPK
```bash
# Ver tamaño
ls -lh VitaCast.vpk

# Ver contenido
unzip -l VitaCast.vpk

# Checksum
md5sum VitaCast.vpk
sha256sum VitaCast.vpk
```

---

## 🐛 Solución de Problemas

### Error: "VITASDK not set"
```bash
# Solución:
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Verificar:
echo $VITASDK
```

### Error: "arm-vita-eabi-gcc: command not found"
```bash
# VitaSDK no está en PATH
# Solución:
export PATH=$VITASDK/bin:$PATH

# O reinstalar VitaSDK
vdpm gcc
```

### Error: "undefined reference to 'vita2d_init'"
```bash
# Falta biblioteca vita2d
# Solución:
vdpm vita2d
```

### Error: "cannot find -lSceCtrl_stub"
```bash
# Faltan stubs
# Solución:
vdpm vita-headers
```

### Warning: "implicit declaration of function"
```bash
# Falta include
# Solución: Verificar que todos los headers estén correctos
# Ya están corregidos en v2.0.1
```

### Error al crear VPK
```bash
# vita-pack-vpk falla
# Solución 1: Verificar que existan los assets
ls -la sce_sys/

# Solución 2: Reinstalar herramientas
vdpm vita-toolchain
```

---

## 🔬 Compilación Avanzada

### Cross-Compilation desde Docker

```bash
# Usar imagen de VitaSDK
docker pull vitasdk/vitasdk

# Compilar
docker run -it --rm \
  -v $(pwd):/build \
  vitasdk/vitasdk \
  sh -c "cd /build && make -f Makefile_final release"
```

### Compilación con CMake (Futuro)

```bash
# Cuando se añada CMakeLists.txt
mkdir build && cd build
cmake ..
make
```

### Custom Flags

```bash
# Añadir flags personalizados
make -f Makefile_final CFLAGS="-O3 -DCUSTOM_FLAG" release
```

---

## 📊 Verificación de Calidad

### Linters y Análisis

```bash
# Verificar estilo (si tienes clang-format)
clang-format -i *.c

# Análisis estático (si tienes cppcheck)
cppcheck --enable=all *.c

# Verificar warnings
make -f Makefile_final CFLAGS="-Wall -Wextra -Werror"
```

### Testing

```bash
# Compilar versión de test
make -f Makefile_final debug

# Probar en emulador (Vita3K - si está disponible)
# O en hardware real
```

---

## 📝 Logs de Compilación

### Guardar Log de Compilación

```bash
# Linux/macOS
make -f Makefile_final release 2>&1 | tee build.log

# Windows (PowerShell)
.\build_release.ps1 *> build.log
```

### Verbose Build

```bash
# Ver todos los comandos ejecutados
make -f Makefile_final V=1 release
```

---

## 🔄 Integración Continua

### GitHub Actions (Ejemplo)

```yaml
name: Build VitaCast

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    container: vitasdk/vitasdk:latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Build
      run: make -f Makefile_final release
    
    - name: Upload VPK
      uses: actions/upload-artifact@v2
      with:
        name: VitaCast.vpk
        path: VitaCast.vpk
```

---

## 🎓 Recursos de Aprendizaje

### Documentación
- [VitaSDK Docs](https://docs.vitasdk.org)
- [vita2d Documentation](https://github.com/xerpi/vita2d)
- [PS Vita Dev Wiki](https://vitadevwiki.com)

### Ejemplos
- [VitaSDK Samples](https://github.com/vitasdk/samples)
- [Vita homebrew](https://github.com/topics/vita-homebrew)

### Comunidad
- [VitaSDK Discord](https://discord.gg/vitasdk)
- [r/vitahacks](https://reddit.com/r/vitahacks)
- [GBAtemp](https://gbatemp.net)

---

## ⚡ Tips de Compilación

### Acelerar Compilación

```bash
# Usar múltiples cores
make -f Makefile_final -j$(nproc) release

# Cache de compilación (ccache)
export CC="ccache arm-vita-eabi-gcc"
```

### Reducir Tamaño del VPK

```bash
# Compilar con optimización de tamaño
make -f Makefile_final CFLAGS="-Os" release

# Strip manual del eboot
arm-vita-eabi-strip eboot.bin
```

---

## 📋 Checklist Pre-Build

Antes de compilar, verifica:

- [ ] VitaSDK instalado y en PATH
- [ ] Variable `$VITASDK` configurada
- [ ] Todas las dependencias instaladas
- [ ] Assets en `sce_sys/` presentes
- [ ] Código sin errores de sintaxis
- [ ] Makefile_final apunta al archivo correcto

---

## 🆘 Obtener Ayuda

Si tienes problemas:

1. **Revisa esta guía** completa
2. **Verifica logs** de compilación
3. **Busca el error** en Google/StackOverflow
4. **Pregunta en Discord** de VitaSDK
5. **Abre un issue** en GitHub

---

<div align="center">

**¿Compilación exitosa? ¡Prueba tu VPK en la Vita! 🎮**

</div>

