#!/bin/bash

sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get install -y python-pip
sudo pip install --upgrade pip
sudo pip install django==1.10

sudo apt-get install -y apache2
sudo apt-get install -y libapache2-mod-wsgi

sudo git clone https://github.com/abemelvin/tiamat/
sudo mv tiamat/web-server web-server
sudo chgrp -R www-data web-server
sudo chmod -R g+w web-server
sudo apache2ctl restart
sudo apache2ctl restart