#!/bin/bash

# --- Cores para melhor visualização ---
GREEN='\033[0;32m'
YELLOW='\033[0;33m' # Corrigido para 0;33m
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "<span class="math-inline">\{GREEN\}\-\-\- Iniciando a configuração do Debian\-erver\- Home Lab \-\-\-</span>{NC}"

# --- 1. Verificar e instalar pré-requisitos (Git, Docker, Docker Compose) ---
echo -e "<span class="math-inline">\{YELLOW\}Verificando e instalando pré\-requisitos \(Git, Docker, Docker Compose\)\.\.\.</span>{NC}"

# Atualiza e faz upgrade dos pacotes
sudo apt update && sudo apt upgrade -y || { echo -e "<span class="math-inline">\{RED\}Erro ao atualizar/fazer upgrade dos pacotes\.</span>{NC}"; exit 1; }

# Instala Git
if ! command -v git &> /dev/null
then
    echo -e "<span class="math-inline">\{YELLOW\}Git não encontrado\. Instalando Git\.\.\.</span>{NC}"
    sudo apt install git -y || { echo -e "<span class="math-inline">\{RED\}Erro ao instalar Git\.</span>{NC}"; exit 1; }
else
    echo -e "<span class="math-inline">\{GREEN\}Git já está instalado\.</span>{NC}"
fi

# Instala Docker
if ! command -v docker &> /dev/null
then
    echo -e "<span class="math-inline">\{YELLOW\}Docker não encontrado\. Instalando Docker\.\.\.</span>{NC}"
    sudo apt install docker.io -y || { echo -e "<span class="math-inline">\{RED\}Erro ao instalar Docker\.</span>{NC}"; exit 1; }
    sudo systemctl start docker || { echo -e "<span class="math-inline">\{RED\}Erro ao iniciar o serviço Docker\.</span>{NC}"; exit 1; }
    sudo systemctl enable docker || { echo -e "<span class="math-inline">\{RED\}Erro ao habilitar o serviço Docker\.</span>{NC}"; exit 1; }
    # Adicionar o usuário ao grupo docker para evitar o uso de sudo
    sudo usermod -aG docker "<span class="math-inline">USER"
echo \-e "</span>{GREEN}Docker instalado. Você precisará <span class="math-inline">\{YELLOW\}reiniciar sua sessão ou fazer logout/login</span>{GREEN} para que as permissões do Docker entrem em vigor.<span class="math-inline">\{NC\}"
else
echo \-e "</span>{GREEN}Docker já está instalado.<span class="math-inline">\{NC\}"
if \! sudo systemctl is\-active \-\-quiet docker; then
echo \-e "</span>{YELLOW}O serviço Docker não está ativo. Iniciando...<span class="math-inline">\{NC\}"
sudo systemctl start docker \|\| \{ echo \-e "</span>{RED}Erro ao iniciar o serviço Docker.<span class="math-inline">\{NC\}"; exit 1; \}
fi
if \! sudo systemctl is\-enabled \-\-quiet docker; then
echo \-e "</span>{YELLOW}O serviço Docker não está habilitado para iniciar com o sistema. Habilitando...<span class="math-inline">\{NC\}"
sudo systemctl enable docker \|\| \{ echo \-e "</span>{RED}Erro ao habilitar o serviço Docker.<span class="math-inline">\{NC\}"; exit 1; \}
fi
fi
\# Instala Docker Compose
if \! command \-v docker\-compose &\> /dev/null
then
echo \-e "</span>{YELLOW}Docker Compose não encontrado. Instalando Docker Compose...<span class="math-inline">\{NC\}"
sudo apt install docker\-compose \-y \|\| \{ echo \-e "</span>{RED}Erro ao instalar Docker Compose.<span class="math-inline">\{NC\}"; exit 1; \}
else
echo \-e "</span>{GREEN}Docker Compose já está instalado.<span class="math-inline">\{NC\}"
fi
echo \-e "</span>{GREEN}Pré-requisitos verificados e instalados.<span class="math-inline">\{NC\}"
\-\-\-
\# \*\*2\. Clonar o repositório Debian\-erver\-\*\*
echo \-e "</span>{YELLOW}Clonando o repositório Debian-erver-...${NC}"

PROJECT_DIR="debian-server-lab"
REPO_URL="https://github.com/Juliocesar-sec/Debian-erver-.git"
DEBIAN_SERVER_REPO_NAME="Debian-erver-" # Nome exato do diretório clonado pelo git

if [ -d "<span class="math-inline">PROJECT\_DIR" \]; then
echo \-e "</span>{YELLOW}Diretório '<span class="math-inline">PROJECT\_DIR' já existe\. Removendo para garantir uma instalação limpa\.\.\.</span>{NC}"
    rm -rf "<span class="math-inline">PROJECT\_DIR" \|\| \{ echo \-e "</span>{RED}Erro ao remover diretório existente.${NC}"; exit 1; }
