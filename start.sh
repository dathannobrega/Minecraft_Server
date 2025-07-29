#!/usr/bin/env bash
set -e

# $1 = nome do arquivo .jar (ex: paper-1.21.jar ou velocity.jar)
JAR_NAME="$1"

# Se não for o proxy Velocity, garante o EULA
if [[ "${JAR_NAME}" != "velocity.jar" ]]; then
  [ -f eula.txt ] || echo "eula=true" > eula.txt
fi

# Define memória mínima e máxima com fallback
MIN_RAM="${MIN_RAM:-512M}"
MAX_RAM="${MAX_RAM:-2G}"

echo "Iniciando ${JAR_NAME} com heap ${MIN_RAM}-${MAX_RAM}"
exec java -Xms"${MIN_RAM}" -Xmx"${MAX_RAM}" -jar "${JAR_NAME}" nogui
