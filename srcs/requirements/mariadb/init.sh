#!/bin/sh

# Checks if the database exists
if [ -d "/var/lib/mysql/${MYSQL_DTBS_NAME}" ]
then
	echo "Database already exists"

# If it doesn't, initiates it
else

chown -R mysql:"${MYSQL_HOST_NAME}" /var/lib/mysql
mysql_install_db --datadir=/var/lib/mysql --user="${MYSQL_HOST_NAME}" --skip-test-db >> /dev/null

# Initiates the database via the mysql cli ( TODO : add --silent ) ( --bootstrap no worky ? )
mysql --user="${MYSQL_HOST_NAME}" << _EOF_

FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS "${MYSQL_DTBS_NAME}";

CREATE USER IF NOT EXISTS "${MYSQL_USER_NAME}"@'%' IDENTIFIED BY "${MYSQL_USER_PSWD}";
GRANT ALL PRIVILEGES ON "${MYSQL_DTBS_NAME}"'.*' TO "${MYSQL_USER_NAME}"@'%' WITH GRANT OPTION;

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PSWD}'
GRANT ALL PRIVILEGES ON '*.*' TO 'root'@'localhost' WITH GRANT OPTION;";

FLUSH PRIVILEGES;

_EOF_

# IDENTIFIED BY "${MYSQL_USER_PSWD}"

# What the above script does ( in order ) :

# Allows ( via FLUSH ) the sql tables to be updated automatically when they are modified
# Creates the initial database, since it doesn't exist yet
# Adds a root user on 127.0.0.1 to allow remote connexion
# Adds an admin user on 127.0.0.1

fi

exec mysqld_safe

# WIP