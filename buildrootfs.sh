#!/bin/bash

set -e
set -u

(
	cd tarwak
	meson setup build
	meson compile -C build
)

(
	make -C smolutils -f Makefile.68000 NOLIBCDIR=`realpath linux/tools/include/nolibc` \
		CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-` \
		TARWAK=`realpath tarwak/build/tarwak` clean

	make -C smolutils -f Makefile.68000 NOLIBCDIR=`realpath linux/tools/include/nolibc` \
		CROSS_COMPILE=`realpath ./buildroot/output/host/bin/m68k-linux-` \
		TARWAK=`realpath tarwak/build/tarwak` m68k.erofs
)
