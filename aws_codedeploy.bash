#!/bin/bash
sudo apt update
sudo apt install ruby-full -y
sudo apt install wget -y
cd /home/ubuntu
#region can be changed below
wget https://aws-codedeploy-us-east-2.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
systemctl status codedeploy-agent
systemctl enable codedeploy-agent