TARGET = VitaCast
OBJS = main_simple.o

LIBS = -lSceDisplay_stub -lSceCtrl_stub

# VitaSDK paths
VITASDK ?= .deps/vitasdk
PREFIX = $(VITASDK)/bin/arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O2 -std=c99
VITA_MKSFOEX = $(VITASDK)/bin/vita-mksfoex
VITA_PACK_VPK = $(VITASDK)/bin/vita-pack-vpk

# VPK metadata (TITLE_ID must be 9 chars)
TITLE_ID = VCAST2000
APP_VER = 02.01
CONTENT_ID = UP0000-$(TITLE_ID)_00-0000000000000000

all: $(TARGET).vpk

$(TARGET).vpk: eboot.bin
	# Generar param.sfo con metadatos válidos para VitaShell
	$(VITA_MKSFOEX) -s TITLE_ID=$(TITLE_ID) -s APP_VER=$(APP_VER) -s CONTENT_ID=$(CONTENT_ID) "$(TARGET)" param.sfo
	# Empaquetar VPK incluyendo recursos esenciales de sce_sys
	$(VITA_PACK_VPK) -s param.sfo -b eboot.bin \
	  -a sce_sys/icon0.png=sce_sys/icon0.png \
	  -a sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png \
	  -a sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
	  -a sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png \
	  -a sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
	  $(TARGET).vpk

%.velf: %.elf
	$(VITASDK)/bin/vita-elf-create $< $@

%.self: %.velf
	$(VITASDK)/bin/vita-make-fself -c $< $@

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

$(TARGET).velf: $(TARGET).elf
	$(VITASDK)/bin/vita-elf-create $< $@

eboot.bin: $(TARGET).velf
	$(VITASDK)/bin/vita-make-fself -c $< $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TARGET).vpk $(TARGET).velf $(TARGET).elf eboot.bin param.sfo $(OBJS)

.PHONY: clean all
