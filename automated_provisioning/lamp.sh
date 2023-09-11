#!/bin/bash

DATABASE_PASS='7Gi10Dvkfgul,cnjf'
sudo apt update -y
sudo apt install mysql-server -y

# starting & enabling mysql-server
sudo systemctl service mysql start
sudo systemctl service mysql enable 

# Secure MySQL installation (use expect to automate input)
sudo apt-get install -y expect

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"\r\"

expect \"Set root password?\"
send \"Y\r\"

expect \"New password:\"
send \"7Gi10Dvkfgul,cnjf\r\"

expect \"Re-enter new password:\"
send \"7Gi10Dvkfgul,cnjf\r\"

expect \"Remove anonymous users?\"
send \"Y\r\"

expect \"Disallow root login remotely?\"
send \"Y\r\"

expect \"Remove test database and access to it?\"
send \"Y\r\"

expect \"Reload privilege tables now?\"
send \"Y\r\"
expect eof
")

echo "$SECURE_MYSQL"

# Initialize MySQL with a default user and password or Create a new MySQL user and set privileges
sudo mysql -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database rosedatabaseaccount"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on rosedatabaseaccount.* TO 'adminrose'@'localhost' identified by '7Gi10Dvkfgul,cnjf'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restart mysql-server
sudo systemctl service mysql restart 
echo "MySQL has been secured and a default user 'myuser' has been created."

# Installing PHP

sudo apt install php libapache2-mod-php
sudo apt install php-mysql
sudo systemctl start php
sudo systemctl enable php 

# Test PHP functionality
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/phpinfo.php

echo "PHP and Apache installed. You can test PHP functionality by accessing http://server_ip/phpinfo.php in a browser."

# installing apache
sudo apt update
sudo apt install -y apache2 apache2-utils
sudo ufw allow http

#starting apache web server
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl restart apache2