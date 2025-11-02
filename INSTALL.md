# 📦 Instalación de VitaCast v2.0.1

Guía de instalación paso a paso para VitaCast en tu PlayStation Vita.

## ✅ Requisitos Previos

### En tu PlayStation Vita
- **Firmware 3.60+** (recomendado 3.65 o superior)
- **HENkaku/Enso** instalado y funcionando
- **VitaShell** instalado
- Al menos **50MB de espacio libre** en ux0:

### Para Compilar desde Código Fuente
- **VitaSDK** instalado y configurado correctamente
- Variable de entorno `VITASDK` configurada
- **arm-vita-eabi-gcc** en tu PATH
- Herramientas: `vita-mksfoex`, `vita-pack-vpk`

## 🚀 Instalación Rápida (VPK Pre-compilado)

### Método 1: USB (Recomendado)
1. Conecta tu PS Vita a tu PC via USB
2. Abre **VitaShell** en tu Vita
3. Presiona **SELECT** para habilitar el modo USB
4. Copia `VitaCast.vpk` a `ux0:/data/` o cualquier carpeta de tu Vita
5. Presiona **O** para salir del modo USB
6. En VitaShell, navega hasta donde copiaste el VPK
7. Presiona **X** sobre `VitaCast.vpk` para instalarlo
8. Espera a que termine la instalación
9. Presiona **O** para cerrar el diálogo
10. **¡Listo!** Busca VitaCast en tu LiveArea

### Método 2: FTP
1. En VitaShell, presiona **SELECT** para obtener la dirección FTP
2. Desde tu PC, conecta al FTP usando FileZilla o WinSCP
3. Navega a `ux0:/data/`
4. Copia `VitaCast.vpk` a esa ubicación
5. En VitaShell, navega a `ux0:/data/`
6. Presiona **X** sobre `VitaCast.vpk` para instalarlo
7. **¡Listo!** Busca VitaCast en tu LiveArea

### Método 3: Instalación Directa (si tienes vita-install-vpk)
```bash
vita-install-vpk VitaCast.vpk
```

## 🔨 Compilar desde Código Fuente

### 1. Clonar el Repositorio
```bash
git clone https://github.com/tuusuario/VitaCast.git
cd VitaCast
```

### 2. Verificar VitaSDK
```bash
echo $VITASDK
# Debe mostrar la ruta de instalación de VitaSDK
# Ejemplo: /usr/local/vitasdk
```

### 3. Compilar
```bash
# Versión normal (recomendada)
make -f Makefile_final

# O versión optimizada para release
make -f Makefile_final release

# O versión debug (para desarrollo)
make -f Makefile_final debug
```

### 4. Instalar el VPK Generado
El archivo `VitaCast.vpk` se generará en la carpeta raíz del proyecto.
Sigue los pasos de instalación de la sección anterior.

## 🎮 Primer Uso

### Controles Básicos
- **D-Pad Arriba/Abajo**: Navegar por el menú
- **X (Cruz)**: Seleccionar opción
- **O (Círculo)**: Volver al menú anterior
- **START**: Salir de la aplicación

### Primera Ejecución
1. Abre **VitaCast** desde tu LiveArea
2. Verás el menú principal con 4 opciones:
   - 📻 **Podcasts**: Gestionar tus podcasts
   - 🎵 **Apple Music**: Biblioteca de música
   - ▶️ **Reproductor**: Controles de reproducción
   - ⚙️ **Configuración**: Ajustes de la app

## 🐛 Solución de Problemas

### Error al Instalar VPK
**Problema**: "Error de instalación C1-6703-6"
- **Solución**: 
  - Verifica que tengas suficiente espacio en ux0:
  - Intenta reiniciar tu Vita y reinstalar
  - Asegúrate de que HENkaku/h-encore esté activo

### La App No Inicia o Cierra Inmediatamente
**Problema**: La app se cierra con un error 0x8010xxxx
- **Solución**:
  - Asegúrate de estar usando la versión **v2.0.1 o superior**
  - Las versiones anteriores tenían problemas de inicialización
  - Desinstala la versión antigua y reinstala la nueva

### Pantalla Negra al Iniciar
**Problema**: La aplicación muestra pantalla negra
- **Solución**:
  - Es normal si faltan los assets gráficos
  - La app debería seguir funcionando
  - Usa los controles normalmente
  - Verifica que el VPK incluya la carpeta `sce_sys`

### Error "C2-12828-1"
**Problema**: Error de excepción no manejada
- **Solución**:
  - Asegúrate de usar la versión compilada con los headers correctos
  - Reinstala el VPK
  - Si persiste, reporta el error en GitHub Issues

## 📊 Verificar Instalación Correcta

Después de instalar, verifica:
- ✅ El icono de VitaCast aparece en LiveArea
- ✅ El icono tiene el logo correcto (no un icono por defecto)
- ✅ Al abrirlo, aparece el menú principal
- ✅ Los controles responden correctamente
- ✅ START cierra la aplicación sin problemas

## 🔄 Actualizar VitaCast

Para actualizar a una nueva versión:
1. **No necesitas** desinstalar la versión anterior
2. Simplemente instala el nuevo VPK
3. El sistema sobrescribirá la versión antigua automáticamente
4. Tus datos y configuraciones se mantendrán

## ⚠️ Desinstalación

Para desinstalar VitaCast:
1. Mantén presionado el icono de VitaCast en LiveArea
2. Espera a que aparezca el menú contextual
3. Selecciona **Eliminar**
4. Confirma la eliminación

## 📞 Soporte

### Reportar Problemas
Si encuentras bugs o problemas:
1. Verifica que estés usando la última versión
2. Revisa esta guía de solución de problemas
3. Reporta en: GitHub Issues

### Información Útil para Reportes
Al reportar un problema, incluye:
- Versión de VitaCast (aparece en el menú)
- Modelo de PS Vita (1000/2000/TV)
- Versión de firmware
- CFW usado (HENkaku/h-encore/Enso)
- Descripción detallada del problema
- Pasos para reproducir el error

## 📝 Notas Adicionales

### Permisos Necesarios
VitaCast requiere los siguientes permisos:
- Acceso a controladores (para input)
- Acceso a pantalla (para gráficos)
- Acceso a red (para descargas - futuro)

### Espacio en Disco
- **App**: ~5-10 MB
- **Assets**: ~2-3 MB
- **Cache** (futuro): Configurable (máx. 1GB)

### Compatibilidad
- ✅ PS Vita 1000 (OLED)
- ✅ PS Vita 2000 (LCD)
- ✅ PS TV / Vita TV
- ✅ Firmware 3.60, 3.65, 3.68, 3.73

---

**VitaCast v2.0.1** - Podcast y Música para PlayStation Vita 🎮🎵

*¿Problemas? Revisa la sección de [Solución de Problemas](#-solución-de-problemas) o contacta en GitHub.*

