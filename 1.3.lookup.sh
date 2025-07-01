```bash
#!/bin/bash

# --- Função para validar formato IPv4 ---
validar_ip() {
  local ip=$1
  local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
  if [[ $ip =~ $regex ]]; then
    # Verifica se cada octeto está entre 0 e 255
    IFS='.' read -r -a octetos <<< "$ip"
    for octeto in "${octetos[@]}"; do
      if ((octeto < 0 || octeto > 255)); then
        return 1
      fi
    done
    return 0
  else
    return 1
  fi
}

# Verifica se ao menos 1 parâmetro foi passado
if [ $# -eq 0 ]; then
  echo "Uso: $0 <IP1> [IP2 IP3 ...]"
  exit 1
fi

# Função para consultar IP
consulta_ip() {
  local ip=$1

  # Valida IP
  if ! validar_ip "$ip"; then
    echo "IP inválido: $ip"
    return
  fi

  echo "==== Informações para IP: $ip ===="
  echo "Salvando dados em geo_${ip}.txt"

  {
    echo "Lookup WHOIS para $ip"
    whois $ip
    echo ""
    echo "Geolocalização para $ip"
    geoiplookup $ip
  } > geo_${ip}.txt

  # Resumo: país + organização
  local pais=$(geoiplookup $ip | grep "GeoIP Country Edition" | cut -d':' -f2 | xargs)
  local org=$(whois $ip | grep -i 'OrgName\|organization\|owner' | head -1 | sed 's/^[[:space:]]*//')

  echo "País: $pais"
  echo "Organização: $org"
  echo "-------------------------------------"
}

# Loop para cada IP passado
for ip in "$@"; do
  consulta_ip "$ip"
done
