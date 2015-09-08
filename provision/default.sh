#!/bin/bash
#
# Default provisioning file that will be used by Vagrant whenever
# `vagrant up`, ` vagrant provision` or `vagrant reload` commands are
# used.

export DEBIAN_FRONTEND=noninteractive

# Set start time
time_start="$(date +%s)"

# Add additional sources for packages
echo "Updating package sources..."
ln -sf /srv/config/apt-sources.list /etc/apt/sources.list.d/apt-sources.list

# Add nginx signing key
echo "Adding nginx signing key..."
wget --quiet http://nginx.org/keys/nginx_signing.key -O- | apt-key add -

# MySQL
echo "Setting up default MySQL password..."
echo mysql-server mysql-server/root_password password password | debconf-set-selections
echo mysql-server mysql-server/root_password_again password password | debconf-set-selections

# List of all required packages
apt_packages=(
    curl
    dos2unix
    gettext
    git
    imagemagick
    mysql-server
    nginx
    #nodejs
    php5-cli
    php5-common
    php5-curl
    php5-dev
    php5-fpm
    php5-gd
    php5-imagick
    php5-imap
    php5-mcrypt
    php5-mysqlnd
    php5-xmlrpc
    php-pear
    phpmyadmin
    unzip
    zip
)

# Update the list
echo "Updating package list..."
apt-get update --assume-yes

# Loop through all the packages to filter only the one that yet to be installed
for i in "${!apt_packages[@]}"; do
    package_version="$(dpkg -s ${apt_packages[$i]} 2>&1 | grep 'Version:' | cut -d " " -f 2)"
    if [[ -n "${package_version}" ]]; then
        echo " *" ${apt_packages[$i]} [already installed]
        unset apt_packages[$i]
    else
        echo " *" ${apt_packages[${i}]} [not installed]
    fi
done

# Installe the packages
if [[ ${#apt_packages[@]} = 0 ]]; then
    echo "No package to install"
else
    echo "Installing required packages..."
    apt-get install --assume-yes ${apt_packages[@]}
fi

# Post installation cleanup
echo "Cleaning up..."
apt-get clean

# nginx
echo "Configuring nginx..."
cp /srv/config/nginx/nginx.conf /etc/nginx/nginx.conf
cp /srv/config/nginx/default.conf /etc/nginx/conf.d/default.conf

# PHP-FPM
echo "Configuring php5-fpm..."
php5enmod mcrypt
cp /srv/config/php5-fpm/www.conf /etc/php5/fpm/pool.d/www.conf
cp /srv/config/php5-fpm/php-custom.ini /etc/php5/fpm/conf.d/php-custom.ini

# MySQL
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

# phpMyAdmin
echo "Configuring phpMyAdmin..."
ln -s /usr/share/phpmyadmin /srv/www/
cp /srv/config/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php

# Restart all the services
echo "Restarting services..."
service php5-fpm restart
service nginx restart

# Add vagrant user to the www-data group
echo "Adding vagrant user to the www-data group..."
usermod -a -G www-data vagrant

# Calculate time taken and inform the user
time_end="$(date +%s)"
echo "Provisioning complete in "$(expr $time_end - $time_start)" seconds"
















# npm install -g npm
# npm install -g npm-check-updates

# MySQL
#
# Use debconf-set-selections to specify the default password for the root MySQL
# account. This runs on every provision, even if MySQL has been installed. If
# MySQL is already installed, it will not affect anything.
#echo mysql-server mysql-server/root_password password root | debconf-set-selections
#echo mysql-server mysql-server/root_password_again password root | debconf-set-selections

# if [[ ! -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
#         echo "Installing Composer..."
#         curl -sS https://getcomposer.org/installer | php
#         chmod +x composer.phar
#         mv composer.phar /usr/local/bin/composer
#     fi

