# Pruebas del sistema Costumes

## Descripción

Este documento registra la ejecución y los resultados de las pruebas realizadas sobre el sistema Costumes.

Las pruebas permiten verificar el funcionamiento de la infraestructura, la API, la aplicación web, la página pública y las principales reglas del sistema. Las evidencias obtenidas durante la ejecución se almacenan en la carpeta `evidence/`.

## Entorno de pruebas

Las pruebas se realizan utilizando los servicios definidos en la infraestructura Docker del proyecto:

- PostgreSQL 16.
- API desarrollada con Laravel.
- Aplicación web desarrollada con React y Vite.
- Página pública servida mediante Nginx.
- Docker Compose para la ejecución de los servicios.

## Registro de pruebas

| ID | Prueba | Resultado | Evidencia |
|---|---|---|---|
| CP-01 | Levantamiento de los servicios con Docker Compose | Aprobada | [Ver evidencia](evidence/01_docker-services.png) |

---

## CP-01 — Levantamiento de los servicios con Docker Compose

### Objetivo

Verificar que los servicios necesarios para el funcionamiento de Costumes puedan iniciarse correctamente mediante Docker Compose.

### Procedimiento

Desde la carpeta `infra/` se validó inicialmente la configuración mediante:

```bash
docker compose config --quiet
```

Posteriormente se construyeron e iniciaron los servicios mediante:

```bash
docker compose up --build
```

Finalmente, en una segunda terminal se verificó el estado de los contenedores mediante:

```bash
docker compose ps
```

### Resultado esperado

Los cuatro servicios principales deben permanecer activos:

- `api`
- `app`
- `db`
- `page`

Además, el servicio de PostgreSQL debe alcanzar el estado `healthy`.

### Resultado obtenido

**Aprobada.**

Los cuatro servicios se iniciaron y permanecieron activos. El contenedor de PostgreSQL alcanzó correctamente el estado `healthy`.

Se verificaron los siguientes servicios:

| Servicio | Estado observado | Puerto publicado |
|---|---|---|
| `api` | Up | `8000` |
| `app` | Up | `5173` |
| `db` | Up (healthy) | No publicado al host |
| `page` | Up | `8081` |

### Evidencia

La ejecución de `docker compose ps` muestra los cuatro contenedores activos y el estado saludable de la base de datos.

![Servicios de Costumes ejecutándose con Docker Compose](evidence/01-docker-services.png)

### Conclusión

La infraestructura inicial del sistema funciona correctamente mediante Docker Compose. Los servicios de base de datos, API, aplicación web y página pública se encuentran activos, por lo que se puede continuar con las pruebas funcionales y técnicas del sistema.
