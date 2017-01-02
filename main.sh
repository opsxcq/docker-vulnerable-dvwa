#!/bin/bash

echo '[+] Starting mysql...'
service mysql start

echo '[+] Starting apache'
service apache2 start

while true
do
    tail -f /var/log/apache2/*.log
    exit 0
done
