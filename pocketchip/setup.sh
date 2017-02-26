#!/bin/bash

# Installs stuff I want and configure things as needed when I reflash the device.

sudo apt-get update
sudo apt-get install apt-transport-https -y

echo "deb https://o-marshmallow.github.io/PocketCHIP-pocket-home/archive/ jessie main" | sudo tee /etc/apt/sources.list.d/marshmallow-pocket-chip-home.list
sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 584F7F9F
echo -e "Package: pocket-home\nPin: version *\nPin-Priority: 1050" | sudo tee /etc/apt/preferences.d/unpin-pocket-home.pref

sudo apt-get install pocket-home openttd iceweasel -y

sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

#xmodmap ~/.Xmodmap   # this might need to be placed into a startup script of some kind to fix FN keys not functioning

# input calibration: http://www.chip-community.org/index.php/Calibrate_Touchscreen
# might be able to get away with using pocket-home's calibrator or copying config from current version

# add IceWeasel and OpenTTD to the screen with pocket-home
# todo: get icons for these!
