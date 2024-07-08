#!/bin/bash

# Initiates the database if it doesn't exist yet
chown -R mysql:mysql /var/lib/mysql
mysql_install_db --datadir=/var/lib/mysql --user=mysql --skip-test-db >> /dev/null

touch tmpfile.sql.fts
chmod 777 tmpfile.sql.fts

# Allows ( via FLUSH ) the sql tables to be updated automatically when they are modified
echo "FLUSH PRIVILEGES;" > tmpfile.sql.fts
# Creates the initial database, since it doesn't exist yet
echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DTBS_NAME}\`;" >> tmpfile.sql.fts

# Adds an admin user on 127.0.0.1
echo "CREATE USER IF NOT EXISTS \`${MYSQL_USER_NAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PSWD}';" >> tmpfile.sql.fts
echo "GRANT ALL PRIVILEGES ON \`${MYSQL_DTBS_NAME}\`.* TO \`${MYSQL_USER_NAME}\`@'%';" >> tmpfile.sql.fts

# Adds a root user on 127.0.0.1 to allow remote connexion
echo "ALTER USER \`root\`@\`localhost\` IDENTIFIED BY '${MYSQL_ROOT_PSWD}';" >> tmpfile.sql.fts
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;" >> tmpfile.sql.fts

echo "FLUSH PRIVILEGES;" >> tmpfile.sql.fts

# The above script needs the two types of "'", because reasons

# Initiates the database via the above script
mysqld --user=mysql --bootstrap < tmpfile.sql.fts

rm -rf tmpfile.sql.fts

echo "Database initiated"

exec mysqld_safe

echo "Database launched"

# WIP