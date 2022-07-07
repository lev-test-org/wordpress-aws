FROM wordpress:cli

WORKDIR /var/www/html

ADD db_init.sh .

ENTRYPOINT ["/bin/bash","db_init.sh"]