#!/usr/bin/env bash

sudo apt-get -y install unzip
wget https://releases.hashicorp.com/consul/0.7.5/consul_0.7.5_linux_amd64.zip
unzip consul_0.7.5_linux_amd64.zip
cp consul /usr/local/bin
