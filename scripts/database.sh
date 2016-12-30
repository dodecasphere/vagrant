#!/usr/bin/env bash

DATABASE_NAME=$1

#clean up first
echo "Droping $DATABASE_NAME if it already exists.";
mysql -uroot -proot -e "DROP DATABASE IF EXISTS $DATABASE_NAME";

echo "Creating new $DATABASE_NAME";
mysql -uroot -proot -e "create database $DATABASE_NAME";

cd /vagrant;

# Test if PHP is installed
php artisan -V > /dev/null 2>&1
ARTISAN_IS_INSTALLED=$?

if [[ $ARTISAN_IS_INSTALLED -eq 0 ]]; then
    php artisan migrate --seed;
fi
