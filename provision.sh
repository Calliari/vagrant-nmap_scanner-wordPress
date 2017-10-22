# #!/bin/bash

# vagrant # check the vagrant CMD

# vagrant global-status # outputs status Vagrant environments for this user
# vagrant status # outputs status of the vagrant machine

# vagrant destroy -f  # destroy the VM
# vagrant up # initialize the VM
# vagrant ssh # ssh into VM

# vagrant halt # shotdown or power off the VM
# vagrant up # initialize the VM


# vagrant suspend # hibernate the VM
# vagrant resume # wake up the VM after supended

# =============================

#  Install git
sudo apt-get install -y git

# Update the souces list and upgrade
sudo apt-get -y update
sudo apt-get -y upgrade

# Install and send service email
# https://gist.github.com/codekipple/688b3f4f8ec00eb0c0c4
# sudo apt-get -y install mailutils
# sudo vi /etc/resolv.conf
# Change the nameserver IP:
# nameserver 8.8.8.8
# sudo /etc/init.d/postfix restart

# install the install's dependecies
sudo apt-get -f install -y

# ================================================
# Install Wkhtmltopdf convert HTML into PDF files
# sudo apt-get install wkhtmltopdf -y

# # If this doesn’t work (cannot connect to x server):
# sudo apt-get install xvfb
#
# sudo nano /usr/local/bin/wkhtmltopdfwrap
#
# # Add:
# # xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf "$@"
#
# sudo chmod a+x /usr/local/bin/wkhtmltopdfwrap
#
# # Now, use `wkhtmltopdfwrap` instead of the native command.

# ================================================
# sudo passwd
# echo 'root\nroot'
# exit && exit

# sudo passwd
# echo 'root\nroot'
