#!/bin/bash
DOMAIN="fazio.com"

sudo apt-get -y update
sudo apt-get -y install build-essential

sudo debconf-set-selections <<< "postfix postfix/mailname string $DOMAIN"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get -y install mailutils

postconf myorigin=fazio.com
postconf mynetworks=10.0.0.0/24
service postfix restart

sudo apt-get -y install dnsmasq

cd ..
cd ..

sudo echo setting the nameserver...
sudo echo nameserver 127.0.0.1 > /etc/resolv.conf

sudo echo setting the dns listening port to 10.0.0.13...
sudo echo interface=eth1 >> /etc/dnsmasq.conf
sudo echo local=/fazio.com/ >> /etc/dnsmasq.conf
sudo echo mx-host=fazio.com,mail.fazio.com,10 >> /etc/dnsmasq.conf


sudo echo adding addresses to the hosts file...
sudo echo 10.0.0.13 localhost.fazio.com localhost > /etc/hosts
sudo echo 10.0.0.13 dns.fazio.com dns >> /etc/hosts
sudo echo 10.0.0.14 mail.fazio.com mail >> /etc/hosts
sudo echo 10.0.0.12 contractor.fazio.com hvac >> /etc/hosts

sudo echo restarting dnsmasq...
sudo /etc/init.d/dnsmasq restart
