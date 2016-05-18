#!/usr/bin/env bash

#clean up first
echo "Droping local_database if it already exists.";
mysql -uroot -proot -e "DROP DATABASE IF EXISTS local_database";

echo "Creating new local_database";
mysql -uroot -proot -e "create database local_database";

cd /vagrant;

# Test if PHP is installed
php artisan -V > /dev/null 2>&1
ARTISAN_IS_INSTALLED=$?

if [[ $ARTISAN_IS_INSTALLED -eq 0 ]]; then
    php artisan migrate --seed;
fi
