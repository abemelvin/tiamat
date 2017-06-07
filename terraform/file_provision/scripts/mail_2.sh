#!/bin/bash

sudo postmap /etc/postfix/virtual
sudo postfix reload
sudo dovecot reload