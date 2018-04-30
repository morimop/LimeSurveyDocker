FROM php:7-apache
RUN apt-get update ; \
    apt-get upgrade -y ; \
    docker-php-ext-install pdo_mysql mbstring ; \
    echo 'error_reporting = E_ALL' >> /usr/local/etc/php/conf.d/99_myconf.ini ; \
    echo 'date.timezone = Asia/Tokyo' >> /usr/local/etc/php/conf.d/99_myconf.ini ;

RUN cd /var/www/html && \
    apt install wget -y && \
    wget https://www.limesurvey.org/stable-release?download=2348:limesurvey371%20180424targz -O limesurvey371+20180424.tar.gz && \
    tar -zxvf limesurvey371+20180424.tar.gz && \
    chmod -R 777 limesurvey/upload && \
    chmod -R 777 limesurvey/tmp && \
    chmod -R 777 limesurvey/application/config/ && \
    rm -f limesurvey371+20180424.tar.gz && \
    apt remove wget -y
