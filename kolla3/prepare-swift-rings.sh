#!/bin/bash
######################################################################
#         This script generates Swift rings on the Kolla deployer
######################################################################

KOLLA_SWIFT_BASE_IMAGE="kolla/ubuntu-source-swift-base:4.0.0"
sudo mkdir -p /etc/kolla/config/swift

##### 2- use swift-ring-builder in Docker image to create builder files
# https://docs.openstack.org/swift/latest/deployment_guide.html:
# swift-ring-builder <builder_file> create <part_power> <replicas> <min_part_hours>
# <min_part_hours> is the time in hours before a specific partition can be moved

for ring in object account container
do
  sudo docker run --rm -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
                  $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder \
                  /etc/kolla/config/swift/${ring}.builder create 10 3 1
done
	  
##### 3- add the filesystems to the rings
# swift-ring-builder <builder_file> add r<region>z<zone>-<ip>:<port>/<device_name>_<meta> <weight>
# It seems that labels are accepted as device names. Below: Labels d0, d1 and d2.

STORAGE_NODES=(192.168.122.201 192.168.122.202 192.168.122.203)

for node in ${STORAGE_NODES[@]}
do 
   for disk in {0..2}
   do 
      sudo docker run --rm -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
      $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder                                \
      /etc/kolla/config/swift/object.builder add r1z1-${node}:6000/d${disk} 1

      sudo docker run --rm -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
      $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder                                \
      /etc/kolla/config/swift/account.builder add r1z1-${node}:6001/d${disk} 1

      sudo docker run --rm -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
      $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder                                \
      /etc/kolla/config/swift/container.builder add r1z1-${node}:6002/d${disk} 1
   done
done

##### 4- rebalance
for ring in object account container 
do sudo docker run --rm -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
                   $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder                \
                   /etc/kolla/config/swift/${ring}.builder rebalance
done

##### 5- output result

for ring in object account container 
do sudo docker run --rm -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ kolla/ubuntu-source-swift-base:4.0.0 swift-ring-builder /etc/kolla/config/swift/$ring.builder
done
