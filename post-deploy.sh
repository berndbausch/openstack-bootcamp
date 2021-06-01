# To be executed on the deployer k1
if [[ $(hostname) != k1 ]]
then echo please run this script on the deployer k1
     exit 1
fi

pip install python-openstackclient   # doc says "python3-openstackclient"
pip install osc-placement

kolla-ansible post-deploy            # create adminrc with correct password
. /etc/kolla/admin-openrc.sh

export KOLLA_DEBUG=1
export ENABLE_EXT_NET=1
export EXT_NET_CIDR=192.168.100.0/24
export EXT_NET_RANGE=start=192.168.100.10,end=192.168.100.50
export EXT_NET_GATEWAY=192.168.100.1

./venv/share/kolla-ansible/init-runonce

ansible -i multi-compute control -m apt -a "name=mariadb-client,libvirt-clients" --become
