# 🤝 Contribuir a VitaCast

¡Gracias por tu interés en contribuir a VitaCast! Este documento te guiará sobre cómo puedes ayudar.

## 📋 Tabla de Contenidos
- [Código de Conducta](#código-de-conducta)
- [¿Cómo puedo contribuir?](#cómo-puedo-contribuir)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Guía de Estilo](#guía-de-estilo)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Features](#sugerir-features)

---

## 📜 Código de Conducta

Al contribuir a VitaCast, te pedimos:
- ✅ Ser respetuoso con todos los colaboradores
- ✅ Aceptar críticas constructivas
- ✅ Enfocarte en lo mejor para el proyecto
- ✅ Mostrar empatía hacia la comunidad

---

## 🤔 ¿Cómo puedo contribuir?

### 🐛 Reportar Bugs
Si encuentras un bug:
1. Verifica que no exista ya un [issue abierto](../../issues)
2. Usa la plantilla de bug report
3. Incluye pasos para reproducir el problema
4. Adjunta logs si es posible

### 💡 Sugerir Features
Para nuevas características:
1. Revisa los [issues existentes](../../issues)
2. Usa la plantilla de feature request
3. Explica el caso de uso
4. Considera la viabilidad técnica

### 📝 Mejorar Documentación
La documentación siempre puede mejorar:
- Corregir typos o errores
- Agregar ejemplos
- Mejorar explicaciones
- Traducir a otros idiomas

### 💻 Contribuir Código
1. Fork el repositorio
2. Crea una rama para tu feature: `git checkout -b feature/mi-feature`
3. Haz commits con mensajes claros
4. Asegúrate de que compila sin errores
5. Prueba en un dispositivo real si es posible
6. Abre un Pull Request

---

## 🔄 Proceso de Desarrollo

### Configurar el Entorno
```bash
# Clonar el repositorio
git clone https://github.com/tuusuario/VitaCast.git
cd VitaCast

# Verificar VitaSDK
echo $VITASDK

# Compilar
make -f Makefile_final
```

### Estructura del Proyecto
```
VitaCast/
├── main.c                   # Main completo con módulos
├── main_final.c             # Main para release
├── main_simple.c            # Main básico
├── ui/                      # Módulos de interfaz
├── audio/                   # Módulos de audio
├── network/                 # Módulos de red
├── apple/                   # Integración Apple
├── sce_sys/                 # Assets y metadatos
└── docs/                    # Documentación
```

### Workflow de Git
1. **Fork** el repositorio
2. **Clone** tu fork localmente
3. **Crea** una rama para tu trabajo
4. **Haz** commits frecuentes y claros
5. **Push** a tu fork
6. **Abre** un Pull Request

### Mensajes de Commit
Usa mensajes descriptivos:
```
✅ Bueno:
"fix: corregir crash al iniciar en Vita 2000"
"feat: añadir soporte para archivos FLAC"
"docs: actualizar guía de instalación"

❌ Malo:
"fix bug"
"update"
"cambios"
```

Prefijos recomendados:
- `feat:` - Nueva característica
- `fix:` - Corrección de bug
- `docs:` - Cambios en documentación
- `style:` - Formato de código
- `refactor:` - Refactorización
- `test:` - Tests
- `chore:` - Tareas de mantenimiento

---

## 📐 Guía de Estilo

### Código C
```c
// ✅ Bueno
static int init_module(void) {
    if (!module) {
        return -1;
    }
    return 0;
}

// ❌ Evitar
static int init_module(void){
if(!module){return -1;}
return 0;}
```

Reglas:
- **Indentación**: 4 espacios (no tabs)
- **Llaves**: Estilo K&R
- **Nombres**: snake_case para funciones/variables
- **Constantes**: UPPER_CASE
- **Punteros**: `type *name` (asterisco junto al nombre)
- **Comentarios**: `// Una línea` o `/* Multi línea */`

### Estructura de Archivos
```c
// 1. Includes del sistema
#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>

// 2. Includes de terceros
#include <vita2d.h>

// 3. Includes locales
#include "ui/ui_manager.h"

// 4. Defines
#define MAX_ITEMS 10

// 5. Typedefs y structs
typedef struct {
    int value;
} my_struct_t;

// 6. Variables globales (evitar si es posible)
static int g_counter = 0;

// 7. Funciones
static void helper_function(void) {
    // ...
}

int main(int argc, char *argv[]) {
    // ...
}
```

### Documentación de Funciones
```c
/**
 * Inicializa el módulo de audio
 * 
 * @return 0 si éxito, -1 si error
 */
int audio_init(void) {
    // ...
}
```

---

## 🐛 Reportar Bugs

### Template de Bug Report
```markdown
**Descripción del Bug**
Una descripción clara y concisa del bug.

**Pasos para Reproducir**
1. Ir a '...'
2. Presionar '...'
3. Ver error

**Comportamiento Esperado**
Lo que esperabas que pasara.

**Comportamiento Actual**
Lo que realmente pasó.

**Screenshots**
Si aplica, añade screenshots.

**Entorno**
- Dispositivo: PS Vita 1000/2000/TV
- Firmware: 3.60/3.65/3.68/3.73
- VitaCast Version: 2.0.1
- CFW: HENkaku/Enso/h-encore

**Información Adicional**
Cualquier otro contexto relevante.
```

---

## 💡 Sugerir Features

### Template de Feature Request
```markdown
**¿Es tu feature request relacionada a un problema?**
Una descripción clara del problema.

**Describe la solución que te gustaría**
Una descripción clara de lo que quieres que pase.

**Describe alternativas que hayas considerado**
Otras soluciones o features que consideraste.

**¿Estarías dispuesto a implementarlo?**
- [ ] Sí, puedo hacer un PR
- [ ] Necesito ayuda
- [ ] Solo sugiero la idea

**Información Adicional**
Screenshots, mockups, o contexto adicional.
```

---

## ✅ Checklist de Pull Request

Antes de enviar tu PR, verifica:

- [ ] El código compila sin errores
- [ ] No hay warnings de compilación
- [ ] Funciona en al menos un dispositivo Vita
- [ ] Documentación actualizada si es necesario
- [ ] Mensajes de commit son claros
- [ ] No hay archivos temporales incluidos
- [ ] .gitignore está actualizado si añadiste archivos nuevos
- [ ] README actualizado si cambió funcionalidad
- [ ] RELEASE_NOTES actualizado para cambios importantes

---

## 🔍 Revisión de Código

Los PRs serán revisados considerando:

1. **Funcionalidad**: ¿Hace lo que dice que hace?
2. **Calidad**: ¿El código está bien escrito?
3. **Compatibilidad**: ¿Funciona en diferentes Vitas?
4. **Performance**: ¿Es eficiente?
5. **Documentación**: ¿Está documentado apropiadamente?

---

## 🎯 Áreas que Necesitan Ayuda

### Prioridad Alta
- 🎵 Implementar reproducción de audio real
- 🌐 Integración con APIs de podcasts
- 💾 Sistema de caché y descarga

### Prioridad Media
- 🎨 Mejorar assets gráficos
- 🌍 Traducción a otros idiomas
- 📱 Mejorar UI/UX

### Prioridad Baja
- 🧪 Tests automatizados
- 📊 Telemetría opcional
- 🎨 Temas personalizables

---

## 📞 Contacto

¿Preguntas sobre contribuciones?
- 💬 [Discussions](../../discussions)
- 🐛 [Issues](../../issues)
- 📧 Email: (añadir si aplica)

---

## 🙏 Reconocimientos

Todos los contribuidores serán reconocidos en:
- README.md
- CONTRIBUTORS.md (se creará)
- Release notes

---

## 📚 Recursos Útiles

### VitaSDK
- [Documentación oficial](https://docs.vitasdk.org)
- [GitHub VitaSDK](https://github.com/vitasdk)
- [VitaSDK Discord](https://discord.gg/vitasdk)

### Comunidad PS Vita
- [r/vitahacks](https://reddit.com/r/vitahacks)
- [VitaDB](https://vitadb.rinnegatamante.it)
- [GBAtemp PS Vita](https://gbatemp.net/forums/ps-vita/)

---

<div align="center">

**¡Gracias por contribuir a VitaCast! 🎮❤️**

</div>

