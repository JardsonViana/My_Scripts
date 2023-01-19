FROM debian:bullseye-slim

ENV \
    MAINTAINER="Jardson Viana" \
    EMAIL=jardson.consultoria@gmail.com \
    TERM=xterm \
    TZ=America/Sao_Paulo \
    PS1='\u@\h:\w\$ '

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    apache2 apache2-utils ca-certificates \
    libapache2-mod-php php php-mysql \
    php-cli php-pear php-gmp php-gd \
    php-bcmath php-mbstring php-curl \
    php-xml php-zip \
    wget unzip \
    && a2enmod rewrite && a2enmod headers \
    && sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf \
    && sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf \
    && echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && wget https://github.com/phpipam/phpipam/releases/download/v1.5.0/phpipam-v1.5.0.tgz -P /tmp/ \
    && tar -vxf /tmp/phpipam-v1.5.0.tgz \
    && mv phpipam /var/www/html/phpipam \
    && find /var/www/* -type d -exec chmod 755 {} \; \
    && find /var/www/* -type f -exec chmod 644 {} \; \
    && mkdir /opt/phpipam \
    && cd /var/www/html/phpipam \
    && cp config.dist.php config.php \
    && mv /var/www/html/phpipam/config.php /opt/phpipam/ \
    && ln -s "/opt/phpipam/config.php" "/var/www/html/phpipam/" \
    && apt remove --purge -y wget unzip \
    && apt autoremove \
    && apt clean \
    && rm -rf /var/cache/apt/*

COPY 000-default.conf /etc/apache2/sites-enabled/

EXPOSE 80/TCP

CMD ["apachectl", "-D",  "FOREGROUND"]
