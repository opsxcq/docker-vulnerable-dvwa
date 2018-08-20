ln -s /etc/apache2/mods-available/php7.2.load /etc/apache2/mods-enabled
rm /etc/apache2/mods-enabled/php7.load

rm /var/www/html
ln -s /var/www/html-bak /var/www/html

if [[ ! -f /var/www/html/config/config.inc.php ]]; then
  cp /var/www/html/config/config.inc.php.dist /var/www/html/config/config.inc.php
fi

service apache2 restart
