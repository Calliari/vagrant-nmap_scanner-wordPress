#!/bin/bash
# ============================================================
# Install jave 8 with python
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk
sudo apt-get update -y

# Install jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install -y jenkins

sleep 10
# get the jenkins Administrator password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
