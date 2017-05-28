#!/usr/bin/env bash

PASSWORD='12345678'
DOMAIN="fazio.com"
DATABASE="mailserver"
DB_USER="mailuser"
DB_USER_PASS="mailuserpass"
EMAIL1="contractor@$DOMAIN"
EMAIL2="blackhat@$DOMAIN"

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install build-essential

# install mysql and give password to installer
sudo echo installing mysql-server...
# sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
# sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

sudo echo installing postfix...
sudo debconf-set-selections <<< "postfix postfix/mailname string $DOMAIN"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get -y install postfix
sudo apt-get -y install postfix-mysql

sudo echo installing dovecot...
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install dovecot-core
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install dovecot-imapd
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install dovecot-pop3d
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install dovecot-lmtpd
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install dovecot-mysql

bootstrapdb(){
  cat <<EOF | mysql

    CREATE DATABASE IF NOT EXISTS $DATABASE;

    GRANT SELECT ON $DATABASE.* TO '$DB_USER'@'127.0.0.1' IDENTIFIED BY '$DB_USER_PASS';

    FLUSH PRIVILEGES;

    USE $DATABASE;

    CREATE TABLE IF NOT EXISTS virtual_domains (
      id INT NOT NULL AUTO_INCREMENT,
      name VARCHAR(50) NOT NULL,
      PRIMARY KEY (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    CREATE TABLE IF NOT EXISTS virtual_users (
      id INT NOT NULL AUTO_INCREMENT,
      domain_id INT NOT NULL,
      password VARCHAR(106) NOT NULL,
      email VARCHAR(120) NOT NULL,
      PRIMARY KEY (id),
      UNIQUE KEY email (email),
      FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
    ) ENGINE=InnoDB default charset=UTF8;

    CREATE TABLE IF NOT EXISTS virtual_aliases (
      id INT NOT NULL AUTO_INCREMENT,
      domain_id INT NOT NULL,
      source VARCHAR(100) NOT NULL,
      destination VARCHAR(100) NOT NULL,
      PRIMARY KEY (id),
      FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    INSERT INTO $DATABASE.virtual_domains
    (id, name)
    VALUES
    ('1', '$DOMAIN');

    INSERT INTO $DATABASE.virtual_users
    (id, domain_id, password, email)
    VALUES
    ('1', '1', ENCRYPT('$PASSWORD', CONCAT('\$6\$', SUBSTRING(SHA(RAND()), -16))), '$EMAIL1'),
    ('2', '1', ENCRYPT('$PASSWORD', CONCAT('\$6\$', SUBSTRING(SHA(RAND()), -16))), '$EMAIL2');

EOF
}
bootstrapdb

# configure postfix
postconf smtpd_recipient_restrictions="permit_sasl_authenticated, permit_mynetworks, reject_unauth_destination"
postconf smtpd_sasl_auth_enable=yes
postconf smtpd_sasl_path=private/auth
postconf smtpd_sasl_type=dovecot
postconf myorigin=fazio.com
postconf mydestination=mail,localhost.fazio.com,fazio.com
postconf mynetworks=127.0.0.0/8,192.168.30.0/24
postconf myhostname=mail
postconf virtual_transport=lmtp:unix:private/dovecot-lmtp
postconf virtual_mailbox_domains=mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf
postconf virtual_mailbox_maps=mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf
postconf virtual_alias_maps=mysql:/etc/postfix/mysql-virtual-alias-maps.cf

IFS=""

echo "user = $DB_USER
password = $DB_USER_PASS
hosts = 127.0.0.1
dbname = $DATABASE
query = SELECT 1 FROM virtual_domains WHERE name='%s'" > /etc/postfix/mysql-virtual-mailbox-domains.cf

service postfix restart

# test if postfix can find the domain
status='postmap -q $DOMAIN mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf'
if [ $status -ne 1 ]; then
  echo "virtual domains config failed"
fi

echo "user = $DB_USER
password = $DB_USER_PASS
hosts = 127.0.0.1
dbname = $DATABASE
query = SELECT 1 FROM virtual_users WHERE email='%s'" > /etc/postfix/mysql-virtual-mailbox-maps.cf

service postfix restart

# test if postfix can find the email addresses
status='postmap -q $EMAIL1 mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf'
if [ $status -ne 1 ]; then
  echo "virtual users config failed"
fi

echo "user = $DB_USER
password = $DB_USER_PASS
hosts = 127.0.0.1
dbname = $DATABASE
query = SELECT destination FROM virtual_aliases WHERE source='%s'" > /etc/postfix/mysql-virtual-alias-maps.cf

service postfix restart

postconf -M submission/inet="submission       inet       n       -       -       -       -       smtpd"
postconf -P submission/inet/syslog_name=postfix/submission
postconf -P submission/inet/smtpd_tls_security_level=may
postconf -P submission/inet/smtpd_sasl_auth_enable=yes
postconf -P submission/inet/smtpd_client_restrictions=permit_sasl_authenticated,reject

service postfix restart
echo postfix was successfully configured

# configure dovecot
cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.orig
cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.orig
cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.orig
cp /etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext.orig
cp /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
cp /etc/dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf.orig

sed -i '/\!include conf\.d\/\*\.conf/s/^#//' /etc/dovecot/dovecot.conf
status='grep "protocols = imap lmtp" /etc/dovecot/dovecot.conf'
if [ -z $status ]; then
  echo "protocols = imap lmtp pop3" >> /etc/dovecot/dovecot.conf
fi

sed -i '/^mail_location =.*/s/^/#/g' /etc/dovecot/conf.d/10-mail.conf
echo "mail_location = maildir:/var/mail/vhosts/%d/%n" >> /etc/dovecot/conf.d/10-mail.conf

sed -i '/^mail_privileged_group =.*/s/^/#/g' /etc/dovecot/conf.d/10-mail.conf
echo "mail_privileged_group = mail" >> /etc/dovecot/conf.d/10-mail.conf

mkdir -p /var/mail/vhosts/"$DOMAIN"
groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /var/mail
chown -R vmail:vmail /var/mail

sed -i '/^auth_mechanisms =.*/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
echo "auth_mechanisms = plain login" >> /etc/dovecot/conf.d/10-auth.conf

sed -i '/\!include auth-system\.conf\.ext/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf

sed -i '/\!include auth-sql\.conf\.ext/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf

if [[ ! -f /etc/dovecot/conf.d/auth-sql.conf.ext.orig ]]; then
  mv /etc/dovecot/conf.d/auth-sql.conf.ext /etc/dovecot/conf.d/auth-sql.conf.ext.orig
fi

auth10="
passdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
  driver = static
  args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n
}
"

echo $auth10 > /etc/dovecot/conf.d/auth-sql.conf.ext

sed -i '/^driver =.*/s/^/#/g' /etc/dovecot/dovecot-sql.conf.ext
echo "driver = mysql" >> /etc/dovecot/dovecot-sql.conf.ext

sed -i '/^connect =.*/s/^/#/g' /etc/dovecot/dovecot-sql.conf.ext
echo "connect = host=127.0.0.1 dbname=$DATABASE user=$DB_USER password=$DB_USER_PASS" >> /etc/dovecot/dovecot-sql.conf.ext

sed -i '/^default_pass_scheme =.*/s/^/#/g' /etc/dovecot/dovecot-sql.conf.ext
echo "default_pass_scheme = SHA512-CRYPT" >> /etc/dovecot/dovecot-sql.conf.ext

sed -i '/^password_query =.*/s/^/#/g' /etc/dovecot/dovecot-sql.conf.ext
echo "password_query = SELECT email as user, password FROM virtual_users WHERE email='%u';" >> /etc/dovecot/dovecot-sql.conf.ext

chown -R vmail:dovecot /etc/dovecot
chmod -R o-rwx /etc/dovecot

if [[ ! -f /etc/dovecot/conf.d/10-master.conf.orig ]]; then
  mv /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
fi

dovecotmaster="service imap-login {
  inet_listener imap {
    port = 0
  }
  inet_listener imaps {
    #port = 993
    #ssl = yes
  }
}
service pop3-login {
  inet_listener pop3 {
    #port = 110
  }
  inet_listener pop3s {
    #port = 995
    #ssl = yes
  }
}
service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
    mode = 0600
    user = postfix
    group = postfix
  }
}
service imap {
}
service pop3 {
}
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0666
    user = postfix
    group = postfix
  }
  unix_listener auth-userdb {
    mode = 0600
    user = vmail
    #group =
  }
  user = dovecot
}
service auth-worker {
  user = vmail
}
service dict {
  unix_listener dict {
  }
}"

echo $dovecotmaster > /etc/dovecot/conf.d/10-master.conf
service dovecot restart
service postfix restart
echo mail server is ready
unset $IFS

sudo apt-get -y install mailutils

# set the nameserver
sudo echo setting the nameserver...
sudo echo nameserver 192.168.30.5 > /etc/resolv.conf

echo root: root@mail.fazio.com >> /etc/aliases
echo vagrant: vagrant@mail.fazio.com >> /etc/aliases
newaliases
service postfix restart
