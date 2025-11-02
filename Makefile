TARGET = VitaCast
TITLE_ID = VCAST2000
APP_VER = 02.01
CONTENT_ID = UP0000-$(TITLE_ID)_00-0000000000000000

# Archivos fuente
OBJS = main.o \
       ui/ui_manager.o \
       audio/audio_player.o \
       audio/atrac_decoder.o \
       network/network_manager.o \
       apple/apple_sync.o

# Compilador y flags
PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O3 -std=c99 -I.

# Bibliotecas necesarias (sin vita2d)
LIBS = -lSceDisplay_stub \
       -lSceCtrl_stub \
       -lSceAudio_stub \
       -lSceAudioOut_stub \
       -lSceNet_stub \
       -lSceNetCtl_stub \
       -lSceSysmodule_stub \
       -lSceLibKernel_stub

# Target principal
all: $(TARGET).vpk

# Generar VPK
$(TARGET).vpk: eboot.bin param.sfo
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║  Empaquetando VitaCast v$(APP_VER)..."
	@echo "╚══════════════════════════════════════════════════════════════╝"
	vita-pack-vpk -s param.sfo -b eboot.bin \
	  -a sce_sys/icon0.png=sce_sys/icon0.png \
	  -a sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png \
	  -a sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
	  -a sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png \
	  -a sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
	  $(TARGET).vpk
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║  ✅ VPK creado exitosamente: $(TARGET).vpk"
	@echo "║  📦 Tamaño: $$(du -h $(TARGET).vpk | cut -f1)"
	@echo "║  🎮 Instalar en PS Vita con VitaShell"
	@echo "╚══════════════════════════════════════════════════════════════╝"
	@echo ""

# Generar param.sfo
param.sfo:
	@echo "Generando param.sfo..."
	vita-mksfoex -s TITLE_ID=$(TITLE_ID) -s APP_VER=$(APP_VER) \
	  -s CONTENT_ID=$(CONTENT_ID) "$(TARGET)" param.sfo

# Generar eboot.bin
eboot.bin: $(TARGET).velf
	@echo "Generando eboot.bin..."
	vita-make-fself -c -s $(TARGET).velf eboot.bin

# Generar VELF
$(TARGET).velf: $(TARGET).elf
	@echo "Generando VELF..."
	vita-elf-create $(TARGET).elf $(TARGET).velf

# Enlazar ELF
$(TARGET).elf: $(OBJS)
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║  Enlazando $(TARGET).elf..."
	@echo "╚══════════════════════════════════════════════════════════════╝"
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@
	@echo "✅ Enlazado completado"

# Compilar archivos .c a .o
%.o: %.c
	@echo "Compilando $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Limpiar archivos generados
clean:
	@echo "Limpiando archivos de compilación..."
	rm -f $(TARGET).vpk $(TARGET).velf $(TARGET).elf eboot.bin param.sfo $(OBJS)
	@echo "✅ Limpieza completada"

# Compilación completa limpia
rebuild: clean all

# Versión debug
debug: CFLAGS = -Wl,-q -Wall -g -O0 -std=c99 -DDEBUG -I.
debug: clean all
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║  ✅ Versión DEBUG compilada"
	@echo "╚══════════════════════════════════════════════════════════════╝"

# Versión release optimizada
release: CFLAGS = -Wl,-q -Wall -O3 -std=c99 -DNDEBUG -I.
release: clean all
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║  ✅ Versión RELEASE compilada y optimizada"
	@echo "╚══════════════════════════════════════════════════════════════╝"

# Información del proyecto
info:
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║  VitaCast Build System v$(APP_VER)"
	@echo "╚══════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "📦 TITLE_ID: $(TITLE_ID)"
	@echo "📌 APP_VER: $(APP_VER)"
	@echo "🔖 CONTENT_ID: $(CONTENT_ID)"
	@echo ""
	@echo "📂 Archivos fuente:"
	@for obj in $(OBJS); do echo "   • $$obj"; done
	@echo ""
	@echo "📚 Bibliotecas:"
	@for lib in $(LIBS); do echo "   • $$lib"; done
	@echo ""
	@echo "🔨 Comandos disponibles:"
	@echo "   make          - Compilar versión normal"
	@echo "   make clean    - Limpiar archivos"
	@echo "   make rebuild  - Limpiar y recompilar"
	@echo "   make debug    - Compilar versión debug"
	@echo "   make release  - Compilar versión release optimizada"
	@echo "   make install  - Instalar en PS Vita (requiere FTP)"
	@echo "   make info     - Mostrar esta información"
	@echo ""

# Instalar en PS Vita (requiere conexión FTP configurada)
install: $(TARGET).vpk
	@echo "Para instalar en PS Vita:"
	@echo "1. Abre VitaShell en tu PS Vita"
	@echo "2. Transfiere $(TARGET).vpk a ux0:/data/"
	@echo "3. En VitaShell, navega a $(TARGET).vpk y presiona X para instalar"
	@echo ""
	@echo "O usa: vita-install-vpk $(TARGET).vpk (si tienes configurado)"

.PHONY: all clean rebuild debug release info install
