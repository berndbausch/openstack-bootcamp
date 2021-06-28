source ~/demorc.sh
openstack network create hadron-net 
openstack subnet create hadron-subnet --network hadron-net --subnet-range 10.0.0.0/24
openstack router create hadron-router 
openstack router set hadron-router --external-gateway public1
openstack router add subnet hadron-router hadron-subnet

