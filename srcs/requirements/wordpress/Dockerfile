FROM debian:buster

# Installs dependencies
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install \
	wget \
	curl \
	bash \
	php \
	php-cgi \
	php-mysql \
	php-fpm \
	php-pdo \
	php-gd php-cli \
	php-mbstring \
	redis \
	php-redis

# Deletes the cache and the package lists
RUN rm -rf /var/lib/apt/lists/*

COPY www.conf /etc/php/7.3/fpm/pool.d/

# Downloads wp-cli.phar, which is the command line interface for WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Copies the .conf in the html directory
COPY ./www.conf /etc/php/7.3/fpm/pool.d/

# Creates the directory for the socket file
RUN mkdir /run/php

# Sets the port to be used by the container
EXPOSE 9000

# CD to the html directory
WORKDIR /var/www/html/

# Copies the init script, sets its permissions and makes it the entrypoint
# This means it will be executed when the container is started
COPY ./init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh
#ENTRYPOINT ["/usr/local/bin/init.sh"]

# Launches PHP-FPM in the forground and not as a daemon
# This means that the process will not be detached from the terminal
CMD ["/bin/sh/php-fpm", "-F"]

# WIP