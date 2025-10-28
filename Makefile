TARGET = VitaCast
TITLE_ID = VCST00001

OBJS = main_final.o

LIBS = -lvita2d -lSceDisplay_stub -lSceGxm_stub -lSceCtrl_stub \
       -lSceSysmodule_stub -lSceCommonDialog_stub -lSceAppMgr_stub \
       -lpng -ljpeg -lfreetype -lz -lm -lc

PREFIX  = arm-vita-eabi
CC      = $(PREFIX)-gcc
CFLAGS  = -Wl,-q -Wall -O3
ASFLAGS = $(CFLAGS)

all: $(TARGET).vpk

%.vpk: eboot.bin
	vita-mksfoex -s TITLE_ID=$(TITLE_ID) "$(TARGET)" param.sfo
	vita-pack-vpk -s param.sfo -b eboot.bin \
		-a sce_sys/icon0.png=sce_sys/icon0.png \
		-a sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png \
		-a sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
		$@

eboot.bin: $(TARGET).velf
	vita-make-fself -c $< eboot.bin

%.velf: %.elf
	cp $< $<.unstripped.elf
	$(PREFIX)-strip -g $<
	vita-elf-create $< $@

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

clean:
	@rm -rf $(TARGET).vpk $(TARGET).velf $(TARGET).elf $(OBJS) \
		eboot.bin param.sfo *.unstripped.elf

.PHONY: all clean
