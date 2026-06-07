#!/bin/bash

make -C linux ARCH=m68k CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-` megadrive_defconfig
make -C linux ARCH=m68k CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-` vmlinux -j8
./buildroot/output/host/bin/m68k-linux-strip linux/vmlinux
lz4 --best linux/vmlinux linux/vmlinux.lz4

#make -C linux ARCH=m68k CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-` menuconfig
#make -C linux ARCH=m68k CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-` savedefconfig
