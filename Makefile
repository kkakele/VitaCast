TARGET = VitaCast
OBJS = main.o ui/ui_manager.o audio/audio_player.o network/network_manager.o apple/apple_sync.o

LIBS = -lvita2d -lSceDisplay_stub -lSceGxm_stub -lSceCtrl_stub -lSceAudio_stub -lSceNet_stub -lSceHttp_stub -lcurl -ljson-c -lm

PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O2 -std=c99

all: $(TARGET).vpk

$(TARGET).vpk: eboot.bin
vita-mksfoex -s TITLE_ID=VITACAST01 -s APP_VER=01.00 -s CONTENT_ID=PCSE00001 "$(TARGET)" param.sfo
vita-pack-vpk -s param.sfo -b eboot.bin \
--add assets/background.png=assets/background.png \
$(TARGET).vpk

eboot.bin: $(OBJS)
$(CC) $(CFLAGS) $^ $(LIBS) -o $@

%.o: %.c
$(CC) $(CFLAGS) -c $< -o $@

clean:
rm -rf $(TARGET).vpk eboot.bin param.sfo $(OBJS)

.PHONY: clean all
