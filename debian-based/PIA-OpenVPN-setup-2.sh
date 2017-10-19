#!/bin/bash

echo "Have you run the other script first?"
read -p " Press [Enter] to continue, or Ctrl+C to cancel."

mkdir ./PIA-VPNs
cd ./PIA-VPNs
wget http://www.privateinternetaccess.com/openvpn/openvpn.zip
unzip openvpn.zip

echo "From here, use the Network Manager, edit connections -> new -> import VPN"
echo "Remove :1198 from Gateway (if present). Enter username/password from PIA."
echo "Advanced... -> custom gateway port: 1198. Security tab ->"
echo "Cipher: AES-128-CBC. HMAC Auth: SHA-1. Click OK. Click Save."
