# ITP CARGO — Sistema de Gestión de Despachos
### Innovatech Chile |  INTRODUCCION A HERRAMIENTAS DEVOPS_004V


---

## 🏗️ Arquitectura del Sistema

El sistema ITP CARGO está desplegado en **AWS ECS Fargate** (serverless), compuesto por 4 servicios orquestados en un clúster administrado:

```
Internet
    │
    ▼
Application Load Balancer (itp-cargo-alb)
    │  Puerto 80 público
    ▼
┌─────────────────────────────────────────┐
│         Amazon ECS Fargate              │
│  ┌─────────────┐   ┌─────────────────┐ │
│  │ svc-frontend│   │svc-back-ventas  │ │
│  │  Nginx:80   │   │ Spring Boot:8080│ │
│  └─────────────┘   └─────────────────┘ │
│                    ┌─────────────────┐  │
│                    │svc-back-despacho│  │
│                    │ Spring Boot:8080│  │
│  ┌─────────────┐   └─────────────────┘ │
│  │   svc-db    │                        │
│  │ MariaDB:3306│                        │
│  └─────────────┘                        │
└─────────────────────────────────────────┘
```

| Servicio | Tecnología | Puerto |
|---|---|---|
| Frontend | React + Vite + Nginx Alpine | 80 |
| Backend Ventas | Spring Boot 3 / Java 17 | 8080 |
| Backend Despachos | Spring Boot 3 / Java 17 | 8080 |
| Base de Datos | MariaDB 10.5 | 3306 |

**URL pública:** `http://itp-cargo-alb-1472582253.us-east-1.elb.amazonaws.com`

---

## ☁️ Infraestructura AWS

| Componente | Detalle |
|---|---|
| Región | us-east-1 |
| Clúster | itp-cargo-cluster (ECS Fargate) |
| VPC | itp-cargo-vpc (10.0.0.0/16) |
| Subredes | 2 públicas en us-east-1a y us-east-1b |
| Load Balancer | itp-cargo-alb (Application, Internet-facing) |
| Registro de imágenes | Amazon ECR (3 repositorios privados) |
| Observabilidad | Amazon CloudWatch (logs + métricas) |
| Autoscaling | Target Tracking 50% CPU (min: 1, max: 3 tareas) |

### Security Groups
| SG | Regla de entrada | Propósito |
|---|---|---|
| SG-ALB | TCP 80 desde 0.0.0.0/0 | Acceso público al Load Balancer |
| SG-Frontend | TCP 80 desde SG-ALB | Solo el ALB alcanza el Frontend |
| SG-Backend | TCP 8080 desde SG-Frontend | Solo el Frontend alcanza los Backends |

---

## 🔄 Pipeline CI/CD

El pipeline se activa automáticamente en cada push a la rama `deploy`:

```
Push a ecs-deploy
       │
       ▼
  Checkout código
       │
       ▼
  Configurar credenciales AWS
       │
       ▼
  Login a Amazon ECR
       │
       ▼
  Build + Push imágenes (tag = SHA del commit)
  ├── front-despacho
  ├── back-ventas
  └── back-despachos
       │
       ▼
  Deploy a ECS (force-new-deployment)
  ├── svc-frontend
  ├── itp-cargo-back-ventas-service-e81lrm11
  └── svc-back-despachos
```

### GitHub Secrets requeridos
| Secret | Descripción |
|---|---|
| `AWS_ACCESS_KEY_ID` | Credencial temporal del Learner Lab |
| `AWS_SECRET_ACCESS_KEY` | Credencial temporal del Learner Lab |
| `AWS_SESSION_TOKEN` | Token de sesión temporal del Learner Lab |

> ⚠️ Las credenciales del AWS Academy Learner Lab caducan cada 3-4 horas y deben actualizarse manualmente en GitHub Secrets antes de cada ejecución del pipeline.

---

## 🖥️ Ejecución Local (Desarrollo)

### Requisitos
- Docker Desktop
- Git

### Levantar el entorno local

```bash
# Clonar el repositorio
git clone https://github.com/Jonathan-JF/proyecto-semestral.git
cd proyecto-semestral
git checkout deploy

# Levantar todos los servicios
docker-compose up --build -d

# Verificar que están corriendo
docker ps
```

### URLs locales
| Servicio | URL |
|---|---|
| Frontend | http://localhost:8080 |
| Backend Ventas | http://localhost:8081 |
| Backend Despachos | http://localhost:8082 |
| MariaDB | localhost:3306 |

### Detener el entorno

```bash
docker-compose down
```

---

## 📁 Estructura del Repositorio

```
proyecto-semestral/
├── .github/
│   └── workflows/
│       └── deploy.yml          # Pipeline CI/CD → ECS Fargate
├── front_despacho/             # Frontend React + Vite
│   ├── Dockerfile              # Multietapa: Node build → Nginx Alpine
│   ├── .dockerignore
│   └── src/
├── back-Ventas_SpringBoot/     # Backend Ventas
│   └── Springboot-API-REST/
│       ├── Dockerfile          # Multietapa: Maven build → JRE Alpine
│       └── src/
├── back-Despachos_SpringBoot/  # Backend Despachos
│   └── Springboot-API-REST-DESPACHO/
│       ├── Dockerfile
│       └── src/
└── docker-compose.yml          # Orquestación local
```

---

## 🔒 Seguridad

- **Imágenes base minimalistas:** `nginx:alpine` y `eclipse-temurin:alpine` reducen la superficie de ataque
- **Escaneo de vulnerabilidades:** Amazon ECR con "Scan on push" activado en los 3 repositorios
- **Secretos fuera del código:** credenciales gestionadas via GitHub Secrets y variables de entorno en Task Definitions de ECS
- **Aislamiento de red:** Security Groups en capas — los Backends no son accesibles públicamente

---

## 📊 Observabilidad

- **Logs:** CloudWatch Log Groups por servicio (`/ecs/itp-cargo-frontend`, `/ecs/itp-cargo-back-ventas`, `/ecs/itp-cargo-back-despachos`, `/ecs/itp-cargo-db`)
- **Métricas:** CPU y memoria por servicio en CloudWatch
- **Autoscaling:** alarmas de Target Tracking configuradas en CloudWatch

---

## 👥 Equipo

| Integrante | Rol |
|---|---|
| Jonathan Ferrer | Desarrollador DevOps |
| Felipe Flores | Desarrollador DevOps |
