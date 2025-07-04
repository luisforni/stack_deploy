import os
import yaml

APP_DIR = "app"
DEFAULT_PORT = 8000
START_PORT = 8001

compose = {
    "version": "3.9",
    "services": {}
}

used_ports = set()
assigned_ports = {}

def get_port_from_env(project_path):
    env_path = os.path.join(project_path, ".env")
    if os.path.exists(env_path):
        with open(env_path) as f:
            for line in f:
                if line.strip().startswith("PORT="):
                    try:
                        return int(line.strip().split("PORT=")[-1])
                    except ValueError:
                        pass
    return None

# Asignar puertos únicos automáticamente
def get_next_available_port():
    port = START_PORT
    while port in used_ports:
        port += 1
    return port

for project in sorted(os.listdir(APP_DIR)):
    project_path = os.path.join(APP_DIR, project)
    dockerfile_path = os.path.join(project_path, "Dockerfile")

    if os.path.isdir(project_path) and os.path.isfile(dockerfile_path):
        # Detectar o asignar puerto
        project_port = get_port_from_env(project_path)
        if not project_port:
            project_port = get_next_available_port()
        used_ports.add(project_port)

        # Agregar al docker-compose
        service = {
            "build": {
                "context": f"./{APP_DIR}/{project}",
                "dockerfile": "Dockerfile"
            },
            "ports": [f"{project_port}:{DEFAULT_PORT}"],
            "restart": "always"
        }

        compose["services"][project] = service
        assigned_ports[project] = project_port

# Escribir docker-compose.yml
with open("docker-compose.yml", "w") as f:
    yaml.dump(compose, f, sort_keys=False)

# Imprimir resultado
print("✅ docker-compose.yml generado con éxito.")
print("📡 Servicios disponibles:")
for name, assigned_port in assigned_ports.items():
    print(f" - {name}: http://localhost:{assigned_port}")
