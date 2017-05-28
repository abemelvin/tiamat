#!/usr/bin/env bash

sudo apt-get -y update
sudo apt-get -y install build-essential
sudo route add -net 192.168.60.0 netmask 255.255.255.0 gw 192.168.50.1
