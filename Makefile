TARGET = VitaCast
PROJECT_TITLE = VitaCast
PROJECT_TITLEID = VCTS00001

OBJS = main.o ui/ui_manager.o audio/audio_player.o audio/atrac_decoder.o network/network_manager.o apple/apple_sync.o vita2d_stub.o

LIBS = -lvita2d -lSceGxm_stub -lSceDisplay_stub -lSceCtrl_stub \
  -lSceSysmodule_stub -lSceCommonDialog_stub -lSceAppMgr_stub \
  -lSceNet_stub -lSceNetCtl_stub -lSceIofilemgr_stub -lSceLibKernel_stub \
  -lSceSsl_stub -lcurl -lssl -lcrypto -lpng -ljpeg -lfreetype -lz -lm -lc

PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
STRIP = $(PREFIX)-strip
CFLAGS = -Wl,-q -Wall -O2 -std=gnu99 -I. -Iui -Iaudio -Inetwork -Iapple

all: $(TARGET).vpk

$(TARGET).vpk: eboot.bin param.sfo
	vita-pack-vpk -s param.sfo -b eboot.bin \
		--add sce_sys/icon0.png=sce_sys/icon0.png \
		--add sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png \
		--add sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
		--add sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png \
		--add sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
	$(TARGET).vpk

eboot.bin: $(TARGET).velf
	vita-make-fself -c -a 0x40000 $(TARGET).velf eboot.bin

param.sfo:
	vita-mksfoex -s TITLE_ID="$(PROJECT_TITLEID)" "$(PROJECT_TITLE)" param.sfo

$(TARGET).velf: $(TARGET).elf
	$(STRIP) -g $<
	vita-elf-create $< $@

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

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

.PHONY: all clean
