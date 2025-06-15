#!/bin/sh

while true
do
  echo "----------------------------------------"
  echo "Ejecutando script de DDNS a las $(date)"

  /usr/local/bin/cloudflare.sh

  echo "Script finalizado. Durmiendo por 60 segundos..."
  sleep 60
done
