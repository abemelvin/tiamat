MYSQL_ROOT=root
MYSQL_PASS=root
DB_NAME=payment_db
export MYSQL_ROOT ; export MYSQL_PASS ; export DB_NAME


# allow ssh connection
sudo ufw allow ssh

sudo apt-get update -y

echo "MySQL installation starts!"
sudo apt-get install -y mysql-server 

sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server

echo "create a payment database demo..."
sudo mysql -u "$MYSQL_ROOT" -p"$MYSQL_PASS"  -e "create database $DB_NAME"
sudo mysql -u "$MYSQL_ROOT" -p"$MYSQL_PASS" "$DB_NAME" < /media/windows-share/terraform/ansible/payment-server/create_table.sql
