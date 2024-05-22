#!/bin/bash

# SLAVE

# Install Ansible
sudo apt update
sudo apt-get update -y
sudo apt-get install python3 -y
sudo apt install software-properties-common

# Create Ansible User
sudo adduser --quiet --disabled-password --gecos "" ansible && \echo "ansible:ansible" | sudo chpasswd

# Configure for SSH Handshake
echo "" | sudo tee /etc/ssh/sshd_config
echo "KbdInteractiveAuthentication no" | sudo tee -a /etc/ssh/sshd_config
echo "UsePAM yes" | sudo tee -a /etc/ssh/sshd_config
echo "X11Forwarding yes" | sudo tee -a /etc/ssh/sshd_config
echo "PrintMotd no" | sudo tee -a /etc/ssh/sshd_config
echo "AcceptEnv LANG LC_*" | sudo tee -a /etc/ssh/sshd_config
echo "Subsystem       sftp    /usr/lib/openssh/sftp-server" | sudo tee -a /etc/ssh/sshd_config
echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config

echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo systemctl restart ssh

# SLAVE
