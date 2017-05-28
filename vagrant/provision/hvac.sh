#!/usr/bin/env bash

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install build-essential
sudo apt-get -y install xfce4

sudo echo nameserver 192.168.30.5 > /etc/resolv.conf
