TARGET = VitaCast
OBJS = main.o

LIBS = -lSceDisplay_stub -lSceCtrl_stub -lvita2d_stub -lcurl -lssl -lcrypto -lpng -ljpeg -lfreetype

PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O2 -std=c99

# VPK metadata (TITLE_ID must be 9 chars)
TITLE_ID = VCAST2000
APP_VER = 02.01
CONTENT_ID = UP0000-$(TITLE_ID)_00-0000000000000000

all: $(TARGET).vpk

$(TARGET).vpk: eboot.bin
	# Generar param.sfo con metadatos válidos para VitaShell
	vita-mksfoex -s TITLE_ID=$(TITLE_ID) -s APP_VER=$(APP_VER) -s CONTENT_ID=$(CONTENT_ID) "$(TARGET)" param.sfo
	# Empaquetar VPK incluyendo recursos esenciales de sce_sys
	vita-pack-vpk -s param.sfo -b eboot.bin \
	  -a sce_sys/icon0.png=sce_sys/icon0.png \
	  -a sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png \
	  -a sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
	  -a sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png \
	  -a sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
	  $(TARGET).vpk

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

$(TARGET).velf: $(TARGET).elf
	vita-elf-create $(TARGET).elf $(TARGET).velf

eboot.bin: $(TARGET).velf
	# Generar SELF sin compresión y con flag UNSAFE (-s)
	vita-make-fself -s $(TARGET).velf eboot.bin

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TARGET).vpk eboot.bin param.sfo $(OBJS) $(TARGET).elf $(TARGET).velf

.PHONY: clean all
