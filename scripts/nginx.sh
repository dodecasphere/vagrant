#!/usr/bin/env bash

echo ">>> Installing Nginx"
php_version = $(php --version | tail -r | tail -n 1 | cut -d ' ' -f 2 | cut -c 1,2,3)

[[ -z $1 ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }
ip_address="$1"

if [[ -z $2 ]]; then
    public_folder="/vagrant"
else
    public_folder="$2"
fi

server_name="$3"

# Update Again
# sudo apt-key update
# sudo apt-get update

# Install nginx
# -qq implies -y --force-yes
sudo apt-get install -qq nginx
# sudo service nginx start

# set up nginx server
cat > /etc/nginx/sites-enabled/default << EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /var/www;
    index index.php index.html index.htm;

    server_name $server_name;

    location / {
        try_files \$uri \$uri/ =404;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    location ~ \.php$ {
        try_files $uri $uri/ /index.php\$is_args\$args;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php$php_version-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

# Set run-as user for nginx to user "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user www-data/user vagrant/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

# Add vagrant user to www-data group
usermod -a -G www-data vagrant

sudo service nginx restart

# clean /var/www
sudo rm -Rf /var/www

# symlink /var/www => /vagrant
ln -s $public_folder /var/www
