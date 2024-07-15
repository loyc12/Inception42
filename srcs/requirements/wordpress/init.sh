#!/bin/bash

# Creates the needed directory
if [ ! -d /run/php ]
then
	service php7.3-fpm start
	service php7.3-fpm stop
fi

# prevents worpress for overtaking the database's initilization ang getting error 2002
# for some stupid reason, "depends on" doesn't do that automatically, contrary to what you'd expect
sleep 10

# Checks if wp-config.php exists, and if so, skips the installation
if [ ! -f /var/www/html/wp-config.php ]
then

	# downloads wordpress and its config file
	wp core download --allow-root --path=/var/www/html
	wp config create --allow-root --dbname="${MYSQL_DTBS_NAME}" --dbuser="${MYSQL_USER_NAME}" --dbpass="${MYSQL_USER_PSWD}" --dbhost="${WP_DTBS_HOST}"
	wp core install --allow-root --url="${DOMAIN_NAME}" --title="${WP_TITLE}" --admin_name="${WP_ADMIN_NAME}" --admin_password="${WP_ADMIN_PSWD}" --admin_email="${WP_ADMIN_EMAIL}" --skip-email
	wp user create --allow-root "${WP_USER_NAME}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PSWD}" --role=author

	echo "Wordpress installed"
else
	echo "Wordpress already downloaded ; skipping installation"
fi

# Launches PHP-FPM in the forground and not as a daemon
# This means that the process will not be detached from the terminal
echo "PHP-FPM launching"
/usr/sbin/php-fpm7.3 -F
