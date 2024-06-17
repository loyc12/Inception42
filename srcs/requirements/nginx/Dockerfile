FROM	debian:buster

# installs dependencies
RUN		apt-get update
RUN		apt-get install -y nginx
RUN 	apt-get install -y openssl

# nginx SSL
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/"$USER_NAME".crt \
       -keyout /etc/nginx/ssl/"$USER_NAME".key \
       -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU="$USER_NAME"/CN="$USER_NAME"/"

COPY ./nginx.conf /etc/nginx/conf.d
RUN mkdir -p /run/nginx

# port used
EXPOSE	443

CMD ["nginx", "-g", "daemon off;"]

# WIP