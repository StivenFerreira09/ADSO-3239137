# Evidencias de pruebas

## Descripción

Esta carpeta reúne las evidencias obtenidas durante la validación funcional y técnica de Costumes.

Las comprobaciones se realizaron sobre los servicios reales del proyecto, incluyendo la API, PostgreSQL, la aplicación web, la página pública y las herramientas disponibles en `tool/`.

Las evidencias permiten verificar el funcionamiento de los principales procesos del sistema, las reglas de negocio, el control de acceso, la concurrencia y el rendimiento del catálogo.

## Resumen de resultados

| Prueba | Validación | Resultado | Evidencia |
|---|---|---|---|
| CP-01 | Servicios Docker | Aprobada | [Ver evidencia](evidence/01_docker_services.png) |
| CP-02 | Estado de la API | Aprobada | [Ver evidencia](evidence/02_api_health.png) |
| CP-03 | Pruebas automatizadas | Aprobada | [Ver evidencia](evidence/03_automated_tests.png) |
| CP-04 | Carga de datos por API | Aprobada | [Ver evidencia](evidence/04_data_seeder.png) |
| CP-05 | Inicio de sesión | Aprobada | [Ver evidencia](evidence/05_login.png) |
| CP-06 | Catálogo de trajes | Aprobada | [Ver evidencia](evidence/06_costume_catalogue.png) |
| CP-07 | Registro de cliente | Aprobada | [Ver evidencia](evidence/07_customer_registration.png) |
| CP-08 | Registro de alquiler | Aprobada | [Ver evidencia](evidence/08_rental_registration.png) |
| CP-09 | Registro de devolución | Aprobada | [Ver evidencia](evidence/09_return_registration.png) |
| CP-10 | Alquileres vencidos | Aprobada | [Ver evidencia](evidence/10_overdue_rentals.png) |
| CP-11 | Concurrencia de última unidad | Aprobada | [Ver evidencia](evidence/11_concurrency_test.png) |
| CP-12 | Reporte de trajes más solicitados | Aprobada | [Ver evidencia](evidence/12_most_rented_report.png) |
| CP-13 | Página pública | Aprobada | [Ver evidencia](evidence/13_public_page.png) |
| CP-14 | Permisos por rol | Aprobada | [Ver evidencia](evidence/14_role_permissions.png) |
| CP-15 | Rendimiento del catálogo | Aprobada | [Ver evidencia](evidence/15_catalogue_benchmark.png) |

## CP-01 — Servicios Docker

Se verificó el inicio de los servicios definidos en Docker Compose.

Los servicios `api`, `app`, `db` y `page` iniciaron correctamente y PostgreSQL alcanzó el estado `healthy`.

**Resultado:** Aprobada.

[Ver evidencia](evidence/01_docker_services.png)

## CP-02 — Estado de la API

Se consultó el endpoint de salud de la API:

```text
GET /api/v1/health
```

La API respondió correctamente con:

```json
{"status":"ok"}
```

**Resultado:** Aprobada.

[Ver evidencia](evidence/02_api_health.png)

## CP-03 — Pruebas automatizadas

Se ejecutó la suite de pruebas automatizadas del backend mediante PHPUnit.

Resultado obtenido:

```text
30 / 30 (100%)
OK (30 tests, 77 assertions)
```

**Resultado:** Aprobada.

[Ver evidencia](evidence/03_automated_tests.png)

## CP-04 — Carga de datos por API

Se ejecutó `tool/seed.py` utilizando la API autenticada.

La carga generó:

- 40 trajes.
- 10 clientes.
- 15 alquileres.

Los datos fueron creados mediante los endpoints públicos de la API, sin realizar una carga directa mediante SQL.

**Resultado:** Aprobada.

[Ver evidencia](evidence/04_data_seeder.png)

## CP-05 — Inicio de sesión

Se verificó la autenticación del administrador.

La API respondió:

```text
HTTP 200
token_type: Bearer
expires_in: 28800
role: admin
access_token: GENERADO
```

La evidencia no expone la contraseña ni el contenido del token.

**Resultado:** Aprobada.

[Ver evidencia](evidence/05_login.png)

## CP-06 — Catálogo de trajes

Se consultó el catálogo autenticado mediante:

```text
GET /api/v1/costumes
```

La API respondió `HTTP 200` y permitió consultar los trajes con información de referencia, nombre, categoría y unidades disponibles.

Durante la comprobación inicial se visualizaron los 40 trajes cargados por el sembrador.

**Resultado:** Aprobada.

[Ver evidencia](evidence/06_costume_catalogue.png)

## CP-07 — Registro de cliente

Se creó un cliente mediante la API utilizando los campos `full_name` y `document_number`.

La operación respondió:

