# 🚀 StackDeploy

Sistema reutilizable de despliegue con Docker para ejecutar una o varias aplicaciones backend (FastAPI, Django, Node, etc.). Permite clonar proyectos dentro de la carpeta `app/` y generar automáticamente un `docker-compose.yml` para levantarlos como servicios independientes.

---

## ✅ Requisitos

- Docker y Docker Compose instalados
- Python 3.9+ instalado
- Git
- (opcional) GNU Make

---

## 🧭 Pasos de uso

### 1. Clonar este repositorio

```bash
git clone https://github.com/luisforni/stack_deploy.git
cd stack_deploy
```

---

### 2. Clonar tus aplicaciones dentro de la carpeta `app/`

```bash
cd app/
git clone https://github.com/tu_usuario/app_1.git
git clone https://github.com/tu_usuario/app_2.git
cd ..
```

Estructura esperada:

```
stack_deploy/
└── app/
    ├── app_1/
    │   ├── Dockerfile
    │   └── .env (opcional)
    └── app_2/
        ├── Dockerfile
        └── .env (opcional)
```

---

### 3. (Opcional) Definir el puerto en cada app

Crear un archivo `.env` dentro de cada subcarpeta de `app/`:

```env
PORT=8001
```

Si no se especifica, el script asignará puertos automáticamente a partir del 8001.

---

### 4. Generar `docker-compose.yml`

```bash
make compose
```

Esto ejecuta `generate_compose.py` que detecta todos los proyectos y crea el archivo `docker-compose.yml`.

---

### 5. Levantar las aplicaciones

```bash
docker-compose up -d --build
```

Cada proyecto se ejecutará como un servicio independiente en su propio puerto.

---

### 6. Acceder a los proyectos

Ejemplo:

- http://localhost:8001 → `app_1`
- http://localhost:8002 → `app_2`

---

## 📁 Estructura del proyecto

```
stack_deploy/
├── app/                       ← Proyectos clonados
│   ├── app_1/
│   └── app_2/
├── docker-compose.yml         ← Generado automáticamente
├── generate_compose.py        ← Script que crea el compose
├── Makefile                   ← Comandos automáticos
├── deploy/
│   ├── deploy_dev.sh
│   ├── deploy_test.sh
│   └── deploy_prod.sh
└── README.md
```

---

## 🧪 Comandos disponibles

| Comando                      | Descripción                                 |
|-----------------------------|---------------------------------------------|
| `make compose`              | Genera el `docker-compose.yml`              |
| `make dev`                  | Levanta todas las apps en modo desarrollo   |
| `make deploy-prod`          | Despliega en entorno producción             |
| `make restart`              | Reinicia contenedores                       |
| `make logs`                 | Ver logs de todos los servicios             |
| `make clean`                | Elimina contenedores, volúmenes e imágenes  |
| `make clone-app REPO=<url>` | Clona una app en la carpeta `app/`          |

---

## 🔁 Para agregar una nueva app

```bash
make clone-app REPO=https://github.com/tu_usuario/nueva_app.git
make compose
docker-compose up -d --build
```

---

## 🛠️ Requisitos de instalación


### 🐧 Linux (Ubuntu / Debian)

```bash
# Actualizar repositorios
sudo apt update

# Instalar Docker y Docker Compose
sudo apt install -y docker.io docker-compose

# Instalar Python 3 y pip
sudo apt install -y python3 python3-pip

# Instalar Make
sudo apt install -y make

# (Opcional) Agregar tu usuario al grupo docker
sudo usermod -aG docker $USER
newgrp docker
```

---

### 🪟 Windows (sin WSL)

- Instalar Docker Desktop

- Instalar Git Bash o usar PowerShell

- Instalar Make con Chocolatey:

```bash
choco install make
```

Si no usás Make, también podés ejecutar manualmente:

```bash
python generate_compose.py
docker-compose up -d --build
```

---