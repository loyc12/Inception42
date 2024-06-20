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
	sed -i "s/password_here/${MYSQL_PSWD}/g" wp-config-sample.php
	sed -i "s/localhost/${MYSQL_HOST_NAME}/g" wp-config-sample.php
	sed -i "s/database_name_here/${MYSQL_DTBS_NAME}/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php

fi

# Launches PHP-FPM in the forground and not as a daemon
# This means that the process will not be detached from the terminal
# php-fpm -F -R

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
# if [[ ${WP_PSWD,,} == *${WP_ADMIN,,}* ]]; then
# 	echo "Error: Passord can't contain the username"
# 	exit 1
# fi
#
#
# if [ ! -f /var/www/html/wp-config.php ]; then
# 	wp core download --allow-root --path=/var/www/html
# 	wp config create --allow-root --dbname=$MYSQL_DTBS_NAME --dbuser=root --dbpass=$MYSQL_PSWD --dbhost=$WP_DTBS_HOST
# 	wp core install --allow-root --url="${DOMAIN_NAME}" --title="${WP_TITLE}" --admin_name="${LOGIN}_admin" --admin_password="${WP_DTBS_PSWD}" --skip-email
# 	wp user create --allow-root "${LOGIN}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PSWD}" --role=author
# fi

# WIP