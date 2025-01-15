#!/bin/bash
sudo apt update
sudo apt install ruby-full -y
sudo apt install wget -y
cd /home/ubuntu
#region can be changed below
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl status codedeploy-agent
sudo systemctl enable codedeploy-agent