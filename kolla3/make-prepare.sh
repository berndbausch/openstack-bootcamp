#!/bin/bash
set -e

source $(dirname "$0")/make-CONSTANTS.sh

mkdir -p $IMAGES_AND_ISOS

[ ! -f $BASE_IMAGE ] && wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img -O $BASE_IMAGE
sha256sum $BASE_IMAGE
qemu-img info $BASE_IMAGE

