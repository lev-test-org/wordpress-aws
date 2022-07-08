#!/bin/bash
echo "changing dir"
cd /tmp
echo "$PWD"
HEADERS="$(mktemp)"
EVENT_DATA=$(curl -sS -LD "$HEADERS" -X GET "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next")
REQUEST_ID=$(grep -Fi Lambda-Runtime-Aws-Request-Id "$HEADERS" | tr -d '[:space:]' | cut -d: -f2)
echo "running /usr/local/bin/wp core download"
/usr/local/bin/wp core download
/usr/local/bin/wp config create --debug --force --path=. --dbname=${DBNAME} --dbuser=${DBUSER} --dbpass=${DBPASS} --dbhost=${DBHOST} --skip-check
/usr/local/bin/wp core install --debug --url="https://${DOMAIN}" --title="${DOMAIN}" --admin_user="${DBUSER}" --admin_password="${DBPASS}" --admin_email="admin@${DOMAIN}" --skip-email
if [ $? == 0 ]; then
  curl -X POST "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/$REQUEST_ID/response"  -d "SUCCESS"
else
  curl -X POST "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/init/error"  -d "FAIL"
fi