#!/bin/bash

# Get the VMware Player version and redirect stderr to /dev/null to ignore warnings
vmware_version=$(vmplayer -v 2>/dev/null | grep -oE 'VMware Player [0-9]+\.[0-9]+\.[0-9]+' | awk '{print $3}')

# Check if the version is found
if [ -z "$vmware_version" ]; then
    echo "Failed to determine the VMware Player version."
    exit 1
fi

# Download the appropriate VMware Host Modules for the detected version
wget "https://github.com/mkubecek/vmware-host-modules/archive/workstation-${vmware_version}.tar.gz"

Extract the downloaded archive
tar -xzf "workstation-${vmware_version}.tar.gz"

# Change to the extracted directory
cd "vmware-host-modules-workstation-${vmware_version}"

# Create tar archives for vmmon and vmnet
tar -cf vmmon.tar vmmon-only
tar -cf vmnet.tar vmnet-only

# Copy the tar archives to the appropriate location
cp -v vmmon.tar vmnet.tar /usr/lib/vmware/modules/source/

# Run vmware-modconfig to install the modules
vmware-modconfig --console --install-all

# Cleanup: Remove the downloaded archive and extracted directory
rm -f "workstation-${vmware_version}.tar.gz"
rm -rf "vmware-host-modules-workstation-${vmware_version}"
