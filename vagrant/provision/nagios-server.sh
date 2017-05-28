#!/bin/bash

apt-get update
apt-get -y install build-essential apache2 apache2-utils libapache2-mod-php5 libgd2-xpm-dev libssl-dev

wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.7.tar.gz
wget http://www.nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz

useradd nagios
groupadd nagcmd
usermod -G nagcmd nagios
usermod -a -G nagcmd www-data

tar -xzf nagios-4.0.7.tar.gz
cd nagios-4.0.7
./configure --with-command-group=nagcmd --with-httpd-conf=/etc/apache2/sites-available
make all
make install
make install-init
make install-commandmode
make install-config
make install-webconf
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios
chown nagios:nagios /usr/local/nagios/etc/htpasswd.users
a2ensite nagios
a2enmod cgi

cd ..
tar -xzf nagios-plugins-2.0.3.tar.gz
cd nagios-plugins-2.0.3
./configure
make
make install

cd ..
tar -xzf nrpe-2.15.tar.gz
cd nrpe-2.15
./configure --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
make
make install

update-rc.d nagios defaults 99
service apache2 restart
service nagios start
