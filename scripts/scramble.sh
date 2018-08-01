#!/bin/bash

cp -Rp /var/www/html /var/www/html-bak
mv /var/www/html /var/www/html-ps
ln -s /var/www/html-ps /var/www/html
cd /php
./php-transformer -php5 -replace /var/www/html

