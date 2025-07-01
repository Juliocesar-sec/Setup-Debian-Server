#!/bin/bash

# --- Cores para melhor visualização ---
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}--- Iniciando a configuração do Debian-erver- Home Lab ---${NC}"

# --- 1. Verificar e instalar pré-requisitos (Git, Docker, Docker Compose) ---
echo -e "${YELLOW}Verificando e instalando pré-requisitos (Git, Docker, Docker Compose)...${NC}"

# Atualiza e faz upgrade dos pacotes
sudo apt update && sudo apt upgrade -y || { echo -e "${RED}Erro ao atualizar/fazer upgrade dos pacotes.${NC}"; exit 1; }

# Instala Git
if ! command -v git &> /dev/null
then
    echo -e "${YELLOW}Git não encontrado. Instalando Git...${NC}"
    sudo apt install git -y || { echo -e "${RED}Erro ao instalar Git.${NC}"; exit 1; }
else
    echo -e "${GREEN}Git já está instalado.${NC}"
fi

# Instala Docker
if ! command -v docker &> /dev/null
then
    echo -e "${YELLOW}Docker não encontrado. Instalando Docker...${NC}"
    sudo apt install docker.io -y || { echo -e "${RED}Erro ao instalar Docker.${NC}"; exit 1; }
    sudo systemctl start docker || { echo -e "${RED}Erro ao iniciar o serviço Docker.${NC}"; exit 1; }
    sudo systemctl enable docker || { echo -e "${RED}Erro ao habilitar o serviço Docker.${NC}"; exit 1; }
    sudo usermod -aG docker "$USER"
    echo -e "${GREEN}Docker instalado. Você precisará ${YELLOW}reiniciar sua sessão ou fazer logout/login${GREEN} para que as permissões do Docker entrem em vigor.${NC}"
else
    echo -e "${GREEN}Docker já está instalado.${NC}"
    if ! sudo systemctl is-active --quiet docker; then
        echo -e "${YELLOW}O serviço Docker não está ativo. Iniciando...${NC}"
        sudo systemctl start docker || { echo -e "${RED}Erro ao iniciar o serviço Docker.${NC}"; exit 1; }
    fi
    if ! sudo systemctl is-enabled --quiet docker; then
        echo -e "${YELLOW}O serviço Docker não está habilitado. Habilitando...${NC}"
        sudo systemctl enable docker || { echo -e "${RED}Erro ao habilitar o serviço Docker.${NC}"; exit 1; }
    fi
fi

# Instala Docker Compose
if ! command -v docker-compose &> /dev/null
then
    echo -e "${YELLOW}Docker Compose não encontrado. Instalando Docker Compose...${NC}"
    sudo apt install docker-compose -y || { echo -e "${RED}Erro ao instalar Docker Compose.${NC}"; exit 1; }
else
    echo -e "${GREEN}Docker Compose já está instalado.${NC}"
fi

echo -e "${GREEN}Pré-requisitos verificados e instalados.${NC}"

# --- 2. Clonar o repositório Debian-erver- ---
echo -e "${YELLOW}Clonando o repositório Debian-erver-...${NC}"

PROJECT_DIR="debian-server-lab"
REPO_URL="https://github.com/Juliocesar-sec/Debian-erver-.git"
DEBIAN_SERVER_REPO_NAME="Debian-erver-"

if [ -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}Diretório '$PROJECT_DIR' já existe. Removendo...${NC}"
    rm -rf "$PROJECT_DIR" || { echo -e "${RED}Erro ao remover diretório existente.${NC}"; exit 1; }
fi

mkdir "$PROJECT_DIR" || { echo -e "${RED}Erro ao criar diretório do projeto.${NC}"; exit 1; }
cd "$PROJECT_DIR" || { echo -e "${RED}Erro ao entrar no diretório do projeto.${NC}"; exit 1; }

git clone "$REPO_URL" || { echo -e "${RED}Erro ao clonar o repositório '${REPO_URL}'.${NC}"; exit 1; }

echo -e "${GREEN}Repositório clonado com sucesso em '$(pwd)/${DEBIAN_SERVER_REPO_NAME}'${NC}"

# --- 3. Criar Dockerfile ---
echo -e "${YELLOW}Criando Dockerfile...${NC}"

cat <<EOF > Dockerfile
FROM debian:latest
ARG DEBIAN_FRONTEND=noninteractive

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

WORKDIR /root
EOF

echo -e "${GREEN}Dockerfile criado com sucesso.${NC}"

# --- 4. Criar docker-compose.yml ---
echo -e "${YELLOW}Criando docker-compose.yml...${NC}"

cat <<EOF > docker-compose.yml
version: '3.8'

services:
  debian-server-lab:
    build:
      context: .
    container_name: debian-server-lab
    volumes:
      - ./${DEBIAN_SERVER_REPO_NAME}:/Debian-erver-project
    tty: true
    stdin_open: true
EOF

echo -e "${GREEN}docker-compose.yml criado com sucesso.${NC}"

# --- 5. Iniciar o ambiente Docker ---
echo -e "${YELLOW}Construindo e iniciando o ambiente Docker...${NC}"
docker-compose up --build -d || { echo -e "${RED}Erro ao iniciar o ambiente Docker.${NC}"; exit 1; }

echo -e "${GREEN}Ambiente Docker iniciado com sucesso!${NC}"

# --- 6. Instruções de Acesso ---
echo -e "${GREEN}--- Configuração do Debian-erver- Home Lab Concluída ---${NC}"
echo -e "${GREEN}Seu ambiente de laboratório Debian-erver- está pronto!${NC}"
echo ""
echo -e "Para acessar o terminal do container:"
echo -e "${YELLOW}docker exec -it debian-server-lab bash${NC}"
echo ""
echo -e "Os arquivos do projeto estão em: ${YELLOW}/Debian-erver-project${NC}"
echo -e "Você pode listar os arquivos com: ${YELLOW}ls /Debian-erver-project${NC}"
echo ""
echo -e "${YELLOW}Lembre-se:${NC} Se adicionou seu usuário ao grupo docker, reinicie sua sessão para aplicar a permissão."
echo ""
echo -e "Para parar o ambiente, execute no diretório '${PROJECT_DIR}':"
echo -e "${YELLOW}docker-compose down${NC}"
