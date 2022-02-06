Not writing this as a script because it involves some messing around as root.

First: Grab the .upt file from Hiby
It's an iso9660 image so unpack it with something
    7z x r3pro-1.7rpt

The SYSTEM.UBI inside is the file we want.

Next: Set up your system with a fake NAND flash device to flash the UBIFS file


VERY IMPORTANT: Check if your system already has any MTD nodes before starting this - overwriting those
with the R3 firmware would be bad.
```
modprobe nandsim first_id_byte=0x2c second_id_byte=0xda \
third_id_byte=0x90 fourth_id_byte=0x95
flash_erase /dev/mtd0 0 0
ubiformat /dev/mtd0 -s 2048 -O 2048
modprobe ubi
ubiattach -m 0 -d 0 -O 2048
ubimkvol /dev/ubi0 -N hiby -m # -m = max size
ubiupdatevol /dev/ubi0_0 SYSTEM.UBI
mount /dev/ubi0_0 /mnt
```
NAND ID bytes were chosen to match the chip inside the R3 (size is wrong but it works)

The update filesystem is now mounted at /mnt. Copy it out (or don't?) and make some modifications.

