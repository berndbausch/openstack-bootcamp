#!/bin/bash
######################################################################
#   This script creates Swift's XFS filesystems on the controllers
######################################################################

##### Create partitions on three disks, put XFS filesystems on them

FORCE=""
if [[ $1 = "-f" ]]
then FORCE="-f"
fi

index=0
for i in b c d
do 
    [ ! -e /dev/sd${i}1 ] && sudo parted -s /dev/sd$i mklabel gpt mkpart KOLLA_SWIFT_DATA 1 100%
    sleep 1     # settle
    sudo mkfs -t xfs $FORCE -L d${index} /dev/sd${i}1
    ((index++))
done
