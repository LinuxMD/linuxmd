#!/bin/bash

cd buildroot
make linuxmdtc_defconfig
make toolchain
