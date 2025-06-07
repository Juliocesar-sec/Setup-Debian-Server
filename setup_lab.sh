#!/bin/bash

# --- Cores para melhor visualização ---
GREEN='\033[0;32m'
YELLOW='\030;33m'
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
    # Adicionar o usuário ao grupo docker para evitar o uso de sudo
    sudo usermod -aG docker "$USER"
    echo -e "${GREEN}Docker instalado. Você precisará ${YELLOW}reiniciar sua sessão ou fazer logout/login${GREEN} para que as permissões do Docker entrem em vigor.${NC}"
else
    echo -e "${GREEN}Docker já está instalado.${NC}"
    if ! sudo systemctl is-active --quiet docker; then
        echo -e "${YELLOW}O serviço Docker não está ativo. Iniciando...${NC}"
        sudo systemctl start docker || { echo -e "${RED}Erro ao iniciar o serviço Docker.${NC}"; exit 1; }
    fi
    if ! sudo systemctl is-enabled --quiet docker; then
        echo -e "${YELLOW}O serviço Docker não está habilitado para iniciar com o sistema. Habilitando...${NC}"
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
DEBIAN_SERVER_REPO_NAME="Debian-erver-" # Nome exato do diretório clonado pelo git

if [ -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}Diretório '$PROJECT_DIR' já existe. Removendo para garantir uma instalação limpa...${NC}"
    rm -rf "$PROJECT_DIR" || { echo -e "${RED}Erro ao remover diretório existente.${NC}"; exit 1; }
fi

mkdir "$PROJECT_DIR" || { echo -e "${RED}Erro ao criar diretório do projeto.${NC}"; exit 1; }
cd "$PROJECT_DIR" || { echo -e "${RED}Erro ao entrar no diretório do projeto.${NC}"; exit 1; }

git clone "$REPO_URL" || { echo -e "${RED}Erro ao clonar o repositório '$REPO_URL'.${NC}"; exit 1; }

echo -e "${GREEN}Repositório Debian-erver- clonado com sucesso em '${PWD}/${DEBIAN_SERVER_REPO_NAME}'.${NC}"

# --- 3. Criar Dockerfile ---
echo -e "${YELLOW}Criando Dockerfile...${NC}"

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
      - ./$DEBIAN_SERVER_REPO_NAME:/Debian-erver-project
    # Se você adicionar um servidor web no Dockerfile e quiser acessá-lo,
    # descomente e configure as portas abaixo:
    # ports:
    #   - "8080:80"
    #   - "8443:443"
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
echo -e "Para acessar o terminal do container e explorar o projeto, use o comando:"
echo -e "${YELLOW}docker exec -it debian-server-lab bash${NC}"
echo ""
echo -e "Uma vez dentro do container, os arquivos do projeto estarão em: ${YELLOW}/Debian-erver-project${NC}"
echo -e "Você pode listar os arquivos com: ${YELLOW}ls /Debian-erver-project${NC}"
echo ""
echo -e "${YELLOW}Lembre-se: ${NC}Se você adicionou seu usuário ao grupo docker, pode precisar reiniciar sua sessão ou fazer logout/login para que as novas permissões entrem em vigor e você possa usar o Docker sem 'sudo'."
echo ""
echo -e "Para parar e remover os containers quando terminar, execute no diretório '${PROJECT_DIR}':"
echo -e "${YELLOW}docker-compose down${NC}"
echo ""

