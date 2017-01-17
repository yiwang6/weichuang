FROM yiwang666/lamp
MAINTAINER YiWanG <admin@yiwang6.cn>

COPY src/weichuang.zip /tmp/weichuang.zip
COPY src/weichuang.sql /tmp/weichuang.sql

RUN apt-get install -y unzip

WORKDIR /tmp
RUN set -x \
    && apt-get install -y php5-mysql php5-dev php5-gd php5-memcache php5-pspell php5-snmp snmp php5-xmlrpc libapache2-mod-php5 php5-cli unzip \
    && rm -rf /var/www/html/* \
    && unzip -x /tmp/weichuang.zip \
    && cp -r /tmp/* /var/www/html/ \
    && /etc/init.d/mysql start \
    && mysql -e "CREATE DATABASE weichuang DEFAULT CHARACTER SET utf8;" -uroot -p \
    && mysql -e "use weichuang;source /tmp/weichuang.sql;" -uroot -p \
    && rm -rf /tmp/* \
    && chown -R www-data:www-data /var/www/html

COPY src/start.sh /start.sh
RUN chmod a+x /start.sh

EXPOSE 80
CMD ["/start.sh"]
