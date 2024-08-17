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
