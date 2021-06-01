# as demo user, timetravel project

openstack keypair create --public-key .ssh/id_rsa.pub key1
openstack security group create web
openstack security group create ssh
openstack security group create rule ssh --protocol tcp --dst-port 80
openstack security group rule create ssh --protocol tcp --dst-port 22
openstack security group rule create ssh --protocol icmp
openstack security group rule create web --protocol tcp --dst-port 80

openstack image create --file ./openstack-bootcamp/module04/Fedora-Cloud-Base-34-1.2.x86_64.qcow2 --disk-format qcow2 fedora

