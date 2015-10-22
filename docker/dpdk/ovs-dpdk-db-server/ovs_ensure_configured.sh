#!/bin/bash

bridge=$1
port=$2
datapath='netdev'

ovs-vsctl br-exists $bridge; rc=$?
if [[ $rc == 2 ]]; then
    changed=changed
    ovs-vsctl --no-wait add-br $bridge -- set bridge $bridge "datapath_type=$datapath"
fi

if [[ ! $(ovs-vsctl list-ports $bridge) =~ "dpdk0" ]]; then
    changed=changed
    ovs-vsctl --no-wait --may-exist add-port $bridge dpdk0 -- set Interface dpdk0 type=dpdk
else
    ovs-vsctl --no-wait del-port dpdk0
    ovs-vsctl --no-wait --may-exist add-port $bridge dpdk0 -- set Interface dpdk0 type=dpdk
fi

pci_address=$(ls -al /sys/class/net/$port | grep pci | awk '{print $NF;}' | awk '{n=split($0,a,"/");print a[n-2] }')
${OVS_DPDK_DIR}/tools/dpdk_nic_bind.py -b igb_uio $pci_address

echo $changed
