# Contrato HTTP — Costumes

## 1. Convenciones generales

La API utiliza como ruta base:

`/api/v1`

La comunicación se realiza mediante JSON UTF-8 utilizando nombres de propiedades en `snake_case`.

Los identificadores utilizan UUID v4 y las fechas se representan en formato ISO 8601 UTC terminadas en `Z`.

Todos los endpoints requieren autenticación mediante:

`Authorization: Bearer <token>`

excepto:

- `POST /auth/login`
- `GET /health`

Los mensajes destinados al usuario se presentan en español.

## 2. Paginación

Los endpoints que retornan colecciones utilizan:

`page=1&size=20`

El tamaño máximo permitido es `50`.

Formato general de respuesta:

```json
{
  "items": [],
  "page": 1,
  "size": 20,
  "total": 0
}
```

## 3. Formato de errores

Los errores utilizan una estructura uniforme:

```json
{
  "code": "COSTUME_NOT_AVAILABLE",
  "message": "No hay unidades disponibles.",
  "details": []
}
```

Los códigos HTTP utilizados son:

| Código | Uso |
|---|---|
| `200` | Consulta u operación completada correctamente. |
| `201` | Recurso u operación creada correctamente. |
| `401` | Autenticación ausente o inválida. |
| `403` | El usuario autenticado no posee el rol requerido. |
| `404` | El recurso solicitado no existe. |
| `409` | Conflicto con el estado actual del sistema. |
| `422` | Datos o reglas de validación inválidos. |

`details` nunca debe exponer consultas SQL, rutas internas, contraseñas, hashes, claves, secretos ni trazas de ejecución.

## 4. Autenticación

### POST `/auth/login`

**Acceso:** público.

Solicitud:

```json
{
  "username": "advisor01",
  "password": "password"
}
```

Respuesta exitosa:

```json
{
  "access_token": "token",
  "token_type": "Bearer",
  "expires_in": 28800,
  "role": "advisor"
}
```

El token tiene una vigencia de ocho horas.

Credenciales inválidas:

`401 INVALID_CREDENTIALS`

## 5. Estado del servicio

### GET `/health`

**Acceso:** público.

Respuesta:

```json
{
  "status": "ok"
}
```

## 6. Usuarios

### POST `/users`

**Rol:** `admin`

Permite crear únicamente usuarios con rol `advisor`.

Solicitud:

```json
{
  "username": "advisor01",
  "password": "password",
  "role": "advisor"
}
```

No se permite crear usuarios con rol `admin` mediante la API.

Posibles errores:

- `409 USERNAME_TAKEN`
- `422 VALIDATION_ERROR`
- `403 FORBIDDEN_ROLE`

Las respuestas nunca incluyen la contraseña ni su hash.

## 7. Categorías

### GET `/categories`

**Acceso:** autenticado.

Retorna las cinco categorías disponibles:

- gala
- folclor
- teatro
- infantiles
- temporada

## 8. Trajes

### GET `/costumes`

**Acceso:** autenticado.

Parámetros disponibles:

- `q`
- `category_id`
- `page`
- `size`

Permite buscar trajes activos por nombre o diseñador y filtrar por categoría.

### GET `/costumes/{id}`

**Acceso:** autenticado.

Retorna el detalle de un traje activo.

Si no existe o se encuentra dado de baja:

`404 NOT_FOUND`

### POST `/costumes`

**Rol:** `admin`

Solicitud:

```json
{
  "name": "Traje de gala clásico",
  "designer": "Diseñador",
  "reference": "GAL-001",
  "category_id": "uuid",
  "total_units": 5
}
```

Al crear el traje:

`available_units = total_units`

Una referencia activa duplicada produce:

`409 REFERENCE_TAKEN`

### PUT `/costumes/{id}`

**Rol:** `admin`

Permite reemplazar:

```json
{
  "name": "Traje de gala clásico",
  "designer": "Diseñador",
  "category_id": "uuid",
  "total_units": 6
}
```

Al modificar `total_units`, las unidades disponibles se ajustan según la diferencia sin permitir valores por debajo de cero ni por encima del total.

### DELETE `/costumes/{id}`

**Rol:** `admin`

Realiza la baja lógica del traje.

No elimina físicamente el registro.

Si existen alquileres abiertos asociados que impiden la operación:

`409 COSTUME_HAS_OPEN_RENTALS`

## 9. Portada del traje

### PUT `/costumes/{id}/cover`

