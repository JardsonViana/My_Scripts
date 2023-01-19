// Instalação Docker Compose
===============================================
````
curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
````
// Verificando a Versão Docker Compose
===============================================
````
docker-compose --version
````
// Instação Nginx Proxy Manager
===============================================
````
mkdir /etc/nginx-proxy
mkdir /etc/nginx-proxy/{data,letsencrypt}
````
````
vim /etc/nginx-proxy/docker-compose.yml
````
// Executando o Docker Compose:
===============================================
````
cd /etc/nginx-proxy
docker-compose up -d
````
// Verificando os containers ativos
===============================================
````
docker ps -a
````
----------

Abra em navegador http://IP_SERVIDOR/ se tudo ocorreu bem.

Agora abra na porta 81 http://IP_SERVIDOR:81/ e entre com:
````
Email: admin@example.com 
Password: changeme
````

// Dados persistentes para backup:
===============================================
````
/etc/nginx-proxy/data
/etc/nginx-proxy/letsencrypt
````
