#!/bin/bash
export DBNAME="${dbname}"
export DB_HOST="${db_host}"
cd /tmp
git clone https://github.com/lev-test-org/wordpress-aws.git
cd wordpress-aws
git checkout new_features #TODO - improve branch mechanism
cd /tmp
bash /tmp/wordpress-aws/application/init.sh
