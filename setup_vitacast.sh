#!/bin/bash

# VitaCast Setup Script
# Configuración automática del proyecto VitaCast para PlayStation Vita

set -e

echo "🎵 VitaCast Setup Script"
echo "========================"
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con color
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
}

# Verificar si estamos en el directorio correcto
if [ ! -f "main.c" ]; then
    print_error "No se encontró main.c. Ejecuta este script desde el directorio raíz de VitaCast."
    exit 1
fi

print_header "🔍 Verificando requisitos del sistema..."

# Verificar VitaSDK
if ! command -v arm-vita-eabi-gcc &> /dev/null; then
    print_error "VitaSDK no está instalado o no está en el PATH."
    print_warning "Instala VitaSDK desde: https://github.com/vitasdk/vitasdk"
    exit 1
fi

print_status "VitaSDK encontrado: $(arm-vita-eabi-gcc --version | head -n1)"

# Verificar herramientas de VPK
if ! command -v vita-mksfoex &> /dev/null; then
    print_error "vita-mksfoex no encontrado. Instala las herramientas de VPK."
    exit 1
fi

if ! command -v vita-pack-vpk &> /dev/null; then
    print_error "vita-pack-vpk no encontrado. Instala las herramientas de VPK."
    exit 1
fi

print_status "Herramientas de VPK encontradas"

# Verificar curl
if ! command -v curl &> /dev/null; then
    print_warning "curl no encontrado. La funcionalidad de red puede estar limitada."
fi

print_header "📁 Creando estructura de directorios..."

# Crear directorios necesarios
mkdir -p assets/fonts
mkdir -p assets/images
mkdir -p data/cache
mkdir -p data/downloads
mkdir -p data/podcasts
mkdir -p data/music

print_status "Estructura de directorios creada"

print_header "🎨 Configurando recursos gráficos..."

# Crear archivos de recursos básicos si no existen
if [ ! -f "assets/background.png" ]; then
    print_warning "assets/background.png no encontrado. Creando placeholder..."
    # Crear un PNG básico de 960x544 con color de fondo
    convert -size 960x544 xc:'#1a1a1a' assets/background.png 2>/dev/null || {
        print_warning "ImageMagick no disponible. Crea manualmente assets/background.png (960x544)"
    }
fi

if [ ! -f "assets/icon0.png" ]; then
    print_warning "assets/icon0.png no encontrado. Creando placeholder..."
    # Crear un icono básico de 128x128
    convert -size 128x128 xc:'#007AFF' -fill white -pointsize 72 -gravity center -annotate +0+0 "VC" assets/icon0.png 2>/dev/null || {
        print_warning "ImageMagick no disponible. Crea manualmente assets/icon0.png (128x128)"
    }
fi

# Crear iconos de control si no existen
for icon in play pause next prev; do
    if [ ! -f "assets/${icon}.png" ]; then
        print_warning "assets/${icon}.png no encontrado. Creando placeholder..."
        convert -size 64x64 xc:'#007AFF' assets/${icon}.png 2>/dev/null || {
            print_warning "Crea manualmente assets/${icon}.png (64x64)"
        }
    fi
done

print_status "Recursos gráficos configurados"

print_header "🔧 Configurando Makefile..."

# Usar el Makefile completo si existe
if [ -f "Makefile_complete" ]; then
    cp Makefile_complete Makefile
    print_status "Makefile_complete copiado como Makefile"
else
    print_warning "Makefile_complete no encontrado. Usando Makefile básico."
fi

print_header "🧪 Compilando proyecto..."

# Limpiar compilaciones anteriores
make clean 2>/dev/null || true

# Compilar proyecto
if make all; then
    print_status "Compilación exitosa!"
    print_status "VPK creado: VitaCast.vpk"
else
    print_error "Error en la compilación. Revisa los errores arriba."
    exit 1
fi

print_header "📋 Verificando archivos generados..."

# Verificar que se crearon los archivos necesarios
if [ -f "VitaCast.vpk" ]; then
    VPK_SIZE=$(du -h VitaCast.vpk | cut -f1)
    print_status "VPK creado: VitaCast.vpk (${VPK_SIZE})"
else
    print_error "No se pudo crear el VPK"
    exit 1
fi

if [ -f "eboot.bin" ]; then
    print_status "eboot.bin creado correctamente"
else
    print_error "eboot.bin no se creó"
    exit 1
fi

print_header "📱 Información de instalación..."

echo ""
print_status "Para instalar en tu PlayStation Vita:"
echo "  1. Copia VitaCast.vpk a tu Vita"
echo "  2. Instala usando VitaShell o VPK Installer"
echo "  3. Configura tu Apple ID en la aplicación"
echo "  4. ¡Disfruta de tus podcasts y música!"
echo ""

print_header "🎯 Funcionalidades disponibles:"

echo "  ✅ Interfaz inspirada en PS Vita Music App"
echo "  ✅ Soporte para múltiples formatos de audio"
echo "  ✅ Soporte nativo para ATRAC3/ATRAC3plus"
echo "  ✅ Integración con Apple Music"
echo "  ✅ Sincronización con iCloud"
echo "  ✅ Búsqueda de podcasts"
echo "  ✅ Descarga para escucha offline"
echo "  ✅ Portadas de podcasts automáticas"
echo ""

print_header "🔧 Comandos útiles:"

echo "  make clean          - Limpiar archivos de compilación"
echo "  make debug          - Compilar versión de debug"
echo "  make release        - Compilar versión optimizada"
echo "  make help           - Mostrar ayuda del Makefile"
echo ""

print_header "📚 Documentación:"

echo "  README.md           - Documentación completa del proyecto"
echo "  ui/ui_manager.h     - Documentación de la interfaz"
echo "  audio/audio_player.h - Documentación del reproductor"
echo ""

print_status "¡Setup completado exitosamente! 🎉"
echo ""
print_warning "Nota: Algunos recursos gráficos pueden ser placeholders."
print_warning "Considera crear assets personalizados para mejor experiencia visual."
echo ""

# Mostrar información del sistema
print_header "ℹ️  Información del sistema:"
echo "  Compilador: $(arm-vita-eabi-gcc --version | head -n1)"
echo "  Directorio: $(pwd)"
echo "  Fecha: $(date)"
echo ""

print_status "VitaCast está listo para usar! 🎵🎮"
