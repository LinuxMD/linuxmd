# linuxmd
Linux for the Sega MegaDrive

## Is this a joke?

No

## What do I need?

- A Sega Megadrive
- Mega EverDrive Core or Pro (pro is untested) (See: https://krikzz.com/our-products/cartridges/)
- USB cable between the EverDrive and your PC
- Time to burn

## Will this work on an emulator?

Probably not, the emulator would need to emulate the EverDrive's special `SSF2` mapper that gives
use 4MB of RAM and the EverDrive's protocol that allows the MegaDrive to load files from the SD
card.

## Build instructions

- Run `./buildtoolchain.sh` to build a toolchain. This uses buildroot but we do not build a root
  filesystem with it. buildroot is the least painful way to get a m68k-linux toolchain that can
  produce usable binaries for 68000.

- Run `./builduboot.sh` to use the toolchain to build u-boot.

- Run `./buildmedtool.sh` to build `medtool` to interact with the everdrive for serial console.

- Run `./buildlinux.sh` to build the linux kernel image. (NOTE: at the moment this does not produce a workable image).

- Run `./buildrootfs.sh` to build the rootfs erofs image.

TODO

## Boot instructions

- Copy `u-boot/u-boot.bin`, `linux/vmlinux.lz4`, `smolutils/m68k.erofs` to your EverDrive SD card

- Power up the Megadrive

- Connect the USB cable to your PC (It might be OK to connect it while the Megadrive is off but I had issues with it)

- Check your dmesg to make sure the EverDrive is detected. You should see something like this:

```
[1135618.045606] usb 3-2: new full-speed USB device number 5 using xhci_hcd
[1135618.255415] usb 3-2: New USB device found, idVendor=0483, idProduct=5740, bcdDevice= 2.00
[1135618.255428] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[1135618.255430] usb 3-2: Product: Mega EverDrive
[1135618.255432] usb 3-2: Manufacturer: STMicroelectronics
[1135618.255434] usb 3-2: SerialNumber: 00000000001A
[1135618.307393] cdc_acm 3-2:1.0: ttyACM0: USB ACM device
[1135618.307472] usbcore: registered new interface driver cdc_acm
[1135618.307475] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
```

- Connect `medtool` to your EverDrive in `terminal` mode:

```
./medtool/medtool -p /dev/ttyACM0 -m terminal
Opened serial port /dev/ttyACM0
data out, 4 bytes -->
0x2b 0xd4 0x40 0xbf 
<-- data in, 4 bytes
0x5a 0x05 0x25 0x00 
core
Creating socket and waiting for connection (minicom -D unix#/tmp/medtool)
```

- Do what it told you and start `minicom` with it connecting to the unix socket for `medtool`

- In the EverDrive menu select `u-boot.bin` hit a button, and then hit `start game`

![everdrive_menu_uboot](doc_everdrive_start_uboot.jpg)

- Wait a little while and you should see u-boot appear on in minicom:

```
Welcome to minicom 2.10

OPTIONS: I18n 
Port unix#/tmp/medtool [?]

Press CTRL-A Z for help on special keys

md
!
a
b
c


U-Boot 2026.01-00663-g58351542bd04-dirty (Jun 09 2026 - 21:45:36 +0900)

DRAM:  3.8 MiB
SR is 0x2700
copy from 00000000 to 0039a000, 0x25f70 bytes (reloc_off 0x0039a000)
copied from 00000000 to 0039a000, 0x25f70 bytes (reloc_off 0x0039a000)
clearing new bss from 003bd000 to 003bff70
Doing relocation 
Relocation point of no return, new SP 0x00338990, jump to 0x003a2184
Core:  5 devices, 5 uclasses, devicetree: embed
Loading Environment from NVRAM... *** Warning - bad CRC, using default environment

In:    serial
Out:   serial,vidconsole
Err:   serial
Hit any key to stop autoboot: 0
status; 0xa500
status; 0xa500
Loading vmlinux.lz4, 772901 bytes
status; 0xa500
Done
Uncompressed size: 1337124 = 0x146724
ELF overwrites reserved memory: 0x00000400 -> 0x00103860: -22
ELF overwrites reserved memory: 0x0011f808 -> 0x0011f810: -22
ELF overwrites reserved memory: 0x0011f810 -> 0x0011f81c: -22
ELF overwrites reserved memory: 0x0011f81c -> 0x0011f82c: -22
ELF overwrites reserved memory: 0x0011f82c -> 0x0011f83c: -22
ELF overwrites reserved memory: 0x0011f83c -> 0x0011f84c: -22
ELF overwrites reserved memory: 0x0011f84c -> 0x0011f85c: -22
ELF overwrites reserved memory: 0x00134000 -> 0x00143928: -22
new fdt 0033b1d0
L
s
K[    0.000000] Linux version 7.1.0-rc6-00187-g59679e53ee8a-dirty (daniel@kinako) (m68k-linux-gcc.br_real (Buildroot -gdb75a8eea0bd) 15.2.0, GNU ld (GNU Binutils) 2.46.0.20260210) #16 Tue Jun  9 22:43:03 JST 2026
[    0.000000] printk: legacy bootconsole [debug0] enabled
[    0.000000] Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne
[    0.000000] Generic DT Machine (C) 2024 Daniel Palmer <daniel@thingy.jp>
[    0.000000] OF: reserved mem: Reserved memory: No reserved-memory node in the DT
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x00000000003fffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x00000000003fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x00000000003fffff]
[    0.000000] Kernel command line: earlyprintk
[    0.000000] Unknown kernel command line parameters "earlyprintk", will be passed to user space.
[    0.000000] printk: log buffer data + meta data: 8192 + 25600 = 33792 bytes
[    0.000000] Dentry cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.000000] Inode-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.000000] Built 1 zonelists, mobility grouping off.  Total pages: 1024
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] SLUB: HWalign=16, Order=0-1, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS: 32
[    0.000000] timer_probe: no matching timers found
``` 

Loading and decompressing the kernel will take some time. Wait!

TODO
