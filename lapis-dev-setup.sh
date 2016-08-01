#!/bin/bash

set -o errexit   # exit on error

sudo apt-get update
sudo apt-get install git nano wget curl nginx lua5.1 liblua5.1-0-dev zip unzip libreadline-dev libncurses5-dev libpcre3-dev openssl libssl-dev perl make build-essential postgresql -y
# OpenResty
wget https://openresty.org/download/openresty-1.9.7.5.tar.gz   # Install a later version if available!
tar xvf openresty-1.9.7.5.tar.gz
cd openresty-1.9.7.5
./configure
make
sudo make install
cd ..
# LuaRocks
wget https://keplerproject.github.io/luarocks/releases/luarocks-2.3.0.tar.gz # Install a later version if available!
tar xvf luarocks-2.3.0.tar.gz
cd luarocks-2.3.0
./configure
make build
sudo make install
# some rocks
sudo luarocks install lapis
sudo luarocks install moonscript
sudo luarocks install bcrypt
sudo luarocks install luacrypto
# cleanup
cd ..
rm -rf openresty*
rm -rf luarocks*
# and let's get this ready
openssl dhparam -out dhparams.pem 2048
