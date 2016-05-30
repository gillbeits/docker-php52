FROM centos:6
MAINTAINER Ivan Koretskiy <gillbeits@gmail.com>

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && \
    rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-6.rpm && \
    rpm -Uvh http://rpms.southbridge.ru/southbridge-rhel6-stable.rpm && \
    rpm -Uvh http://rpms.southbridge.ru/southbridge-rhel6-php52.rpm && \
	yum install -y yum-utils && \
	yum-config-manager --save --setopt=base.exclude=php* && \
	yum-config-manager --save --setopt=updates.exclude=php* && \
	yum-config-manager --save --setopt=epel.exclude=php* && \
	yum-config-manager --save --setopt=remi.exclude=php* && \
	yum install -y httpd mod_ssl mod_rpaf openssl vixie-cron syslog \
	php php-pecl-apc php-cli php-common php-gd php-mbstring \
	php-mysql php-odbc php-pdo \
	php-soap php-xml php-xmlrpc \
	php-bcmath php-pecl-imagick php-pecl-memcache \
	php-mcrypt php-mhash && \
	ssmtp && \
	yum clean all && \
	mkdir /etc/httpd/vhost.d && \
	echo "Include vhost.d/*.conf" >> /etc/httpd/conf/httpd.conf && \
	echo "root=gillbeits@gmail.com" >> /etc/ssmtp/ssmtp.conf && \
	echo "mailhub=docker-host" >> /etc/ssmtp/ssmtp.conf && \
	echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf

EXPOSE 80 443

COPY init.sh /init.sh

RUN chmod +x /init.sh

CMD ["/init.sh", "httpd"]