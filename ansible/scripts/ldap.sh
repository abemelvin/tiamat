#!/usr/bin/expect -f

spawn sudo apt-get -y update

expect "xuan"
send "Vdcn1259399#\r"

expect "$ "

spawn sudo apt-get -y install slapd ldap-utils

expect "xuan"
send "Vdcn1259399#\r"

expect "$ "

spawn sudo dpkg-reconfigure slapd

expect "xuan"
send "Vdcn1259399#\r"

expect "server configuration?"
send "\r"

expect "DNS domain name:"
unset expect_out(buffer)
send "test1.com\r"

expect "Organization name:"
send "target\r"

expect "Administrator password:"
send "root\r"

expect "Confirm password:"
send "root\r"

expect "backend to use:"
send "\r"

expect "purged?"
send "\r"

expect "Move old database?"
send "\r"

expect "protocol?"
send "\r"

expect "$ "

spawn ldapadd -x -D cn=admin,dc=test,dc=com -W -f add_content.ldif

expect "Password:"
send "root\r"

expect "$ "



# change root dn

# change logging level
# sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f logging.ldif

# should we do replication and TLS encription?

# any acess control?