**Rol:** `admin`

Recibe `multipart/form-data` con:

`file`

Formatos permitidos:

- JPG
- PNG

Tamaño máximo:

`2 MB`

### GET `/costumes/{id}/cover`

**Acceso:** autenticado.

Retorna la imagen almacenada.

Si no existe:

`404 NOT_FOUND`

### DELETE `/costumes/{id}/cover`

**Rol:** `admin`

Elimina la portada asociada al traje.

## 10. Objeto traje

Representación general:

```json
{
  "id": "uuid",
  "name": "Traje de gala clásico",
  "designer": "Diseñador",
  "reference": "GAL-001",
  "category": {
    "id": "uuid",
    "name": "gala"
  },
  "total_units": 5,
  "available_units": 4,
  "cover_key": null
}
```

Debe cumplirse siempre:

`0 <= available_units <= total_units`

## 11. Clientes

### GET `/customers`

**Roles:** `admin`, `advisor`

Parámetros:

- `q`
- `page`
- `size`

Permite buscar por nombre o número de documento.

### GET `/customers/{id}`

**Roles:** `admin`, `advisor`

Retorna el detalle del cliente y sus líneas de alquiler activas mediante:

`active_rentals`

### POST `/customers`

**Roles:** `admin`, `advisor`

Solicitud:

```json
{
  "full_name": "Nombre del cliente",
  "document_number": "123456789"
}
```

Documento duplicado:

`409 DOCUMENT_TAKEN`

Los clientes no se eliminan.

## 12. Registrar alquiler

### POST `/rentals`

**Roles:** `admin`, `advisor`

Solicitud:

```json
{
  "customer_id": "uuid",
  "items": [
    {
      "costume_id": "uuid"
    }
  ]
}
```

Cada alquiler contiene entre **1 y 3 líneas**.

No se puede repetir el mismo traje dentro del mismo alquiler.

Antes de registrar la operación, el backend debe verificar:

- Que el cliente no tenga alquileres vencidos pendientes.
- Que el cliente no supere un máximo de 5 trajes sin devolver entre todos sus alquileres.
- Que cada traje tenga unidades disponibles.
- Que un mismo traje no aparezca repetido dentro del alquiler.

El registro del alquiler y la modificación de disponibilidad se realizan dentro de una transacción.

Si una línea no puede registrarse, no debe persistirse parcialmente el alquiler.

Posibles errores:

- `409 COSTUME_NOT_AVAILABLE`
- `409 CUSTOMER_HAS_OVERDUE`
- `422 CUSTOMER_LIMIT_EXCEEDED`
- `422 DUPLICATE_COSTUME_IN_RENTAL`
- `422 VALIDATION_ERROR`

Cuando dos operadores intenten alquilar simultáneamente la última unidad disponible, una operación debe completarse con `201` y la otra debe recibir `409`.

## 13. Consultar alquileres

### GET `/rentals`

**Roles:** `admin`, `advisor`

Filtros:

- `from`
- `to`
- `status`
- `customer_id`
- `page`
- `size`

Los estados disponibles son:

- `open`
- `overdue`
- `closed`

El estado se calcula y no se almacena como valor persistente.

### GET `/rentals/{id}`

**Roles:** `admin`, `advisor`

Retorna el alquiler, sus líneas y su estado calculado.

## 14. Objeto alquiler

Representación general:

```json
{
  "id": "uuid",
  "customer_id": "uuid",
  "rented_at": "2026-11-11T15:00:00Z",
  "status": "open",
  "items": [
    {
      "id": "uuid",
      "costume_id": "uuid",
      "costume_name": "Traje de gala clásico",
      "reference": "GAL-001",
      "category_name": "gala",
      "due_at": "2026-11-15T15:00:00Z",
      "returned_at": null
    }
  ]
}
```

Cada línea conserva congelados:

- `costume_name`
- `reference`
- `category_name`

Estos valores no cambian si posteriormente se modifica el catálogo.

La fecha límite se calcula como:

`due_at = rented_at + 4 días`

## 15. Registrar devolución

### POST `/rentals/{rental_id}/items/{item_id}/return`

**Roles:** `admin`, `advisor`

Registra la devolución de una única línea.

La operación:

1. Verifica que la línea no haya sido devuelta.
2. Registra `returned_at` en UTC.
3. Incrementa una unidad disponible del traje.
4. Mantiene `available_units <= total_units`.

