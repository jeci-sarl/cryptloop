#!/bin/bash

if [ -z "$1" ]; then
echo "Usage: bl_umount.sh <dir>" 1>&2
exit 1
fi

source config.sh
IMG_MOUNT_DIR=$1

debug && echo "#  umount $IMG_MOUNT_DIR"
sudo umount $IMG_MOUNT_DIR

debug && echo "#  cryptsetup remove $DM_CRYPT_NAME_DEVICE"

LOOP_DEVICE=$(sudo cryptsetup status $DM_CRYPT_NAME_DEVICE | grep "device:" | cut -d: -f2)
sudo cryptsetup remove $DM_CRYPT_NAME_DEVICE
if [ -z "$LOOP_DEVICE" ]; then
    echo "no loop device"
else
debug && echo "#  losetup -d $LOOP_DEVICE"
    sudo losetup -d $LOOP_DEVICE 
fi
