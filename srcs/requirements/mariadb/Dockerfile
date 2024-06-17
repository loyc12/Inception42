FROM debian:buster

RUN apt-get update
RUN apt-get install -y \
	mariadb-server \
    mariadb-client \
    vim
RUN rm -rf /var/lib/apt/lists/*

# allows the mysql daemon to run
# purges and re-creates /var/lib/mysql with appropriate ownership
# ensures that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID the mysqld instance ends up having at runtime
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld
RUN chmod 777 /var/run/mysqld


COPY ./init.sh /usr/local/bin/
### COPY ./wordpress.sql /usr/local/bin/

# gives the right to execute & launch the .sh
RUN chmod +x /usr/local/bin/init.sh
### RUN chmod +x /usr/local/bin/wordpress.sql

ENTRYPOINT [ "/usr/local/bin/init.sh" ]

# port used
EXPOSE 3306

# launches mariadb and enables the database to listen globally - also can be put on mysqldump.cnf file
CMD ["mysqld", "--bind-address=0.0.0.0"]

# WIP
# add wordpress.sql and enable its copying and chmod-ing

