FROM	debian:buster

# Installs dependencies
RUN	apt-get update && apt-get -y upgrade
RUN	apt-get install -y nginx
RUN apt-get install -y openssl

# Deletes the cache and the package lists
RUN	rm -rf /var/lib/apt/lists/*

# Sets up the ssl certificate
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/"${LOGIN}".crt \
       -keyout /etc/nginx/ssl/"${LOGIN}".key \
       -subj "/C=CA/ST=Quebec/L=Quebec/O=42 School/OU=42_Quebec/CN=${DOMAIN_NAME}/"

# Copies the nginx configuration file
COPY ./nginx.conf /etc/nginx/conf.d/

# Creates the directory for the socket file
RUN mkdir -p  /run/nginx
RUN chmod 777 /run/nginx

# Port used by the container
EXPOSE	443

# Starts the nginx service
CMD ["nginx", "-g", "daemon off;"]