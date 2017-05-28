#!/usr/bin/env bash

apt-get update
apt-get -y install build-essential

echo 1 > /proc/sys/net/ipv4/ip_forward
