#!/bin/bash
set -e

source $(dirname "$0")/make-CONSTANTS.sh
source $(dirname "$0")/make-HELPER.sh

if [[ $# != 1 ]]
then
    echo need machine number and nothing else
    exit 1
else
    NUM=$1
fi

pushd $IMAGES_AND_ISOS

make_cloud_init_seed elastic $((200 + $NUM))
[ ! -f elastic.qcow2 ] && sudo qemu-img create -f qcow2 -o backing_file=$BASE_IMAGE -F qcow2 ./elastic.qcow2 50G

sudo virt-install --noautoconsole --cpu host --name elastic --ram 8192 --vcpus 2 \
                  --graphics vnc,listen=0.0.0.0,port=591$NUM  \
                  --virt-type kvm --os-type Linux --os-variant $OS_VARIANT \
                  --network network=default --network network=provider --network network=lbmgmt \
                  --import                                     \
                  --disk ./elastic.qcow2,bus=scsi                   \
                  --disk path=./elastic-cloud_init_seed.iso,device=cdrom \

popd

