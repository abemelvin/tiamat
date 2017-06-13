#!/usr/bin/env bash

# Variables
APPNAME=appname
DBHOST=localhost
DBNAME=db_app
DBUSER=user1
DBPASSWD=password1

# Update the box
# --------------
# Downloads the package lists from the repositories
# and "updates" them to get information on the newest
# versions of packages and their dependencies
apt-get update
# Run upgrade with the updated packages
apt-get -y upgrade

# Install Nginx
apt-get install -y nginx

# Install PHP5-FPM
apt-get install -y php5-fpm

# Configure PHP Processor
sed -i s/\;cgi\.fix_pathinfo\s*\=\s*1/cgi.fix_pathinfo\=0/ /etc/php5/fpm/php.ini
service php5-fpm restart

# Set default Server Block
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
cp /vagrant/vagrant_env/default /etc/nginx/sites-available/default

# Create phpinfo page to test PHP Installation
echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/info.php

# Install MySQL
echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
apt-get install -y mysql-server-5.5
# Setup required database structure
mysql_install_db
# MySQL Secure Installation as defined via: mysql_secure_installation
mysql -uroot -p$DBPASSWD -e "DROP DATABASE test"
mysql -uroot -p$DBPASSWD -e "DELETE FROM mysql.user WHERE User='root' AND NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -uroot -p$DBPASSWD -e "DELETE FROM mysql.user WHERE User=''"
mysql -uroot -p$DBPASSWD -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -uroot -p$DBPASSWD -e "FLUSH PRIVILEGES"

# Install SQLite
#apt-get install -y php5-sqlite

# PHP stuff
# ---------
# Command-Line Interpreter
apt-get install -y php5-cli
# MySQL database connections directly from PHP
apt-get install -y php5-mysql
# cURL is a library for getting files from FTP, GOPHER, HTTP server
apt-get install -y php5-curl
# Module for MCrypt functions in PHP
apt-get install -y php5-mcrypt
# Enable mycrpt for PHP5
php5enmod mcrypt
# Install PHPUnit
apt-get install -y phpunit

# Install Memcached
apt-get install -y memcached
apt-get install -y php5-memcached
service php5-fpm restart
service nginx restart

# Install cURL
apt-get install -y curl

# Install Git
apt-get install -y git

# Install Composer
curl -s https://getcomposer.org/installer | php
# Make Composer available globally
mv composer.phar /usr/local/bin/composer

# Install self-signed SSL Cert
mkdir /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/cert.key -out /etc/nginx/ssl/cert.crt -subj "/C=SG/ST=Singapore/L=Singapore/O=Webmaster/OU=./CN=vagrant/emailAddress=no-reply@domain.com"

# Add Server Block for Application
cp /vagrant/vagrant_env/$APPNAME /etc/nginx/sites-available/$APPNAME
ln -s /etc/nginx/sites-available/$APPNAME /etc/nginx/sites-enabled/$APPNAME
service nginx restart

# # Install PHPMyAdmin NOT ADVISABLE FOR PRODUCTION
# echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
# apt-get install -y phpmyadmin
# # Make PHPMyAdmin available as http://localhost/phpmyadmin
# ln -s /usr/share/phpmyadmin /usr/share/nginx/html/phpmyadmin

# Laravel stuff
# -------------
# Load Composer packages
cd /var/www/$APPNAME
composer install
# Set up the database
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "GRANT ALL PRIVILEGES on $DBNAME.* to '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASSWD'"
# Run artisan migrate to setup the database and schema, then seed it
php artisan migrate --package=Cartalyst/Sentry
php artisan migrate
php artisan db:seed