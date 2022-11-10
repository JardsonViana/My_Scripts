# Apache: Como configurar um VirtualHost com proxy reverso


#### Instala biblioteca do Apache
```bash
sudo apt-get install libapache2-mod-proxy-html
```

#### Habilita os módulos no Apache
```bash
sudo a2enmod proxy proxy_http proxy_connect proxy_html xml2enc
```

#### Reinicia o Apache
```bash
sudo service apache2 restart
```

#### Cria o arquivo com novo site
```bash
sudo nano /etc/apache2/sites-available/site-proxy.conf
```

```apache
<VirtualHost *:80>

    # Altere o email do administrador.
    ServerAdmin hostmaster@example.com
    ProxyRequests off
    DocumentRoot /var/www
    ProxyPreserveHost On

    # Altere a URL que vai ser usada
    # para acessar o site
    ServerName example.com

    # Caso mais de uma URL for usada,
    # adicione as outras aqui, uma em
    # cada linha.
    ServerAlias www.example.com

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    # Alguns possíveis valores: debug, info, notice, warn, error, crit,
    # alert, emerg.
    LogLevel error

    <Location />
        # Configure aqui a URL do site que se quer acessar.
        ProxyPass http://internal.example.com:8444/
        ProxyPassReverse http://internal.example.com:8444/
        Order allow,deny
        Allow from all
    </Location>
</VirtualHost>
```

#### Adiciona o site ao Apache
```bash
sudo a2ensite site-proxy
```

#### Reinicia (de novo) o Apache
```bash
sudo service apache2 restart
```
