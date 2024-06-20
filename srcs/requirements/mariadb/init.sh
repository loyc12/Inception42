#!/bin/sh

mysql_install_db
/etc/init.d/mysql start

# checks if the database exists

if [ -d "/var/lib/mysql/${MYSQL_DTBS_NAME}" ]
then
	echo "Database already exists"
else

mysql_install_db --datadir=/var/lib/mysql --user="${USER_NAME}" --skip-test-db >> /dev/null

# forces us to connect with the root password
mysql_secure_installation << _EOF_

Y
"${MYSQL_ROOT_PSWD}"
"${MYSQL_ROOT_PSWD}"
Y
n
Y
Y

_EOF_

#mysqladmin --user==root password "${MYSQL_ROOT_PSWD}"

# Initiates the database via the mysql cli
mysql --user=root --bootstrap << _EOF_

# The flush allows the sql tables to be updated automatically when they are modified
echo "FLUSH PRIVILEGES;" | mysql -uroot

# Creates the initial database, since it doesn't exist yet
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DTBS_NAME" | mysql -uroot

# Adds a root user on 127.0.0.1 to allow remote connexion
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PSWD}" | mysql -uroot

# Adds an admin user on 127.0.0.1
echo "GRANT ALL PRIVILEGES ON '${MYSQL_DTBS_NAME}'.* TO '${USER_NAME}'@'%' IDENTIFIED BY '${MYSQL_PSWD}' WITH GRANT OPTION" | mysql -uroot

echo "FLUSH PRIVILEGES;" | mysql -uroot

_EOF_

fi

exec mysqld_safe

# WIP