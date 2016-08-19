#!/bin/bash

set -o errexit   # exit on error

# install apps I want
echo "(If a PPA fails to add, just re-run the script.)"
sudo add-apt-repository ppa:webupd8team/java -y
sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next -y
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo add-apt-repository ppa:bartbes/love-stable -y
sudo add-apt-repository ppa:mpstark/elementary-tweaks-daily -y
sudo apt-get update
sudo apt-get install keepass2 git ncdu htop redshift virtualbox oracle-java8-installer steam ffmpeg obs-studio love screen nano wget curl tree transmission libreoffice gimp gnome-system-monitor wondershaper rar unrar zip unzip bsdgames elementary-tweaks dconf-editor gparted -y # should already be there: nano, wget, curl, unzip

# Dropbox is special
git clone https://github.com/zant95/elementary-dropbox/
cd elementary-dropbox
bash ./install.sh
cd ..

# LuaRocks is also special
VER=2.3.0
sudo apt-get install lua5.1 liblua5.1-0-dev -y
wget https://keplerproject.github.io/luarocks/releases/luarocks-$VER.tar.gz
tar xvf luarocks-$VER.tar.gz
cd luarocks-$VER
./configure
make build
sudo make install
sudo luarocks install moonscript
sudo luarocks install busted
sudo luarocks install ldoc
cd ..

# we're going HOME for the next few items
CURDIR=$(pwd)
cd ~

# Bash should look cooler
git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1
echo "
source ~/.bash-git-prompt/gitprompt.sh
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_FETCH_REMOTE_STATUS=0
" >> ~/.bashrc

# Nano should be cooler
#   note: some features don't work on Freya :(
#git clone https://github.com/serialhex/nano-highlight.git .nano --depth=1
echo "set autoindent
#set constantshow # show where we are always
set morespace    # use the extra empty space at top below title
set mouse
set nowrap      # stops auto-wrapping
#set positionlog # remembers where cursor was in previously opened files
set smarthome   # 'home' key goes to start of non-whitespace
set smooth      # smooth scrolling instead of paging
set tabsize 4
set tabstospaces

# use all default syntax highlighting
#include \"/usr/share/nano/*.nanorc\"

# use all syntax highlighting from https://github.com/serialhex/nano-highlight
#include \"~/.nano/*.nanorc\"" >> ~/.nanorc

# let's go back to continue
cd $CURDIR

# Google Chrome, Atom, Slack! :D
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget https://github.com/atom/atom/releases/download/v1.9.2/atom-amd64.deb
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-2.1.0-amd64.deb
set +e   # ignore errors when unpacking deb's without their dependencies
sudo dpkg -i google-chrome*.deb
sudo dpkg -i atom*.deb
sudo dpkg -i slack-desktop*.deb
set -e   # and turn stopping on error back on
sudo apt-get -f install -y

# uninstall apps I don't want
sudo apt-get purge midori-granite -y

# make sure everything is upgraded, and autoremove unused packages
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# a little extra cleanup
rm -rf luarocks*
rm -rf ./*.deb
rm -rf ./elementary-dropbox

# make sure a laptop doesn't die from low power
gsettings set org.gnome.settings-daemon.plugins.power percentage-action 14      # when to hibernate
gsettings set org.gnome.settings-daemon.plugins.power percentage-critical 16    # when to warn of hibernation
gsettings set org.gnome.settings-daemon.plugins.power percentage-low 25         # when to warn of low power
gsettings set org.gnome.settings-daemon.plugins.power use-time-for-policy false # don't use time remaining !

# configure git
git config --global user.name "Paul Liverman III"
git config --global user.email "paul.liverman.iii@gmail.com"
git config --global push.default simple

# set up SSH key for GitHub
ssh-keygen -t rsa -b 4096 -C "paul.liverman.iii@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo "Your public key is in '~/.ssh/id_rsa.pub', copy it to GitHub."
read -p "Press enter to continue..."

# stop Bluetooth from starting on boot
# ref: http://elementaryos.stackexchange.com/questions/711/turn-off-bluetooth-by-default-on-start-up
echo "Opening /etc/rc.local"
echo "Put 'rfkill block bluetooth' before the exit command!"
read -p " Press [Enter] to continue"
sudo nano /etc/rc.local

echo "Done! :D Enjoy your Fake Mac."
echo "(You should probably reboot it!)"
