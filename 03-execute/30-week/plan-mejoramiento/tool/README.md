# Costumes - Herramientas de apoyo

## Descripción

Esta carpeta contiene herramientas desarrolladas en Python para apoyar la carga de datos, las pruebas de concurrencia y la medición del rendimiento del sistema Costumes mediante solicitudes HTTP a la API REST de Laravel.

Las herramientas se comunican con la API y no insertan ni modifican información directamente en la base de datos.

## Tecnologías

- Python 3.
- Librería estándar de Python.
- Solicitudes HTTP.
- API REST de Laravel.

## Estructura

```text
tool/
├── README.md
├── api_client.py
├── benchmark.py
├── check_concurrency.py
└── seed.py
```

## Requisitos

- Python 3 instalado.
- API de Costumes funcionando.
- Base de datos PostgreSQL configurada y disponible.
- Administrador inicial creado.
- Credenciales válidas del administrador.

## Configuración

Por defecto, las herramientas utilizan la siguiente dirección de la API:

`http://localhost:8000/api/v1`

El usuario administrador puede obtenerse desde la variable de entorno `ADMIN_USERNAME`. La contraseña puede proporcionarse mediante `ADMIN_PASSWORD` o ingresarse de forma segura cuando la herramienta la solicite.

Las credenciales no se almacenan directamente en los scripts.

## Ejecución

Los comandos pueden ejecutarse desde la raíz del proyecto.

### Cargar datos de demostración

`python3 tool/seed.py --url http://localhost:8000/api/v1 --username admin`

### Verificar concurrencia

`python3 tool/check_concurrency.py --url http://localhost:8000/api/v1 --username admin`

### Medir el rendimiento de búsqueda

`python3 tool/benchmark.py --url http://localhost:8000/api/v1 --username admin`

## Funcionamiento

Las herramientas cumplen diferentes funciones dentro del proyecto:

1. `api_client.py` proporciona un cliente HTTP reutilizable para comunicarse con la API y gestionar la autenticación.
2. `seed.py` carga datos de demostración mediante la API.
3. `check_concurrency.py` comprueba el comportamiento del sistema cuando dos solicitudes intentan alquilar simultáneamente la última unidad disponible.
4. `benchmark.py` mide el tiempo de respuesta de las consultas realizadas al catálogo.

## Carga de datos

`seed.py` registra mediante la API:

- 40 trajes.
- 10 clientes.
- 15 alquileres.

También verifica que el sistema tenga las cinco categorías definidas para el catálogo.

La herramienta presupone un entorno de demostración vacío y no es idempotente. Para repetir la carga desde cero durante el desarrollo, se debe restaurar cuidadosamente una base de datos vacía.

Las líneas vencidas no se generan modificando fechas mediante la API, ya que el contrato establece un plazo de cuatro días para los alquileres.

## Prueba de concurrencia

`check_concurrency.py` crea un traje con una sola unidad disponible y realiza dos solicitudes de alquiler de forma simultánea.

El resultado esperado es:

- Una solicitud exitosa con código HTTP `201`.
- Una solicitud rechazada por conflicto con código HTTP `409`.
- Cero unidades disponibles después de completar la prueba.

Esto permite comprobar que una misma última unidad no pueda ser asignada a dos alquileres simultáneamente.

## Prueba de rendimiento

`benchmark.py` realiza 30 consultas al catálogo y calcula la mediana y el tiempo máximo de respuesta.

La comprobación del requisito de búsqueda inferior a 300 ms debe realizarse con 5.000 trajes cargados realmente en el sistema antes de ejecutar la medición.

## Comunicación con la API

Todas las operaciones se realizan mediante solicitudes HTTP a la API REST.

Las herramientas no ejecutan instrucciones SQL ni modifican directamente la base de datos PostgreSQL.

## Resultado esperado

Según la herramienta ejecutada, se obtiene:

- Confirmación de la carga de datos de demostración.
- Resultado de la prueba de concurrencia.
- Códigos HTTP `201` y `409` en la competencia por la última unidad.
- Medición del rendimiento de las búsquedas del catálogo.

## Seguridad

Las contraseñas y secretos no deben escribirse directamente en los archivos de esta carpeta ni publicarse en el repositorio.

Cuando la contraseña del administrador no se proporciona mediante una variable de entorno, las herramientas la solicitan durante la ejecución sin almacenarla en los archivos del proyecto.
