#!/bin/bash

# Initiates the database if it doesn't exist yet
chown -R mysql:mysql /var/lib/mysql
mysql_install_db --datadir=/var/lib/mysql --user=mysql --skip-test-db >> /dev/null

mysqld --user=mysql --bootstrap << _EOF_
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DTBS_NAME}\`;

CREATE USER IF NOT EXISTS \`${MYSQL_USER_NAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PSWD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DTBS_NAME}\`.* TO \`${MYSQL_USER_NAME}\`@'%';

ALTER USER \`root\`@\`localhost\` IDENTIFIED BY '${MYSQL_ROOT_PSWD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
_EOF_

# PS : These two kinds of apostrophes are needed to distinguish between string literals ( '_' ) and sql identifiers ( `_` )

# The above script, in order, does the following :
# - Creates the initial database
# - Adds an admin user on it
# - Adds a root user on
# - Forces the database to update its tables

echo "Database initiated"
exec mysqld_safe