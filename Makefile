TARGET = VitaCast
OBJS = main_simple.o

LIBS = -lSceDisplay_stub -lSceCtrl_stub

PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O2 -std=c99

# VPK metadata (TITLE_ID must be exactly 9 chars)
TITLE_ID = VCST00001
APP_VER = 01.00
CONTENT_ID = IV0000-$(TITLE_ID)_00-VITACAST000001

all: $(TARGET).vpk

$(TARGET).vpk: eboot.bin
	vita-mksfoex -s TITLE_ID=$(TITLE_ID) -s APP_VER=$(APP_VER) "$(TARGET)" param.sfo
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