Intentar devolver nuevamente una línea ya devuelta produce:

`409 ITEM_ALREADY_RETURNED`

Los alquileres y devoluciones no se eliminan.

## 16. Consultar vencidos

### GET `/rentals/overdue`

**Roles:** `admin`, `advisor`

Retorna las líneas que cumplen:

`returned_at = null`

y:

`due_at < current_time`

La respuesta incluye `days_late`.

Los resultados se ordenan comenzando por los de mayor retraso.

## 17. Reporte de trajes más solicitados

### GET `/reports/most-rented`

**Rol:** `admin`

Parámetros:

- `from`
- `to`

El intervalo de fechas es inclusivo.

Respuesta:

```json
{
  "from": "2026-11-01",
  "to": "2026-11-30",
  "rows": [
    {
      "costume_id": "uuid",
      "costume_name": "Traje de gala clásico",
      "category_name": "gala",
      "times_rented": 10
    }
  ]
}
```

El reporte utiliza la información congelada de las líneas de alquiler.

No expone información del cliente ni del asesor.

Si `to` es anterior a `from`:

`422 INVALID_DATE_RANGE`

Cuando no existen alquileres en el intervalo:

```json
{
  "from": "2026-11-01",
  "to": "2026-11-30",
  "rows": []
}
```

## 18. Códigos de error

Los códigos definidos para la API son:

| Código | Significado |
|---|---|
| `INVALID_CREDENTIALS` | Credenciales de autenticación inválidas. |
| `FORBIDDEN_ROLE` | El rol no permite realizar la operación. |
| `NOT_FOUND` | El recurso solicitado no existe. |
| `USERNAME_TAKEN` | El nombre de usuario ya está registrado. |
| `REFERENCE_TAKEN` | La referencia del traje ya está utilizada. |
| `DOCUMENT_TAKEN` | El documento del cliente ya está registrado. |
| `COSTUME_HAS_OPEN_RENTALS` | El traje posee alquileres abiertos que impiden la operación. |
| `COSTUME_NOT_AVAILABLE` | No existen unidades disponibles. |
| `CUSTOMER_HAS_OVERDUE` | El cliente posee alquileres vencidos pendientes. |
| `ITEM_ALREADY_RETURNED` | La línea ya fue devuelta. |
| `CUSTOMER_LIMIT_EXCEEDED` | El cliente superaría el máximo de cinco trajes sin devolver. |
| `DUPLICATE_COSTUME_IN_RENTAL` | Un mismo traje aparece repetido dentro del alquiler. |
| `VALIDATION_ERROR` | Los datos recibidos no cumplen las validaciones. |
| `INVALID_DATE_RANGE` | El intervalo de fechas no es válido. |

## 19. Resumen de endpoints

| Método | Endpoint | Acceso | Operación |
|---|---|---|---|
| POST | `/auth/login` | Público | Autenticación |
| GET | `/health` | Público | Estado del servicio |
| POST | `/users` | `admin` | Crear asesor |
| GET | `/categories` | Autenticado | Listar categorías |
| GET | `/costumes` | Autenticado | Buscar trajes |
| GET | `/costumes/{id}` | Autenticado | Consultar traje |
| POST | `/costumes` | `admin` | Crear traje |
| PUT | `/costumes/{id}` | `admin` | Actualizar traje |
| DELETE | `/costumes/{id}` | `admin` | Baja lógica |
| PUT | `/costumes/{id}/cover` | `admin` | Registrar portada |
| GET | `/costumes/{id}/cover` | Autenticado | Consultar portada |
| DELETE | `/costumes/{id}/cover` | `admin` | Eliminar portada |
| GET | `/customers` | `admin`, `advisor` | Buscar clientes |
| GET | `/customers/{id}` | `admin`, `advisor` | Consultar cliente |
| POST | `/customers` | `admin`, `advisor` | Crear cliente |
| POST | `/rentals` | `admin`, `advisor` | Registrar alquiler |
| GET | `/rentals` | `admin`, `advisor` | Listar alquileres |
| GET | `/rentals/overdue` | `admin`, `advisor` | Consultar vencidos |
| GET | `/rentals/{id}` | `admin`, `advisor` | Consultar alquiler |
| POST | `/rentals/{rental_id}/items/{item_id}/return` | `admin`, `advisor` | Registrar devolución |
| GET | `/reports/most-rented` | `admin` | Reporte de trajes más solicitados |
