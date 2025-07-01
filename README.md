# Projeto Roadmap de Cybersegurança: Do Iniciante ao Profissional

---
# Setup-Debian-Server

Este repositório automatiza a configuração de um ambiente Debian para uso como Home Lab focado em segurança, usando Docker para criar um ambiente controlado.

---

## Objetivo

Fornecer scripts para preparar um laboratório Debian com as ferramentas necessárias para estudos, simulações e testes, seguindo um roadmap de aprendizado.

---

## Pré-requisitos

- Sistema Debian ou derivado (Ubuntu, etc).
- Acesso sudo para instalação de pacotes.
- Conexão com internet.

---

## Como usar

1. Clone este repositório ou baixe os scripts.
2. Execute o script de setup:

```bash
chmod +x 1.1.Setup.sh
./1.1.Setup.sh

---

## Sumário

- Níveis de Evolução  
- Fase 1 – Exploração Fácil (Semanas 1-2)  
- Fase 2 – Análise Intermediária (Semanas 3-5)  
- Fase 3 – Pentest & Monitoramento Profissional (Semanas 6-8)  
- Fase 4 – Automação & Integração Avançada (Nível Sênior)  
- Dicas Gerais  
- Próximos Passos  

---

## Níveis de Evolução

| Nível       | O que você aprende e faz                                                      | Ferramentas e recursos chave                                  |
| ----------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------ |
| **Iniciante** | Mapear rede, identificar hosts, executar comandos básicos                    | `nmap`, `whois`, `geoiplookup`, `LocalTunnel`                |
| **Júnior**  | Monitorar tráfego, configurar IDS/IPS, logs básicos, usar Cloudflare para regras básicas | `Suricata`, `IPTables`, `Squid`, `multitail`, Cloudflare Dashboard e Firewall Rules |
| **Pleno**   | Realizar pentests, simular phishing, analisar pacotes, avaliar proteção Cloudflare e logs avançados | `OpenVAS`, `SET`, `tcpdump`, `Wireshark`, `Nuclei`, Cloudflare Analytics |
| **Sênior**  | Automatizar, criar dashboards, integração e alertas usando APIs Cloudflare e sistemas externos | `ELK Stack`, `Grafana`, playbooks, Cloudflare API, `Ansible`, `SOAR` |

---

## Fases Semanais e Setup Detalhado

### Fase 1 – Exploração Fácil (Semanas 1-2)

**Objetivo:**  
Aprender conceitos básicos de redes e segurança; instalar e usar ferramentas essenciais para reconhecimento.

**Atividades:**  
1. Criar ambiente de laboratório (máquina virtual ou container)  
2. Mapear redes e hosts usando `nmap`  
3. Realizar consultas DNS com `whois` e geolocalização com `geoiplookup`  
4. Usar `LocalTunnel` para expor serviços locais e praticar reconhecimento remoto  

**Resultado Esperado:**  
Conhecimento básico de topologia de rede e identificação de sistemas

---

### Fase 2 – Análise Intermediária (Semanas 3-5)

**Objetivo:**  
Monitorar e analisar tráfego, configurar proteções básicas e trabalhar com logs, integrando Cloudflare.

**Atividades:**  
1. Instalar e configurar IDS/IPS com `Suricata`  
2. Gerenciar firewall com `IPTables`  
3. Configurar proxy com `Squid`  
4. Analisar logs em tempo real com `multitail`  
5. Criar conta no Cloudflare e adicionar domínio para proteção básica  
6. Configurar regras básicas de firewall no Cloudflare (WAF) e usar modo “Under Attack”  
7. Monitorar tráfego e eventos via painel Cloudflare  

**Resultado Esperado:**  
Capacidade de detectar e reagir a ataques simples, monitorar e configurar regras básicas na nuvem

---

### Fase 3 – Pentest & Monitoramento Profissional (Semanas 6-8)

**Objetivo:**  
Testar vulnerabilidades, simular ataques e monitorar de forma avançada, avaliando proteção Cloudflare.

**Atividades:**  
1. Executar varreduras e pentests com `OpenVAS`  
2. Simular ataques de phishing com `SET`  
3. Capturar e analisar pacotes com `tcpdump` e `Wireshark`  
4. Automatizar scanners de vulnerabilidades com `Nuclei`  
5. Analisar detalhadamente logs e analytics do Cloudflare para identificar ameaças  
6. Testar a eficácia das regras WAF e proteções DDoS do Cloudflare  

**Resultado Esperado:**  
Habilidade para realizar testes de invasão, avaliar proteções avançadas em ambientes protegidos por Cloudflare

---

### Fase 4 – Automação & Integração Avançada (Nível Sênior)

**Objetivo:**  
Automatizar respostas, criar dashboards e integrar alertas usando API do Cloudflare e ferramentas externas.

**Atividades:**  
1. Automatizar ações via API do Cloudflare (bloqueios automáticos, ajustes em regras)  
2. Criar dashboards integrados com `ELK Stack` e `Grafana` incluindo dados do Cloudflare  
3. Desenvolver playbooks de resposta automática com `Ansible` ou ferramentas SOAR  
4. Configurar alertas em tempo real e integração com sistemas de comunicação (Slack, email)  

**Resultado Esperado:**  
Implementar monitoramento e respostas automáticas avançadas, com integração entre Cloudflare e sistemas corporativos

---