fi

mkdir "<span class="math-inline">PROJECT\_DIR" \|\| \{ echo \-e "</span>{RED}Erro ao criar diretório do projeto.${NC}"; exit 1; }
cd "<span class="math-inline">PROJECT\_DIR" \|\| \{ echo \-e "</span>{RED}Erro ao entrar no diretório do projeto.${NC}"; exit 1; }

git clone "<span class="math-inline">REPO\_URL" \|\| \{ echo \-e "</span>{RED}Erro ao clonar o repositório '<span class="math-inline">REPO\_URL'\.</span>{NC}"; exit 1; }

echo -e "<span class="math-inline">\{GREEN\}Repositório Debian\-erver\- clonado com sucesso em '</span>{PWD}/<span class="math-inline">\{DEBIAN\_SERVER\_REPO\_NAME\}'\.</span>{NC}"

---

# **3. Criar Dockerfile**

echo -e "<span class="math-inline">\{YELLOW\}Criando Dockerfile\.\.\.</span>{NC}"

cat <<EOF > Dockerfile
# Usa a imagem base mais recente do Debian
FROM debian:latest

# Define um argumento para a versão do Debian (opcional, pode ser ajustado)
ARG DEBIAN_FRONTEND=noninteractive

# Atualiza os pacotes e instala ferramentas essenciais
RUN apt update && \\
    apt upgrade -y && \\
    apt install -y \\
    curl \\
    wget \\
    git \\
    vim \\
    net-tools \\
    iputils-ping \\
    sudo \\
    --no-install-recommends && \\
    rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho dentro do container
WORKDIR /root

# O Debian-erver- não é uma aplicação web que expõe uma porta por padrão,
# mas se você instalar um servidor web como Apache/Nginx, pode expor a porta 80 ou 443.
# EXPOSE 80
# EXPOSE 443
EOF

echo -e "<span class="math-inline">\{GREEN\}Dockerfile criado com sucesso\.</span>{NC}"

---

# **4. Criar docker-compose.yml**

echo -e "<span class="math-inline">\{YELLOW\}Criando docker\-compose\.yml\.\.\.</span>{NC}"

cat <<EOF > docker-compose.yml
version: '3.8'

services:
  debian-server-lab:
    build:
      context: .
    container_name: debian-server-lab
    volumes:
      - ./<span class="math-inline">DEBIAN\_SERVER\_REPO\_NAME\:/Debian\-erver\-project
\# Se você adicionar um servidor web no Dockerfile e quiser acessá\-lo,
\# descomente e configure as portas abaixo\:
\# ports\:
\#   \- "8080\:80"
\#   \- "8443\:443"
tty\: true
stdin\_open\: true
EOF
echo \-e "</span>{GREEN}docker-compose.yml criado com sucesso.<span class="math-inline">\{NC\}"
\-\-\-
\# \*\*5\. Iniciar o ambiente Docker\*\*
echo \-e "</span>{YELLOW}Construindo e iniciando o ambiente Docker...<span class="math-inline">\{NC\}"
docker\-compose up \-\-build \-d \|\| \{ echo \-e "</span>{RED}Erro ao iniciar o ambiente Docker.<span class="math-inline">\{NC\}"; exit 1; \}
echo \-e "</span>{GREEN}Ambiente Docker iniciado com sucesso!<span class="math-inline">\{NC\}"
\-\-\-
\# \*\*6\. Instruções de Acesso\*\*
echo \-e "</span>{GREEN}--- Configuração do Debian-erver- Home Lab Concluída ---<span class="math-inline">\{NC\}"
echo \-e "</span>{GREEN}Seu ambiente de laboratório Debian-erver- está pronto!<span class="math-inline">\{NC\}"
echo ""
echo \-e "Para acessar o terminal do container e explorar o projeto, use o comando\:"
echo \-e "</span>{YELLOW}docker exec -it debian-server-lab bash${NC}"
echo ""
echo -e "Uma vez dentro do container, os arquivos do projeto estarão em: <span class="math-inline">\{YELLOW\}/Debian\-erver\-project</span>{NC}"
echo -e "Você pode listar os arquivos com: <span class="math-inline">\{YELLOW\}ls /Debian\-erver\-project</span>{NC}"
echo ""
echo -e "${YELLOW}Lembre-se: <span class="math-inline">\{NC\}Se você adicionou seu usuário ao grupo docker, pode precisar reiniciar sua sessão ou fazer logout/login para que as novas permissões entrem em vigor e você possa usar o Docker sem 'sudo'\."
echo ""
echo \-e "Para parar e remover os containers quando terminar, execute no diretório '</span>{PROJECT_DIR}':"
echo -e "<span class="math-inline">\{YELLOW\}docker\-compose down</span>{NC}"
echo ""
