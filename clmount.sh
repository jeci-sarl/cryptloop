#!/bin/bash

if [ -z "$1" ]; then
echo "Usage: bl_mount.sh <img_file> <dir>" 1>&2
exit 1
fi


source config.sh
validCryptDeviceName

IMG_FILE=$1
IMG_MOUNT_DIR=$2

LOOP_DEVICE=$(sudo losetup -f)

debug && echo "# losetup $LOOP_DEVICE $IMG_FILE "
sudo losetup $LOOP_DEVICE $IMG_FILE

debug && echo "#  cryptsetup create $DM_CRYPT_NAME_DEVICE $LOOP_DEVICE"
sudo cryptsetup -c aes create $DM_CRYPT_NAME_DEVICE $LOOP_DEVICE
fail=$?
debug && echo "crypto return val : $fail"

if [ $fail -eq 0 ]
then
	debug && echo "# mount -t ext4 $MOUNT_OPT /dev/mapper/$DM_CRYPT_NAME_DEVICE $IMG_MOUNT_DIR "
	sudo mount -t ext4 $MOUNT_OPT /dev/mapper/$DM_CRYPT_NAME_DEVICE $IMG_MOUNT_DIR
	fail=$?
	debug && echo "mount return val : $fail"
fi

## IF FAIL CLEANING
if [ $fail -ne 0 ]
then
sudo cryptsetup -c aes remove $DM_CRYPT_NAME_DEVICE 
sudo losetup -d $LOOP_DEVICE 
fi

	

