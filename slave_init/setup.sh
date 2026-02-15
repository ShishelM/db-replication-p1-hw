#!/bin/bash
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CHANGE MASTER TO
        MASTER_HOST='mysql-master',
        MASTER_USER='${MYSQL_REPL_USER}',
        MASTER_PASSWORD='${MYSQL_REPL_PASSWORD}',
        SOURCE_SSL=1;
    START REPLICA;
EOSQL