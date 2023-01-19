
# Buildando a imagem docker:

1 - Criar o arquivo Dockerfile dentro da pasta;

2 - realizar a compilação com o comando: 

````docker build . -t jvisp/wordpress-apache:1.0````


// Exemplo de aplicação no Host:
````

docker run -itd \
        --name wordpress01 \
        --hostname wordpress01 \
        --network rede-docker \
        --restart always \
        -p 60080:80 \
        -m 128M \
        -c 204 \
        -v wordpress01:/var/www/wordpress/ \
        jvisp/wordpress-apache:1.0
````

Adicionar o banco de dados do wordpress no server mysql...

------

// Exemplo de configuração mysql para o librespeed:

mariadb -u root -p
````
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'SUA_SENHA';
FLUSH PRIVILEGES;
quit;
````

------

// Criando um virtualhost para o wordpress no arquivo wordpress.conf

-----------------
````
<virtualhost *:80>
        ServerName blog.jvconsultisp.com.br
        ServerAdmin noc@jvconsultisp.com.br
 
        DocumentRoot /var/www/blog.jvconsultisp.com.br
 
        <directory /var/www/blog.jvconsultisp.com.br/ >
                Options FollowSymLinks
                AllowOverride All
        </directory> 
 
        LogLevel warn 
        ErrorLog ${APACHE_LOG_DIR}/error_blog.jvconsultisp.com.br.conf.log
        CustomLog ${APACHE_LOG_DIR}/access_blog.jvconsultisp.com.br.conf.log combined
</virtualhost>
````
-----------------

#--------- Modificar o tamanho de upload do arquivo:

// Alterar no arquivo PHP.ini
nano php.ini
````
php_value upload_max_filesize 512M
php_value post_max_size 512M
php_value max_execution_time 300
php_value max_input_time 300
````

#-------- Sugestão de plugin para backups:

- All-in-one WP Migration


