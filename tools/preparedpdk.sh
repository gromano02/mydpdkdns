#!/bin/bash

dev=$1

# Check if device is provided
if [ -z "$dev" ]; then
    echo "Usage: $0 <device>"
    exit 1
fi

bind_nic() {
    ifconfig $dev down
    ${RTE_SDK}/usertools/dpdk-devbind.py --bind=igb_uio $dev
}

# Insert Module
modprobe uio

# Insert igb_uio
lsmod | grep igb_uio >& /dev/null
if [ $? -ne 0 ]; then
    insmod ${RTE_SDK}/${RTE_TARGET}/kmod/igb_uio.ko
fi

# Insert rte_kni
lsmod | grep rte_kni >& /dev/null
if [ $? -ne 0 ]; then
    insmod ${RTE_SDK}/${RTE_TARGET}/kmod/rte_kni.ko kthread_mode=multiple
fi

# Create and mount hugepages directory
if [ ! -d /mnt/huge ]; then
    mkdir -p /mnt/huge
fi

mount -t hugetlbfs nodev /mnt/huge

# Set the number of hugepages
echo 1024 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages

# Bind the NIC
bind_nic $dev
