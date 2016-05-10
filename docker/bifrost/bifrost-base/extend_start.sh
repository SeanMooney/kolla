#!/bin/bash

if [[ ! -d "/var/log/kolla/bifrost" ]]; then
    mkdir -p /var/log/kolla/bifrost
fi
if [[ $(stat -c %a /var/log/kolla/bifrost) != "755" ]]; then
    chmod 755 /var/log/kolla/bifrost
fi

source /usr/local/bin/kolla_bifrost_extend_start
