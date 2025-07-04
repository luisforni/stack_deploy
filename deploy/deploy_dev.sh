#!/bin/bash
set -e

echo "🧪 Desplegando entorno de desarrollo..."

# Variables
export ENVIRONMENT=dev

# Generar docker-compose.yml actualizado
echo "🔄 Generando docker-compose.yml..."
python generate_compose.py

# Levantar contenedores
docker-compose down
docker-compose up --build
