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

echo "[INFO] - Iniciando Instalação do Apache2..."
apt update &> /etc/null

echo "[INFO] - Instalando Pacotes Apache..."
apt install "$DOWNLOAD_APACHE" -y &> /etc/null

echo "[INFO] - Habilitando os Modulos do Apache..."
sleep 2
a2enmod rewrite &> /etc/null
a2enmod headers &> /etc/null

echo "[INFO] - Baixando arquivo 000-default do github..."
sleep 2
wget "$DOWNLOAD_GIT_APACHE" -O /etc/apache2/sites-enabled/000-default.conf &> /etc/null

echo "[INFO] - Limpando assinaturas do apache2..."
sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf
sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf
sleep 2

echo "[INFO] - Reiniciando o Apache2..."
systemctl restart apache2


#~----------------- Instalação do Banco de Dados:

echo "[INFO] - Instalando MariaDB..."
apt install "$DOWNLOAD_MARIADB" -y &> /etc/null
sleep 2

#~------------------ Instalaçã do PHP 7.4:

echo "[INFO] - Instalando Pacotes PHP7.4..."
apt install "$DOWNLOAD_PHP7" -y &> /etc/null
sleep 2

echo "[INFO] - Restartando Apache2..."
systemctl restart apache2 &> /etc/null
sleep 2

echo "[INFO] - Habilitando pagina phpinfo..."
echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php


#~------------------- Instalação PHPMyAdmin:

#.........Falta Completar


#~------------------- Configuração de senha root do mariadb:
echo "[INFO] - Alterando senha Mysql root..."

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_NEW_PW';" | mysql -u"$MYSQL_USER" -p"$MYSQL_PW" "$MYSQL_BANCO"
echo "FLUSH PRIVILEGES;" | mysql -u"$MYSQL_USER" -p"$MYSQL_NEW_PW" "$MYSQL_BANCO"

echo "[INFO] - Limpando Historico do mysql..."
echo > /root/.mysql_history

#~------------------- Instalação do Let's Encrypt:

echo "[INFO] - Instalando Let's Encrypt SSL..."
apt install "$DOWNLOAD_CERTBOT" -y &> /etc/null
sleep 2

echo "[INFO] - Instalação concluida com sucesso..!"


#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
