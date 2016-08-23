#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Set start time
time_start="$(date +%s)"

# Get domain name passed from Vagrantfile
vagrant_domain=$1

# Add additional sources for packages
echo "Updating package sources..."
ln -sf /srv/config/apt-sources-extra.list /etc/apt/sources.list.d/apt-sources-extra.list

# Add nginx signing key
echo "Adding nginx signing key..."
wget --quiet http://nginx.org/keys/nginx_signing.key -O- | apt-key add -

# Fix missing pub keys
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C

# Set MySQL default roow password
echo "Setting up root MySQL password..."
echo mariadb-server mysql-server/root_password password password | debconf-set-selections
echo mariadb-server mysql-server/root_password_again password password | debconf-set-selections

# phpMyAdmin unattended installation
# See: http://stackoverflow.com/questions/30741573/debconf-selections-for-phpmyadmin-unattended-installation-with-no-webserver-inst
echo phpmyadmin phpmyadmin/internal/skip-preseed boolean true | debconf-set-selections
echo phpmyadmin phpmyadmin/reconfigure-webserver multiselect none | debconf-set-selections
echo phpmyadmin phpmyadmin/dbconfig-install boolean false | debconf-set-selections

# Add Node.js source
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

# Update the list, disabled since the above command will already trigger apt-get update
#echo "Updating package list..."
#apt-get update --assume-yes

# Install the packages
apt-get install -y --force-yes \
    nginx \
    build-essential \
    curl \
    dos2unix \
    gettext \
    git \
    imagemagick \
    mariadb-server \
    nodejs \
    ntp \
    php7.0-cli \
    php7.0-common \
    php7.0-curl \
    php7.0-fpm \
    php7.0-dev \
    php7.0-gd \
    php7.0-imap \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-soap \
    php7.0-xmlrpc \
    php-gettext \
    php-imagick \
    php-pear \
    subversion \
    unzip \
    zip

# phpMyAdmin needs to be installed separately as it pulls down apache
apt-get install -y --force-yes --no-install-recommends phpmyadmin

# Install Composer
if [ ! -f /usr/local/bin/composer ]; then
        echo "Installing Composer..."
        curl -sS https://getcomposer.org/installer | php
        chmod +x composer.phar
        mv composer.phar /usr/local/bin/composer
fi

# Install WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    echo "Installing wp-cli..."
    curl -sS -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Install mailhog
wget --quiet -O ~/mailhog https://github.com/mailhog/MailHog/releases/download/v0.2.0/MailHog_linux_amd64
chmod +x ~/mailhog
mv ~/mailhog /usr/local/bin/mailhog

tee /etc/init/mailhog.conf <<EOL
description "Mailhog"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env $(which mailhog)
EOL
service mailhog start

# Install mhsendmail
wget --quiet -O ~/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
chmod +x ~/mhsendmail
mv ~/mhsendmail /usr/local/bin/mhsendmail

# Post installation cleanup
echo "Cleaning up..."
apt-get autoremove

# nginx initial setup
echo "Configuring nginx..."
cp /srv/config/nginx/nginx.conf /etc/nginx/nginx.conf
cp /srv/config/nginx/default.conf /etc/nginx/conf.d/default.conf
sed -i "s/VAGRANT_DOMAIN/$vagrant_domain/g" /etc/nginx/conf.d/default.conf

# PHP initial setup
echo "Configuring PHP..."
phpenmod mcrypt
phpenmod mbstring
cp /srv/config/php/php-custom.ini /etc/php/7.0/fpm/conf.d/php-custom.ini
sed -i "s/VAGRANT_DOMAIN/$vagrant_domain/g" /etc/php/7.0/fpm/conf.d/php-custom.ini

# MySQL initial setup
echo "Configuring MySQL..."
mysql_install_db
mysql_secure_installation<<EOF
password
n
Y
Y
Y
Y
EOF

# phpMyAdmin initial setup
echo "Configuring phpMyAdmin..."
ln -sf /usr/share/phpmyadmin /srv/www/
cp /srv/config/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php

# Update Composer
echo "Updating Composer..."
composer self-update

# Update npm and npm-check-updates
echo "Updating npm..."
npm install -g npm
npm install -g npm-check-updates

# Setup default MySQL table
echo "Setting up MySQL table"
mysql -u root -ppassword << EOF
CREATE DATABASE IF NOT EXISTS wp;
GRANT ALL PRIVILEGES ON wp.* TO 'wp'@'localhost' IDENTIFIED BY 'password';
EOF

# Restart all the services
echo "Restarting services..."
service mysql restart
service php7.0-fpm restart
service nginx restart
service mailhog restart

# Add vagrant user to the www-data group with correct owner
echo "Adding vagrant user to the www-data group..."
usermod -a -G www-data vagrant
chown -R www-data:www-data /srv/www/

# Calculate time taken and inform the user
time_end="$(date +%s)"
echo "Provisioning completed in "$(expr $time_end - $time_start)" seconds"
