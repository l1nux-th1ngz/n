#!/bin/bash

# Update package list and upgrade any existing packages
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y xorg xbacklight xbindkeys xvkbd xinput xorg-dev
sudo apt install -y python3-pip 

# Install base packages and tools
sudo apt-get -y install i3 nemo geany xdg-user-dirs xdg-user-dirs-gtk
xdg-user-dirs-gtk-update
xdg-user-dirs-update

sudo apt-get install -y \
  smartmontools lm-sensors htop p7zip p7zip-full zip unzip \
  xserver-xorg-core efibootmgr dos2unix udiskie udisks2 \
  xserver-xorg-video-nouveau xserver-xorg-video-fbdev xserver-xorg-video-vesa \
  xserver-xorg-input-evdev udiskie udisks2 dex dialog \
  x11-xserver-utils x11-xkb-utils x11-utils xinit \
  alsa-utils xterm rxvt-unicode dunst libnotify-bin inotify-tools\
  w3m mc gvfs gvfs-backends gvfs-fuse nemo geany geany-plugins scrot yad zenity \
  neofetch imagemagick kitty alacritty vlc tmux nala \
  scrot feh gnome-icon-theme gnome-themes-extra arc-theme \
  oxygen-icon-theme gtk2-engines gtk2-engines-pixbuf gtk2-engines-murrine oxygencursors \
  fonts-noto xfonts-terminus fonts-roboto fonts-oxygen \
  sox libsox-fmt-all pipewire-audio cmus moc pavucontrol \
  qbittorrent xbacklight xbindkeys xvkbd xinput build-essential git \
  policykit-1-gnome network-manager network-manager-gnome \
  file-roller lxappearance dialog mtools dosfstools avahi-daemon \
  acpi acpid gvfs-backends  pulseaudio pavucontrol pamixer python3-venv\
  pulsemixer feh fonts-recommended fonts-font-awesome fonts-terminus \
  papirus-icon-theme exa libnotify-bin xdotool unzip libnotify-dev \
  micro geany geany-plugins playerctl wmctl brightnessctl redshift curl 
# Clean up unnecessary packages
sudo clean apt autoremove -y

# Enable services
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid
