#!/bin/bash
#
# Running additional provisioning related to WordPress setup, including
# creating the database, and downloading the latest WP core files to
# web root.

export DEBIAN_FRONTEND=noninteractive
echo "Running WordPress provisioning..."

# Set start time
time_start="$(date +%s)"

# wp-cli
if [ ! -f /usr/local/bin/wp ]; then
    echo "Installing wp-cli..."
    curl -sS -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

echo "Creating database..."
mysql -u root -ppassword < /srv/config/mysql/wordpress.sql

# WordPress
if ! $(wp core is-installed --allow-root); then
    echo "Downloading latest WordPress..."
    cd /srv/www
    wp core download --quiet --allow-root

    echo "Configuring WordPress..."
    wp core config --dbname=wp --dbuser=wp --dbpass=password --quiet --allow-root --extra-php <<PHP
        define('WP_DEBUG', true);
        define('WP_DEBUG_LOG', true);
        define('WP_DEBUG_DISPLAY', false);
PHP
    echo "Done! Please run /wp-admin/install.php first to configure your WordPress site"
fi

# Calculate time taken and inform the user
time_end="$(date +%s)"
echo "WordPress provisioning completed in "$(expr $time_end - $time_start)" seconds"
