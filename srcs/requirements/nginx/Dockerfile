FROM	debian:buster

# Installs dependencies
RUN	apt-get update -y && apt-get -y upgrade
RUN	apt-get install -y nginx
RUN apt-get install -y openssl

# Deletes the cache and the package lists
RUN	rm -rf /var/lib/apt/lists/*

# Sets up the ssl certificate
RUN mkdir -p /etc/nginx/ssl
RUN chmod 777 /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out "/etc/nginx/ssl/llord.crt" \
       -keyout "/etc/nginx/ssl/llord.key" \
       -subj "/C=CA/ST=Quebec/L=Quebec/O=42_School/OU=42_Quebec/CN=llord.42.fr/"

# Copies the nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Creates the directory for the socket file
RUN mkdir -p  /run/nginx
RUN chmod 777 /run/nginx

# Port used by the container
EXPOSE	443

# Starts the nginx service
CMD ["nginx", "-g", "daemon off;"]