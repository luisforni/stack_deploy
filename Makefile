# Variables
ENV ?= dev
PORT ?= 8000
REPO ?=

# Iniciar entorno de desarrollo
dev:
	@echo "🧪 Iniciando entorno de desarrollo..."
	ENVIRONMENT=dev docker-compose up --build

# Desplegar en producción
deploy-prod:
	@echo "🚀 Desplegando entorno de producción..."
	ENVIRONMENT=prod docker-compose down
	ENVIRONMENT=prod docker-compose up --build -d

# Reiniciar en caliente (ideal para cambios de código sin build)
restart:
	@echo "🔄 Reiniciando contenedores..."
	docker-compose restart

# Clonar un proyecto dentro de /app
clone-app:
	@if [ -z "$(REPO)" ]; then \
		echo "❌ Debes indicar REPO=<url_del_repo>"; \
		exit 1; \
	fi
	@echo "📥 Clonando $(REPO) en app/"
	@rm -rf app/$(notdir $(basename $(REPO)))
	git clone $(REPO) app/$(notdir $(basename $(REPO)))

# Generar docker-compose.yml automáticamente
compose:
	@echo "🔄 Generando docker-compose.yml desde /app..."
	python generate_compose.py
	@echo "✅ docker-compose.yml generado."

# Construir imágenes sin ejecutar
build:
	@echo "🔨 Ejecutando build manual..."
	ENVIRONMENT=$(ENV) docker-compose build

# Limpiar contenedores, imágenes y volúmenes
clean:
	@echo "🧼 Limpiando contenedores, volúmenes e imágenes no usadas..."
	docker-compose down -v --remove-orphans
	docker system prune -f

# Ver logs en tiempo real
logs:
	@echo "📄 Logs en vivo..."
	docker-compose logs -f

# Inicializar nuevo proyecto a partir de la plantilla (opcional)
init:
	@echo "🔧 Creando nuevo proyecto desde plantilla..."
	@echo "Usar: make init name=mi_app"
	@cp -r . ../stack_deploy_$(name)
	@sed -i "s/stack_deploy/stack_deploy_$(name)/g" ../stack_deploy_$(name)/README.md
	@echo "✅ Nuevo proyecto creado: stack_deploy_$(name)"

# Ayuda
help:
	@echo ""
	@echo "📦 Comandos disponibles:"
	@echo "  make dev               # Levantar entorno de desarrollo"
	@echo "  make deploy-prod       # Desplegar en entorno de producción"
	@echo "  make restart           # Reiniciar contenedores"
	@echo "  make clone-app REPO=<url>  # Clonar repositorio dentro de app/"
	@echo "  make compose           # Generar docker-compose.yml dinámicamente"
	@echo "  make build             # Construir imágenes sin ejecutarlas"
	@echo "  make clean             # Limpiar contenedores e imágenes"
	@echo "  make logs              # Ver logs en tiempo real"
	@echo "  make init name=xxx     # Clonar esta plantilla en otro proyecto"
