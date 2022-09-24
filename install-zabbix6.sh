#!/bin/bash
#


#~----------------------------------- Instalação Servidor Zabbix-Server


#---- VARIAVEIS DE AMBIENTE:

DIRETORIO_DOWNLOAD="/home/jardson/downloads"
DIRETORIO_BD_PW="/home/jardson/temporario"
DOWNLOAD_ZABBIX_SERVER="https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-3%2Bdebian11_all.deb"
DOWNLOAD_PCT_ZABBIX_ADD_APT=(

)
PACOTE_ZABBIX="zabbix-release_6.0-3+debian11_all.deb"

MYSQL_USER="root"
MYSQL_PW="Dado1234@@"
MYSQL_ZBX_BANCO="zabbix"
MYSQL_ZBX_PW="z4bb1x@@"
MYSQL_ZBX_USER="zabbix"


#~--------- Instalação do Repositorio:

mkdir "$DIRETORIO_DOWNLOAD"
cd "$DIRETORIO_DOWNLOAD"
wget "$DOWNLOAD_ZABBIX_SERVER"
dpkg -i "$PACOTE_ZABBIX"

apt update

#~--------- Instalação do Pacotes Zabbix:

apt install zabbix-server-mysql -y

apt install zabbix-frontend-php \
            zabbix-apache-conf \
            zabbix-sql-scripts \
            zabbix-agent -y


#~--------- Criando banco de dados:

echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mysql -u"$MYSQL_USER" -p"$MYSQL_PW"
echo "create user zabbix@localhost identified by '$MYSQL_ZBX_PW';" | mysql -u"$MYSQL_USER" -p"$MYSQL_PW"
echo "grant all privileges on zabbix.* to zabbix@localhost;" | mysql -u"$MYSQL_USER" -p"$MYSQL_PW"


#~--------- Populando o banco de dados do Zabbix:

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -u"$MYSQL_ZBX_USER" -p"$MYSQL_ZBX_PW" "$MYSQL_ZBX_BANCO"

sleep 2

#~--------- Configurando o zabbix-server.conf:

sed -i "s/# DBPassword=/DBPassword=$MYSQL_ZBX_PW/" /etc/zabbix/zabbix_server.conf

#~--------- Configurando o apache.conf do zabbix:

sed -i 's/memory_limit 128M/memory_limit 512M/' /etc/zabbix/apache.conf
sed -i 's/post_max_size 16M/post_max_size 48M/' /etc/zabbix/apache.conf
sed -i 's/upload_max_filesize 2M/upload_max_filesize 24M/' /etc/zabbix/apache.conf
sed -i 's/Europe/America/' /etc/zabbix/apache.conf
sed -i 's/Riga/Sao_Paulo/' /etc/zabbix/apache.conf
sed -i 's/# php_value/php_value/' /etc/zabbix/apache.conf

#~--------- Limpando assinaturas do apache:

sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf
sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf


#~------ Iniciando os serviços:

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2


echo ="Instalação finalizada com sucesso!!!"
