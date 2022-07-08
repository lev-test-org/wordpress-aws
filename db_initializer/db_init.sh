#!/bin/bash
cd /tmp
HEADERS="$(mktemp -p /tmp)"
EVENT_DATA=$(curl -sS -LD "$HEADERS" -X GET "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next")
echo "event data $EVENT_DATA"
REQUEST_ID=$(grep -Fi Lambda-Runtime-Aws-Request-Id "$HEADERS" | tr -d '[:space:]' | cut -d: -f2)
echo "request id $REQUEST_ID"
echo "running /usr/local/bin/wp core download"
/usr/local/bin/wp core download
echo "running wp config create"
/usr/local/bin/wp config create  --force --path=. --dbname=${DBNAME} --dbuser=${DBUSER} --dbpass=${DBPASS} --dbhost=${DBHOST} --skip-check
echo "running wp core install"
/usr/local/bin/wp core install --url="https://${DOMAIN}" --title="${DOMAIN}" --admin_user="${DBUSER}" --admin_password="${DBPASS}" --admin_email="admin@${DOMAIN}" --skip-email
if [ $? -eq 0 ]; then
  echo "running curl -X POST \"http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/$REQUEST_ID/response\"  -d \"SUCCESS\""
  curl -X POST "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/$REQUEST_ID/response"  -d "SUCCESS"
else
  echo "curl -X POST \"http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/init/error\"  -d \"FAIL\""
  curl -X POST "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/init/error"  -d "FAIL"
fi