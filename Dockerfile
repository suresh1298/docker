# Base Image
FROM ubuntu:16.04

# The Author
MAINTAINER Reddy Eswar

# Setup Proxy for APT
COPY ./apt.conf /etc/apt/apt.conf

# Install Dependencies
RUN apt update -y && apt install sudo wget apache2-dev apache2 git \
        libmysqlclient-dev libsqlite3-dev build-essential zlib1g-dev libncurses5-dev \
        libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev -y

#  Copy Python3.7 src
COPY Python-3.7.3.tar.xz /usr/src/

# Copy Project config file
COPY campaign.conf /etc/apache2/sites-enabled/campaign.conf

# Install Python3.7, requirements.txt, Project Checkout from SCM
RUN cd /usr/src/ \
	&& tar -xf Python-3.7.3.tar.xz && cd Python-3.7.3 \
        && ./configure --enable-optimizations \
        && sudo make altinstall \
	&& cd /var/www/html \
        && git init \
        && git clone http://5d0fa1c811bf1d3f1e862282b2a008d7aaff17dc:x-oauth-basic@github.conti.de/uids8641/campaign-management-backend.git \
        && cd /var/www/html/campaign-management-backend \
        && git checkout origin/storage-planner \
        && git checkout storage-planner \
	&& pip3.7 --proxy=http://cias.geoaws.com:8080/ install --no-cache-dir -r requirements.txt \
	&& cd /usr/src/Python-3.7.3 && ./configure --enable-shared \
        && sudo make altinstall && ./configure --enable-optimizations \
        && sudo make altinstall && pip3.7 --proxy=http://cias.geoaws.com:8080/ install mod_wsgi \
        && ./configure --enable-loadable-sqlite-extensions \
        && make && sudo make install

# CD into project dir
WORKDIR /var/www/html/campaign-management-backend

# To clearup cache fro below layers
ARG CLEAR_CACHE=1000000

# Taking Updates from SCM, Check httpd config errors
RUN git pull \
	&& pip3.7 --proxy=http://cias.geoaws.com:8080/ install --no-cache-dir -r requirements.txt \
	&& a2enmod authnz_ldap && a2enmod headers \
        && rm -rf /var/www/html/index.html && rm -rf /etc/apache2/sites-enabled/000-default.conf \
        && chown -R www-data:www-data /var/www/html/campaign-management-backend \
        && apache2ctl -t

# Allow port inside container
EXPOSE 80

# httpd server starts
ENTRYPOINT rm -rf /run/apache2/apache2.pid && /usr/sbin/apache2ctl -D FOREGROUND
