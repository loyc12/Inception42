FROM debian:buster

RUN apt-get update -y
RUN apt-get install mariadb-server -y

COPY ./addons/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./addons/script.sh /

CMD ["/script.sh"]