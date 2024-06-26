FROM debian:buster

# Installs dependencies
RUN apt-get update -y && apt-get -y upgrade
RUN apt-get install -y mariadb-server
RUN apt-get install -y mariadb-client

# Deletes the cache and the package lists
RUN rm -rf /var/lib/apt/lists/*

# Copies the .sh and .conf files
COPY ./init.sh init.sh
COPY ./mariadb.conf /etc/mysql/mariadb.conf

# Sets appropriate permissions
RUN chmod +x /init.sh
RUN chmod 777 /etc/mysql/mariadb.conf

# TODO : remove me ?
# Allows the mysql daemon to run
# Ensures that /var/run/mysqld (used for socket and lock files) is always writable
#RUN mkdir -p  /var/run/mysqld
#RUN chmod 777 /var/run/mysqld

# port used
EXPOSE 3306

ENV MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PSWD}"
ENV MYSQL_PASSWORD="${MYSQL_PSWD}"

# Sets the init script as the entrypoint, which means it will be executed when the container is started
ENTRYPOINT [ "/init.sh" ]

# Launches mariadb and enables the database to listen globally
# Was prevented to listen globally before ( see mariadb.conf ) to avoid conflicts with other containers
CMD ["mysqld", "--bind-address=0.0.0.0"]

# WIP

