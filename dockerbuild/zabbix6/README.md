<h1 align='center'>Exemplo de utilização:</h1>

// Buildando a imagem docker das 3 camadas do zabbix:
1 - Criar o arquivo Dockerfile dentro da pasta;
```
mkdir -p /tmp/zabbix-server
touch Dockerfile -P /tmp/zabbix-server

mkdir -p /tmp/zabbix-front
touch Dockerfile -P /tmp/zabbix-front

mkdir -p /tmp/zabbix-agent
touch Dockerfile -P /tmp/zabbix-agent
```


2 - Atualiza os arquivos Dockerfile com as instruções e realizar a compilação com o comando: 
```
docker build . -t jvconsult/zabbix6-frontend:1.0
docker build . -t jvconsult/zabbix6-server:1.0
docker build . -t jvconsult/zabbix6-agent:1.0
```



// Exemplo de aplicação no Host:
-Zabbix-Server:
```
docker run -itd \
        --name zabbix-server \
        --hostname zabbix-server \
        --network rede-publica \
        --restart always \
        --ip 45.xx.xx.10 \
        -v zabbix-server:/lib/zabbix \
        jvconsult/zabbix6-server:1.0
```
-Zabbix-Front:
```
docker run -itd \
        --name zabbix-front \
        --hostname zabbix-front \
        --network rede-publica \
        --restart always \
        --ip 45.xx.xx.10 \
        -v zabbix-front:/etc/zabbix \
        jvconsult/zabbix6-front:1.0
```
-Zabbix-Agent
```
docker run -itd \
        --name zabbix-agent \
        --hostname zabbix-agent \
        --network rede-publica \
        --restart always \
        --ip 45.xx.xx.10 \
        -v zabbix-agent:/etc/zabbix \
        jvconsult/zabbix6-agent:1.0
```
Adicionar o banco de dados do zabbix-server no server mysql...
----


// Exemplo de configuração mysql para o librespeed:
```
mariadb -u root -p
```
---------------------------
```
CREATE DATABASE zabbix;
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'%' IDENTIFIED BY 'SUA_SENHA';
FLUSH PRIVILEGES;
quit;
```
---------------------------

##############################################################

Agora acesse em seu navegador http://IP-SERVIDOR/zabbix/


Extra:
-------
// Criando rede IPvlan no docker:

```
docker network create \
-d ipvlan \
--subnet=RANGE_IP \
--gateway=IP_GATEWAY \
-o parent=PLACA_REDE \
rede-pulica
```
