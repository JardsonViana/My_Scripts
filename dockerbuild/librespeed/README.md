
// Buildando a imagem docker:
1 - Criar o arquivo Dockerfile dentro da pasta;
2 - realizar a compilação com o comando: 
````
        docker build . -t jvisp/librespeed-apache:1.0
````

// Exemplo de aplicação no Host:

````
docker run -itd \
        --name librespeed01 \
        --hostname librespeed01 \
        --network rede-docker \
        --restart always \
        -p 60180:80 \
        -m 128M \
        -c 307 \
        -v librespeed01:/opt/librespeed/ \
        jvisp/librespeed-apache:1.0
        
````

Adicionar o banco de dados do librespeed no server mysql...
----

// Exemplo de configuração mysql para o librespeed:

mariadb -u root -p

````
CREATE DATABASE librespeed;
GRANT ALL PRIVILEGES ON librespeed.* TO 'librespeed'@'localhost' IDENTIFIED BY 'SUA_SENHA';
FLUSH PRIVILEGES;
quit;
````

-----
mariadb -p -u librespeed
````
USE librespeed;
 
CREATE TABLE `speedtest_users` (
  `id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` text NOT NULL,
  `ispinfo` text,
  `extra` text,
  `ua` text NOT NULL,
  `lang` text NOT NULL,
  `dl` text,
  `ul` text,
  `ping` text,
  `jitter` text,
  `log` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
ALTER TABLE `speedtest_users`
  ADD PRIMARY KEY (`id`);
 
ALTER TABLE `speedtest_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;COMMIT;
 
show tables;

````
----

// Para adicionar uma Logo ao librespeed:
- Subir via FTP um logotipo para a pasta /home/USER
- Copiar para o diretorio do volume do librespeed:
````
mv /home/fulano/logo.png /var/lib/docker/volumes/librespeed01/_data/logo.png
````


----

// Criando um virtualhost para o librespeed no arquivo librespeed.conf

````
<virtualhost *:80>
        ServerName speed.jvconsultisp.com.br
        ServerAdmin noc@jvconsultisp.com.br
        DocumentRoot /var/www/librespeed 
        <directory /var/www/librespeed/ >
                Options FollowSymLinks
                AllowOverride All
        </directory> 
        LogLevel warn 
        ErrorLog ${APACHE_LOG_DIR}/error_librespeed.log
        CustomLog ${APACHE_LOG_DIR}/access_librespeed.log combined
</virtualhost>
````

##############################################################
