#!/bin/bash
#
#********************************************************************
#
# Script de Gerar prefix-list em huawei
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
#~------------------------ Gerador de Prefix-list Huawei:------------------~#

#----Variaveis de Ambiente:
AS_SET="$1"

#----Código:

bgpq4 -U -r 22 -R 24 -S RADB "$AS_SET"
