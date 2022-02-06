#!/bin/bash

# If you want to remove the kernel section from the update it's possible, but it's really finicky about whitespace
# If the update fails, try adding or removing some blank lines to match the original file.
# Also this sed command to rewrite the update assumes the kernel section is in place

sed -i '7,$s/md5=.*/md5='"$(md5sum customfw/SYSTEM.UBI | cut -d\  -f1)/" customfw/UPDATE.TXT
genisoimage -l -o r3pro_custom.upt customfw/{SYSTEM.UBI,UBOOT.BIN,UIMAGE.BIN,UPDATE.TXT,VERSION.TXT,_GITIGNO}

