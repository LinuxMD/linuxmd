#/bin/bash

mkdir qemu-build
cd qemu-build
#../qemu/configure --target-list=m68k-softmmu --enable-sdl --enable-slirp
make
