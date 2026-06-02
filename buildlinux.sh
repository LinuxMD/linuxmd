#!/bin/bash

make -C linux ARCH=m68k CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-` virt_mc68000_defconfig
make -C linux ARCH=m68k CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-` vmlinux -j8
