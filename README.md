Tools to unpack and repack the Hiby R3 firmware
===============================================
This was build for the Hiby R3 Pro and R3 Pro Saber DAPs. I've only got the R3 Pro to test but Hiby provide the same updates
for both. The general procedure should work with most Hiby-backed players (Shanling, Hidizs....) but I haven't verified anything.

To use:
* Follow the instructions in unpack.md to extract the firmware
* Put the contents of the filesystem in the firmware-1.7-custom folder (or modify the script to point to your modified filesystem)
* Put the contents of the original update package in a customfw folder

Make modifications to the filesystem folder. The included patch.sh file is my modifications, with regular UTF-8 sort
order. It works on the hiby_player binary directly.

Run build_image.sh . This will overwrite the SYSTEM.UBI in the customfw folder.

Run build_update.sh . This will rewrite the checksum in the customfw folder then use the contents to build the .upt 
firmware file the player expects.

Write the resulting file to r3pro.upt on the player and execute a firmware update.


If you're using Windows, track down a copy of the Shanling theme editor. It has the tools to unpack repack the images.
