# creates projects hadron and timetravel
# creates user demo and gives it roles in those projects
# creates timetravel-net and timetravel-router

source ~/admin-openrc.sh
openstack project create hadron
openstack project create timetravel
openstack user create demo --password pw
openstack role add --user demo --project hadron reader
openstack role add --user demo --project timetravel member

openstack network create timetravel-net --project timetravel
openstack subnet create timetravel-subnet --project timetravel --network timetravel-net --subnet-range 10.0.0.0/24
openstack router create timetravel-router --project timetravel
openstack router set timetravel-router --external-gateway public1
openstack router add subnet timetravel-router timetravel-subnet


