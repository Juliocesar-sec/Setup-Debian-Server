#!/bin/bash

# Script para limpar os arquivos de geolocalização gerados pelo lookup2.sh

echo "Removendo arquivos geo_*.txt gerados pelo lookup2.sh..."

rm -f geo_*.txt

if [ $? -eq 0 ]; then
  echo "Arquivos removidos com sucesso. Lookup desarmado."
else
  echo "Falha ao remover arquivos. Verifique permissões."
fi
