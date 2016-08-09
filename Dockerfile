FROM tutum/lamp:latest

MAINTAINER Rafael <rafael@thestorm.com.br>)

# Install DVWA
RUN \
    rm -rf /app/* && \
    apt-get update && \
    apt-get install -y wget php5-gd && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/ethicalhack3r/DVWA/archive/v1.9.zip -O dvwa.tar.gz && \
    tar -xf dvwa.tar.gz && \
    cp -r DVWA-master/* /app/ && \
    rm -rf DVWA-master && \
    rm -rf dvwa.tar.gz

# Fix some issues about default lamp installation
RUN \
    chmod -R 777 /app/hackable/uploads/ /app/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt && \
    sed -i 's/allow_url_include = Off/allow_url_include = On/g' /etc/php5/apache2/php.ini && \
    sed -i "s/$_DVWA[ 'recaptcha_private_key' ] = ''/$_DVWA[ 'recaptcha_private_key' ] = '6LcdSCQTAAAAAGYfl1nYDeK8Dt_Art60KRIMgLXb'/g" /app/config/config.inc.php && \
    sed -i "s/$_DVWA[ 'recaptcha_public_key' ] = ''/$_DVWA[ 'recaptcha_public_key' ] = '6LcdSCQTAAAAAGYfl1nYDeK8Dt_Art60KRIMgLXb'/g" /app/config/config.inc.php

# Configure the db access
RUN \
    sed -i 's/root/admin/g' /app/config/config.inc.php && \
    echo "sed -i \"s/p@ssw0rd/\$PASS/g\" /app/config/config.inc.php" >> /create_mysql_admin_user.sh

EXPOSE 80 3306
CMD ["/run.sh"]

