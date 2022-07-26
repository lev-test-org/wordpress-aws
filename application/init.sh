#!/bin/bash
#TODO - handle region more generically
export AWS_DEFAULT_REGION=eu-west-1
export DBNAME="${dbname}"
export DB_HOST="${db_host}"
export USERNAME="$(aws secretsmanager get-secret-value --secret-id lev-wordpress-rds-user)"
export PASSWORD="$(aws secretsmanager get-secret-value --secret-id lev-wordpress-rds-password)"
aws secretsmanager get-secret-value --secret-id lev-wordpress-rds-password
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y apache2 apache2-utils mysql-client php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip awscli
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
sed -i .bak "s/_REPLACE_DBNAME_/${DBNAME}/g"
sed -i .bak "s/_REPLACE_DBHOST_/${DB_HOST}/g"
sed -i .bak "s/_REPLACE_USERNAME_/${USERNAME}/g"
sed -i .bak "s/_REPLACE_PASSWORD_/${PASSWORD}/g"
cp wordpress-aws/application/wp-config.php /var/www/html/wp-config.php
cp wordpress-aws/application/wordpress.conf /etc/apache2/sites-available/wordpress.conf
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload