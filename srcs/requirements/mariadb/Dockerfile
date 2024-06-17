FROM debian:buster

# Installs dependencies
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y mariadb-server
RUN apt-get install -y mariadb-client

# Deletes the cache and the package lists
RUN rm -rf /var/lib/apt/lists/*

# Allows the mysql daemon to run
# Purges and re-creates /var/lib/mysql with appropriate ownership
# Ensures that /var/run/mysqld (used for socket and lock files) is always writable
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld
RUN chmod 755 /var/run/mysqld

# port used
EXPOSE 3306

# Copies the .sh and .conf files
COPY ./init.sh /usr/local/bin/
COPY ./mariadb.conf /etc/mysql/mariadb.d

# Sets appropriate permissions
RUN chmod +x /usr/local/bin/init.sh
RUN chmod 755 /etc/mysql/mariadb.d

# Sets the init script as the entrypoint, which means it will be executed when the container is started
ENTRYPOINT [ "/usr/local/bin/init.sh" ]

# Launches mariadb and enables the database to listen globally
# Was prevented to listen globally before ( see mariadb.conf ) to avoid conflicts with other containers
CMD ["mysqld", "--bind-address=0.0.0.0"]

# WIP

