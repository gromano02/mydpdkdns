#!/bin/bash

# Update package list and install dependencies
echo "Updating package list and installing dependencies..."
apt-get update
apt-get install -y curl build-essential

# Install Homebrew
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
echo "export PATH=\"/home/linuxbrew/.linuxbrew/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc  # or ~/.profile

# Install dnspyre
echo "Tapping dnspyre repository..."
brew tap tantalor93/dnspyre

echo "Installing dnspyre..."
brew install dnspyre

DIRECTORY_NAME="my_empty_directory"
echo "Creating an empty directory named $DIRECTORY_NAME..."
mkdir -p ~/$DIRECTORY_NAME

echo "Installation complete. You can now use dnspyre."