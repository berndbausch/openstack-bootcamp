#!/bin/bash

# install DB
dnf install mariadb-server -y

# enable and launch web server and database server
systemctl enable mariadb.service --now

# obtain DB parameters from metadata
# First, get the metadata file
curl -O 169.254.169.254/openstack/latest/meta_data.json

# Next, use jq to get the metadata items from the file
db_name=$(jq -r .meta.db_name meta_data.json)
db_user=$(jq -r .meta.db_user meta_data.json)
db_password=$(jq -r .meta.db_password meta_data.json)

# configure wordpress database
mysqladmin -u root password $db_password
mysqladmin create $db_name -u root -p$db_password
mysql -D mysql -u root -p$db_password -e "GRANT ALL PRIVILEGES ON $db_name.* \
               TO '$db_user'@'%'                                             \
               IDENTIFIED BY '$db_password'; FLUSH PRIVILEGES;"

