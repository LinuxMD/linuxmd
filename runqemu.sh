#!/bin/bash

mkdir everdrive-sd
cp u-boot/u-boot.bin linux/vmlinux.lz4 smolutils/m68k.erofs everdrive-sd/
qemu-build/qemu-system-m68k -M megadrive -bios everdrive-sd/u-boot.bin -serial stdio -global md-everdrive.dir=everdrive-sd/
