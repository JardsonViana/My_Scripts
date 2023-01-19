// Servidor PHPIPAM:
===========================================
````
docker run -itd \
        --name phpipam01 \
        --hostname phpipam01 \
        --network rede-docker \
        --restart always \
        -p 60380:80 \
        -m 128M \
        -c 204 \
        -v phpipam01:/opt/phpipam/ \
        jvisp/phpipam:1.5.0
````
// Banco de Dados:
===========================================
````
CREATE DATABASE phpipam;
GRANT ALL PRIVILEGES ON phpipam.* TO 'phpipam'@'localhost' IDENTIFIED BY 'SUA.SENHA';
FLUSH PRIVILEGES;
quit;
````
// Pós-Instalação:
===========================================
````
cd /var/lib/docker/volumes/phpipam01/_data/
vim config.php
````

````
$db['host'] = "localhost";
$db['user'] = "phpipam";
$db['pass'] = "SUA.SENHA";
$db['name'] = "phpipam";
````

Altere :
define(‘BASE’, “/”);
para:
define(‘BASE’, “/phpipam/”);

// Pós-Instalação - WEB:
===========================================

- Agora acesse seu servidor em seu navegado: http://ip-server.ou.dominio/phpipam/
- Clique em [New phpipam installation]
- Clique em [Automatic database installation]
- Entre com seu usuario: 
- phpipam e senha senha de conexão do banco de dados (SUA.SENHA), 
- clique em [Show advanced options], 
- DESMARQUE as opções: 
- Create new database e Set permissions to tables 
- e após em [Install phpipam database]
