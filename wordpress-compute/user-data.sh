#!/bin/bash
export DBNAME="${dbname}"
export DB_HOST="${db_host}"
export CURRENT_ENV="${current_env}"
cd /tmp
git clone https://github.com/lev-test-org/wordpress-aws.git
cd wordpress-aws
git checkout "${CURRENT_ENV}"
cd /tmp
bash /tmp/wordpress-aws/application/init.sh