#!/bin/bash

curl -XPUT 'http://10.0.0.11:9200/_template/metricbeat' -d@/etc/metricbeat/metricbeat.template.json
curl -XDELETE 'http://10.0.0.11:9200/metricbeat-*'

cd /usr/share/metricbeat
./scripts/import_dashboards -es http://10.0.0.11:9200
