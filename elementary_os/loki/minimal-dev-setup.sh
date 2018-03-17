#!/bin/bash

ROCKSVER=2.4.3

set -o errexit   # exit on error

# install apps I want
sudo apt-get update
sudo apt-get install software-properties-common -y              # Allows installing PPAs

echo "(If a PPA fails to add, just re-run the script.)"
sudo add-apt-repository ppa:philip.scott/elementary-tweaks -y   # Elementary OS Tweaks
sudo add-apt-repository ppa:bartbes/love-stable -y              # LOVE game engine
sudo apt-get update
sudo apt-get install snapd ncdu htop screen tree transmission libreoffice gimp gnome-system-monitor rar unrar dconf-editor gparted elementary-tweaks ffmpeg love audacity fsarchiver virtualbox -y
sudo snap install keepassxc telegram-desktop slack
# gnome-software removed due to missing appstream package

# LuaRocks is special
# using env variable defined at top!
sudo apt-get install lua5.1 liblua5.1-0-dev -y
wget https://luarocks.github.io/luarocks/releases/luarocks-$ROCKSVER.tar.gz
tar xvf luarocks-$ROCKSVER.tar.gz
cd luarocks-$ROCKSVER
./configure
make build
sudo make install
sudo luarocks install moonscript
sudo luarocks install busted
sudo luarocks install ldoc 1.4.4-1   # I'm using a specific version because of an issue with generating docs for Pop.Box in newer versions
cd ..

# going HOME for next few items
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
git clone https://github.com/serialhex/nano-highlight.git .nano --depth=1
echo "set autoindent
set constantshow # show where we are always
set morespace    # use the extra empty space at top below title
set mouse
set nowrap       # stops auto-wrapping
set positionlog  # remembers where cursor was in previously opened files
set smarthome    # 'home' key goes to start of non-whitespace
set smooth       # smooth scrolling instead of paging
set tabsize 4
set tabstospaces

# use all default syntax highlighting
include \"/usr/share/nano/*.nanorc\"

# use all syntax highlighting from https://github.com/serialhex/nano-highlight
include \"~/.nano/*.nanorc\"" >> ~/.nanorc

# let's go back to continue
cd $CURDIR

# Google Chrome, Atom, KeyBase, TeamViewer, Discord! :D
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget https://github.com/atom/atom/releases/download/v1.9.2/atom-amd64.deb
curl -O https://prerelease.keybase.io/keybase_amd64.deb
wget https://download.teamviewer.com/download/teamviewer_i386.deb
#wget https://discordapp.com/api/download?platform=linux&format=deb
set +e   # ignore errors when unpacking deb's without their dependencies
sudo dpkg -i google-chrome*.deb
sudo dpkg -i atom*.deb
sudo dpkg -i keybase_amd64.deb
sudo dpkg -i teamviewer*.deb
#sudo dpkg -i discord*.deb
set -e   # and turn stopping on error back on
sudo apt-get -f install -y   # then fix the errors

run_keybase

# uninstall apps I don't want
sudo apt-get purge epiphany-browser -y

# make sure everything is upgraded, and autoremove unused packages
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# a little extra cleanup
rm -rf luarocks*
rm -rf ./*.deb

# make sure we don't die from low power
gsettings set org.gnome.settings-daemon.plugins.power percentage-action 6       # when to hibernate
gsettings set org.gnome.settings-daemon.plugins.power percentage-critical 9     # when to warn of hibernation
gsettings set org.gnome.settings-daemon.plugins.power percentage-low 15         # when to warn of low power
# (note: using percent instead of time was because Freya was incredibly terrible at estimating time remaining
#        on my laptop, this issue may have been resolved (issue still exists on Loki))
gsettings set org.gnome.settings-daemon.plugins.power use-time-for-policy false # don't use time remaining !

# Telegram
wget https://telegram.org/dl/desktop/linux

# configure git
git config --global user.name "Paul Liverman III"
git config --global user.email "paul.liverman.iii@gmail.com"
git config --global push.default simple
git config --global core.editor nano

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
