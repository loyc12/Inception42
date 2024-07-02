#!/bin/sh

# Checks if the database exists
if [ -d "/var/lib/mysql/${MYSQL_DTBS_NAME}" ]
then
	echo "Database already exists : Skipping creation"

# If it doesn't, initiates it
else
chown -R mysql:"${MYSQL_HOST_NAME}" /var/lib/mysql
mysql_install_db --datadir=/var/lib/mysql --user="${MYSQL_HOST_NAME}" --skip-test-db >> /dev/null

touch tmpfile.sql.fuckthatshit
chmod 777 tmpfile.sql.fuckthatshit

echo "FLUSH PRIVILEGES;" > tmpfile.sql.fuckthatshit
echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DTBS_NAME}\`;" > tmpfile.sql.fuckthatshit

echo "CREATE USER IF NOT EXISTS \`${MYSQL_USER_NAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PSWD}';" > tmpfile.sql.fuckthatshit
echo "GRANT ALL PRIVILEGES ON \`${MYSQL_DTBS_NAME}\`'.*' TO \`${MYSQL_USER_NAME}\`@'%' WITH GRANT OPTION;" > tmpfile.sql.fuckthatshit

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PSWD}';" > tmpfile.sql.fuckthatshit
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;" > tmpfile.sql.fuckthatshit

echo "FLUSH PRIVILEGES;" > tmpfile.sql.fuckthatshit

# What the above script does ( in order ) :

# Allows ( via FLUSH ) the sql tables to be updated automatically when they are modified
# Creates the initial database, since it doesn't exist yet
# Adds a root user on 127.0.0.1 to allow remote connexion
# Adds an admin user on 127.0.0.1

# Initiates the database via the mysql cli ( TODO : add --silent )
# Does not work with a heredoc because of mysql's cli shitty syntax requirements, afaik
mysqld --user="${MYSQL_HOST_NAME}" --bootstrap < tmpfile.sql.fuckthatshit

rm -rf tmpfile.sql.fuckthatshit

#mysqld --user="${MYSQL_HOST_NAME}" --bootstrap << _EOF_
#
#FLUSH PRIVILEGES
#CREATE DATABASE IF NOT EXISTS ${MYSQL_DTBS_NAME}
#
#CREATE USER IF NOT EXISTS ${MYSQL_USER_NAME}@'%' IDENTIFIED BY '${MYSQL_USER_PSWD}'
#GRANT ALL PRIVILEGES ON ${MYSQL_DTBS_NAME}'.*' TO ${MYSQL_USER_NAME}@'%' WITH GRANT OPTION
#
#ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PSWD}'
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION
#
#FLUSH PRIVILEGES
#
#_EOF_

fi

exec mysqld_safe

# WIP