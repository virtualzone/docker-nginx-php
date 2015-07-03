FROM nginx:latest
MAINTAINER Heiner Peuser <heiner.peuser@weweave.net>

RUN apt-get update && apt-get install -y \
    php5-fpm \
    php5-cli \
    php5-mysql \
    php-apc \
    supervisor

RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf

RUN rm /etc/nginx/conf.d/*
RUN rm -f /etc/nginx/sites-{enabled,available}
ADD nginx.conf /etc/nginx/
ADD custom.conf /etc/nginx/

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD index.php /usr/share/nginx/html/

EXPOSE 80

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/supervisord"]
