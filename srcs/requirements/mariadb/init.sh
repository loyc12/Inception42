#!/bin/sh

# Code to initiate the database if it doesn't exist yet, and give the needed perms either way
chown -R mysql:${MYSQL_HOST_NAME} /var/lib/mysql
mysql_install_db --datadir=/var/lib/mysql --user=${MYSQL_HOST_NAME} --skip-test-db >> /dev/null

touch tmpfile.sql.fuckthatshit
chmod 777 tmpfile.sql.fuckthatshit

# Allows ( via FLUSH ) the sql tables to be updated automatically when they are modified
echo "FLUSH PRIVILEGES;" > tmpfile.sql.fuckthatshit
# Creates the initial database, since it doesn't exist yet
echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DTBS_NAME}\`;" >> tmpfile.sql.fuckthatshit

# Adds an admin user on 127.0.0.1
echo "CREATE USER IF NOT EXISTS \`${MYSQL_USER_NAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PSWD}';" >> tmpfile.sql.fuckthatshit
echo "GRANT ALL PRIVILEGES ON \`${MYSQL_DTBS_NAME}\`.* TO \`${MYSQL_USER_NAME}\`@'%' WITH GRANT OPTION;" >> tmpfile.sql.fuckthatshit

# Adds a root user on 127.0.0.1 to allow remote connexion
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PSWD}';" >> tmpfile.sql.fuckthatshit
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;" >> tmpfile.sql.fuckthatshit

echo "FLUSH PRIVILEGES;" >> tmpfile.sql.fuckthatshit

# Initiates the database via the mysql cli ( TODO : add --silent )
# Does not work with a heredoc because of mysql's cli shitty syntax requirements or some shit like that
mysqld --user=${MYSQL_HOST_NAME} --bootstrap < tmpfile.sql.fuckthatshit

rm -rf tmpfile.sql.fuckthatshit

#mysqld --user="${MYSQL_HOST_NAME}" --bootstrap << _EOF_
#
#FLUSH PRIVILEGES
#CREATE DATABASE IF NOT EXISTS ${MYSQL_DTBS_NAME}
#
#CREATE USER IF NOT EXISTS ${MYSQL_USER_NAME}@'%' IDENTIFIED BY '${MYSQL_USER_PSWD}'
#GRANT ALL PRIVILEGES ON ${MYSQL_DTBS_NAME}.* TO ${MYSQL_USER_NAME}@'%' WITH GRANT OPTION
#
#ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PSWD}'
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION
#
#FLUSH PRIVILEGES
#
#_EOF_

#fi

exec mysqld_safe

# WIP