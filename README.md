# linuxmd
Linux for the Sega MegaDrive

## Is this a joke?

No

## What do I need?

- A Sega Megadrive
- Mega EverDrive Core or Pro (pro is untested) (See: https://krikzz.com/our-products/cartridges/)
- USB cable between the EverDrive and your PC
- Time to burn

## Will this work on a (normal) emulator?

Probably not, the emulator would need to emulate the EverDrive's special `SSF2` mapper that gives
us 4MB of RAM, the EverDrive's protocol that allows the MegaDrive to load files from the SD
card and the timer register the EverDrive provides.

A QEMU fork that emulates enough of the MegaDrive and the EverDrive to play with this without
the real hardware is included. Note that this doesn't really emulate the feel of the real thing,
QEMU emulates the CPU way too fast.

## Build instructions

- Run `./buildtoolchain.sh` to build a toolchain. This uses buildroot but we do not build a root
  filesystem with it. buildroot is the least painful way to get a m68k-linux toolchain that can
  produce usable binaries for 68000.

- Run `./builduboot.sh` to use the toolchain to build u-boot.

- Run `./buildmedtool.sh` to build `medtool` to interact with the everdrive for serial console.

- Run `./buildlinux.sh` to build the linux kernel image.

- Run `./buildrootfs.sh` to build the rootfs erofs image.

### For the emulated version

- Run `./buildqemu.sh` to build QEMU

- Run `./runqemu.sh` to run QEMU and boot.

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


U-Boot 2026.01-00675-g9da66c43e96b-dirty (Jun 24 2026 - 20:10:31 +0900)

DRAM:  3.8 MiB
SR is 0x2700
copy from 00000000 to 00398000, 0x27f70 bytes (reloc_off 0x00398000)
copied from 00000000 to 00398000, 0x27f70 bytes (reloc_off 0x00398000)
clearing new bss from 003bd000 to 003bff70
Doing relocation 
Relocation point of no return, new SP 0x003368d0, jump to 0x003a0370
Core:  5 devices, 5 uclasses, devicetree: embed
Loading Environment from NVRAM... *** Warning - bad CRC, using default environment

In:    serial
Out:   serial,vidconsole
Err:   serial
Hit any key to stop autoboot: 0
status; 0xa500
status; 0xa500
Loading vmlinux.lz4, 744178 bytes
status; 0xa500
Done
Uncompressed size: 1270696 = 0x1363A8
ELF overwrites reserved memory: 0x00000000 -> 0x0013ff35: -22
new fdt 003392a8
L
s
KLinux version 7.1.0-rc6-00250-g29f5b5b8fc12-dirty (daniel@kinako) (m68k-linux-gcc.br_real (Buildroot -gdb75a8eea0bd) 15.2.0, GNU ld (GNU Binutils) 2.46.0.20260210) #374 Wed Jun 24 22:12:37 JST 2026
Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne
Generic DT Machine (C) 2024 Daniel Palmer <daniel@thingy.jp>
OF: reserved mem: Reserved memory: No reserved-memory node in the DT
Zone ranges:
  DMA      [mem 0x0000000000000000-0x00000000003fffff]
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000000000000-0x00000000003fffff]
Initmem setup node 0 [mem 0x0000000000000000-0x00000000003fffff]
Kernel command line: console=ttyVDP0 console=ttyED0 root=/dev/edblk -- smolinit.getty=/dev/ttyED0 smolinit.getty=/dev/ttyVDP0 smolinit.hostname=md
printk: log buffer data + meta data: 4096 + 8704 = 12800 bytes
Dentry cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
Inode-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
Built 1 zonelists, mobility grouping off.  Total pages: 1024
mem auto-init: stack:all(zero), heap alloc:off, heap free:off
SLUB: HWalign=16, Order=0-1, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS: 32
clocksource: everdrive-timer: mask: 0xffff max_cycles: 0xffff, max_idle_ns: 29163075000 ns
printk: console [ttyVDP0] enabled
printk: console [ttyED0] enabled
Calibrating delay loop... 0.72 BogoMIPS (lpj=5984)
pid_max: default: 4096 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
VFS: Finished mounting rootfs on nullfs
everdrive fifo thread started
Memory: 2532K/4096K available (1002K kernel code, 54K rwdata, 108K rodata, 72K init, 39K bss, 1368K reserved, 0K cma-reserved)
devtmpfs: initialized
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 31854341414376613 ns
clocksource: Switched to clocksource everdrive-timer
workingset: timestamp_bits=30 (anon: 26) max_order=10 bucket_order=0 (anon: 0)
status 0xa500
status 0xa500
status 0xa500
everdrive-blk everdrive-blk@0: Everdrive blk created for m68k.erofs, size is 90112
erofs (device edblk): mounted with root inode @ nid 36.
VFS: Mounted root (erofs filesystem) readonly on device 259:0.
devtmpfs: mounted
VFS: Pivoted into new rootfs
Freeing unused kernel image (initmem) memory: 72K
This architecture does not have kernel memory protection.
Run /sbin/init as init process
smolutils init (Jun 20 2026, 22:01:47)
cmdline args:
smolinit.getty=/dev/ttyED0
Will start getty on TTY /dev/ttyED0
smolinit.getty=/dev/ttyVDP0
Will start getty on TTY /dev/ttyVDP0
smolinit.hostname=md
Hostname will be md
environment variables
HOME=/
TERM=linux
mounting filesystems...
mounted sysfs(sysfs) on /sys
mounted proc(proc) on /proc
mounted tmp(tmpfs) on /tmp
mounted run(tmpfs) on /run
Starting getty on /dev/ttyED0 with shell /bin/smolsh
Starting getty on /dev/ttyVDP0 with shell /bin/smolsh
smolsh / > ls -l
random: crng init done
dr-xr-xr-x     2      root      root        447 bin
drwxr-xr-x     2      root      root          0 dev
dr-xr-xr-x    61      root      root          0 proc
drwxr-xr-x     2      root      root          0 run
dr-x------     2      root      root        112 sbin
dr-xr-xr-x    11      root      root          0 sys
drwxr-xr-x     2      root      root          0 tmp
smolsh / > ps
USER            PID             CMD
root            1               init
root            2               kthreadd
root            3               pool_workqueue_release
root            4               kworker/R-slub_flushwq
root            5               kworker/0:0-events
root            8               kworker/R-mm_percpu_wq
root            9               everdrive_fifo
root            10              ksoftirqd/0
root            11              pr/ttyED0
root            12              pr/ttyVDP0
root            13              kworker/0:1
root            14              kdevtmpfs
root            15              kworker/R-writeback
root            16              kworker/R-kblockd
root            17              kswapd0
root            18              kworker/u5:0
root            19              kworker/u4:1-ttyED-ttyED
root            20              kworker/u4:2-ttyED-ttyED
root            21              kworker/0:1H-kblockd
root            24              getty
root            25              getty
root            26              smolsh
root            27              smolsh
root            29              kworker/u4:3-ttyED-ttyED
root            30              ps
root            31              kworker/0:0H
root            32              kworker/u4:0-ttyED-ttyED
smolsh / >
```

Loading and decompressing the kernel will take some time. Wait!

Not that is insanely slow right now. A 12MHz 68000 system I have is way more usable that the megadrive
is right now. This needs a bit of optimization. Interacting with the EverDrive fifo is pretty slow.

## But what's the point if its just over serial anyone can do that?

![vdpconsole](vdpconsole.png)

Prize for someone that can workout a nice 32x32 16 colour tux or logo to go where the blue box is.
