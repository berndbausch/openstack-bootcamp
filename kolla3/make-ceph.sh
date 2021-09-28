if [[ $# != 1 ]]
then
    echo need machine number and nothing else
    exit 1
else
    NUM=$1
fi

[ ! -f cephroot$NUM.qcow2 ] && sudo qemu-img create -f qcow2 -b ubuntu-base.qcow2 -F qcow2 cephroot$NUM.qcow2  
[ ! -f cephdisk$NUM.qcow2 ] && sudo qemu-img create -f qcow2 cephdisk$NUM.qcow2 50G

sudo virt-install --noautoconsole --cpu host --name ceph$NUM --ram $((4*1024)) --vcpus 1 \
                  --graphics vnc,listen=0.0.0.0,port=594$1  \
                  --network network=default --network network=provider \
                  --import                                     \
                  --disk cephroot$NUM.qcow2,bus=scsi --disk cephdisk$NUM.qcow2,bus=scsi                   
