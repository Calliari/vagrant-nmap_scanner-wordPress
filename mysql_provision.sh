#!/bin/bash
# ========== Install MySQL Database Server ========================
# user: root
# pass: toor

# this is not working on on vagrant up
# sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password root toor'
# sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again root toor'
# sudo apt-get -y install mysql-server-5.6
# sudo mysql_secure_installation

#this works fine on vagrant
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mysql-server-5.6

# change the password
mysqladmin -u root password toor
