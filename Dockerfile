# Dockerfile for LettureEnel web application using Yii2 and Apache webserver

# Select Debian Jessie as the base image
FROM debian:jessie

MAINTAINER Alessio Garzi "gun101@email.it"

RUN apt-get update -q && apt-get install -qy curl git php5 apache2 php5-mysql && rm -rf /var/lib/apt/lists/*
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer global require "fxp/composer-asset-plugin:~1.1.1"
RUN mkdir /var/www/LettureEnel && git clone https://github.com/Ozzyboshi/LettureEnel.git /var/www/LettureEnel/ && chown -R www-data /var/www/LettureEnel
WORKDIR /var/www/LettureEnel
RUN composer install --prefer-dist --no-interaction
#RUN composer update
RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2ensite default-ssl.conf
RUN a2enmod ssl
COPY start.sh /var/www/LettureEnel/start.sh
ENV PATH="/var/www/LettureEnel:${PATH}"

# Publish port 80 and 443 for http and https
EXPOSE 80 443

# Start apache in foreground
CMD ["/var/www/LettureEnel/start.sh","insecureonly"]


