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
    wget \
    && a2enmod rewrite && a2enmod headers \
    && sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf \
    && sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf \
    && echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && mkdir /var/www/jvconsult/ \
    && mkdir -p /var/www/jvconsult/{TXT,IMAGENS} \
    && touch /var/www/jvconsult/IMAGENS/arquivo-teste.txt \
    && touch /var/www/jvconsult/TXT/arquivo-teste.txt \
    && htpasswd -cb /var/www/jvconsult/.htpasswd jardson MINHASUPERSENHA@ \
    && wget https://raw.githubusercontent.com/JardsonViana/My_Scripts/main/Install/apache2-banco-de-imagens/jvconsult.conf -O /var/www/jvconsult/jvconsult.conf \
    && ln -s "/var/www/jvconsult/jvconsult.conf" "/etc/apache2/sites-available/jvconsult.conf" \
    && a2ensite jvconsult \
    && apt remove --purge -y wget unzip \
    && apt autoremove \
    && apt clean \
    && rm -rf /var/cache/apt/*

COPY 000-default.conf /etc/apache2/sites-enabled/
COPY index.php /var/www/jvconsult/

EXPOSE 80/TCP

CMD ["apachectl", "-D",  "FOREGROUND"]
