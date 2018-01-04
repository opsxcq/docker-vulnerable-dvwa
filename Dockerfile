FROM debian:jessie

LABEL maintainer "opsxcq@strm.sh"

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    debconf-utils && \
    echo mysql-server-5.5 mysql-server/root_password password vulnerables | debconf-set-selections && \
    echo mysql-server-5.5 mysql-server/root_password_again password vulnerables | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    php5 \
    php5-mysql \
    php-pear \
    php5-gd \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/2 /var/log/apache2/error.log

COPY conf/php.ini /etc/php5/apache2/php.ini
COPY conf/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN chown www-data:www-data -R /var/www/html && \
    rm /var/www/html/index.html

EXPOSE 80
VOLUME ["/var/www/html"]

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

