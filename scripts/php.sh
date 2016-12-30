#!/usr/bin/env bash

export LANG=C.UTF-8

PHP_TIMEZONE=$1
PHP_VERSION=$2

echo ">>> Installing PHP $PHP_VERSION"

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C

sudo add-apt-repository -y ppa:ondrej/php

sudo apt-key update
sudo apt-get update

# Install PHP
# -qq implies -y --force-yes
sudo apt-get install -qq php$PHP_VERSION-cli php$PHP_VERSION-fpm php$PHP_VERSION-mysql php$PHP_VERSION-pgsql php$PHP_VERSION-sqlite php$PHP_VERSION-curl php$PHP_VERSION-gd php$PHP_VERSION-gmp php$PHP_VERSION-mcrypt php$PHP_VERSION-memcached php$PHP_VERSION-imagick php$PHP_VERSION-intl php$PHP_VERSION-xdebug

# Set PHP FPM to listen on TCP instead of Socket
# sudo sed -i "s/listen =.*/listen = 127.0.0.1:9000/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

# Set PHP FPM allowed clients IP address
sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

# Set run-as user for PHP5-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user = www-data/user = vagrant/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
sudo sed -i "s/group = www-data/group = vagrant/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

sudo sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
sudo sed -i "s/listen\.mode.*/listen.mode = 0666/" /etc/php/$PHP_VERSION/fpm/pool.d/www.conf


# xdebug Config
cat > $(find /etc/php/$PHP_VERSION -name xdebug.ini) << EOF
zend_extension=$(find /usr/lib/php/$PHP_VERSION -name xdebug.so)
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9000
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1

; var_dump display
xdebug.var_display_max_depth = 5
xdebug.var_display_max_children = 256
xdebug.var_display_max_data = 1024
EOF

# PHP Error Reporting Config
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/$PHP_VERSION/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/$PHP_VERSION/fpm/php.ini

# PHP Date Timezone
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php/$PHP_VERSION/fpm/php.ini
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php/$PHP_VERSION/cli/php.ini

sudo service php$PHP_VERSION-fpm restart
