#
#  To be run on deployer
#
sudo apt install python3-dev libffi-dev gcc libssl-dev -y
# make venv
sudo apt install python3-venv -y
python3 -m venv ~/venv

echo source ~/venv/bin/activate >> .bashrc
source ~/venv/bin/activate

# update pip and install the correct version of Ansible
pip install -U pip
pip install 'ansible<2.10'

# install and configure Kolla-Ansible
pip install kolla-ansible
sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla
cp -r ~/venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
cp ~/venv/share/kolla-ansible/ansible/inventory/* .

# Ansible config
sudo mkdir /etc/ansible
cat <<EOF | sudo tee /etc/ansible/ansible.cfg
[defaults]
host_key_checking=False
pipelining=True
forks=100
log_path=/home/stack/ansible.log
EOF

# create passwords in /etc/kolla/passwords.yml
kolla-genpwd

