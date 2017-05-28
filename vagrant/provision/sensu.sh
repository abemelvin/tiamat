#!/usr/bin/env bash

# install redis
sudo apt-get -y update
sudo apt-get -y install redis-server

echo "ULIMIT=65536" >> ~/etc/default/redis-server

# install rabbitmq
sudo wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get -y install socat erlang-nox=1:19.0-1

sudo wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.3/rabbitmq-server_3.6.3-1_all.deb
sudo dpkg -i rabbitmq-server_3.6.3-1_all.deb
sudo update-rc.d rabbitmq-server enable

sudo rabbitmqctl add_vhost /sensu
sudo rabbitmqctl add_user sensu secret
sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

echo "ulimit -n 65536" > /etc/default/rabbitmq-server

echo "{
  \"rabbitmq\": {
    \"host\": \"127.0.0.1\",
    \"port\": 5672,
    \"vhost\": \"/sensu\",
    \"user\": \"sensu\",
    \"password\": \"secret\"
  }
}
" > /etc/sensu/conf.d/rabbitmq.json

# install sensu
wget -q https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | sudo apt-key add -
export CODENAME=trusty
echo "deb     https://sensu.global.ssl.fastly.net/apt $CODENAME main" | sudo tee /etc/apt/sources.list.d/sensu.list
sudo apt-get update
sudo apt-get install sensu
