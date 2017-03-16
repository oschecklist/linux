#!/bin/bash

git clone https://github.com/mir-ror/ltunify
cd ltunify
sudo make ltunify
sudo make install-home
sudo mv ~/bin/ltunify /bin/ltunify
rm -r ~/bin
cd ..
rm -rf ./ltunify
