#!/bin/bash

systemctl enable httpd mariadb --now
mysqladmin -u root password pw
mysqladmin create wpdb -u root -ppw
mysql -D mysql -u root -ppw -e "grant all privileges on wpdb.* to 'wp'@'localhost' identified by 'pw'; flush privileges;"

curl -O https://wordpress.org/latest.tar.gz
tar xf latest.tar.gz

mkdir /var/www/html/blog
cp -rn wordpress/* /var/www/html/blog


# obtain DB parameters from metadata
# First, get the metadata file
curl -O 169.254.169.254/openstack/latest/meta_data.json

# Next, use jq to get the metadata items from the file.
db_name=$(jq -r .meta.db_name meta_data.json)
db_user=$(jq -r .meta.db_user meta_data.json)
db_password=$(jq -r .meta.db_password meta_data.json)
db_ip=$(jq -r .meta.db_ipaddress meta_data.json)

cd /var/www/html/blog
mv wp-config-sample.php wp-config.php
sed -i s/database_name_here/$db_name/ wp-config.php
sed -i s/username_here/$db_user/ wp-config.php
sed -i s/password_here/$db_password/ wp-config.php
sed -i s/localhost/$db_ip/ wp-config.php
