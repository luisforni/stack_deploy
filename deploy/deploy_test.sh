#!/bin/bash
set -e

echo "🧪 Desplegando entorno de TEST..."

# Variables
export ENVIRONMENT=test

# Asegurarse de tener última versión del código (si estás en servidor)
git pull origin test

# Generar docker-compose.yml
echo "🔄 Generando docker-compose.yml..."
python generate_compose.py

# Reiniciar contenedores
docker-compose down
docker-compose up --build -d

echo "✅ Test desplegado en modo detached (fondo)"
