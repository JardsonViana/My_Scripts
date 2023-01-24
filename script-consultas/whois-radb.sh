#!/bin/bash
#
#********************************************************************
#
# Script de Consulta Whois
#          
#********************************************************************
#
# Versão do Script:  1.0
# Ultima edição:     24/01/23
# Autor:             Jardson Viana (JvConsult)
# Contato:           jardson.viana@jvconsultisp.com.br
#
#********************************************************************
#
# Homologando em ambiente Debian 11!
#
#~------------------------ Consulta de AS-SET Whois:------------------~#

#----Variaveis de Ambiente:
ASN="$1"

#----Código:

whois -h whois.radb.net "$ASN" || exit 10
