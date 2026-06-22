#!/bin/bash

mkdir everdrive-sd
cp u-boot/u-boot.bin linux/vmlinux.lz4 smolutils/m68k.erofs everdrive-sd/
#cpulimit -l 10 --

qemu-build/qemu-system-m68k -M megadrive -bios everdrive-sd/u-boot.bin \
	-serial stdio -global md-everdrive.dir=everdrive-sd/ -global md-everdrive.resp-delay-us=1 -icount shift=10,align=on -s
