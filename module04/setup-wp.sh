#!/bin/bash

systemctl enable httpd mariadb --now
mysqladmin -u root password pw
mysqladmin create wpdb -u root -ppw
mysql -D mysql -u root -ppw -e "grant all privileges on wpdb.* to 'wp'@'localhost' identified by 'pw'; flush privileges;"

curl -O https://wordpress.org/latest.tar.gz
tar xf latest.tar.gz

mkdir /var/www/html/blog
cp -rn wordpress/* /var/www/html/blog

cd /var/www/html/blog
mv wp-config-sample.php wp-config.php
sed -i s/database_name_here/wpdb/ wp-config.php
sed -i s/username_here/wp/ wp-config.php
sed -i s/password_here/pw/ wp-config.php
