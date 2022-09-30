#!/bin/bash
#
#********************************************************************
#
# Script de instalação de servidor Zabbix
#
#********************************************************************
#
# Algumas alterações realizadas durante o processo:
#
#     - Alteração do arquivo 000-default do apache2;
#     - Alteração da senha de root do mariadb.
#********************************************************************
#
# Versão do Script:  2.0
# Ultima edição:     28/09/22
# Autor:             Jardson Viana (JvConsult)
# Contato:           jardson.consultoria@gmail.com
#
#********************************************************************
#
# Homologando em ambiente Debian 11!
#
#********************************************************************

#~----------------------------------- Instalação Servidor Zabbix-Server


#---- VARIAVEIS DE AMBIENTE:

DIR_ARQUIVOS="/tmp/downloads"
DIR_NULL="/etc/null"
DIR_ZBX_APACHE="/etc/zabbix/apache.conf"
DIR_IPV4="/tmp/downloads/getipv4"
DOWNLOAD_ZABBIX_SERVER="https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-3%2Bdebian11_all.deb"

PACOTE_ZABBIX="zabbix-release_6.0-3+debian11_all.deb"

HOST="$3"
MYSQL_USER="root"
MYSQL_PW="$1"
MYSQL_ZBX_BANCO="zabbix"
MYSQL_ZBX_PW="$2"
MYSQL_ZBX_USER="zabbix"


#~--------- Instalação do Repositorio:

figlet -c "JV CONSULT ISP - ZABBIX"
sleep 2

echo "[INFO] - Iniciando Instalação do repositório Zabbix..."
mkdir "$DIR_ARQUIVOS"
cd "$DIR_ARQUIVOS"
wget "$DOWNLOAD_ZABBIX_SERVER" &> "$DIR_NULL"
dpkg -i "$PACOTE_ZABBIX" &> "$DIR_NULL"

echo "[INFO] - Atualizando Repositório..."
apt update &> "$DIR_NULL"


#~--------- Instalação do Pacotes Zabbix:

echo "[INFO] - Instalando os Pacotes Zabbix..."
apt install zabbix-server-mysql -y &> "$DIR_NULL"

apt install zabbix-frontend-php \
            zabbix-apache-conf \
            zabbix-sql-scripts \
            zabbix-agent -y &> "$DIR_NULL"


#~--------- Criando banco de dados:

echo "[INFO] - Criando Banco de Dados do Zabbix Server..."
echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mysql -u"$MYSQL_USER" -p"$MYSQL_PW"
echo "create user zabbix@localhost identified by '$MYSQL_ZBX_PW';" | mysql -u"$MYSQL_USER" -p"$MYSQL_PW"
echo "grant all privileges on zabbix.* to zabbix@localhost;" | mysql -u"$MYSQL_USER" -p"$MYSQL_PW"

echo "[INFO] - Limpando Historico do mysql..."
echo > /root/.mysql_history


#~--------- Populando o banco de dados do Zabbix:

echo "[INFO] - Populando o Banco de Dados do Zabbix Server..."
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -u"$MYSQL_ZBX_USER" -p"$MYSQL_ZBX_PW" "$MYSQL_ZBX_BANCO"

sleep 2

#~--------- Configurando o zabbix-server.conf:

echo "[INFO] - Realizando alterações na Conf. do Zabbix..."
sed -i "s/# DBPassword=/DBPassword=$MYSQL_ZBX_PW/" /etc/zabbix/zabbix_server.conf &> "$DIR_NULL"
sleep 1

#~--------- Configurando o apache.conf do zabbix:

echo "[INFO] - Realizando alterações na Conf. do Apache..."
sed -i 's/memory_limit 128M/memory_limit 512M/' "$DIR_ZBX_APACHE" &> "$DIR_NULL"
sed -i 's/post_max_size 16M/post_max_size 48M/' "$DIR_ZBX_APACHE" &> "$DIR_NULL"
sed -i 's/upload_max_filesize 2M/upload_max_filesize 24M/' "$DIR_ZBX_APACHE" &> "$DIR_NULL"
sed -i 's/Europe/America/' "$DIR_ZBX_APACHE" &> "$DIR_NULL"
sed -i 's/Riga/Sao_Paulo/' "$DIR_ZBX_APACHE" &> "$DIR_NULL"
sed -i 's/# php_value/php_value/' "$DIR_ZBX_APACHE" &> "$DIR_NULL"
sleep 2

#~--------- Limpando assinaturas do apache:

echo "[INFO] - Limpando assinaturas do apache2..."
sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf &> "$DIR_NULL"
sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf &> "$DIR_NULL"
sleep 1

#~------ Iniciando os serviços:

echo "[INFO] - Iniciando os Serviços do Zabbix Server..."
systemctl restart zabbix-server zabbix-agent apache2 &> "$DIR_NULL"
systemctl enable zabbix-server zabbix-agent apache2 &> "$DIR_NULL"
sleep 1

#~------------------- Finalizando Instalação:

echo "[INFO] - PREPARANDO PARA FINALIZAR..."
sleep 1

ip ad sh |grep -i global |grep -i brd |awk '{print $2}' |cut -d / -f1 > "$DIR_IPV4"
sleep 1

GETIP4=$(cat "$DIR_IPV4")

echo "[INFO] - PREPARANDO DADOS PARA ENVIO..."
touch "$DIR_ARQUIVOS"/zabbix_mysql_"$HOST"_"$GETIP4".txt
sleep 2

echo "$HOST" >> "$DIR_ARQUIVOS"/zabbix_mysql*
echo "$MYSQL_ZBX_USER" >> "$DIR_ARQUIVOS"/zabbix_mysql*
echo "$MYSQL_ZBX_PW" >> "$DIR_ARQUIVOS"/zabbix_mysql*
echo "$GETIP4" >> "$DIR_ARQUIVOS"/zabbix_mysql*
sleep 3

echo "[INFO] - ENVIANDO DADOS, DIGITE A SENHA PARA CONTINUAR..."
sleep 2
rsync -vza "$DIR_ARQUIVOS"/zabbix_mysql* jardson@200.110.202.3:/home/jardson/backup_servidores &> "$DIR_NULL"
sleep 2

echo "[INFO] - LIMPANDO SISTEMA..."
sleep 1
apt autoremove -y &> "$DIR_NULL"
apt clean &> "$DIR_NULL"
rm -rf "$DIR_ARQUIVOS" &> "$DIR_NULL"
sleep 2

echo "[INFO] - Instalação concluida com sucesso..!"
sleep 1

figlet -c OBRIGADO!
sleep 2

#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------