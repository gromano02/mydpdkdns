#!/bin/bash

# Variables
DPDK_VERSION="17.02.1"
DPDK_TAR="dpdk-$DPDK_VERSION.tar.xz"
DPDK_URL="http://dpdk.org/releases/$DPDK_TAR"
DPDK_DIR="/root/dpdk"
ETH_INTERFACE="eth0"
IPADDR="192.168.44.129"
NETMASK="255.255.255.0"
MAC="08:00:27:cf:bb:76"
GATEWAY="192.168.44.2"

# Install Dependencies
echo "Updating package list and installing dependencies..."
apt-get update
apt-get install -y build-essential linux-headers-$(uname -r) git

# Download and Install DPDK
echo "Downloading DPDK from $DPDK_URL..."
wget $DPDK_URL -P /root
echo "Extracting DPDK..."
tar xf /root/$DPDK_TAR -C /root
mv /root/dpdk-$DPDK_VERSION $DPDK_DIR
cd $DPDK_DIR

echo "Configuring DPDK..."
make config T=x86_64-native-linuxapp-gcc
make
make install T=x86_64-native-linuxapp-gcc

# Set Environment Variables
echo "Setting environment variables..."
echo "export RTE_SDK=$DPDK_DIR" >> ~/.bashrc
echo "export RTE_TARGET=x86_64-native-linuxapp-gcc" >> ~/.bashrc
source ~/.bashrc

# Clone mydpdkdns repository
echo "Cloning mydpdkdns repository..."
git clone https://github.com/alandtsang/mydpdkdns.git /root/mydpdkdns

# Create ethinfo file
echo "Creating ethinfo file..."
cat <<EOF > /root/mydpdkdns/tools/ethinfo
DEV=$ETH_INTERFACE
IPADDR=$IPADDR
NETMASK=$NETMASK
MAC=$MAC
GATEWAY=$GATEWAY
EOF

# Insert modules and prepare DPDK
echo "Preparing DPDK..."
cd /root/mydpdkdns/tools
./preparedpdk.sh $ETH_INTERFACE

# Start the DPDK DNS Server
echo "Starting the DNS server..."
./start.sh

# Configure the IP and MAC addresses
echo "Configuring network interface..."
./upeth.sh

# Output instructions for testing
echo "Setup complete. You can now test the DNS server."
echo "To stop the server, run: ./stop.sh"
echo "To monitor traffic, run: ./monitor.sh"
echo "To test the DNS server, use the following command:"
echo "dig @$IPADDR www.baidu.com +subnet=1.2.3.4"