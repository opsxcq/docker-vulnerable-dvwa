FROM debian:stretch

LABEL maintainer "goldrak@gmail.com"

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    debconf-utils && \
    echo mysql-server mysql-server/root_password password vulnerables | debconf-set-selections && \
    echo mysql-server mysql-server/root_password_again password vulnerables | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    mysql-server \
    php \
    php-mysql \
    php-pear \
    php-gd \
    unzip \
    wget \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /tmp/

#donwload code
RUN wget https://github.com/ethicalhack3r/DVWA/archive/master.zip && unzip master.zip

#change config database
RUN sed -i "s/p@ssw0rd/password/g" "DVWA-master/config/config.inc.php.dist"
RUN sed -i "s/'root'/'admin'/g" "DVWA-master/config/config.inc.php.dist"

#change name config
RUN mv DVWA-master/config/config.inc.php.dist DVWA-master/config/config.inc.php 

#active allow url include
RUN sed -i "s/allow_url_include = Off/allow_url_include = On/g"  "/etc/php/7.0/apache2/php.ini"

#Delete zip and move folder
RUN rm master.zip && mv DVWA-master/* /var/www/html

#Permision for work
RUN chown www-data:www-data -R /var/www/html && \
    rm /var/www/html/index.html

#Start apache
RUN service apache2 start

#Start mysql and create user for dvwa
RUN service mysql start && mysql -uroot -pvulnerables -e "CREATE USER admin@localhost IDENTIFIED BY 'password';CREATE DATABASE dvwa;GRANT ALL privileges ON dvwa.* TO 'admin'@localhost;"

EXPOSE 80

CMD service mysql start && service apache2 start && tail -f /var/log/apache2/error.log