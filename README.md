# projeto_pratico_brute_force

🛡️Este projeto faz parte de um desafio prático da DIO. O objetivo é simular cenários de ataques de força bruta em um ambiente controlado para entender vulnerabilidades em serviços comuns e propor medidas de segurança.
---

🚀 Tecnologias e Ferramentas
Kali Linux: Sistema operacional para testes de invasão. (versão 2026.1)

Metasploitable 2: Máquina virtual propositalmente vulnerável (Alvo). (Last Update: 2019-08-19)

Oracle VM VirtualBox: Gerenciador de virtualização.

Nmap: Ferramenta de varredura e reconhecimento de rede.

Medusa: Ferramenta de força bruta (brute-force) modular e paralela.

---

🛠️ Configuração do Ambiente
1. Rede Virtual
As VMs foram configuradas em modo Host-only (Placa de Rede Exclusiva de Hospedeiro) para garantir que os testes de segurança ficassem isolados da rede externa, evitando riscos.

2. Solução de Problemas (Troubleshooting)
Durante a montagem, a VM Metasploitable apresentou falhas de boot e tela preta.

Problema: O disco .vmdk estava associado a uma controladora SATA.

Solução: Removi a controladora SATA e adicionei o disco a uma Controladora IDE, garantindo a compatibilidade com o kernel do sistema legado.

---

Com base no desafio da DIO e em toda a jornada de resolução de problemas que tivemos até agora (desde o erro de boot da VM até a correção do comando do Medusa), aqui está um exemplo de README.md profissional para você copiar, adaptar e subir no seu GitHub.

🛡️ Auditoria de Segurança: Ataque de Força Bruta com Medusa
Este projeto faz parte de um desafio prático da DIO (Digital Innovation One). O objetivo é simular cenários de ataques de força bruta em um ambiente controlado para entender vulnerabilidades em serviços comuns e propor medidas de mitigação.

🚀 Tecnologias e Ferramentas
Kali Linux: Sistema operacional para testes de invasão.

Metasploitable 2: Máquina virtual propositalmente vulnerável (Alvo).

Oracle VM VirtualBox: Gerenciador de virtualização.

Nmap: Ferramenta de varredura e reconhecimento de rede.

Medusa: Ferramenta de força bruta (brute-force) modular e paralela.

🛠️ Configuração do Ambiente
1. Rede Virtual
As VMs foram configuradas em modo Host-only (Placa de Rede Exclusiva de Hospedeiro) para garantir que os testes de segurança ficassem isolados da rede externa, evitando riscos.

2. Solução de Problemas (Troubleshooting)
Durante a montagem, a VM Metasploitable apresentou falhas de boot e tela preta.

Problema: O disco .vmdk estava associado a uma controladora SATA.

Solução: Removi a controladora SATA e adicionei o disco a uma Controladora IDE, garantindo a compatibilidade com o kernel do sistema legado.

🔍 Desenvolvimento do Projeto
Passo 1: Reconhecimento de Rede
Utilizei o nmap para identificar o IP do alvo e os serviços ativos:

-------------------------------------------
nmap -v -sn 192.168.56.100-200 | grep 192 |
-------------------------------------------
