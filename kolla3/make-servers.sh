if [[ $# != 1 ]]
then
    echo need machine number and nothing else
    exit 1
else
    NUM=$1
fi

[ ! -f k$NUM.qcow2 ] && sudo qemu-img create -f qcow2 -b ubuntu-base.qcow2 -F qcow2 k$NUM.qcow2  

sudo virt-install --noautoconsole --cpu host --name k$NUM --ram $((12*1024)) --vcpus 3 \
                  --graphics vnc,listen=0.0.0.0,port=591$1  \
                  --network network=default --network network=provider --network network=lbmgmt \
                  --import                                     \
                  --disk k$NUM.qcow2,bus=scsi                   \
                  --disk k$NUM-swift1.qcow2,size=50,bus=scsi    \
                  --disk k$NUM-swift2.qcow2,size=50,bus=scsi    \
                  --disk k$NUM-swift3.qcow2,size=50,bus=scsi    \
                  --disk k$NUM-cinder.qcow2,size=50,bus=scsi    
