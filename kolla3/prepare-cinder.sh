#!/bin/bash
[ ! -e /dev/sde1 ] && sudo parted -s /dev/sde mklabel gpt mkpart KOLLA_CINDER_DATA 1 100%
sudo pvcreate /dev/sde1
sudo vgcreate cinder-volumes /dev/sde1
sudo vgs
