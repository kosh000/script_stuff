#!/bin/bash
sudo apt update
sud apt upgrade -y

wget https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh -O ubuntu-22.04-lts-vpn-server.sh
sudo chmod +x ubuntu-22.04-lts-vpn-server.sh

sudo AUTO_INSTALL=y ./ubuntu-22.04-lts-vpn-server.sh
sudo MENU_OPTION="1" CLIENT="user1" PASS="1" ./ubuntu-22.04-lts-vpn-server.sh
unset MENU_OPTION CLIENT PASS AUTO_INSTALL
echo "max-clients 2" | sudo tee -a /etc/openvpn/server.conf # change to your concurrent user you want.

sudo systemctl enable openvpn@server
sudo systemctl restart openvpn@server