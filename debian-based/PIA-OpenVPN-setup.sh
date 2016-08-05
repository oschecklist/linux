#!/bin/bash
#TODO check this script actually works

# ref: https://www.privateinternetaccess.com/forum/discussion/18003/openvpn-step-by-step-setups-for-various-debian-based-linux-oss-with-videos-ubuntu-mint-debian

set -o errexit   # exit on error

sudo apt-get update
sudo apt-get install network-manager-openvpn -y # should auto install openvpn

mkdir ./PIA-VPNs
cd ./PIA-VPNs
wget http://www.privateinternetaccess.com/openvpn/openvpn.zip
unzip openvpn.zip

echo "From here, use the Network Manager, edit connections -> new -> import VPN"
echo "Remove :1198 from Gateway (if present). Enter username/password from PIA."
echo "Advanced... -> custom gateway port: 1198. Security tab ->"
echo "Cipher: AES-128-CBC. HMAC Auth: SHA-1. Click OK. Click Save."
