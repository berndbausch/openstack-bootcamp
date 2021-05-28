if [[ $# != 1 ]]
then
    echo need machine number and nothing else
    exit 1
else
    NUM=$1
fi

[ ! -f d$NUM.qcow2 ] && sudo qemu-img create -f qcow2 -b devstack-base.qcow2 -F qcow2 d$NUM.qcow2  

sudo virt-install --noautoconsole --cpu host --name d$NUM --ram $((12*1024)) --vcpus 3 \
                  --graphics vnc,listen=0.0.0.0,port=592$1  \
                  --network network=default --network network=provider    \
                  --import                                     \
                  --disk d$NUM.qcow2,bus=scsi                   
