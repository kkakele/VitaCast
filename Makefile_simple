TARGET = VitaCast
OBJS = main_simple.o

LIBS = -lSceDisplay_stub -lSceCtrl_stub

PREFIX = arm-vita-eabi
CC = $(PREFIX)-gcc
CFLAGS = -Wl,-q -Wall -O2 -std=c99

all: $(TARGET).vpk

$(TARGET).vpk: eboot.bin
	vita-mksfoex -s TITLE_ID=VITACAST01 -s APP_VER=01.00 -s CONTENT_ID=PCSE00001 "$(TARGET)" param.sfo
	vita-pack-vpk -s param.sfo -b eboot.bin $(TARGET).vpk

eboot.bin: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TARGET).vpk eboot.bin param.sfo $(OBJS)

.PHONY: clean all