```text
HTTP 201
```

El sistema generó correctamente el identificador UUID del nuevo cliente.

**Resultado:** Aprobada.

[Ver evidencia](evidence/07_customer_registration.png)

## CP-08 — Registro de alquiler

Se registró un alquiler para un cliente y un traje disponible.

La API respondió:

```text
HTTP 201
status: open
```

También se comprobó que `due_at` quedó establecido cuatro días después de `rented_at` y que las fechas se registraron en UTC.

**Resultado:** Aprobada.

[Ver evidencia](evidence/08_rental_registration.png)

## CP-09 — Registro de devolución

Se registró la devolución del traje utilizado en CP-08.

La API respondió:

```text
HTTP 200
rental_status: closed
```

El campo `returned_at` quedó registrado y el alquiler pasó correctamente de `open` a `closed`.

**Resultado:** Aprobada.

[Ver evidencia](evidence/09_return_registration.png)

## CP-10 — Alquileres vencidos

Para validar el escenario sin esperar cuatro días reales, se creó un alquiler exclusivo para la prueba y se ajustó su `due_at` a una fecha anterior, siguiendo el escenario utilizado por las pruebas del proyecto.

Posteriormente se verificó que:

```text
GET /api/v1/rentals/overdue
```

identificara correctamente el alquiler vencido.

También se intentó registrar un nuevo alquiler para el mismo cliente. La API respondió:

```text
HTTP 409
code: CUSTOMER_HAS_OVERDUE
```

Esto confirma que un cliente con alquileres vencidos no puede recibir un nuevo alquiler mientras mantenga la situación pendiente.

**Resultado:** Aprobada.

[Ver evidencia](evidence/10_overdue_rentals.png)

## CP-11 — Concurrencia de última unidad

Se ejecutó `tool/check_concurrency.py` para simular dos solicitudes simultáneas sobre la última unidad disponible de un traje.

El resultado fue:

```text
Códigos recibidos: [201, 409]
Concurrencia correcta: una entrega, un conflicto, cero unidades restantes.
```

Esto confirma que únicamente una solicitud puede tomar la última unidad disponible y que la segunda recibe un conflicto, evitando el sobrealquiler.

**Resultado:** Aprobada.

[Ver evidencia](evidence/11_concurrency_test.png)

## CP-12 — Reporte de trajes más solicitados

Se consultó el reporte:

```text
GET /api/v1/reports/most-rented
```

La API respondió `HTTP 200` y presentó los resultados ordenados por cantidad de alquileres.

Durante la prueba, `Capa de mago 10` ocupó la primera posición con tres alquileres.

**Resultado:** Aprobada.

[Ver evidencia](evidence/12_most_rented_report.png)

## CP-13 — Página pública

Se verificó el servicio de la página pública mediante Nginx y posteriormente se comprobó su visualización en el navegador.

La página de Costumes cargó correctamente, mostrando su identidad visual, navegación, información del producto y contenido en español.

**Resultado:** Aprobada.

[Ver evidencia](evidence/13_public_page.png)

## CP-14 — Permisos por rol

Se creó un usuario con rol `advisor` y se verificó que pudiera autenticarse correctamente.

Posteriormente se intentó acceder a una función reservada al administrador.

La API respondió:

```text
HTTP 403
code: FORBIDDEN_ROLE
message: No tiene permiso para realizar esta acción.
```

Esto confirma que el sistema aplica correctamente las restricciones de acceso según el rol del usuario autenticado.

**Resultado:** Aprobada.

[Ver evidencia](evidence/14_role_permissions.png)

## CP-15 — Rendimiento del catálogo

Antes de ejecutar la medición se completó el catálogo hasta alcanzar:

```text
total_final: 5000
objetivo: 5000
preparacion_benchmark: COMPLETA
```

Posteriormente se ejecutó `tool/benchmark.py`, realizando 30 consultas reales sobre el catálogo.

Resultado:

```text
Mediana: 42.5 ms
Máximo: 79.9 ms
Consultas: 30
```

El requisito evaluado establece un tiempo inferior a `300 ms` con 5.000 trajes.

Tanto la mediana como el tiempo máximo obtenido se mantuvieron por debajo del límite establecido.

**Resultado:** Aprobada.

[Ver evidencia](evidence/15_catalogue_benchmark.png)

## Resultado general

Se completaron las 15 comprobaciones definidas para la validación del sistema.

```text
Pruebas realizadas: 15
Pruebas aprobadas: 15
Resultado: 100% de las comprobaciones aprobadas
```

Las evidencias confirman el funcionamiento de la infraestructura, API, autenticación, catálogo, clientes, alquileres, devoluciones, vencimientos, concurrencia, reportes, página pública, control de acceso y rendimiento del catálogo.
