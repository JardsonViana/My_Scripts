
// Buildando a imagem docker:
1 - Criar o arquivo Dockerfile dentro da pasta;
2 - realizar a compilação com o comando: 
````
        docker build . -t jvconsult/dataserver:1.0
````

// Exemplo de aplicação no Host:

````
docker run -itd \
        --name dataserver01 \
        --hostname dataserver01 \
        --network rede-docker \
        --restart always \
        -p 60580:80 \
        -m 128M \
        -c 107 \
        -v dataserver01:/var/www/jvconsult/ \
        jvisp/dataserver:1.0
        
````



----


##############################################################
