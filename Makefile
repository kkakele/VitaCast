TARGET = VitaCast
OBJS = main.o ui/ui_manager.o audio/audio_player.o audio/atrac_decoder.o network/network_manager.o apple/apple_sync.o vita2d_stub.o

VSDKLIB ?= $(VITASDK)/arm-vita-eabi/lib
LIBS = -lvita2d -lSceGxm_stub -lSceDisplay_stub -lSceCommonDialog_stub -lSceSysmodule_stub \
  -lSceCtrl_stub -lSceNet_stub -lSceNetCtl_stub -lSceIofilemgr_stub -lSceLibKernel_stub \
  -lSceSsl_stub -lcurl -lssl -lcrypto -lpng -lz -lm

PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O2 -std=c99 -I. -Iui -Iaudio -Inetwork -Iapple

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

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

ui/ui_manager.o: ui/ui_manager.c ui/ui_manager.h
	$(CC) $(CFLAGS) -c $< -o $@

audio/audio_player.o: audio/audio_player.c audio/audio_player.h
	$(CC) $(CFLAGS) -c $< -o $@

audio/atrac_decoder.o: audio/atrac_decoder.c audio/atrac_decoder.h
	$(CC) $(CFLAGS) -c $< -o $@

network/network_manager.o: network/network_manager.c network/network_manager.h
	$(CC) $(CFLAGS) -c $< -o $@

apple/apple_sync.o: apple/apple_sync.c apple/apple_sync.h
	$(CC) $(CFLAGS) -c $< -o $@

vita2d_stub.o: vita2d_stub.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TARGET).vpk $(TARGET).velf $(TARGET).elf eboot.bin param.sfo $(OBJS)
	rm -rf ui/*.o audio/*.o network/*.o apple/*.o

.PHONY: clean all
