#!/bin/bash
cd /var/www/html
/usr/local/bin/wp core download
/usr/local/bin/wp config create --path=. --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASS --dbhost=$DBHOST --skip-check
/usr/local/bin/wp core install --url="https://$DOMAIN" --title="$DOMAIN" --admin_user=$DBUSER --admin_password=$DBPASS --dbhost=$DBHOST --skip-email