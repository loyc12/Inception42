FROM debian:buster

RUN apt-get update
RUN apt-get install -y \
	mariadb-server \
    mariadb-client \
    vim
RUN rm -rf /var/lib/apt/lists/*

#Allow to run the daemon of mysql
# Purge and re-create /var/lib/mysql with appropriate ownership
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld
RUN chmod 777 /var/run/mysqld


#Copy of the .sh and .sql in the /bin of the container to be able to run the program
# Give the right to execute + launch the .sh
COPY ./init.sh /usr/local/bin/
### COPY ./wordpress.sql /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/wordpress.sql

ENTRYPOINT [ "/usr/local/bin/init.sh" ]

# port used
EXPOSE 3306

#Command to launch mariadb and enable the database to listen globally - also can be put on mysqldump.cnf file
CMD ["mysqld", "--bind-address=0.0.0.0"]

# WIP

