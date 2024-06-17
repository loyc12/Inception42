FROM debian:buster

RUN apt-get update
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
RUN rm -rf /var/lib/apt/lists/*

# installs wp_cli and puts it in /usr/local/bin
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# copies the .conf in the html directory
COPY ./wordpress.conf /etc/php/7.3/fpm/pool.d/

# creates the folder to enable php start
RUN mkdir /run/php

# copies the script and sets its rights
COPY ./init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh
ENTRYPOINT ["/usr/local/bin/init.sh"]

# port used
EXPOSE 9000

# cd to html directory
WORKDIR /var/www/html/

# Launch PHP FPM in foreground and ignore deamonize from conf file (-F)
CMD ["/usr/sbin/php-fpm7.3", "-F"]

# WIP