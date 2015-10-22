#!/bin/bash

mkdir -p "/var/run/openvswitch"
if [[ ! -e "/etc/openvswitch/conf.db" ]]; then
    ovsdb-tool create "/etc/openvswitch/conf.db"
fi
modprobe uio
insmod $OVS_DPDK_DIR/$RTE_TARGET/kmod/igb_uio.ko

