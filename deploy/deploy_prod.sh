#!/bin/bash
set -e

echo "🚀 Desplegando entorno de PRODUCCIÓN..."

# Variables
export ENVIRONMENT=prod

# Asegurarse de tener última versión del código (si estás en VPS)
git pull origin main

# Generar docker-compose.yml
echo "🔄 Generando docker-compose.yml..."
python generate_compose.py

# Reiniciar contenedores en modo detach
docker-compose down
docker-compose up --build -d

echo "✅ Producción desplegada correctamente en segundo plano."
