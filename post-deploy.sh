# To be executed on the deployer

pip install python-openstackclient   # doc says "python3-openstackclient"
pip install osc-placement
pip install python-heatclient

kolla-ansible post-deploy            # create adminrc with correct password
. /etc/kolla/admin-openrc.sh

export KOLLA_DEBUG=1
export ENABLE_EXT_NET=1
export EXT_NET_CIDR=192.168.100.0/24
export EXT_NET_RANGE=start=192.168.100.10,end=192.168.100.50
export EXT_NET_GATEWAY=192.168.100.1

./venv/share/kolla-ansible/init-runonce

ansible -i multi-compute control -m apt -a "name=mariadb-client" --become
ansible -i multi-compute compute -m apt -a "name=libvirt-clients" --become
