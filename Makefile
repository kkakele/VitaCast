TARGET = VitaCast
TITLE_ID = VCST00003

OBJS = main.o ui/ui_manager.o audio/audio_player.o audio/atrac_decoder.o \
       network/network_manager.o apple/apple_sync.o vita2d_stub.o

LIBS = -lvita2d -lSceGxm_stub -lSceDisplay_stub -lSceCtrl_stub \
       -lSceSysmodule_stub -lSceCommonDialog_stub -lSceAppMgr_stub \
       -lSceNet_stub -lSceNetCtl_stub -lSceIofilemgr_stub -lSceLibKernel_stub \
       -lSceSsl_stub -lcurl -lssl -lcrypto \
       -lpng -ljpeg -lfreetype -lz -lm -lc

PREFIX  = arm-vita-eabi
CC      = $(PREFIX)-gcc
CFLAGS  = -Wl,-q -Wall -O3
ASFLAGS = $(CFLAGS)

all: $(TARGET).vpk

%.vpk: eboot.bin param.sfo
	vita-pack-vpk -s param.sfo -b eboot.bin \
		-a sce_sys/icon0.png=sce_sys/icon0.png \
		-a sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
		-a sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
		$@

param.sfo:
	vita-mksfoex -s TITLE_ID=$(TITLE_ID) "$(TARGET)" param.sfo

eboot.bin: $(TARGET).velf
	vita-make-fself -s $< eboot.bin

%.velf: %.elf
	cp $< $<.unstripped.elf
	$(PREFIX)-strip -g $<
	vita-elf-create $< $@

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

ui/%.o: ui/%.c
	$(CC) $(CFLAGS) -c $< -o $@

audio/%.o: audio/%.c
	$(CC) $(CFLAGS) -c $< -o $@

network/%.o: network/%.c
	$(CC) $(CFLAGS) -c $< -o $@

apple/%.o: apple/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -rf $(TARGET).vpk $(TARGET).velf $(TARGET).elf $(OBJS) \
		eboot.bin param.sfo *.unstripped.elf ui/*.o audio/*.o network/*.o apple/*.o

.PHONY: all clean
