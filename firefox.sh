#!/bin/bash

# Download the Mozilla GPG key
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | gpg --dearmor | sudo tee /usr/share/keyrings/packages.mozilla.org.gpg > /dev/null

# Verify the fingerprint of the GPG key
gpg --quiet --no-default-keyring --keyring /usr/share/keyrings/packages.mozilla.org.gpg --fingerprint | awk '/pub/{getline; gsub(/^ +| +$/,""); print "\n"$0"\n"}'

# Add the Mozilla repository to sources.list.d
echo "deb [signed-by=/usr/share/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

# Update package lists
sudo apt update

# Install Firefox
sudo apt-get -y install firefox
