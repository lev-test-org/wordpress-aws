#!/bin/bash
export DBNAME="${dbname}"
export DB_HOST="${db_host}"
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y apache2 apache2-utils mysql-client php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2
sudo ufw allow in "Apache"
sudo ufw status
cd /tmp
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo mv wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo rm /var/www/html/index.html
#TODO - replace username and password
cp wordpress-aws/application/wp-config.php /var/www/html/wp-config.php
cp wordpress-aws/application/wordpress.conf /etc/apache2/sites-available/wordpress.conf
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload