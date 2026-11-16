<p align="center">
<a href="https://laravel.com" target="_blank">
<img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo">
</a>
</p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

# Costumes - API

## Descripción

Esta carpeta contiene la API REST del sistema Costumes, desarrollada con PHP y Laravel.

La API administra la autenticación de operadores, el catálogo de trajes, los clientes, los alquileres, las devoluciones y el informe de trajes más solicitados. También aplica las reglas de negocio relacionadas con disponibilidad, vencimientos y concurrencia.

## Tecnologías

- PHP 8.3.
- Laravel 12.
- PostgreSQL 16.
- Composer.
- PHPUnit.
- Docker.
- Autenticación mediante JWT.

## Estructura

```text
api/
├── app/
│   ├── Adapters/
│   ├── Application/
│   ├── Domain/
│   ├── Exceptions/
│   ├── Http/
│   ├── Ports/
│   ├── Providers/
│   └── Support/
├── bootstrap/
├── config/
├── database/
│   └── migrations/
├── public/
├── routes/
├── tests/
│   ├── Feature/
│   └── Unit/
├── .dockerignore
├── .env.example
├── artisan
├── composer.json
├── Dockerfile
├── phpunit.xml
└── README.md
```

## Requisitos

Para ejecutar la API como parte de la infraestructura del proyecto se requiere:

- Docker Desktop instalado y en ejecución.
- Docker Compose disponible.
- PostgreSQL disponible mediante la infraestructura del proyecto.
- Variables de entorno correctamente configuradas.

Para ejecutarla fuera de los contenedores también se requiere PHP 8.3 y Composer.

## Configuración

La API utiliza variables de entorno para configurar la aplicación, la conexión con PostgreSQL, la autenticación y el administrador inicial.

El archivo `.env.example` contiene la estructura de referencia.

Entre las principales variables se encuentran:

```text
APP_KEY
DB_CONNECTION
DB_HOST
DB_PORT
DB_DATABASE
DB_USERNAME
DB_PASSWORD
JWT_SECRET
ADMIN_USERNAME
ADMIN_PASSWORD
CORS_ORIGIN
```

Las contraseñas, claves y secretos reales no deben publicarse en el repositorio.

## Ejecución

La forma principal de iniciar la API es mediante la infraestructura Docker del proyecto.

Desde la carpeta `infra/`:

```bash
docker compose up --build
```

La API queda disponible en:

```text
http://localhost:8000/api/v1
```

Para comprobar que está funcionando:

```text
http://localhost:8000/api/v1/health
```

La respuesta esperada del servicio de salud es:

```json
{
  "status": "ok"
}
```

## Base de datos

La API utiliza PostgreSQL.

La creación y actualización del esquema se realiza mediante las migraciones de Laravel ubicadas en:

```text
database/migrations/
```

Al iniciar el contenedor, la API ejecuta las migraciones y posteriormente provisiona el administrador inicial utilizando las variables de entorno configuradas.

## Autenticación y roles

El sistema utiliza autenticación mediante JWT.

Los tokens incluyen el identificador y el rol del operador y tienen una vigencia de ocho horas.

Existen dos roles:

- `admin`: puede realizar las operaciones administrativas del catálogo, registrar asesores y consultar el informe de trajes más solicitados.
- `advisor`: puede realizar las operaciones autorizadas para la gestión de clientes, alquileres, devoluciones y consultas operativas.

Los clientes no requieren una cuenta de acceso.

El administrador inicial se configura mediante variables de entorno y se provisiona al iniciar la API. No se crea mediante el endpoint de registro de usuarios.

## Funcionalidades principales

La API permite:

1. Iniciar sesión.
2. Registrar asesores desde una cuenta administrativa.
3. Consultar las categorías.
4. Registrar, consultar, actualizar y retirar lógicamente trajes.
5. Administrar fotografías de los trajes.
6. Registrar y consultar clientes.
7. Registrar alquileres.
8. Registrar devoluciones.
9. Consultar alquileres vencidos.
10. Consultar el informe de trajes más solicitados.

## Categorías

