#!/bin/bash

# Initiates the database if it doesn't exist yet
chown -R mysql:mysql /var/lib/mysql
mysql_install_db --datadir=/var/lib/mysql --user=mysql --skip-test-db >> /dev/null

# Initiates the database via the following script
echo "Initiating database"
mysqld --user=mysql --bootstrap --silent-startup << _EOF_
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DTBS_NAME}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER_NAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PSWD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DTBS_NAME}\`.* TO \`${MYSQL_USER_NAME}\`@'%';

ALTER USER \`root\`@\`localhost\` IDENTIFIED BY '${MYSQL_ROOT_PSWD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
_EOF_

# In the above script, the "`" indicates a mysql variable/tablename, while the "'" indicates a string

# The above script, in order:
# - Creates a user with all privileges on the database
# - Creates a root user with all privileges on all databases
# - Forces the database to update the privileges

echo "Database initiated"
exec mysqld_safe
