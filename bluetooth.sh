#!/bin/bash

echo ""
echo -e "\e[0;33mBluetooth Installer\e[0m"
echo ""

# Update package lists and install required packages
sudo apt update 

sudo apt-get install -y bluetooth bluez-tools blueman libspa-0.2-bluetooth gstreamer1.0-gl gstreamer1.0-x gstreamer1.0-plugins-bad rfkill

echo "" 
echo -e "\e[0;32mBluetooth services installed!\e[0m"
echo ""
echo -e "\e[0;33mLet's Activate The Bluetooth Devices.\e[0m"
echo ""

# Enable and start the Bluetooth service
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo -e "\e[0;32mBluetooth services activated!\e[0m"
echo -e "\e[0;32mREMINDER!!! YOU MAY NEED TO REBOOT YOUR COMPUTER FOR BLUETOOTH TO WORK!\e[0m"
echo " Finished"