El sistema trabaja con cinco categorías:

- `gala`
- `folclor`
- `teatro`
- `infantiles`
- `temporada`

Las categorías pueden consultarse mediante la API y son utilizadas para clasificar los trajes del catálogo.

## Reglas principales

La API controla las reglas de negocio del sistema, entre ellas:

- Un cliente puede tener como máximo cinco trajes sin devolver.
- El plazo de alquiler es de cuatro días.
- Un cliente con alquileres vencidos no puede recibir nuevos trajes hasta realizar la devolución correspondiente.
- Las unidades disponibles se mantienen entre cero y el total de unidades del traje.
- La información histórica de cada línea de alquiler se conserva aunque posteriormente cambie el catálogo.
- Los alquileres y las devoluciones conservan su historial.
- Los trajes se retiran del catálogo mediante eliminación lógica.
- Las fechas de la operación se manejan en UTC.

Cada alquiler permite seleccionar entre uno y tres trajes, respetando además el límite global de cinco trajes sin devolver por cliente.

## Concurrencia

La API controla el acceso concurrente a las unidades disponibles.

Cuando dos operadores intentan alquilar simultáneamente la última unidad disponible de un traje, solamente una operación puede completarse correctamente.

El resultado esperado es:

```text
Una operación       → HTTP 201
La otra operación   → HTTP 409
Unidades disponibles → 0
```

Esto evita que la misma última unidad disponible sea asignada a dos alquileres diferentes.

## Endpoints

La API utiliza como base:

```text
/api/v1
```

Las rutas públicas son:

```text
GET  /api/v1/health
POST /api/v1/auth/login
```

Las demás rutas requieren autenticación mediante token Bearer.

Entre los principales recursos se encuentran:

```text
/users
/categories
/costumes
/customers
/rentals
/rentals/overdue
/reports/most-rented
```

Las operaciones administrativas adicionales son verificadas según el rol del operador autenticado.

## Pruebas

Las pruebas automatizadas se encuentran en:

```text
tests/
├── Feature/
└── Unit/
```

Para ejecutar las pruebas en un entorno correctamente configurado:

```bash
php artisan test
```

Las pruebas incluyen casos relacionados con:

- Arquitectura.
- Autenticación.
- Autorización por roles.
- Categorías.
- Creación, consulta, actualización y retiro de trajes.
- Referencias duplicadas.
- Búsqueda y paginación.
- Clientes.
- Alquileres.
- Disponibilidad.
- Límites de alquiler.
- Vencimientos.
- Devoluciones.
- Informes.
- Reglas del dominio.

## Manejo de errores

La API utiliza respuestas JSON uniformes para los errores.

La estructura general es:

```json
{
  "code": "ERROR_CODE",
  "message": "Mensaje para el usuario.",
  "details": []
}
```

Entre los códigos HTTP utilizados se encuentran:

- `401`: credenciales o autenticación inválida.
- `403`: operación no permitida para el rol.
- `404`: recurso no encontrado.
- `409`: conflicto de negocio o concurrencia.
- `422`: datos o reglas de validación no cumplidas.

Los mensajes visibles para el usuario se presentan en español.

## Seguridad

- No se deben publicar archivos `.env`.
- Las contraseñas y secretos no se almacenan directamente en el código.
- `JWT_SECRET` debe mantenerse privado y tener al menos 32 caracteres.
- `APP_KEY` debe mantenerse privada.
- Las contraseñas de los operadores se almacenan mediante Argon2id.
- Las rutas protegidas requieren autenticación mediante token.
- Las operaciones administrativas verifican el rol correspondiente.
- La API solo permite crear usuarios con rol `advisor` mediante el endpoint de usuarios.
- El administrador inicial se provisiona mediante la configuración del entorno.

## Framework

La API está desarrollada con Laravel y aprovecha su estructura de aplicación, sistema de rutas, validación, middleware, migraciones y herramientas de prueba.

La lógica específica de Costumes se organiza en componentes de dominio, aplicación, adaptadores, puertos, controladores y utilidades de soporte para mantener separadas las responsabilidades principales del sistema.
