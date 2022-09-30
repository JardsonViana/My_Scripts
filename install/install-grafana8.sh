#!/bin/bash
#
#********************************************************************
#
# Script de instalação de servidor Grafana 8.5
#
#********************************************************************
#
# Algumas alterações realizadas durante o processo:
#
#********************************************************************
#
# Versão do Script:  1.0
# Ultima edição:     28/09/22
# Autor:             Jardson Viana (JvConsult)
# Contato:           jardson.consultoria@gmail.com
#
#********************************************************************
#
# Homologando em ambiente Debian 11 com zabbix 6.0LTS!
#
#********************************************************************


#---- Variáveis Globais:

DIR_ARQUIVOS="/tmp/grafana"
DIR_NULL="/etc/null"
DIR_GRAFANA="/etc/grafana/grafana.ini"
DOWNLOAD_GRAFANA="https://dl.grafana.com/oss/release/grafana_8.5.11_amd64.deb"

#~----------------------------------- Instalação Servidor Grafana:


#~--------- Instalação do Grafana:

figlet -c "JV CONSULT ISP - GRAFANA 8"
sleep 2

echo "[INFO] - Iniciando Instalação do Grafana Server..."
apt update &> "$DIR_NULL"
sleep 1

echo "[INFO] - Instalando os Pacotes Necessários..."
apt install gnupg2 apt-transport-https \
            software-properties-common -y \
            &> "$DIR_NULL"
sleep 1

echo "[INFO] - Baixando o Grafana Server 8..."
mkdir "$DIR_ARQUIVOS"
cd "$DIR_ARQUIVOS"
wget "$DOWNLOAD_GRAFANA" &> "$DIR_NULL"
sleep 2

echo "[INFO] - Instalando o Grafana Server 8..."
apt install ./grafana_8.5.11_amd64.deb &> "$DIR_NULL"
sleep 2

echo "[INFO] - Atualizando os Plugins..."
grafana-cli plugins update-all &> "$DIR_NULL"
sleep 1

echo "[INFO] - Restartando o Grafana Server..."
systemctl restart grafana-server &> "$DIR_NULL"
sleep 1

#~--------------- Alterando Porta de Acesso:

echo "[INFO] - Alterando a porta do Grafana..."
sed -i 's/;http_port = 3000/http_port = 53000/' "$DIR_GRAFANA" &> "$DIR_NULL"
sleep 1

echo "[INFO] - Instalando o Plugin Zabbix..."
grafana-cli plugins install alexanderzobnin-zabbix-app &> "$DIR_NULL"
sleep 1

echo "[INFO] - Atualizando os Plugins..."
grafana-cli plugins update-all &> "$DIR_NULL"
sleep 1

echo "[INFO] - Iniciando os Serviços..."
systemctl daemon-reload &> "$DIR_NULL"
systemctl enable grafana-server &> "$DIR_NULL"
systemctl start grafana-server &> "$DIR_NULL"
systemctl restart apache2 &> "$DIR_NULL"
systemctl restart grafana-server &> "$DIR_NULL"
sleep 2

#~--------------------------- Proxy Grafana:
#
# Pendente para proximas atualizações...
#
#
#~------------------- Finalizando Instalação:

echo "[INFO] - PREPARANDO PARA FINALIZAR..."
sleep 2

echo "[INFO] - LIMPANDO SISTEMA..."
sleep 1
apt autoremove -y &> "$DIR_NULL"
apt clean &> "$DIR_NULL"
rmdir -rf "$DIR_ARQUIVOS" &> "$DIR_NULL"
sleep 2

echo "[INFO] - Instalação concluida com sucesso..!"
sleep 1

figlet -c OBRIGADO!
sleep 2

#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------


#===============================
#===============================
#===============================
