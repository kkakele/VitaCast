# Estado de Releases de VitaCast

## Releases con VPKs Disponibles ?

Todos los releases publicados tienen VPKs disponibles:

- **v2.0.2** - `VitaCast-v2.0.2.vpk` ? (Con correcci?n error 0x8010113D)
- **v2.0.1** - `VitaCast-v2.0.1.vpk` ?
- **v2.7.2** - `VitaCast.vpk` y `VitaCast-Simple.vpk` ?
- **v2.7.1** - `VitaCast.vpk` y `VitaCast-Simple.vpk` ?
- **v2.7.0** - `VitaCast.vpk` y `VitaCast-Simple.vpk` ?
- **v2.6.0** - `VitaCast.vpk` ?
- **v2.5.0** - `VitaCast.vpk` ?
- **v2.4.0** - `VitaCast.vpk` ?

## Notas Importantes

### v2.0.2 - ?ltima Versi?n
Este release incluye la correcci?n cr?tica del error **0x8010113D** en VitaShell.
- CONTENT_ID corregido: `PCSE00001` (formato homebrew)
- Makefile_complete actualizado
- Documentaci?n completa en `FIX_0x8010113D.md`

### Versiones Anteriores
Las versiones anteriores (v2.7.x, v2.6.x, etc.) pueden tener el error 0x8010113D.
Se recomienda usar **v2.0.2** o recompilar con el Makefile_complete corregido.

## Descargar Releases

Todos los releases est?n disponibles en:
https://github.com/kkakele/VitaCast/releases

## Compilar Versi?n Corregida

Para asegurar un VPK sin errores:
```bash
git clone https://github.com/kkakele/VitaCast.git
cd VitaCast
make -f Makefile_complete clean
make -f Makefile_complete release
```

Esto generar? `VitaCast.vpk` con el CONTENT_ID correcto.
