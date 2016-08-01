#!/bin/bash

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
echo "Starting dropboxd! Use the link provided to connect to Dropbox, then Ctrl+C!"
./.dropbox-dist/dropboxd
echo "Okay! Now creating and starting the service!"
echo "[Unit]
Description=Dropbox as a daemon

[Service]
ExecStart=$(pwd)/.dropbox-dist/dropboxd

[Install]
WantedBy=multi-user.target" > dropbox.service
sudo cp ./dropbox.service /etc/systemd/system/dropbox.service
sudo systemctl daemon-reload
sudo systemctl enable dropbox.service
service dropbox start
echo "Done."
