#!/bin/bash

ROCKSVER=2.4.3

set -o errexit   # exit on error

# install apps I want
echo "(If a PPA fails to add, just re-run the script.)"
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:webupd8team/java -y
sudo add-apt-repository ppa:philip.scott/elementary-tweaks -y
#sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next -y   # no xenial Release target ?
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo add-apt-repository ppa:bartbes/love-stable -y
sudo add-apt-repository ppa:gezakovacs/ppa -y
sudo apt-get update
sudo apt-get install keepass2 git ncdu htop redshift virtualbox steam screen nano wget curl tree transmission libreoffice gimp gnome-system-monitor rar unrar zip unzip bsdgames dconf-editor gparted kid3 elementary-tweaks oracle-java8-installer ffmpeg obs-studio love audacity unetbootin lmms fsarchiver gnome-software -y

# Dropbox is special
git clone https://github.com/zant95/elementary-dropbox.git
cd elementary-dropbox
#gsettings set org.pantheon.desktop.wingpanel use-transparency false   # temporary workaround for Loki support, see zant95/elementary-dropbox#11 for details
bash ./install.sh -y
cd ..

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

# Google Chrome, Atom, Slack, KeyBase, Discord! :D
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget https://github.com/atom/atom/releases/download/v1.9.2/atom-amd64.deb
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-2.1.0-amd64.deb
curl -O https://prerelease.keybase.io/keybase_amd64.deb
wget wget https://discordapp.com/api/download?platform=linux&format=deb
set +e   # ignore errors when unpacking deb's without their dependencies
sudo dpkg -i google-chrome*.deb
sudo dpkg -i atom*.deb
sudo dpkg -i slack-desktop*.deb
sudo dpkg -i keybase_amd64.deb
sudo dpkg -i discord*.deb
set -e   # and turn stopping on error back on
sudo apt-get -f install -y
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
rm -rf ./elementary-dropbox

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

echo "Done! :D Enjoy your Fake Mac."
echo "(You should probably reboot it!)"
