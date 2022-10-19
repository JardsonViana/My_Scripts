#!/bin/bash
##########################################
#
# SCRIPT DE INSTALAÇÃO DOCKER - DEBIAN 11
#
##########################################

#-------------------------
#-Variaveis Globais:
DOCKER_REMOVER=(
   docker
   docker-engine
   docker.io
)

#-------------------------

#~------------------------------------ INSTALAÇÃO SERVIDOR DOCKER:

echo "[INFO] - Removendo todos APP's Docker's Pré instalados..."
apt remove -y "$DOCKER_REMOVER" &> /etc/null
sleep 2

echo "[INFO] - Instalando os pacotes necessários..."
apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  gnupg \
  gnupg1 \
  gnupg2 \
  &> /etc/null
sleep 2

echo "[INFO] - Adicionando repositório..."
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
sleep 1
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sleep 2

echo "[INFO] - Carregando repositorio e instalando docker..."
apt update &> /etc/null
apt install -y docker-ce &> /etc/null


#-Habilitando Redes:

echo "[INFO] - Habilitando Forward em IPv4 e IPv6..."
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
sleep 1

echo "[INFO] - Habilitando Forward v4 e v6 no arquivo systctl.conf..."
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/' /etc/sysctl.conf
sleep 2

echo "[INFO] - Carregando mudanças no sysctl.conf..."
sysctl -p /etc/sysctl.conf &> /home/jardson/retorno_sysctl.txt
sleep 1

echo "[INFO] - Criando Rede no Docker..."
docker network create rede-docker -d bridge --subnet 100.202.0.0/24 &> /etc/null
sleep 2

echo "[INFO] - Finalizado instalação!!!"

