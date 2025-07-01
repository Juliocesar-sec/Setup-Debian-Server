#!/bin/bash

# Função para validar IPv4 simples
validar_ip() {
  local ip=$1
  local regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
  if [[ $ip =~ $regex ]]; then
    # Verifica se cada octeto está entre 0 e 255
    IFS='.' read -r -a octetos <<< "$ip"
    for octeto in "${octetos[@]}"; do
      if (( octeto < 0 || octeto > 255 )); then
        return 1
      fi
    done
    return 0
  else
    return 1
  fi
}

# Verifica se as ferramentas necessárias estão instaladas
for cmd in whois geoiplookup; do
  if ! command -v $cmd &> /dev/null; then
    echo "Erro: '$cmd' não está instalado. Instale-o para continuar."
    exit 1
  fi
done

# Verifica parâmetros
if [ $# -eq 0 ]; then
  echo "Uso: $0 <IP1> [IP2 IP3 ...]"
  exit 1
fi

# Consulta IP, salva arquivo e mostra resultado (padrão: mostrar no terminal)
consulta_ip() {
  local ip=$1
  local silent=$2 # "true" para não mostrar no terminal

  echo "==== Informações para IP: $ip ===="

  {
    echo "Lookup WHOIS para $ip"
    whois $ip
    echo ""
    echo "Geolocalização para $ip"
    geoiplookup $ip
  } > geo_${ip}.txt

  # Extrai resumo para exibir
  local pais=$(geoiplookup $ip | grep "GeoIP Country Edition" | cut -d':' -f2 | xargs)
  local org=$(whois $ip | grep -i 'OrgName\|organization\|owner' | head -1 | sed 's/^[[:space:]]*//')

  if [ "$silent" != "true" ]; then
    echo "País: $pais"
    echo "Organização: $org"
    echo "Dados salvos em geo_${ip}.txt"
    echo "-------------------------------------"
  fi
}

# Loop pelos IPs passados
for ip in "$@"; do
  if validar_ip "$ip"; then
    consulta_ip "$ip"
  else
    echo "Aviso: '$ip' não é um endereço IP válido. Ignorando."
  fi
done
