# Contribuyendo a VitaCast

## Configuración del Entorno de Desarrollo

### Requisitos

- Linux, macOS o Windows (con WSL)
- Git
- CMake (opcional)
- Python 3 (para algunos scripts)

### Instalación de VitaSDK

#### Linux/macOS

```bash
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

git clone https://github.com/vitasdk/buildscripts.git
cd buildscripts
./build.sh
```

#### Windows (WSL)

Sigue las mismas instrucciones que Linux dentro de WSL.

#### Docker (Recomendado)

```bash
docker pull vitasdk/vitasdk
docker run -it -v $(pwd):/workspace vitasdk/vitasdk bash
cd /workspace
make release
```

## Compilación

```bash
# Versión release optimizada
make release

# Versión debug
make debug

# Limpiar
make clean
```

## Estructura del Código

- `main.c` - Punto de entrada principal
- `ui/` - Sistema de interfaz de usuario
- `audio/` - Reproductor de audio y decodificadores
- `network/` - Gestión de red y descargas
- `apple/` - Integración con servicios de Apple

## Estándares de Código

- Usar C11 estándar
- Indentación con 4 espacios
- Comentarios en español
- Verificación de errores en todas las funciones
- Gestión cuidadosa de memoria

## Enviar Cambios

1. Fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Reportar Bugs

Usa el sistema de Issues de GitHub con:
- Descripción clara del problema
- Pasos para reproducir
- Comportamiento esperado vs actual
- Versión de firmware de PS Vita
- Logs si están disponibles
