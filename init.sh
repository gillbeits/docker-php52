#!/bin/bash

DOCKER_HOST=`/sbin/ip route|awk '/default/ { print $3 }'`
echo "${DOCKER_HOST}    ${HOST_IP}" >> /etc/hosts

if [ "$1" = 'httpd' ]; then
    if ! id -g "$PHP52_USER_GROUP" >/dev/null 2>&1; then
        groupadd -g ${PHP52_USER_GROUP_GID} ${PHP52_USER_GROUP}
    fi
    if ! id -u "$PHP52_USER" >/dev/null 2>&1; then
        useradd -u ${PHP52_USER_UID} -g ${PHP52_USER_GROUP} ${PHP52_USER}
    fi

    sed -i.bak "s/User apache/User ${PHP52_USER}/" /etc/httpd/conf/httpd.conf
    sed -i.bak "s/Group apache/Group ${PHP52_USER_GROUP}/" /etc/httpd/conf/httpd.conf
    service rsyslog start
    service crond start
    apachectl -D FOREGROUND
else
	exec "$@"
fi