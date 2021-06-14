#!/bin/bash
set -e

virsh net-define $(dirname "$0")/lbmgmt.xml
virsh net-autostart lbmgmt
virsh net-start lbmgmt

virsh net-define $(dirname "$0")/provider.xml
virsh net-autostart provider
virsh net-start provider
