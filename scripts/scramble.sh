#!/bin/bash

cp -Rp /var/www/html /var/www/html-bak
mv /var/www/html /var/www/html-ps
ln -s /var/www/html-ps /var/www/html
cd /php
php tok-php-transformer.php -p /var/www/html --replace
