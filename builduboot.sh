#!/bin/bash

make -C u-boot sega_megadrive_defconfig
make -C u-boot CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-`
