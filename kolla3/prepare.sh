#!/bin/bash
set -e
#################################################################
#       Installs software on a virgin Ubuntu 20
#       Probably needs to run on the deployer only
#################################################################

sudo apt update
sudo apt install python3-dev libffi-dev gcc libssl-dev -y
sudo apt install qemu-utils virtinst virt-manager git cloud-image-utils docker.io curl -y
sudo usermod -a -G libvirt $USER
sudo usermod -a -G kvm $USER

[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -f ~/.ssh/id_ed25519 -t ed25519 -C "$USER@labserver" -N ""

# make venv
#
sudo apt install python3-venv -y
python3 -m venv ~/venv

source ~/venv/bin/activate
echo source ~/venv/bin/activate >> ~/.bashrc

# update pip and install requirements
#
pip install -U pip
pip install -r $(dirname "$0")/requirements.txt

# install and configure Kolla-Ansible
sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla
cp -r ~/venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
cp $(dirname "$0")/globals.yml /etc/kolla
ln -s $(dirname "$0")/multi-compute ./multi-compute

# Ansible config
#
sudo mkdir -p /etc/ansible
cat <<EOF | sudo tee /etc/ansible/ansible.cfg
[defaults]
host_key_checking=False
pipelining=True
forks=100
log_path=/home/$USER/ansible.log
EOF

# create passwords in /etc/kolla/passwords.yml
#
[ ! -f /etc/kolla/passwords.yml ] && kolla-genpwd

