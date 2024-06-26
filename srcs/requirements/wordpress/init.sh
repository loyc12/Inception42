#!/bin/sh

# Creates the needed directory
if [ ! -d /run/php ]
then

	service php7.3-fpm start
	service php7.3-fpm stop

fi

# Checks if wp-config.php exists, else downloads wordpress
if [ -f /var/www/html/wp-config.php ]
then
	echo "Wordpress already downloaded; skipping installation"
else

	# downloads wordpress and its config file
	wp core download --allow-root --path=/var/www/html
	wp config create --allow-root --dbname="${MYSQL_DTBS_NAME}" --dbuser="${MYSQL_USER_NAME}" --dbpass="${MYSQL_PSWD}" --dbhost=mariadb:3306
	wp core install --allow-root --url="${DOMAIN_NAME}" --title="${WP_TITLE}" --admin_name="${WP_ADMIN_NAME}" --admin_password="${WP_ADMIN_PSWD}" --skip-email
	wp user create --allow-root "${WP_USER_NAME}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PSWD}" --role=author
fi

# Launches PHP-FPM in the forground and not as a daemon
# This means that the process will not be detached from the terminal
/usr/sbin/php-fpm7.3 -F

f