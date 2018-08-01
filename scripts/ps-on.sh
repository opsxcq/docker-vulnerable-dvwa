ln -s /etc/apache2/mods-available/php7.load /etc/apache2/mods-enabled
rm /etc/apache2/mods-enabled/php7.2.load

rm /var/www/html
ln -s /var/www/html-ps /var/www/html

service apache2 restart
