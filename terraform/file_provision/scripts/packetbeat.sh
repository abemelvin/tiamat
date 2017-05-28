#!/bin/bash

curl -XPUT 'http://10.0.0.11:9200/_template/packetbeat' -d@/etc/packetbeat/packetbeat.template.json
curl -XDELETE 'http://10.0.0.11:9200/packetbeat-*'
