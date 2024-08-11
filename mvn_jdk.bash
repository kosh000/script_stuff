#!/bin/bash

## Amazon Linux

sudo yum install -y java-1.8.0-amazon-corretto-devel.x86_64
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64
export PATH=$JAVA_HOME/bin:$PATH

wget https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
sudo tar xf apache-maven-3.6.3-bin.tar.gz -C /opt
#sudo vim ~/.bash_profile
#
sudo su - ec2-user -c "echo 'export M2_HOME=/opt/apache-maven-3.6.3' | tee -a /home/ec2-user/.bashrc >/dev/null"
sudo su - ec2-user -c "echo 'export PATH=\$PATH:/opt/apache-maven-3.6.3/bin' | tee -a /home/ec2-user/.bashrc >/dev/null"
sudo su - root -c "echo 'export M2_HOME=/opt/apache-maven-3.6.3' | tee -a /root/.bashrc >/dev/null"
sudo su - root -c "echo 'export PATH=\$PATH:/opt/apache-maven-3.6.3/bin' | tee -a /root/.bashrc >/dev/null"
#
echo "versions"
mvn -v
java -version