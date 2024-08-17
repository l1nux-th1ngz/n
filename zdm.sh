#!/bin/bash

# Update the package list
sudo apt-get update

# Install LightDM and greeters
sudo apt-get -y install lightdm lightdm-gtk-greeter slick-greeter

# Set Slick Greeter as the default greeter
sudo bash -c 'echo "[Seat:*]" > /etc/lightdm/lightdm.conf'
sudo bash -c 'echo "greeter-session=slick-greeter" >> /etc/lightdm/lightdm.conf'

# Restart LightDM to apply changes
sudo systemctl restart lightdm

echo "Installation complete and Slick Greeter set as default."

sudo apt-get update

sudo apt-get upgrade
