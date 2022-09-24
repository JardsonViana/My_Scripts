#!/bin/bash


#~----------------------------------- Instalação Servidor LAMP:



#---- VARIAVEIS DE AMBIENTE:

DOWNLOAD_GIT_APACHE="https://github.com/JardsonViana/zabbix-6-debian11/raw/main/conf-apache2"

DOWNLOAD_APACHE=(
  apache2
  apache2-utils
)
DOWNLOAD_MARIADB=(
  mariadb-server
  mariadb-client
)
DOWNLOAD_PHP7=(
  libapache2-mod-php
  php
  php-mysql
  php-cli
  php-pear
  php-gmp
  php-gd
  php-bcmath
  php-mbstring
  php-curl
  php-xml
  php-zip
)
DOWNLOAD_CERTBOT=(
  certbot
  python3-certbot-apache
)
MYSQL_USER=root
MYSQL_PW=dado1234
MYSQL_BANCO=mysql
MYSQL_NEW_PW=Dado1234@@


#------------------- Instalação servidor Apache:

apt update

apt install "$DOWNLOAD_APACHE" -y

a2enmod rewrite
a2enmod headers

wget "$DOWNLOAD_GIT_APACHE" -O /etc/apache2/sites-enabled/000-default.conf

sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf
sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf

systemctl restart apache2


#~----------------- Instalação do Banco de Dados:

apt install "$DOWNLOAD_MARIADB" -y


#~------------------ Instalaçã do PHP 7.4:

apt install "$DOWNLOAD_PHP7" -y

systemctl restart apache2

echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php

#~------------------- Instalação PHPMyAdmin:

#.........Falta Completar


#~------------------- Configuração de senha root do mariadb:

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_NEW_PW';" | mysql -u"$MYSQL_USER" -p"$MYSQL_PW" "$MYSQL_BANCO"
echo "FLUSH PRIVILEGES;" | mysql -u"$MYSQL_USER" -p"$MYSQL_NEW_PW" "$MYSQL_BANCO"

echo > /root/.mysql_history


#~------------------- Instalação do Let's Encrypt:

apt install "$DOWNLOAD_CERTBOT" -y

#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
