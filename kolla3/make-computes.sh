if [[ $# != 1 ]]
then
    echo need machine number and nothing else
    exit 1
else
    NUM=$1
fi

[ ! -f c$NUM.qcow2 ] && sudo qemu-img create -f qcow2 -b ubuntu-base.qcow2 -F qcow2 c$NUM.qcow2  

sudo virt-install --noautoconsole --cpu host --name c$NUM --ram $((12*1024)) --vcpus 3 \
                  --graphics vnc,listen=0.0.0.0,port=593$1  \
                  --network network=default --network network=provider \
                  --import                                     \
                  --disk c$NUM.qcow2,bus=scsi                   
