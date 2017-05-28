#!/bin/bash

apt-get update
apt-get install -y libssl-dev

wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz

useradd nagios

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
make install-daemon-config

cp init-script.debian /etc/init.d/nrpe
chmod 755 /etc/init.d/nrpe
update-rc.d nrpe defaults 99
service nrpe start
