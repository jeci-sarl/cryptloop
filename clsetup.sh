#!/bin/bash

if [ -z "$1" ]; then
echo "Usage: bl_setup.sh <img_file>" 1>&2
exit 1
fi


source config.sh
IMG_FILE=$1


echo "# Size off disk ? (in MB)"
read size
#dd if=/dev/zero of=$IMG_FILE bs=1M count=$size
dd of=$IMG_FILE bs=1M count=0 seek=$size

LOOP_DEVICE=$(sudo losetup -f)
debug && echo "# losetup $LOOP_DEVICE $IMG_FILE"
sudo losetup $LOOP_DEVICE $IMG_FILE

debug && echo "# cryptsetup -c aes --verify-passphrase create $DM_CRYPT_NAME_DEVICE $LOOP_DEVICE"
sudo cryptsetup -c aes --verify-passphrase create $DM_CRYPT_NAME_DEVICE $LOOP_DEVICE
sudo cryptsetup status $DM_CRYPT_NAME_DEVICE

# force the allocation of data blocks http://wiki.centos.org/HowTos/EncryptedFilesystem
#sudo dd if=/dev/zero of=/dev/mapper/$DM_CRYPT_NAME_DEVICE

debug && echo "# mkfs.ext4 /dev/mapper/$DM_CRYPT_NAME_DEVICE"
sudo mkfs.ext4 /dev/mapper/$DM_CRYPT_NAME_DEVICE
sudo tune2fs -l /dev/mapper/$DM_CRYPT_NAME_DEVICE


TMP_DIR=/tmp/btrfloop$LOOP_DEVICE
mkdir -p $TMP_DIR
sudo mount -t ext4 /dev/mapper/$DM_CRYPT_NAME_DEVICE $TMP_DIR

sudo touch $TMP_DIR/remove_me
debug && echo "sudo chown $(whoami) $TMP_DIR"
sudo chown -R $(whoami) $TMP_DIR
sudo umount $TMP_DIR
rm -r $TMP_DIR

debug && echo "# Remove Crypt Device"
sudo cryptsetup remove $DM_CRYPT_NAME_DEVICE
debug && echo "# delete loop device"
sudo losetup -d $LOOP_DEVICE 

