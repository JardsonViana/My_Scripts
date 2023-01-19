// Instalação do Portainer-ce:
===============================
````
docker run -itd \
        --name portainer01 \
        --hostname portainer01 \
        --network rede-docker \
        --restart always \
        -p 9200:9000 \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer:/data \
        portainer/portainer-ce
````
// Pós-Instalação - WEB:
===============================

- Acesse: http://HOST:9200
- Defina um usuario [USER]
- Defina a senha em [PASSWORD]
- Seleciona a Opção [GET STATERD]
---
// Restaurando Backup - WEB:
===============================

- Após instalação acesso: http://HOST:9200
- Selecione a opção [RESTORE]
- Suba o Backup do banco.
