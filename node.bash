#!/bin/bash

# Update package lists
sudo apt-get update
sudo apt install nodejs npm -y
wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh && sudo bash install.sh && bash install.sh
sudo groupadd pm2
sudo usermod -aG pm2 ubuntu
sudo usermod -aG pm2 root
sudo apt update && sudo apt install sudo curl && curl -sL https://raw.githubusercontent.com/Unitech/pm2/master/packager/setup.deb.sh | sudo -E bash -