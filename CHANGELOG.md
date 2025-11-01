# Changelog - Correcciones de VitaCast

## Versi?n 2.0.0 - Correcciones y Mejoras

### ?? Correcciones Realizadas

#### 1. Includes Faltantes
- **main.c**: Agregado `#include <stdbool.h>` para soportar el tipo `bool`
- **main_final.c**: Agregado `#include <stdbool.h>` para soportar el tipo `bool`

#### 2. Makefile_complete - Optimizaci?n de Librer?as
- **Simplificado las librer?as**: Removidas dependencias innecesarias (vitaGL, TinyGL, etc.)
- **Corregidas rutas de librer?as**: Simplificado el uso de librer?as stub
- **Agregados recursos al VPK**: Incluidos icon0.png, backgrounds y templates XML correctamente
- **Librer?as principales mantenidas**: vita2d, SceGxm, controles, red, SSL, curl, etc.

#### 3. Template XML - Correcci?n de Sintaxis
- **sce_sys/livearea/contents/template.xml**: Corregidas comillas faltantes en atributos XML
- Ahora cumple con el est?ndar XML v?lido

#### 4. Script de Build para Releases
- **build_release.sh**: Nuevo script para generar releases listos para GitHub
- Genera VPK con timestamp y versi?n latest
- Crea archivo RELEASE_INFO.txt con informaci?n del build
- Calcula SHA256 para verificaci?n de integridad

### ? Problemas Resueltos

1. **Error de compilaci?n por `bool` sin `stdbool.h`**: ? Resuelto
2. **Makefile con librer?as innecesarias**: ? Simplificado
3. **VPK sin recursos gr?ficos**: ? Corregido
4. **Template XML con sintaxis inv?lida**: ? Corregido
5. **Falta de proceso para generar releases**: ? Agregado script

### ?? Compatibilidad con VitaSDK

- Verificado seg?n documentaci?n oficial de [vitasdk.org](https://vitasdk.org)
- Librer?as compatibles con la versi?n actual de VitaSDK
- Estructura de VPK conforme a est?ndares de PS Vita

### ?? C?mo Usar

#### Compilaci?n Normal
```bash
make -f Makefile_complete
```

#### Compilaci?n de Release
```bash
./build_release.sh
```

El script generar?:
- `release/VitaCast-latest.vpk` - VPK para subir a releases
- `release/RELEASE_INFO.txt` - Informaci?n del release

### ?? Notas

- El VPK generado es compatible con firmware 3.60+ (recomendado 3.65+)
- Requiere HENkaku/Enso instalado
- Los recursos gr?ficos deben existir en `sce_sys/` antes de compilar

### ?? Verificaci?n

Para verificar la integridad del VPK:
```bash
sha256sum VitaCast.vpk
```

Compara el resultado con el SHA256 en RELEASE_INFO.txt
