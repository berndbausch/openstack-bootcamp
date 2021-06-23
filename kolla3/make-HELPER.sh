

make_cloud_init_seed(){
  # creates $NAME-cloud_init_seed.iso
  
  local NAME=$1
  local HOST_IP=$2

  IID=$(uuidgen)

  cat >$NAME-meta-data <<EOF
local-hostname: $NAME
instance-id: $IID
EOF

  cat >$NAME-network_config_static.cfg <<EOF
version: 2
ethernets:
  ens3:
    dhcp4: false
    # default libvirt network
    addresses: [ 192.168.122.$HOST_IP/24 ]
    gateway4: 192.168.122.1
    nameservers:
      addresses: [ 192.168.122.1 ]
      search: []
  ens4:
    addresses: []
  ens5:
    addresses: [ 192.168.200.$HOST_IP/24 ]
EOF


  cat >$NAME-cloud_init.cfg <<EOF
#cloud-config
users:
  - name: $USER
    ssh-authorized-keys:
      - $PUB_KEY
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
chpasswd:
  list: |
     $USER:pw
  expire: False

runcmd:
  - echo "AllowUsers $USER" >> /etc/ssh/sshd_config
  - restart ssh

package_update: true
packages:
  - qemu-guest-agent
EOF

  cloud-localds -v --network-config=$NAME-network_config_static.cfg $NAME-cloud_init_seed.iso $NAME-cloud_init.cfg $NAME-meta-data
  rm $NAME-network_config_static.cfg $NAME-cloud_init.cfg $NAME-meta-data
}

