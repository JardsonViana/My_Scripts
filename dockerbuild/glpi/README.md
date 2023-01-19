// Buildando a imagem docker:
1 - Criar o arquivo Dockerfile dentro da pasta;
2 - realizar a compilação com o comando: 
 ´´´´ 
      docker build . -t jvisp/glpi-apache:1.0
 ´´´´ 


// Exemplo de aplicação no Host:

´´´´
docker run -itd \
        --name glpi01 \
        --hostname glpi01 \
        --network rede-docker \
        --restart always \
        -p 60280:80 \
        -m 128M \
        -c 204 \
        -v glpi01:/var/www/html/glpi/ \
        jvisp/glpi-apache:1.0
 ´´´´

Adicionar o banco de dados do glpi no server mysql...


----
// Exemplo de configuração mysql para o librespeed:

mariadb -u root -p
´´´´
CREATE DATABASE glpi;
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost' IDENTIFIED BY 'SUA_SENHA';
FLUSH PRIVILEGES;
quit;
´´´´


#---------- Por segurança renomeie a pasta install.

´´´´
cd /var/www/html/glpi/
mv install/ install_XGT29122016
´´´´


Agora acesse em seu navegador http://IP-SERVIDOR/
