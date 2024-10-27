#!/bin/bash

dev=$1

record_eth() {
    inetinfo=$(ifconfig $dev | grep -w inet)
    macinfo=$(ifconfig $dev | grep ether)

    ipaddr=$(echo $inetinfo | awk '/inet/{print $2}')
    netmask=$(echo $inetinfo | awk '/inet/{print $4}')
    mac=$(echo $macinfo | awk '/ether/{print $2}')
    gateway=$(route -n | awk '/UG/{print $2}')

    basepath=$(cd `dirname $0`; pwd)
    nicinfo="$basepath/ethinfo"
    rm -f $nicinfo

    if [ -z "$ipaddr" ] || [ -z "$netmask" ] || [ -z "$mac" ] || [ -z "$gateway" ]; then
        echo "Get Eth Info Failed" && exit 1
    fi

    echo -e "DEV=$dev\nIPADDR=$ipaddr\nNETMASK=$netmask\nMAC=$mac\nGATEWAY=$gateway" > $nicinfo
}

# Check if a device name was provided
if [ -z "$dev" ]; then
    echo "Usage: $0 <network_device>"
    exit 1
fi

record_eth $dev
