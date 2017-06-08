#!/bin/bash

curl -L -O http://download.elastic.co/beats/dashboards/beats-dashboards-1.3.1.zip
sudo apt-get install unzip -y
unzip beats-dashboards-1.3.1.zip
cd beats-dashboards-1.3.1/
./load.sh
