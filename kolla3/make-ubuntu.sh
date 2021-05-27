virt-install --cpu host --name ubuntu --ram $((8*1024)) --vcpus 2 --graphics vnc,listen=0.0.0.0  \
             --network network=default --network network=provider    \
             --cdrom /home/nobleprog/ubuntu-20.04.2-live-server-amd64.iso \
             --disk ubuntu-base.qcow2,size=50,bus=scsi
