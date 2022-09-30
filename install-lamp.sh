#!/bin/bash
#
#********************************************************************
#
# Script de instalação de servidor LAMP, incluindo:
#     - Apache 2;
#     - MariaDB;
#     - PHP7.4;
#     - Certbot.
#********************************************************************
#
# Algumas alterações realizadas durante o processo:
#
#     - Alteração do arquivo 000-default do apache2;
#     - Alteração da senha de root do mariadb.
#********************************************************************
#
# Versão do Script:  3.0
# Ultima edição:     28/09/22
# Autor:             Jardson Viana (JvConsult)
# Contato:           jardson.consultoria@gmail.com
#
#********************************************************************
#
# Homologando em ambiente Debian 11!
#
#~------------------------ Instalação Servidor LAMP:---------------~#



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
MYSQL_PW="$1"
MYSQL_BANCO=mysql
MYSQL_NEW_PW="$2"
HOST="$3"

#~--- Diretorios:
DIR_ARQUIVO="/tmp/temporario"
DIR_IPV4="/tmp/temporario/getipv4"
DIR_NULL="/etc/null"
DIR_PHPINFO="/var/www/html/phpinfo.php"


#------------------- Instalação servidor Apache:

figlet -c "JV CONSULT ISP"
sleep 2

echo "[INFO] - Iniciando Instalação do Apache2..."
apt update &> "$DIR_NULL"

echo "[INFO] - Instalando Pacotes Apache..."
apt install "$DOWNLOAD_APACHE" -y &> "$DIR_NULL"

echo "[INFO] - Habilitando os Modulos do Apache..."
sleep 2
a2enmod rewrite &> "$DIR_NULL"
a2enmod headers &> "$DIR_NULL"

echo "[INFO] - Baixando arquivo 000-default do github..."
sleep 2
wget "$DOWNLOAD_GIT_APACHE" -O /etc/apache2/sites-enabled/000-default.conf &> "$DIR_NULL"

echo "[INFO] - Limpando assinaturas do apache2..."
sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf
sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf
sleep 2

echo "[INFO] - Reiniciando o Apache2..."
systemctl restart apache2


#~----------------- Instalação do Banco de Dados:

echo "[INFO] - Instalando MariaDB..."
apt install "$DOWNLOAD_MARIADB" -y &> "$DIR_NULL"
sleep 2

#~------------------ Instalaçã do PHP 7.4:

echo "[INFO] - Instalando Pacotes PHP7.4..."
apt install "$DOWNLOAD_PHP7" -y &> "$DIR_NULL"
sleep 2

echo "[INFO] - Restartando Apache2..."
systemctl restart apache2 &> "$DIR_NULL"
sleep 2

echo "[INFO] - Habilitando pagina phpinfo..."
echo '<?php phpinfo(); ?>' > "$DIR_PHPINFO"


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
apt install "$DOWNLOAD_CERTBOT" -y &> "$DIR_NULL"
sleep 2

#~------------------- Finalizando Instalação:

echo "[INFO] - PREPARANDO PARA FINALIZAR..."
mkdir "$DIR_ARQUIVO"
sleep 1

ip ad sh |grep -i global |grep -i brd |awk '{print $2}' |cut -d / -f1 > "$DIR_IPV4"
sleep 1

GETIP4=$(cat "$DIR_IPV4")

echo "[INFO] - PREPARANDO DADOS PARA ENVIO..."
touch "$DIR_ARQUIVO"/lamp_mysql_"$HOST"_"$GETIP4".txt
sleep 2

echo "$HOST" >> "$DIR_ARQUIVO"/lamp_mysql_*
echo "$MYSQL_USER" >> "$DIR_ARQUIVO"/lamp_mysql_*
echo "$MYSQL_NEW_PW" >> "$DIR_ARQUIVO"/lamp_mysql_*
echo "$GETIP4" >> "$DIR_ARQUIVO"/lamp_mysql_*
sleep 3

echo "[INFO] - ENVIANDO DADOS, DIGITE A SENHA PARA CONTINUAR..."
sleep 2
rsync -vza "$DIR_ARQUIVO"/lamp_mysql_* jardson@200.110.202.3:/home/jardson/backup_servidores &> "$DIR_NULL"
sleep 2

echo "[INFO] - LIMPANDO SISTEMA..."
sleep 1
apt autoremove -y &> "$DIR_NULL"
apt clean &> "$DIR_NULL"
rm -rf "$DIR_ARQUIVO" &> "$DIR_NULL"
sleep 2

echo "[INFO] - Instalação concluida com sucesso..!"
sleep 1

figlet -c OBRIGADO!
sleep 2

#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------