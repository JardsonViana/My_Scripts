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
    apache2 apache2-utils sshpass \
    graphviz ca-certificates \
    libapache2-mod-php php php-cli \
    php-pear php-gmp php-gd php-bcmath \
    php-mbstring php-curl php-xml php-zip \
    wget unzip graphviz \
    && a2enmod rewrite && a2enmod headers \
    && sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf \
    && sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf \
    && echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && mkdir /var/www/html/lg \
    && cd /var/www/html/lg \
    && wget https://github.com/remontti/lg/raw/master/htdocs/favicon.ico \
    && wget https://github.com/remontti/lg/raw/master/htdocs/lg_logo.gif \
    && wget https://raw.githubusercontent.com/remontti/lg/master/htdocs/index.php \
    && wget https://raw.githubusercontent.com/remontti/lg/master/htdocs/lg_config.php \
    && apt remove --purge -y wget unzip \
    && apt autoremove \
    && apt clean \
    && rm -rf /var/cache/apt/*

COPY 000-default.conf /etc/apache2/sites-enabled/

EXPOSE 80/TCP

CMD ["apachectl", "-D",  "FOREGROUND"]
