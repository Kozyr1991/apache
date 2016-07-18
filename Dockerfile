FROM centos:7

MAINTAINER Vitaliy Kozyr  <kozyrvitaliy@gmail.com>

#install php & httpd
RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum -y install --enablerepo=remi,remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-pecl-xdebug php-pecl-xhprof $
RUN php -v
RUN yum install nano -y && yum install wget -y
RUN yum install http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm -y
RUN yum install Percona-Server-server-56 -y
RUN yum install nano -y && yum install wget -y && yum install pwgen -y
RUN mkdir -p /home/etc/httpd/ && mkdir -p /home/www/public_html
ADD ./web.conf /home/etc/httpd/  
RUN echo "IncludeOptional /home/etc/httpd/*.conf" >> /etc/httpd/conf/httpd.conf
RUN echo "<?php phpinfo();  ?>" > /home/www/public_html/info.php
RUN cp /etc/php.ini /home/etc
RUN echo "PHPIniDir /home/etc/" >> /etc/httpd/conf/httpd.conf
ADD ./virtuemart /home/www/public_html
RUN chown -R apache:apache /home/www/public_html
RUN chmod -R 755 /home/www
RUN rm -rf /etc/my.cnf
ADD ./my.cnf /etc/
RUN echo "!include /home/etc/my.cnf" >> /etc/my.cnf && echo "!includedir /home/mysql/" >> /etc/my.cnf
ADD ./my.cnf /home/etc
ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
VOLUME /home/
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
EXPOSE 3306


CMD ["/usr/bin/mysqld_safe &", "-c"]
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
