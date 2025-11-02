##############################################
# VitaCast - PlayStation Vita Homebrew
# Makefile siguiendo estándares homebrew
##############################################

# Información de la aplicación
TARGET = VitaCast
TITLE_ID = VCAST001
APP_VER = 03.00
CONTENT_ID = UP0000-$(TITLE_ID)_00-0000000000000000

# Directorios
BUILD_DIR = build
VPK_DIR = $(BUILD_DIR)/vpk

# Herramientas VitaSDK
PREFIX = arm-vita-eabi-
CC = $(PREFIX)gcc
STRIP = $(PREFIX)strip
OBJCOPY = $(PREFIX)objcopy

# Flags de compilación
CFLAGS = -Wl,-q -O2 -g
CFLAGS += -Wall -Wextra -Wpedantic
CFLAGS += -std=c11
CFLAGS += -DVITA
CFLAGS += -I.
CFLAGS += -fno-use-linker-plugin
CFLAGS += $(shell $(PREFIX)pkg-config --cflags vita2d 2>/dev/null || echo "-I$$VITASDK/arm-vita-eabi/include")

# Flags para release
RELEASE_CFLAGS = -Wl,-q -O3
RELEASE_CFLAGS += -Wall -Wextra
RELEASE_CFLAGS += -std=c11
RELEASE_CFLAGS += -DVITA -DNDEBUG
RELEASE_CFLAGS += -I.
RELEASE_CFLAGS += -fno-use-linker-plugin
RELEASE_CFLAGS += $(shell $(PREFIX)pkg-config --cflags vita2d 2>/dev/null || echo "-I$$VITASDK/arm-vita-eabi/include")

# Archivos fuente
SOURCES = main.c \
          ui/ui_manager.c \
          audio/audio_player.c \
          audio/atrac_decoder.c \
          network/network_manager.c \
          apple/apple_sync.c

# Archivos objeto
OBJECTS = $(SOURCES:%.c=$(BUILD_DIR)/%.o)

# Bibliotecas del sistema
LIBS = -lSceDisplay_stub \
       -lSceCtrl_stub \
       -lSceLibKernel_stub \
       -lSceAudio_stub \
       -lSceNet_stub \
       -lSceNetCtl_stub \
       -lSceSysmodule_stub \
       -lSceCommonDialog_stub \
       -lSceFont_stub \
       -lSceGxm_stub \
       -lSceAppMgr_stub \
       -lvita2d \
       -lm

# Targets principales
.PHONY: all clean release debug install

all: $(TARGET).vpk

release: CFLAGS = $(RELEASE_CFLAGS)
release: clean $(TARGET).vpk

debug: CFLAGS += -DDEBUG -g -O0
debug: clean $(TARGET).vpk

# Crear VPK
$(TARGET).vpk: $(BUILD_DIR)/eboot.bin param.sfo | $(VPK_DIR)
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  Empaquetando $(TARGET) v$(APP_VER)..."
	@echo "═══════════════════════════════════════════════════════════"
	vita-pack-vpk -s param.sfo \
	              -b $(BUILD_DIR)/eboot.bin \
	              -a sce_sys/icon0.png=sce_sys/icon0.png \
	              -a sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png \
	              -a sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
	              -a sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png \
	              -a sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
	              $(TARGET).vpk
	@echo ""
	@echo "✅ VPK creado: $(TARGET).vpk"
	@du -h $(TARGET).vpk | awk '{print "  📦 Tamaño: " $$1}'

# Crear param.sfo
param.sfo:
	@echo "Generando param.sfo..."
	vita-mksfoex -s TITLE_ID=$(TITLE_ID) \
	             -s APP_VER=$(APP_VER) \
	             -s CONTENT_ID=$(CONTENT_ID) \
	             -s ATTRIBUTE=0x8000000000000000 \
	             "$(TARGET)" param.sfo

# Crear eboot.bin
$(BUILD_DIR)/eboot.bin: $(BUILD_DIR)/$(TARGET).velf | $(BUILD_DIR)
	@echo "Generando eboot.bin..."
	vita-make-fself $(BUILD_DIR)/$(TARGET).velf $(BUILD_DIR)/eboot.bin

# Crear VELF
$(BUILD_DIR)/$(TARGET).velf: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
	@echo "Generando VELF..."
	vita-elf-create $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).velf

# Enlazar ELF
$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) | $(BUILD_DIR)
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  Enlazando $(TARGET)..."
	@echo "═══════════════════════════════════════════════════════════"
	$(CC) $(CFLAGS) $(OBJECTS) $(LIBS) -o $@
	@echo "✅ Enlazado completado"

# Compilar archivos fuente
$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	@echo "Compilando $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Crear directorios
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/ui
	@mkdir -p $(BUILD_DIR)/audio
	@mkdir -p $(BUILD_DIR)/network
	@mkdir -p $(BUILD_DIR)/apple

$(VPK_DIR): $(BUILD_DIR)
	@mkdir -p $(VPK_DIR)

# Limpiar
clean:
	@echo "Limpiando archivos de compilación..."
	rm -rf $(BUILD_DIR)
	rm -f $(TARGET).vpk
	rm -f param.sfo
	@echo "✅ Limpieza completada"

# Instalación (información)
install: $(TARGET).vpk
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  Instrucciones de instalación:"
	@echo "═══════════════════════════════════════════════════════════"
	@echo "1. Transfiere $(TARGET).vpk a tu PS Vita"
	@echo "2. Abre VitaShell en tu PS Vita"
	@echo "3. Navega a $(TARGET).vpk y presiona X para instalar"
	@echo "═══════════════════════════════════════════════════════════"

# Información del proyecto
info:
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  $(TARGET) Build Information"
	@echo "═══════════════════════════════════════════════════════════"
	@echo "📦 TITLE_ID: $(TITLE_ID)"
	@echo "📌 APP_VER: $(APP_VER)"
	@echo "🔖 CONTENT_ID: $(CONTENT_ID)"
	@echo ""
	@echo "📂 Archivos fuente:"
	@for src in $(SOURCES); do echo "   • $$src"; done
	@echo ""
	@echo "📚 Bibliotecas:"
	@for lib in $(LIBS); do echo "   • $$lib"; done
	@echo ""
	@echo "🔨 Comandos disponibles:"
	@echo "   make          - Compilar versión normal"
	@echo "   make release  - Compilar versión optimizada"
	@echo "   make debug    - Compilar versión debug"
	@echo "   make clean    - Limpiar archivos"
	@echo "   make install  - Mostrar instrucciones"
	@echo "   make info     - Mostrar esta información"
	@echo "═══════════════════════════════════════════════════════════"
