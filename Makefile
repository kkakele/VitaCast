TARGET = VitaCast
OBJS = main_final.o

LIBS = -lvita2d -lSceGxm_stub -lSceDisplay_stub -lSceCtrl_stub -lpng -lz -lm

PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O2 -std=gnu99 -I. -Iui -Iaudio -Inetwork -Iapple

# VPK metadata (TITLE_ID must be exactly 9 chars)
TITLE_ID = VCST00001
APP_VER = 01.00
CONTENT_ID = IV0000-$(TITLE_ID)_00-VITACAST000001

all: $(TARGET).vpk

$(TARGET).vpk: eboot.bin param.sfo
	vita-pack-vpk -s param.sfo -b eboot.bin \
	  -a sce_sys/icon0.png=sce_sys/icon0.png \
	  -a sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png \
	  -a sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
	  -a sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png \
	  -a sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
	  $(TARGET).vpk

param.sfo:
	vita-mksfoex -s TITLE_ID=$(TITLE_ID) \
		-s APP_VER=$(APP_VER) \
		-s CATEGORY=gd \
		-s ATTRIBUTE2=12 \
		-d ATTRIBUTE=c0000000 \
		"$(TARGET)" param.sfo

eboot.bin: $(TARGET).velf
	vita-make-fself -s $< $@

$(TARGET).velf: $(TARGET).elf
	vita-elf-create $< $@

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $^ -Wl,--start-group $(LIBS) -Wl,--end-group -o $@

main_final.o: main_final.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TARGET).vpk $(TARGET).velf $(TARGET).elf eboot.bin param.sfo $(OBJS)
	rm -rf ui/*.o audio/*.o network/*.o apple/*.o

.PHONY: clean all
