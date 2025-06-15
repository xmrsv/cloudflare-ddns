#!/bin/bash
auth_email="CLOUDFLARE_EMAIL"
auth_key="GLOBAL_API_KEY"
zone_identifier="ZONE_ID"
record_name="DOMAIN"
proxy=true

log() {
    if [ "$1" ]; then
        echo -e "[$(date)] - $1"
    fi
}

ip=$(curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com/)

if [ "${ip}" == "" ]; then
  log "No se encontró IP pública."
  exit 1
fi

record_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records?name=${record_name}" -H "X-Auth-Email: ${auth_email}" -H "X-Auth-Key: ${auth_key}" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1)

if [ "${record_identifier}" == "" ]; then
  log "Registro no encontrado. Creando..."
  record_identifier=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records" -H "X-Auth-Email: ${auth_email}" -H "X-Auth-Key: ${auth_key}" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"${record_name}\",\"content\":\"${ip}\",\"ttl\":120,\"proxied\":${proxy}}" | grep -Po '(?<="id":")[^"]*')
  log "Registro creado con ID: ${record_identifier}"
else
  log "Registro encontrado con ID: ${record_identifier}"
fi

update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records/${record_identifier}" -H "X-Auth-Email: ${auth_email}" -H "X-Auth-Key: ${auth_key}" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"${record_name}\",\"content\":\"${ip}\",\"ttl\":120,\"proxied\":${proxy}}")

if [[ "${update}" == *"\"success\":false"* ]]; then
    log "Error al actualizar: ${update}"
    exit 1
else
    log "¡Éxito! IP actualizada a ${ip}"
fi
