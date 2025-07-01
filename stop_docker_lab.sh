#!/bin/bash

# --- Cores para saída ---
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

CONTAINER_NAME="debian-server-lab"

echo -e "${GREEN}--- Parando e removendo o container Docker: $CONTAINER_NAME ---${NC}"

# Verifica se o container está rodando
if sudo docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
  echo -e "${YELLOW}Parando o container...${NC}"
  sudo docker stop $CONTAINER_NAME || { echo -e "${RED}Erro ao parar o container.${NC}"; exit 1; }
else
  echo -e "${YELLOW}Container não está em execução.${NC}"
fi

# Verifica se o container existe (parado ou rodando)
if sudo docker ps -a -q -f name=$CONTAINER_NAME | grep -q .; then
  echo -e "${YELLOW}Removendo o container...${NC}"
  sudo docker rm $CONTAINER_NAME || { echo -e "${RED}Erro ao remover o container.${NC}"; exit 1; }
else
  echo -e "${YELLOW}Container não existe.${NC}"
fi

echo -e "${GREEN}--- Parando e desativando o serviço Docker ---${NC}"

# Para o serviço Docker
if sudo systemctl is-active --quiet docker; then
  echo -e "${YELLOW}Parando o serviço Docker...${NC}"
  sudo systemctl stop docker || { echo -e "${RED}Erro ao parar o serviço Docker.${NC}"; exit 1; }
else
  echo -e "${YELLOW}Serviço Docker já está parado.${NC}"
fi

# Desativa o serviço Docker para não iniciar no boot
if sudo systemctl is-enabled --quiet docker; then
  echo -e "${YELLOW}Desativando o serviço Docker...${NC}"
  sudo systemctl disable docker || { echo -e "${RED}Erro ao desativar o serviço Docker.${NC}"; exit 1; }
else
  echo -e "${YELLOW}Serviço Docker já está desativado.${NC}"
fi

echo -e "${GREEN}Processo concluído.${NC}"
