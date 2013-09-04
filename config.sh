#!/bin/bash
#MOUNT_OPT="-o noatime,nodiratime,nodev,exec,nosuid,compress=lzo"

## NOT FOR EXT4
# MOUNT_OPT="-o noatime,nodiratime,nodev,exec,nosuid,umask=0022,gid=$(id -g),uid=$(id -u)"
##
MOUNT_OPT="-o noatime,nodiratime,nodev,exec,nosuid"


DM_CRYPT_NAME_DEVICE=dsk1

DEBUG=true
function debug { if [ "true" != "$DEBUG" ]; then return 1; fi }

