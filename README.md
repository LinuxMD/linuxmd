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
use 4MB of RAM, the EverDrive's protocol that allows the MegaDrive to load files from the SD
card and the timer register the EverDrive provides.

## Build instructions

- Run `./buildtoolchain.sh` to build a toolchain. This uses buildroot but we do not build a root
  filesystem with it. buildroot is the least painful way to get a m68k-linux toolchain that can
  produce usable binaries for 68000.

- Run `./builduboot.sh` to use the toolchain to build u-boot.

- Run `./buildmedtool.sh` to build `medtool` to interact with the everdrive for serial console.

- Run `./buildlinux.sh` to build the linux kernel image.

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


U-Boot 2026.01-00665-ga72b247a95c4-dirty (Jun 10 2026 - 23:16:28 +0900)

DRAM:  3.8 MiB
SR is 0x2700
copy from 00000000 to 0039a000, 0x25f70 bytes (reloc_off 0x0039a000)
copied from 00000000 to 0039a000, 0x25f70 bytes (reloc_off 0x0039a000)
clearing new bss from 003bd000 to 003bff70
Doing relocation 
Relocation point of no return, new SP 0x003388f0, jump to 0x003a2184
Core:  5 devices, 5 uclasses, devicetree: embed
Loading Environment from NVRAM... *** Warning - bad CRC, using default environment

In:    serial
Out:   serial,vidconsole
Err:   serial
Hit any key to stop autoboot: 0
status; 0xa500
status; 0xa500
Loading vmlinux.lz4, 722392 bytes
status; 0xa500
Done
status; 0xa500
Loading m68k.erofs, 90112 bytes
status; 0xa500
Done
Uncompressed size: 1244884 = 0x12FED4
ELF overwrites reserved memory: 0x00000400 -> 0x000f2c60: -22
ELF overwrites reserved memory: 0x000f3000 -> 0x0010bf50: -22
ELF overwrites reserved memory: 0x0010bf50 -> 0x0010bf58: -22
ELF overwrites reserved memory: 0x0010bf58 -> 0x0010bf64: -22
ELF overwrites reserved memory: 0x0010bf64 -> 0x0010bf74: -22
ELF overwrites reserved memory: 0x0010bf74 -> 0x0010bf84: -22
ELF overwrites reserved memory: 0x0010bf84 -> 0x0010bf94: -22
ELF overwrites reserved memory: 0x0010bf94 -> 0x0010bfa4: -22
ELF overwrites reserved memory: 0x0010bfa4 -> 0x0010c210: -22
ELF overwrites reserved memory: 0x0010c210 -> 0x0010c264: -22
ELF overwrites reserved memory: 0x0010d000 -> 0x0011d7e0: -22
ELF overwrites reserved memory: 0x0011e000 -> 0x0012d1a2: -22
ELF overwrites reserved memory: 0x0012d1a4 -> 0x0012fac0: -22
ELF overwrites reserved memory: 0x00130000 -> 0x0013735d: -22
new fdt 0033b1e8
L
s
K[    0.000000] Linux version 7.1.0-rc6-00197-g21fa92d7c57d-dirty (daniel@kinako) (m68k-linux-gcc.br_real (Buildroot -gdb75a8eea0bd) 15.2.0, GNU ld (GNU Binutils) 2.46.0.20260210) #61 Thu Jun 11 00:50:10 JST 2026
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
[    0.000000] Kernel command line: earlyprintk root=/dev/ram
[    0.000000] Unknown kernel command line parameters "earlyprintk", will be passed to user space.
[    0.000000] printk: log buffer data + meta data: 4096 + 8704 = 12800 bytes
[    0.000000] Dentry cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.000000] Inode-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.000000] Built 1 zonelists, mobility grouping off.  Total pages: 1024
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] SLUB: HWalign=16, Order=0-1, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS: 32
[    0.000000] Enabling VDP ints..
[    0.000000] Enabled VDP ints..
[    0.020000] Calibrating delay loop... 1.19 BogoMIPS (lpj=5952)
[    0.170000] pid_max: default: 4096 minimum: 301
[    0.250000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.270000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.360000] VFS: Finished mounting rootfs on nullfs
[    1.720000] Memory: 2552K/4096K available (970K kernel code, 66K rwdata, 104K rodata, 72K init, 28K bss, 1336K reserved, 0K cma-reserved)
[    2.240000] devtmpfs: initialized
[    3.070000] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    6.890000] workingset: timestamp_bits=30 (anon: 26) max_order=10 bucket_order=0 (anon: 0)
[    7.800000] megadrive_vdp_probe:31
[    7.870000] megadrive-vdp c00000.vdp: registered IRQ 3
[   10.770000] Warning: unable to open an initial console.
[   10.960000] /dev/root: Can't open blockdev
[   11.010000] VFS: Cannot open root device "/dev/ram" or unknown-block(1,0): error -6
[   11.040000] Please append a correct "root=" boot option; here are the available partitions:
[   11.070000] List of all bdev filesystems:
[   11.090000]  erofs
[   11.100000] 
[   11.140000] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(1,0)
[   11.140000] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(1,0) ]---
```

Loading and decompressing the kernel will take some time. Wait!

TODO
