#!/bin/bash

echo '[+] Starting mysql...'
echo "--> Ensuring /var/lib/mysql is owned by mysql user."
chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user=mysql --ldata=/var/lib/mysql
service mysql start
echo '--> Verifying mysql service...'
ss=$(service mysql status)
echo "$ss"
if [[ "$ss" == "MySQL is stopped.." ]]; then
	echo "----> Mysql is not running."
        echo "$ss"
        echo "----> Displaying last few lines of mysql service error log."
        tail /var/log/mysql/error.log
        echo "----> If the error is Can't open and lock privilege tables: Got error 140 from storage engine,"
	echo "      your docker is probably running overlay2 or overlay. Mysql only runs on aufs."
        echo "      An easy remedy is to mount an external volume at /var/lib/mysql"
	echo "      You may just mount a tmpfs: --mount type=tmpfs,destination=/var/lib/mysql"
	exit 1
else
	echo "----> Mysql is running..."
fi

echo "--> Setting Debian user password for Mysql (in case /var/lib/mysql was mounted)"
debpass=$(cat /etc/mysql/debian.cnf | grep password | awk '{print $3}' |tail -n 1)
debpasswdcmd="GRANT ALL PRIVILEGES on *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '$debpass' WITH GRANT OPTION; FLUSH PRIVILEGES;"
echo "----> $debpasswdcmd"
mysql -u root -e "$debpasswdcmd"

echo "--> Setting dvwa accessor user for MariaDB"
dvwacmd="create database dvwa;  grant all on dvwa.* to 'dvwa'@'localhost' identified by 'p@ssw0rd'; flush privileges;"
echo "----> $dvwacmd"
mysql -u root -e "$dvwacmd"

echo '[+] Starting apache'
cp /var/www/html/config/config.inc.php.dist /var/www/html/config/config.inc.php
sed 's/.*$_DVWA.*root.*/$_DVWA[ '"'"'db_user'"'"' ]     = '"'"'dvwa'"'"';/' /var/www/html/config/config.inc.php > /var/www/html/config/config.inc.php.new
yes | cp /var/www/html/config/config.inc.php.new /var/www/html/config/config.inc.php
service apache2 start

while true
do
    tail -f /var/log/apache2/*.log
    exit 0
done
