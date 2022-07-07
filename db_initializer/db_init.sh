#!/bin/bash
echo "changing dir"
cd /tmp
echo "$PWD"
echo "running /usr/local/bin/wp core download"
/usr/local/bin/wp core download
/usr/local/bin/wp config create --debug --force --path=. --dbname=${DBNAME} --dbuser=${DBUSER} --dbpass=${DBPASS} --dbhost=${DBHOST} --skip-check
/usr/local/bin/wp core install --debug --url="https://${DOMAIN}" --title="${DOMAIN}" --admin_user="${DBUSER}" --admin_password="${DBPASS}" --admin_email="admin@${DOMAIN}" --skip-email