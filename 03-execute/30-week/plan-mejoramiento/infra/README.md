# Infraestructura

## Descripción

Esta carpeta contiene la configuración necesaria para ejecutar los servicios de Costumes mediante Docker Compose.

La infraestructura incluye:

- PostgreSQL como base de datos.
- API de Costumes.
- Aplicación web.
- Página pública servida con Nginx.

## Configuración

Crear el archivo `infra/.env` a partir de `.env.example` y configurar valores seguros para las variables requeridas.

El archivo `.env` contiene información privada y no debe incluirse en el repositorio.

El nombre de usuario del administrador se obtiene de las variables de entorno y no del sembrador de datos.

## Iniciar los servicios

Desde la carpeta `infra`, ejecutar:

```bash
docker compose up --build
