#!/bin/bash

# Code to initiate the database if it doesn't exist yet, and give the needed perms either way
chown -R mysql:mysql /var/lib/mysql
mysql_install_db --datadir=/var/lib/mysql --user=mysql --skip-test-db >> /dev/null

touch tmpfile.sql.fuckthatshit
chmod 777 tmpfile.sql.fuckthatshit

# Allows ( via FLUSH ) the sql tables to be updated automatically when they are modified
echo "FLUSH PRIVILEGES;" > tmpfile.sql.fuckthatshit
# Creates the initial database, since it doesn't exist yet
echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DTBS_NAME}\`;" >> tmpfile.sql.fuckthatshit

# Adds an admin user on 127.0.0.1
echo "CREATE USER IF NOT EXISTS \`${MYSQL_USER_NAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PSWD}';" >> tmpfile.sql.fuckthatshit
echo "GRANT ALL PRIVILEGES ON \`${MYSQL_DTBS_NAME}\`.* TO \`${MYSQL_USER_NAME}\`@'%';" >> tmpfile.sql.fuckthatshit

# Adds a root user on 127.0.0.1 to allow remote connexion
echo "ALTER USER \`root\`@\`localhost\` IDENTIFIED BY '${MYSQL_ROOT_PSWD}';" >> tmpfile.sql.fuckthatshit
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;" >> tmpfile.sql.fuckthatshit

echo "FLUSH PRIVILEGES;" >> tmpfile.sql.fuckthatshit

# The above script needs the two types of "'", because fuck you that's why

# Initiates the database via the above script
mysqld --user=mysql --bootstrap < tmpfile.sql.fuckthatshit

rm -rf tmpfile.sql.fuckthatshit

echo DATABASE INITIATED

exec mysqld_safe

# WIP