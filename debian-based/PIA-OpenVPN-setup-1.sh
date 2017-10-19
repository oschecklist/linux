#!/bin/bash

# ref: https://www.privateinternetaccess.com/forum/discussion/18003/openvpn-step-by-step-setups-for-various-debian-based-linux-oss-with-videos-ubuntu-mint-debian

set -o errexit   # exit on error

sudo apt-get update
sudo apt-get install network-manager-openvpn network-manager network-manager-gnome network-manager-openvpn-gnome -y # should auto install openvpn

echo "Change 'managed=false' to 'managed=true' and then your computer will be rebooted."
echo "Then continue with the 2nd script."
read -p " Press [Enter] to continue, or Ctrl+C to cancel."

sudo nano /etc/NetworkManager/NetworkManager.conf
sudo reboot
