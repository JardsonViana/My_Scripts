// Instalação do Looking Glass:
=====================================
````
docker run -itd \
        --name looking01 \
        --hostname looking01 \
        --network rede-docker \
        --restart always \
        -p 60480:80 \
        -m 128M \
        -c 204 \
        -v looking01:/var/www/html/lg/ \
        jvisp/looking-glass:1.0
 ````       
// Pós-Instalação:
=====================================
````
cd /var/lib/docker/volumes/looking01/_data
````
editar o arquivo lg_config.php e alterar os valores das variáveis:
````
$_CONFIG[‘asn’] – Seu AS para exibição na página LG.
$_CONFIG[‘company’] – Nome da empresa para exibição na página LG.
$_CONFIG[‘logo’] – O logotipo da sua empresa para exibição na página LG.
$_CONFIG[‘color’] – Cor principal dos elementos de design na página LG.
````
----
A configuração dos roteadores é especificada em $_CONFIG[‘routers’], no seguinte formato:
````
$_CONFIG['routers'] = array
(
    'router1' = array
    (
        // Router valores
    ),
    'router2' = array
    (
        // Router valores
    ),
    // etc.
);
````
----
No nosso arquivo atual já consta com 3 exemplos sendo um o do IX.BR (SP). Basta você configurar seu roteado seguindo os padrões:

- url – Endereço no formato: [ssh|telnet]://[login]:[password]@[host]:[port].
- pingtraceurl – Endereço URL para ferramentas de ping e traceroute para roteadores Quagga (ou * FALSE *).
- description – Descrição do roteador.
- group – Nome do grupo de roteadores (AS) (ou FALSE).
- ipv6 – Suporte IPv6? (TRUE ou FALSE).
- os – Tipo do Router (ios, mikrotik, quagga, junos, openbgpd, huawei).
---

- Configurações ajustada basta acessar o endereço http://ip-servidor/lg
