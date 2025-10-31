TARGET = VitaCast
OBJS = main_simple.o

# Bibliotecas necesarias segun VitaSDK.org (orden correcto de linking)
LIBS = -lvita2d -lSceLibKernel_stub \
  -lSceDisplay_stub -lSceGxm_stub \
  -lSceSysmodule_stub -lSceCtrl_stub \
  -lScePgf_stub -lSceCommonDialog_stub \
  -lSceAppMgr_stub \
  -lfreetype -lpng -ljpeg -lz -lm

PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O2 -std=gnu11
CFLAGS += -D__PSP2__ -DVITA

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

eboot.bin: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TARGET).vpk eboot.bin param.sfo $(OBJS)

.PHONY: clean all
