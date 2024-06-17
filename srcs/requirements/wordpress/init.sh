#!/bin/sh

# Checks if wp-config.php exists, else downloads wordpress
if [ -f ./wp-config.php ]
then
	echo "Wordpress already downloaded; skipping installation"
else

	# downloads wordpress and its config file
	wget http://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	mv wordpress/* .
	rm -rf latest.tar.gz
	rm -rf wordpress

	# imports the .env variables
	sed -i "s/username_here/${LOGIN}/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php

fi

############################### V - WIP - V ###############################
#
# if [ ! -d /run/php ]; then
# 	service php7.4-fpm start
# 	service php7.4-fpm stop
# fi
#
#
# if [[ ${WP_ADMIN,,} == *"admin"* ]]; then
# 	echo "Error: Username can't contain the 'admin'"
# 	exit 1
# fi
#
# if [[ ${WP_PASSWORD,,} == *${WP_ADMIN,,}* ]]; then
# 	echo "Error: Passord can't contain the username"
# 	exit 1
# fi
#
#
# if [ ! -f /var/www/html/wp-config.php ]; then
# 	wp core download --allow-root --path=/var/www/html
# 	wp config create --allow-root --dbname=$MYSQL_DATABASE --dbuser=root --dbpass=$MYSQL_PASSWORD --dbhost=$WP_DB_HOST
# 	wp core install --allow-root --url="${DOMAIN_NAME}" --title="${WP_TITLE}" --admin_name="${LOGIN}_admin" --admin_password="${WP_DB_PASSWORD}" --skip-email
# 	wp user create --allow-root "${LOGIN}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PASSWORD}" --role=author
# fi

 /usr/sbin/php-fpm7.4 -F


# WIP