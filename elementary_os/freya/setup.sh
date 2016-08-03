#!/bin/bash

set -o errexit   # exit on error

# install apps I want
sudo add-apt-repository ppa:webupd8team/java
sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next
sudo add-apt-repository ppa:obsproject/obs-studio
sudo add-apt-repository ppa:bartbes/love-stable
sudo apt-get update
sudo apt-get install keepass2 git ncdu htop redshift virtualbox oracle-java8-installer steam ffmpeg obs-studio love screen nano wget curl -y # should already be there: screen, nano, wget, curl

# Dropbox is special
git clone https://github.com/zant95/elementary-dropbox/
cd elementary-dropbox
bash ./install.sh #TODO figure out if this needs to be launched in a screen
cd ..

# LuaRocks is also special
#TODO write commands to install it here! make sure required dependencies are here! (zip and unzip, build essentials, liblua and lua and all that stuff! openssl and libopenssl I think are required for OpenResty only, but idk for sure, test in a VM!)
VER=2.3.0
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

# uninstall apps I don't want
sudo apt-get purge midori-granite -y

# make sure everything is upgraded, and autoremove unused packages
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# configure git
git config --global user.name "Paul Liverman III"
git config --global user.email "paul.liverman.iii@gmail.com"
git config --global push.default simple

# set up SSH key for GitHub
ssh-keygen -t rsa -b 4096 -C "paul.liverman.iii@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# THINGS TO GET:
#  Atom https://atom.io/
#  Google Chrome https://google.com/chrome
#  Slack https://slack.com/
