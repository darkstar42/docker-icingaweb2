FROM alpine

MAINTAINER Christoph Wiechert <wio@psitrax.de>

ENV REFRESHED_AT="2017-11-27"\
    ICINGAWEB_VERSION="2.5.0" \
    CUBE_VERSION="1.0.1" \
    BUSINESSPROCESS_VERSION="2.1.0" \
    TIMEZONE="UTC" \
    ICINGAWEB_AUTOCONF=true \
    ICINGA_API_PASS="super-secret" \
    WEB_DB_TYPE="mysql" \
    WEB_DB_HOST="mysql" \
    WEB_DB_PORT="3306" \
    WEB_DB_USER="root" \
    WEB_DB_PASS="root" \
    WEB_DB="icingaweb2" \
    IDO_DB_TYPE="" \
    IDO_DB_HOST="" \
    IDO_DB_USER="" \
    IDO_DB_PASS="" \
    IDO_DB="icinga2"

RUN apk add --no-cache \
      mysql-client \
      ca-certificates openssl \
      php7 php7-apache2 php7-pdo_mysql php7-openssl php7-intl php7-ldap php7-gettext \
      php7-ctype php7-json php7-mbstring php7-session php7-curl php7-iconv && \
    mkdir -p /run/apache2 && \
    echo "Fetch Icingaweb2 ${ICINGAWEB_VERSION}" && \
    mkdir /icingaweb2 && \
    wget -q -O - https://github.com/Icinga/icingaweb2/archive/v${ICINGAWEB_VERSION}.tar.gz \
      | tar xz --strip 1 -C /icingaweb2 && \
    ln -s /icingaweb2/bin/icingacli /usr/bin/icingacli && \
    echo "Fetch Module Cube ${CUBE_VERSION}" && \
    mkdir -p /icingaweb2/modules/cube && \
    wget -q -O - https://github.com/Icinga/icingaweb2-module-cube/archive/v${CUBE_VERSION}.tar.gz \
      | tar xz --strip 1 -C /icingaweb2/modules/cube --strip 1 && \
    echo "Fetch Module Businessprocess ${BUSINESSPROCESS_VERSION}" && \
    mkdir -p /icingaweb2/modules/businessprocess && \
    wget -q -O - https://github.com/Icinga/icingaweb2-module-businessprocess/archive/v${BUSINESSPROCESS_VERSION}.tar.gz \
      | tar xz --strip 1 -C /icingaweb2/modules/businessprocess --strip 1 && \
    chown -R apache /icingaweb2 && \
    mkdir -p /var/log/icingaweb2 && \
    chown -R apache /var/log/icingaweb2

ADD rootfs /

EXPOSE 80
VOLUME [ "/etc/icingaweb2"]

HEALTHCHECK CMD nc -z $WEB_DB_HOST $WEB_DB_PORT && nc -z localhost 80

CMD ["/init/run.sh"]

