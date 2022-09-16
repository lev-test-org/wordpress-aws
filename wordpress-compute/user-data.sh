#!/bin/bash
export DBNAME="${dbname}"
export DB_HOST="${db_host}"
export ENV="${env}"
cd /tmp
git clone https://github.com/lev-test-org/wordpress-aws.git
cd wordpress-aws
git checkout "${ENV}"
cd /tmp
bash /tmp/wordpress-aws/application/init.sh