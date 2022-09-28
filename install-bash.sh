#!/bin/bash
#
#********************************************************************
#
# Script de Pós instalação Debian11!
#          
#********************************************************************
#
# Algumas alterações realizadas durante o processo:
#
#     - Alteração do arquivo bashrc,
#       para melhor produtividade.
#********************************************************************
#
# Versão do Script:  1.0
# Ultima edição:     27/09/22
# Autor:             Jardson Viana (JvConsult)
# Contato:           jardson.consultoria@gmail.com
#
#********************************************************************
#
# Homologando em ambiente Debian 11!
#
#~------------------------ Pós instalação debian:------------------~#



#---- VARIAVEIS DE AMBIENTE:

DIR_IPV4="/home/jardson/getipv4"
DIR_IPV6="/home/jardson/getipv6"

#---- Instalação dos pacotes pós instalação:

echo "[ INFO ] - INICIANDO PÓS INSTALAÇÃO DEBIAN11..."
sleep 2

echo "[ INFO ] - DESABILITANDO TEMPORARIO IPv6..."
sleep 2
sysctl -w net.ipv6.conf.all.disable_ipv6=1 &> /etc/null
sysctl -w net.ipv6.conf.default.disable_ipv6=1 &> /etc/null
sysctl -w net.ipv6.conf.lo.disable_ipv6=1 &> /etc/null

echo "[ INFO ] - ATUALIZANDO SISTEMA..."
apt update &> /etc/null
apt upgrade -y &> /etc/null
sleep 2

echo "[ INFO ] - INSTALANDO PACOTES NECESSÁRIOS..."
apt install \
vim bash-completion fzf grc \
iotop htop ipcalc whois iftop \
traceroute mtr-tiny net-tools \
neofetch wget figlet -y &> /etc/null
sleep 2

figlet -c "JV CONSULT ISP"
sleep 2

echo "[ INFO ] - CONCLUINDO MODIFICAÇÕES..."
sleep 2

#---- Editando o Bash:

echo '' >> /etc/bash.bashrc
echo '# Autocompletar extra' >> /etc/bash.bashrc
echo 'if ! shopt -oq posix; then' >> /etc/bash.bashrc
echo '  if [ -f /usr/share/bash-completion/bash_completion ]; then' >> /etc/bash.bashrc
echo '    . /usr/share/bash-completion/bash_completion' >> /etc/bash.bashrc
echo '  elif [ -f /etc/bash_completion ]; then' >> /etc/bash.bashrc
echo '    . /etc/bash_completion' >> /etc/bash.bashrc
echo '  fi' >> /etc/bash.bashrc
echo 'fi' >> /etc/bash.bashrc
sed -i 's/"syntax on/syntax on/' /etc/vim/vimrc
sed -i 's/"set background=dark/set background=dark/' /etc/vim/vimrc
cat <<EOF >/root/.vimrc
set showmatch " Mostrar colchetes correspondentes
set ts=4 " Ajuste tab
set sts=4 " Ajuste tab
set sw=4 " Ajuste tab
set autoindent " Ajuste tab
set smartindent " Ajuste tab
set smarttab " Ajuste tab
set expandtab " Ajuste tab
"set number " Mostra numero da linhas
EOF
sed -i "s/# export LS_OPTIONS='--color=auto'/export LS_OPTIONS='--color=auto'/" /root/.bashrc
sed -i 's/# eval "`dircolors`"/eval "`dircolors`"/' /root/.bashrc
sed -i 's/# eval "$(dircolors)"/eval "$(dircolors)"/' /root/.bashrc
sed -i "s/# alias ls='ls \$LS_OPTIONS'/alias ls='ls \$LS_OPTIONS'/" /root/.bashrc
sed -i "s/# alias ll='ls \$LS_OPTIONS -l'/alias ll='ls \$LS_OPTIONS -l'/" /root/.bashrc
sed -i "s/# alias l='ls \$LS_OPTIONS -lA'/alias l='ls \$LS_OPTIONS -lha'/" /root/.bashrc
# echo '# Para usar o fzf use: CTRL+R' >> ~/.bashrc
echo 'source /usr/share/doc/fzf/examples/key-bindings.bash' >> ~/.bashrc
echo "alias grep='grep --color'" >> /root/.bashrc
echo "alias egrep='egrep --color'" >> /root/.bashrc
echo "alias ip='ip -c'" >> /root/.bashrc
echo "alias diff='diff --color'" >> /root/.bashrc
echo "alias tail='grc tail'" >> /root/.bashrc
echo "alias ping='grc ping'" >> /root/.bashrc
echo "alias ps='grc ps'" >> /root/.bashrc
echo "PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;31m\]\u\[\033[01;34m\]@\[\033[01;33m\]\h\[\033[01;34m\][\[\033[00m\]\[\033[01;37m\]\w\[\033[01;34m\]]\[\033[01;31m\]\\$\[\033[00m\] '" >> /root/.bashrc
# echo "echo;echo 'Q29udHJpYnVhIGNvbSBodHRwczovL2Jsb2cucmVtb250dGkuY29tLmJyL2RvYXIgOikK'|base64 --decode; echo;" >> /root/.bashrc

echo "[ INFO ] - CONCLUIDO PÓS INSTALAÇÃO...!"

touch getipv4 "$DIR_IPV4"
#touch getipv6 "$DIR_IPV6"
ip ad sh |grep -i global |grep -i brd |awk '{print $2}' |cut -d / -f1 > getipv4
#ip ad sh |grep -i global |grep -i inet6 |awk '{print $2}' |cut -d / -f1 > getipv6

echo "[ INFO ] - SEU ENDEREÇO IPv4:"
figlet < $DIR_IPV4
sleep 2

#echo "[ INFO ] - SEU ENDEREÇO IPv6:"
#figlet < /home/jardson/getipv6
#sleep 2

rm -f $DIR_IPV4

figlet -c OBRIGADO!
sleep 2

bash