#!/bin/bash

if [ -z "$1" ]; then
echo "Usage: bl_umount.sh <dir>" 1>&2
exit 1
fi

source config.sh

IMG_MOUNT_DIR=$1

function searchGoodDevice {
	dev_mapper=$(mount |grep "$IMG_MOUNT_DIR" | awk '{ print $1 }')
	if [ -z $dev_mapper ]; then
		continue
	fi

	for device in $(ls /dev/mapper/)
	do
		debug && echo "cryptsetup status $device | grep \"$dev_mapper\""
		sudo cryptsetup status $device | grep "$dev_mapper"
		if [ $? -eq 0 ]
		then
			debug && echo "Found device : $device"
			DM_CRYPT_NAME_DEVICE=$device
			return 0
		fi
	done
	return 2
}

searchGoodDevice
if [ $? -ne 0 ]
then
	echo "Device Not Found"
	exit 2
fi


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



