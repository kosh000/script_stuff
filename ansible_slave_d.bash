#!/bin/bash

ID=$(cat /etc/os-release | grep ID_LIKE | awk -F'=' '{gsub(/"/, "", $2); print $2}')
if [[ $ID == "debian" ]]; then
    echo "#########################################"
    echo "installing for debian - anisble slave"
    echo "#########################################"
    sudo apt update
    sudo apt-get update -y
    sudo apt-get install python3 -y
    sudo apt install software-properties-common

    # Create Ansible User
    sudo adduser --quiet --disabled-password --gecos "" ansible && \echo "ansible:ansible" | sudo chpasswd

    # file: etc/ssh/sshd_config
    echo "" | sudo tee /etc/ssh/sshd_config
    echo "KbdInteractiveAuthentication no" | sudo tee -a /etc/ssh/sshd_config
    echo "UsePAM yes" | sudo tee -a /etc/ssh/sshd_config
    echo "X11Forwarding yes" | sudo tee -a /etc/ssh/sshd_config
    echo "PrintMotd no" | sudo tee -a /etc/ssh/sshd_config
    echo "AcceptEnv LANG LC_*" | sudo tee -a /etc/ssh/sshd_config
    echo "Subsystem       sftp    /usr/lib/openssh/sftp-server" | sudo tee -a /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
    echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config

    # file: /etc/sudoers
    echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

    sudo systemctl restart ssh
elif [[ $ID == "fedora" ]]; then
    echo "#########################################"
    echo "installing for fedora - anisble slave"
    echo "#########################################"
    sudo yum update -y
    sudo yum install python3 -y

    sudo adduser ansible
    echo "ansible:ansible" | sudo chpasswd

    # file: etc/ssh/sshd_config
    echo "" | sudo tee /etc/ssh/sshd_config
    echo "KbdInteractiveAuthentication no" | sudo tee -a /etc/ssh/sshd_config
    echo "UsePAM yes" | sudo tee -a /etc/ssh/sshd_config
    echo "X11Forwarding yes" | sudo tee -a /etc/ssh/sshd_config
    echo "PrintMotd no" | sudo tee -a /etc/ssh/sshd_config
    echo "AcceptEnv LANG LC_*" | sudo tee -a /etc/ssh/sshd_config
    echo "Subsystem       sftp    /usr/lib/openssh/sftp-server" | sudo tee -a /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
    echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config

    # file: /etc/sudoers
    echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

    # Restart SSH service to apply changes
    sudo systemctl restart sshd
fi
