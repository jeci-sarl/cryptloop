#!/bin/bash

if [ -z "$1" ]; then
echo "Usage: bl_mount.sh <img_file> <dir>" 1>&2
exit 1
fi


source config.sh

IMG_FILE=$1
IMG_MOUNT_DIR=$2

LOOP_DEVICE=$(sudo losetup -f)

#echo "# losetup $LOOP_DEVICE $IMG_FILE "
sudo losetup $LOOP_DEVICE $IMG_FILE

#echo "#  cryptsetup create $DM_CRYPT_NAME_DEVICE $LOOP_DEVICE"
sudo cryptsetup create $DM_CRYPT_NAME_DEVICE $LOOP_DEVICE

#echo "# mount -t ext4 $BTRFS_OPT /dev/mapper/$DM_CRYPT_NAME_DEVICE $IMG_MOUNT_DIR "
sudo mount -t ext4 /dev/mapper/$DM_CRYPT_NAME_DEVICE $IMG_MOUNT_DIR


