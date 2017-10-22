#!/bin/bash

# https://www.youtube.com/watch?v=_y1d7MC9SBc

# ========= install apache2
sudo apt-get install apache2 -y

# ========= start Apache2 web server
sudo service apache2 restart
sudo apt-get install php5 libapache2-mod-php5 php5-mysqlnd-ms -y
php -r 'echo "\n\nYour PHP installation is working fine.\n\n\n";'
