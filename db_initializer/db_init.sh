#!/bin/bash
echo "variables"
env
echo "changing dir"
cd /tmp
echo "$PWD"
echo "running /usr/local/bin/wp core download"
/usr/local/bin/wp core download
echo "running /usr/local/bin/wp config create --path=. --dbname=${DBNAME} --dbuser=${DBUSER} --dbpass=${DBPASS} --dbhost=${DBHOST} --skip-check"
/usr/local/bin/wp config create --path=. --dbname=${DBNAME} --dbuser=${DBUSER} --dbpass=${DBPASS} --dbhost=${DBHOST} --skip-check
echo "running /usr/local/bin/wp core install --url=https://${DOMAIN} --title=${DOMAIN} --admin_user=${DBUSER} --admin_password=${DBPASS} --dbhost=${DBHOST} --skip-email"
/usr/local/bin/wp core install --debug --url="https://${DOMAIN}" --title="${DOMAIN}" --admin_user="${DBUSER}" --admin_password="${DBPASS}" --admin_email="admin@${DOMAIN}" --skip-email