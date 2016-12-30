#!/usr/bin/env bash

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
sudo service nginx start

# set up nginx server
cat > /etc/nginx/sites-enabled/default << EOF
server {
    listen 80 $server_name;
    listen [::]:80 $server_name ipv6only=on;

    root /var/www/public;
    index index.php index.html index.htm;

    server_name $server_name;

    location / {
        try_files $uri $uri/ =404;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

sudo service nginx restart

# clean /var/www
sudo rm -Rf /var/www
mkdir /var/www/public

# symlink /var/www => /vagrant
ln -s $public_folder /var/www/public
