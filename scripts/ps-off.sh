ln -s /etc/apache2/mods-available/php7.2.load /etc/apache2/mods-enabled
mv /etc/apache2/mods-enabled/php7.load

rm /var/www/html
ln -s /var/www/html-bak /var/www/html

service apache2 restart
