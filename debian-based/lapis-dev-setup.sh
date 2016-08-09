#!/bin/bash

set -o errexit   # exit on error

RESTYVER=1.9.7.5   # CHECK FOR NEW VERSION AT http://openresty.org/en/download.html
ROCKSVER=2.3.0     # CHECK FOR NEW VERSION AT http://keplerproject.github.io/luarocks/releases/

echo "Please check for new versions of OpenResty and LuaRocks first!"
read -p " Press [Enter] to continue, or Ctrl+C to cancel."

sudo apt-get update
sudo apt-get install nginx lua5.1 liblua5.1-0-dev zip unzip libreadline-dev libncurses5-dev libpcre3-dev openssl libssl-dev perl make build-essential postgresql -y
# OpenResty
wget https://openresty.org/download/openresty-$RESTYVER.tar.gz   # Install a later version if available!
tar xvf openresty-$RESTYVER.tar.gz
cd openresty-$RESTYVER
./configure
make
sudo make install
cd ..
# LuaRocks
wget https://keplerproject.github.io/luarocks/releases/luarocks-$ROCKSVER.tar.gz # Install a later version if available!
tar xvf luarocks-$ROCKSVER.tar.gz
cd luarocks-$ROCKSVER
./configure
make build
sudo make install
# some rocks
sudo luarocks install lapis
sudo luarocks install moonscript
sudo luarocks install bcrypt
sudo luarocks install luacrypto
sudo luarocks install busted
sudo luarocks install ldoc
# cleanup
cd ..
rm -rf openresty*
rm -rf luarocks*
# and let's get this ready
openssl dhparam -out dhparams.pem 2048
