#!/bin/bash

git clone --depth=1 https://github.com/mir-ror/ltunify
cd ltunify
sudo make ltunify
sudo make install-home
sudo mv ~/bin/ltunify /bin/ltunify
sudo rm -r ~/bin
cd ..
rm -rf ./ltunify
