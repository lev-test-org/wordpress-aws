#!/bin/bash
#TODO - handle region more generically
sudo apt-get update
sudo apt-get install -y apache2 apache2-utils mysql-client php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip awscli jq
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2
sudo ufw allow in "Apache"
sudo ufw status
export AWS_DEFAULT_REGION=eu-west-1
export USERNAME="$(aws secretsmanager get-secret-value --secret-id ${CURRENT_ENV}-${NAME}-rds-user |  jq -r .SecretString )"
export PASSWORD="$(aws secretsmanager get-secret-value --secret-id ${CURRENT_ENV}-${NAME}-rds-password |  jq -r .SecretString )"
cd /tmp
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo mv wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo rm /var/www/html/index.html
#TODO - replace username and password
sed -i "s/_REPLACE_DBNAME_/${DBNAME}/g" wordpress-aws/application/wp-config.php
sed -i  "s/_REPLACE_DBHOST_/${DB_HOST}/g" wordpress-aws/application/wp-config.php
sed -i  "s/_REPLACE_USERNAME_/${USERNAME}/g" wordpress-aws/application/wp-config.php
sed -i  "s/_REPLACE_PASSWORD_/${PASSWORD}/g" wordpress-aws/application/wp-config.php
cp wordpress-aws/application/wp-config.php /var/www/html/wp-config.php
cp wordpress-aws/application/wordpress.conf /etc/apache2/sites-available/wordpress.conf
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload