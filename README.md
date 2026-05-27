# Proyecto Semestral – ITP CARGO | Innovatech Chile

## Descripción
Aplicación de gestión de carga contenedorizada con microservicios desplegados en AWS EC2.

## Tecnologías
- Frontend: React + Vite + Nginx (Docker multi-stage)
- Backend Ventas: Spring Boot 3 + Java 17 (Docker multi-stage)
- Backend Despachos: Spring Boot 3 + Java 17 (Docker multi-stage)
- Base de datos: MariaDB 10.5
- CI/CD: GitHub Actions
- Cloud: AWS EC2

## Estructura del monorepo
proyecto-semestral/
├── .github/
│   └── workflows/
│       └── deploy.yml        # Pipeline CI/CD
├── front_despacho/           # Frontend React + Nginx
│   └── Dockerfile
├── back-Ventas_SpringBoot/   # Backend microservicio ventas
│   └── Springboot-API-REST/
│       └── Dockerfile
├── back-Despachos_SpringBoot/ # Backend microservicio despachos
│   └── Springboot-API-REST-DESPACHO/
│       └── Dockerfile
└── docker-compose.yml        # Orquestador de servicios

## Requisitos previos
- Docker Desktop instalado
- Docker Compose instalado
- Java 17 (solo para desarrollo local sin Docker)
- Node.js 20 (solo para desarrollo local sin Docker)

## Cómo levantar el proyecto localmente

```bash
# Clonar el repositorio en la rama deploy
git clone -b deploy https://github.com/Jonathan-JF/proyecto-semestral.git
cd proyecto-semestral

# Levantar todos los servicios
sudo docker-compose up --build -d

# Verificar que todos los contenedores estén activos
sudo docker ps
```

## Servicios y puertos

| Servicio | URL | Puerto |
|----------|-----|--------|
| Frontend | http://localhost:8080 | 8080 |
| Backend Ventas | http://localhost:8081 | 8081 |
| Backend Despachos | http://localhost:8082 | 8082 |
| MariaDB | localhost:3306 | 3306 |

## Variables de entorno requeridas

Las variables de entorno se configuran en `docker-compose.yml`. Para producción, se gestionan mediante GitHub Secrets:

| Secret | Descripción |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | Credencial AWS |
| `AWS_SECRET_ACCESS_KEY` | Credencial AWS |
| `AWS_SESSION_TOKEN` | Token de sesión AWS |
| `EC2_SSH_KEY` | Clave SSH para acceso EC2 |
| `DOCKERHUB_USERNAME` | Usuario Docker Hub |
| `DOCKERHUB_TOKEN` | Token Docker Hub |

## Pipeline CI/CD

El pipeline se activa automáticamente con cada `push` a la rama `deploy`:
1. **Build**: Construye las imágenes Docker con multi-stage
2. **Push**: Publica las imágenes en Docker Hub
3. **Deploy**: Se conecta por SSH a la instancia EC2 y actualiza los contenedores

## Despliegue en producción

- **Frontend:** http://34.207.71.210:8080
- **Instancia EC2:** ip-10-0-11-177

## Autores
- Jonathan Alexander Ferrer
- Felipe Andres Flores

**Duoc UC – Introducción a Herramientas DevOps 004V – 2026**
