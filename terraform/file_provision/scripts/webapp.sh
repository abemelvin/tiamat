#!/bin/bash

sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get install -y python-pip
sudo pip install --upgrade pip
sudo pip install django==1.10

sudo apt-get install -y apache2
sudo apt-get install -y libapache2-mod-wsgi

cd ~
git clone https://github.com/abemelvin/tiamat/
mv tiamat/web-server web-server
cd ~
sudo chgrp -R www-data web-server
sudo chmod -R g+w web-server
sudo apache2ctl restart