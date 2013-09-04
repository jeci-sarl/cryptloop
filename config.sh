#!/bin/bash
#MOUNT_OPT="-o noatime,nodiratime,nodev,exec,nosuid,owner=$(whoami),compress=lzo"
MOUNT_OPT="-o noatime,nodiratime,nodev,exec,nosuid"
DM_CRYPT_NAME_DEVICE=dsk1


DEBUG=true
function debug { if [ "true" != "$DEBUG" ]; then return 1; fi }

