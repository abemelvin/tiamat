#!/usr/bin/env bash

sudo apt-get -y upgrade
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get -y update
sudo apt-get -y install ansible
sudo mv file_provision/hosts /etc/ansible/hosts
sudo mv file_provision/ansible.cfg /etc/ansible/ansible.cfg
sudo mv file_provision/key key
sudo mv file_provision/install install
sudo mv file_provision/scripts scripts
ansible-playbook install/elk.yml