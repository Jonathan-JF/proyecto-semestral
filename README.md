# Sistema de Gestión de Despachos - Innovatech Chile 🚀

Este repositorio contiene la arquitectura unificada y multi-capa para la plataforma de **Innovatech Chile**, desarrollada para la Evaluación Parcial N°2 de la asignatura Desarrollo Full Stack III. El proyecto implementa un enfoque **Monorepo** que orquesta microservicios distribuidos, bases de datos relacionales y una interfaz de usuario frontend mediante contenedores aislados de Docker.

## 🏗️ Arquitectura del Ecosistema

El sistema está dividido en capas desacopladas que se comunican a través de redes virtuales internas:

* **Frontend (`front_despacho`):** Tablero de control y paneles de usuario montados sobre un servidor Nginx (Puerto externo: `8080`).
* **Backend Ventas (`back-Ventas_SpringBoot`):** Microservicio encargado de la lógica transaccional montado en Spring Boot (Puerto externo: `8081`).
* **Backend Despachos (`back-Despachos_SpringBoot`):** Microservicio para el control logístico de envíos en Spring Boot (Puerto externo: `8082`).
* **Base de Datos (`innovatech-db`):** Motor de base de datos relacional MariaDB 10.5 (Puerto interno: `3306`).

---

## 🛠️ Requisitos Previos

Antes de levantar el proyecto, asegúrate de tener instalado en tu equipo:
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) corriendo de forma nativa.
* Git para la gestión de versiones.

---

## 🚀 Despliegue Rápido Automatizado

Para facilitar las pruebas locales y la continuidad operativa en entornos de producción, el repositorio incluye scripts de automatización en su raíz:

### En Windows (Entorno Local)
Si estás desarrollando en tu computadora personal, simplemente ve a la carpeta raíz y ejecuta haciendo doble clic o mediante la terminal:
```bash
.\subir-v2.bat
