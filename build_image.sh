#!/bin/bash

# Based on the ShanLing M2 theme editor
mkfs.ubifs -x lzo -d firmware-1.7-custom -e 0x1F000 -c 512 -m 0x800 -o customfw/SYSTEM.UBI
