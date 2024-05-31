#!/bin/sh

mysql_install_db
/etc/init.d/mysql start

# checks if the database exists

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]
then
	echo "Database already exists"
else

# forces us to connect with the root password

mysql_secure_installation << _EOF_

Y
root4life
root4life
Y
n
Y
Y
_EOF_

# Add a root user on 127.0.0.1 to allow remote connexion
# Flush privileges allow to your sql tables to be updated automatically when you modify it
# mysql -uroot launch mysql command line client
echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PSWD'; FLUSH PRIVILEGES;" | mysql -uroot

echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$USER_NAME'@'%' IDENTIFIED BY '$MYSQL_PSWD'; FLUSH PRIVILEGES;" | mysql -u root

#Import database in the mysql command line
mysql -uroot -p$MYSQL_ROOT_PSWD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql

fi

/etc/init.d/mysql stop

exec "$@"

# WIP