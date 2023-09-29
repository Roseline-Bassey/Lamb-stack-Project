#!/bin/bash

OLD_DATABASE_PASS=''
NEW_DATABASE_PASS="7Gi10Dvkfgu%,cnjf"
document_root="/var/www/html"
php_test_file="$document_root/phpinfo.php"

# Delete package expect when script is done
# 0 - No; 
# 1 - Yes.
PURGE_EXPECT_WHEN_DONE=0

# installing apache
sudo apt-get update -y
sudo apt-get install -y apache2 apache2-utils
sudo ufw allow http

#starting apache web server
sudo systemctl start apache2

#Install mysql
# sudo apt-get clean
# sudo apt-get purge mysql*
sudo apt-get install mysql-server-8.0 -y
# sudo apt-get dist-upgrade


# starting & enabling mysql-server
sudo systemctl start mysql
# sudo mysqladmin -u root -p"$DATABASE_PASS"
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$DATABASE_PASS';"

# Secure MySQL installation
sudo apt-get install -y expect

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"$OLD_DATABASE_PASS\r\"

expect \"root password?\"
send \"y\r\"

expect \"New password:\"
send \"$NEW_DATABASE_PASS\r\"

expect \"Re-enter new password:\"
send \"$NEW_DATABASE_PASS\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "${SECURE_MYSQL}"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Installing PHP
sudo apt-get install php -y 
sudo apt-get install libapache2-mod-php -y
sudo apt-get install php-mysql -y

# Starting and Enabling services
sudo systemctl restart apache2
sudo systemctl enable apache2

# Restart Apache to enable PHP
sudo a2enmod php
sudo systemctl restart apache2

# Create the PHP test file
echo "<?php phpinfo();" | sudo tee "$php_test_file" > /dev/null

# Verify that the PHP test file was created
if [ -e "$php_test_file" ]; then
  echo "PHP test file created successfully: $php_test_file"
  echo "You can access it at: http://server ip address/phpinfo.php"
else
  echo "Failed to create the PHP test file."
fi 

# Enabling php service
sudo systemctl restart mysql
sudo systemctl enable mysql 

if [ "${PURGE_EXPECT_WHEN_DONE}" -eq 1 ]; then
    # Uninstalling expect package
    aptitude -y purge expect
fi

exit 0