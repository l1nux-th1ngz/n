#!/bin/bash

# Update package list and upgrade any existing packages
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y xorg xbacklight xbindkeys xvkbd xinput xorg-dev
sudo apt install -y python3-pip curl wget

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

# Function to check if a user exists
user_exists() {
  id "$1" &>/dev/null
}

# Get the current logged-in user
CURRENT_USER=$(whoami)

# Install LightDM and greeters
sudo apt-get install -y lightdm lightdm-gtk-greeter slick-greeter

# Set Slick Greeter as the default greeter
sudo bash -c 'echo "[Seat:*]" > /etc/lightdm/lightdm.conf'
sudo bash -c 'echo "greeter-session=slick-greeter" >> /etc/lightdm/lightdm.conf'

# Restart LightDM to apply changes
sudo systemctl restart lightdm

# Ensure the current user exists and create if not
if ! user_exists "$CURRENT_USER"; then
  echo "User $CURRENT_USER does not exist. Creating the user..."
  sudo adduser --disabled-password --gecos "" "$CURRENT_USER"
fi

# Extract current autologin users to a temporary file
grep -n 'autologin-user=' /etc/lightdm/lightdm.conf | grep -v "autologin-user-timeout=.*" | grep -v "#" | cut -d'=' -f2 > /tmp/autologinlist.txt

# Function to list current autologin usernames
userslist() {
  yad --text-info < /tmp/autologinlist.txt --fore=#4BEA80 \
    --geometry=260x100-885+230 --borders=8 \
    --title="Autologin User" \
    --fontname="JetBrains Mono Light 11" \
    --button=" Exit!gtk-delete:1" \
    --window-icon="user-info"
}

export -f "userslist"

# If there are existing autologin users, show them in a yad dialog
if [[ $(wc -l </tmp/autologinlist.txt) -ge 1 ]]; then
  bash -c "userslist" &
fi

# Get the list of usernames from /etc/passwd
ret=($(cut -d: -f1,3 /etc/passwd | grep -E ':[0-9]{4}$' | cut -d: -f1))

# Adjust list for yad use
LIST=""
for p in "${ret[@]}"; do
  LIST="${LIST}FALSE $p "
done

# Show a list dialog for selecting autologin user
LOGIN=$(yad --list --center --borders=8 \
    --title="Autologin Toggle" \
    --window-icon="user-info" \
    --text="         Select User For Autologin On/Off" \
    --radiolist --geometry=314x230-860+400 \
    --column="Select" --column="Username" $LIST --separator="" \
    --button=" Cancel!gtk-cancel:1" \
    --button=" Okay!gtk-ok:0")

SELECTION=${LOGIN//"TRUE"}

# If canceled
if (( $? == 1 )); then
    exit 0
fi

# Toggle selection on/off
if grep -q "$SELECTION" /etc/lightdm/lightdm.conf; then
  pkexec sed -i '/autologin-user='"$SELECTION"'/d' /etc/lightdm/lightdm.conf
  notify-send -i "user-info" --urgency low "$SELECTION autologin entry removed"
  notify-send -i "info" --urgency low "REBOOT for changes to take effect"
else
  pkexec sh -c "sed -i '/autologin-user=.*/d' /etc/lightdm/lightdm.conf; sed -i '125aautologin-user='"$SELECTION"'' /etc/lightdm/lightdm.conf"
  notify-send -i "user-info" --urgency low "Autologin enabled for $SELECTION"
  notify-send -i "info" --urgency low "REBOOT for changes to take effect"
fi

# Clean up
rm /tmp/autologinlist.txt

# Final message
printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
