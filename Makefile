# SPDX-License-Identifier: GPL-2.0
obj-m += tagtagtag-ears.o
#dtbo-y += tagtagtag-ears.dtbo

#targets += $(dtbo-y)
#always  := $(dtbo-y)

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) clean

tagtagtag-ears.dtbo:
	dtc -I dts -O dtb -o tagtagtag-ears.dtbo tagtagtag-ears-overlay.dts

install: tagtagtag-ears.ko tagtagtag-ears.dtbo
	install -o root -m 755 -d /lib/modules/$(shell uname -r)/kernel/input/misc/
	install -o root -m 644 tagtagtag-ears.ko /lib/modules/$(shell uname -r)/kernel/input/misc/
	depmod -a $(shell uname -r)
	install -o root -m 644 tagtagtag-ears.dtbo /boot/overlay-user/
	sed /boot/armbianEnv.txt -i -e "s/^#dtoverlay=tagtagtag-ears/dtoverlay=tagtagtag-ears/"

	grep -q -E "^dtoverlay=tagtagtag-ears" /boot/armbianEnv.txt || printf "dtoverlay=tagtagtag-ears\n" >> /boot/armbianEnv.txt

.PHONY: all clean install
