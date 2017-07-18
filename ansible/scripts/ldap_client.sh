#!/usr/bin/expect -f

spawn sudo apt -y install libnss-ldap # fill in all configurations

#sudo dpkg-reconfigure ldap-auth-config

sudo auth-client-config -t nss -p lac_ldap

sudo pam-auth-update # choose ldap authentication in the prompt

