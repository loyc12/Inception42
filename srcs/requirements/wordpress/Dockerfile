FROM debian:buster

# Prevents an infinite death spiral
ENV DEBIAN_FRONTEND noninteractive

# Installs dependencies
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install \
	wget \
	bash \
	php \
	php-fpm \
	php-cli \
	mariadb-client \
	mariadb-server \
	php-mysql

	# TODO : remove me
	#php-cgi \
	#php-pdo \
	#php-gd \
	#php-mbstring \
	#redis \
	#php-redis

# Deletes the cache and the package lists
RUN rm -rf /var/lib/apt/lists/*

# Downloads wp-cli.phar, which is the command line interface for WordPress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Copies the .conf in the html directory
COPY ./www.conf /etc/php/7.3/fpm/pool.d/

# Sets the port to be used by the container
EXPOSE 9000

# CD to the html directory
WORKDIR /var/www/html/

# Copies the init script, sets its permissions and makes it the entrypoint
# This means it will be executed when the container is started
COPY ./init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]

# WIP