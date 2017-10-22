#!/bin/bash

# hot to install wordpress... Step by Step

# https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-14-04

# Create WordPress Database,  provide the root user password, then hit Enter to move to mysql
mysql -uroot -ptoor

# At the mysql shell, type the following commands, pressing Enter after each line of a mysql command. Remember to use your own, valid values for database_name, databaseuser, and also use a strong and secure password as databaseuser_password:

# GRANT ALL PRIVILEGES ON wp_myblog.* TO 'your_username_here'@'localhost' IDENTIFIED BY 'your_chosen_password_here';
# mysql> FLUSH PRIVILEGES;
# mysql> EXIT;

CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;
FLUSH PRIVILEGES;
exit;


# ========== Install WordPress CMS ====================================================
cd ~
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo apt-get update -y

cd ~/wordpress
# Go the /var/www/html/ directory and cp existing wp-config-sample.php to wp-config.php:
sudo cp wp-config-sample.php wp-config.php
curl -s https://api.wordpress.org/secret-key/1.1/salt/

# change the detaisl to connect o db
# // ** MySQL settings - You can get this info from your web host ** //
# /** The name of the database for WordPress */
# define('DB_NAME', 'wordpress');
#
# /** MySQL database username */
# define('DB_USER', 'wordpressuser');
#
# /** MySQL database password */
# define('DB_PASSWORD', 'password');


# ========== install wp-cli =====================================
# http://wp-cli.org/
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
# check if the wp-cli is installed
# wp --info



# Then move the WordPress files from the extracted folder to the Apache default root directory, /var/www/html/:
cd ~
sudo rsync -avP wordpress/* /var/www/html/

# set the correct permissions on the website directory
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html/
sudo mkdir -P /var/www/html/wp-content/uploads
sudo chown -R www-data: /var/www/html/wp-content/uploads


touch /var/www/html/.htaccess
sudo chown www-data: /var/www/html/.htaccess
sudo chmod 664 /var/www/html/.htaccess
sudo mv /var/www/html/index.html /var/www/html/index2.html





# then update it with your database information under the MySQL settings section (refer to the highlighted boxes in the image below

# // ** MySQL settings - You can get this info from your web host ** //
# /** The name of the database for WordPress */
# define('DB_NAME', 'database_name_here');
# /** MySQL database username */
# define('DB_USER', 'username_here');
# /** MySQL database password */
# define('DB_PASSWORD', 'password_here');
# /** MySQL hostname */
# define('DB_HOST', 'localhost');
# /** Database Charset to use in creating database tables. */
# define('DB_CHARSET', 'utf8');
# /** The Database Collate type. Don't change this if in doubt. */
# define('DB_COLLATE', '');







# ==============================================================
