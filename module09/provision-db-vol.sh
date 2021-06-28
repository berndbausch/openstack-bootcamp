#!/bin/bash

# If there is a second disk, try mounting it under /var/lib/mysql.
# If that fails, create a filesystem and try again.

if [ -e /dev/vdb ]
then
    echo STOPPING MYSQL
    systemctl stop mariadb
    echo "/dev/vdb /var/lib/mysql ext4 defaults 0 0" >> /etc/fstab
    mount -a

    if (( $? != 0 ))   # mount failed
    then
        mkfs -t ext4 /dev/vdb
        mount -a
    fi

    # Fix ownership and SELinux label of /var/lib/mysql
    chown mysql:mysql /var/lib/mysql/
    chcon -t mysqld_db_t /var/lib/mysql/

    echo RESTARTING MYSQL
    systemctl start mariadb
fi

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

