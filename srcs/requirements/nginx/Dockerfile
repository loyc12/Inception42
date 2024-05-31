FROM debian:buster

RUN apt update -y
RUN apt install nginx -y
RUN apt install openssl -y

COPY ./tools/script.sh /

CMD [ "/script.sh" ]
