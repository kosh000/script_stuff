#!/bin/bash

# Master/Server

# Install Ansible
sudo apt update
sudo apt-get update -y
sudo apt-get install python3 -y
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Version Output of Ansible
ansible --version

# Create Ansible User
sudo adduser --quiet --disabled-password --gecos "" ansible && \echo "ansible:ansible" | sudo chpasswd

# Generate SSH Keys NO PROMPT
sudo -u ansible ssh-keygen -q -t rsa -N '' -f /home/ansible/.ssh/id_rsa <<< y >/dev/null 2>&1

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

# Master/Server
echo "" | sudo tee /etc/ansible/ansible.cfg

echo "[defaults]" | sudo tee -a /etc/ansible/ansible.cfg
echo "host_key_checking = False" | sudo tee -a /etc/ansible/ansible.cfg
echo "pipelining = true" | sudo tee -a /etc/ansible/ansible.cfg

# Create the file with the correct user and permissions
sudo -u ansible touch /home/ansible/handshake.yml
sudo chmod 777 /home/ansible/handshake.yml

# Use 'sudo tee' to write to the file with elevated permissions
sudo tee /home/ansible/handshake.yml > /dev/null << EOT
# ansible-playbook --ask-vault-pass ansible_handshake.yml
---
#Play 1
- name: Add SSH key to authorized_keys
  hosts: handshake
  vars_files:
  - /home/ansible/my_passwords.yml
  become: yes
  gather_facts: no
  tasks:
    - name: Add SSH public key to remote host
      authorized_key:
        user: ansible
        exclusive: true
        key: "{{ lookup('file', '/home/ansible/.ssh/id_rsa.pub') }}"
 
- name: Remove known_hosts from LOCAL
  hosts: localhost
  vars_files:
  - /home/ansible/my_passwords.yml
  become: yes
  gather_facts: no
  tasks:
    - name: Removing known_hosts from ansible.mgmt for ansible
      ansible.builtin.file:
        path: /home/ansible/.ssh/known_hosts
        state: absent
 
- name: Create known_hosts
  hosts: localhost
  vars_files:
  - /home/ansible/my_passwords.yml
  become: yes
  gather_facts: no
  tasks:
    - name: Ensure the file exists
      ansible.builtin.file:
        path: /home/ansible/.ssh/known_hosts
        state: touch  # Use 'touch' state to create an empty file
        owner: ansible
        group: ansible
        mode: "0644"
 
- name: Running key scan
  hosts: localhost
  vars_files:
  - /home/ansible/my_passwords.yml
  become: yes
  gather_facts: no
  tasks:
    - name: Running ssh-keyscan
      shell: ssh-keyscan "{{ item }}" >> /home/ansible/.ssh/known_hosts
      loop: "{{ query('inventory_hostnames', 'handshake') }}"

- name: Change Password for Ansible User
  hosts: all
  become: yes
  vars_files:
    - /home/ansible/my_passwords.yml
  tasks:
    - name: Change pass for anisble
      ansible.builtin.user:
        name: "ansible"
        password: "{{ ansible_pass|password_hash('sha512') }}"
 
# ansible-playbook --ask-vault-pass ansible_handshake.yml

- name: Turn off PasswordAuthentication
  hosts: all
  become: yes
  tasks:
    - name: Running Shell
      ansible.builtin.shell: |
       sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
       sudo systemctl restart ssh

EOT


sudo -u ansible touch /home/ansible/my_passwords.yml
sudo chmod 777 /home/ansible/my_passwords.yml
sudo tee /home/ansible/my_passwords.yml > /dev/null << EOT
---
ansible_ssh_pass: ansible

ansible_pass: "password1"
EOT