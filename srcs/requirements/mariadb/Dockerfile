FROM debian:buster

# Installs dependencies
RUN apt-get update -y && apt-get -y upgrade
RUN apt-get install -y mariadb-server

# Deletes the cache and the package lists
#RUN rm -rf /var/lib/apt/lists/*

# Copies the .sh and .conf files
COPY init.sh init.sh
COPY mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

# Sets appropriate permissions
RUN chmod +x /init.sh
RUN chmod 600 /etc/mysql/mariadb.conf.d/50-server.cnf

# Allows the mysql daemon to run
# Ensures that /var/run/mysqld (used for socket and lock files) is always writable
RUN mkdir -p  /var/run/mysqld
RUN chmod 777 /var/run/mysqld

# port used
EXPOSE 3306

# Sets the init script as the entrypoint, which means it will be executed when the container is started
ENTRYPOINT [ "/init.sh" ]

# WIP

