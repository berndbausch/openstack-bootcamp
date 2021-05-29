[[ ! -f elastic.qcow2 ]] && sudo qemu-img create -f qcow2 -b ubuntu-base.qcow2 -F qcow2 elastic.qcow2
sudo virt-install --noautoconsole --cpu host --name elastic --ram 8192 --vcpus 2 \
	          --graphics vnc,listen=0.0.0.0,port=5919 --network network=default \
		  --import --disk elastic.qcow2,bus=scsi
