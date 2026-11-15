# Infraestructura - Costumes

## Descripción

Esta carpeta contiene la configuración necesaria para ejecutar la infraestructura del proyecto Costumes mediante Docker Compose.

La infraestructura incluye la base de datos PostgreSQL, la API desarrollada en Laravel, la aplicación web en React y la página pública del producto.

## Requisitos

- Docker Desktop instalado y en ejecución.
- Docker Compose disponible.
- Archivo de configuración `.env`.

## Configuración inicial

1. Copiar el archivo de ejemplo:

   `Copy-Item .env.example .env`

2. Abrir el archivo `.env` y configurar las variables:

   `POSTGRES_PASSWORD=change_this_database_password`

   `ADMIN_PASSWORD=change_this_admin_password`

   `JWT_SECRET=change_this_random_secret`

   `APP_KEY=base64:change_this_application_key`

   Reemplazar los valores de ejemplo por contraseñas y secretos propios. La contraseña del administrador debe tener al menos 12 caracteres y el secreto JWT debe tener al menos 32 caracteres.

## Iniciar los servicios

Desde esta carpeta, ejecutar:

`docker compose up --build`

Este comando construye e inicia los servicios necesarios para el funcionamiento del sistema.

## Verificar los servicios

Consultar el estado de los contenedores:

`docker compose ps`

Una vez iniciados correctamente, los servicios estarán disponibles en:

- API: `http://localhost:8000/api/v1/health`
- Aplicación: `http://localhost:5173`
- Página pública: `http://localhost:8081`

También se pueden consultar los registros de los servicios con:

`docker compose logs`

## Base de datos

El proyecto utiliza PostgreSQL 16.

La base de datos inicia mediante Docker y la API espera a que PostgreSQL esté disponible antes de continuar. La creación y actualización de las tablas se realiza mediante las migraciones de Laravel, por lo que la carpeta `infra` no contiene instrucciones DDL para crear el esquema.

## Detener los servicios

Para detener los contenedores:

`docker compose down`

Este comando conserva la información almacenada en los volúmenes de Docker.

Para detener los servicios y eliminar los datos locales almacenados en los volúmenes:

`docker compose down -v`

**Importante:** este último comando elimina los datos locales de la base de datos.

## Persistencia de datos

La infraestructura utiliza los siguientes volúmenes:

- `database_data`: conserva la información de PostgreSQL.
- `covers_data`: conserva las imágenes de los trajes almacenadas por la API.

Esto permite mantener la información aunque los contenedores sean detenidos o eliminados.

