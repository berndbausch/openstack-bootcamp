#!/bin/bash

# update software and install packages recommended for Wordpress
dnf install "@web-server" jq -y

# enable and launch web server and database server
systemctl enable httpd.service --now

# SELinux does not allow HTTP servers to make network connections.
# Create an exception for network connections to a database.
setsebool httpd_can_network_connect_db on

# obtain DB parameters from metadata
# First, get the metadata file
curl -O 169.254.169.254/openstack/latest/meta_data.json

# Next, use jq to get the metadata items from the file
db_name=$(jq -r .meta.db_name meta_data.json)
db_user=$(jq -r .meta.db_user meta_data.json)
db_password=$(jq -r .meta.db_password meta_data.json)
db_ip=$(jq -r .meta.db_ipaddress meta_data.json)

# Download and unpack Wordpress
cd /var/tmp
curl -O https://wordpress.org/latest.tar.gz
tar xf latest.tar.gz

# Install Wordpress
mkdir /var/www/html/blog
cp -r wordpress/* /var/www/html/blog
cd /var/www/html/blog

# Configure Wordpress
mv wp-config-sample.php wp-config.php
sed -i s/database_name_here/$db_name/ wp-config.php
sed -i s/username_here/$db_user/ wp-config.php
sed -i s/password_here/$db_password/ wp-config.php
sed -i s/localhost/$db_ip/ wp-config.php
# To improve security, we should also change keys and salts,
# but for simplicity's sake we will leave this step out

