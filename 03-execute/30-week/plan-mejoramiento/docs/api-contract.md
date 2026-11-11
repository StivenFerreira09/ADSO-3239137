# Contrato de API — Costumes

## 1. Propósito

Este documento define el contrato de la API de `Costumes`, utilizada para la comunicación entre la aplicación frontend y el backend.

La API permite gestionar la autenticación, asesores, trajes, clientes, alquileres, devoluciones y consultas necesarias para la operación del sistema.

## 2. Convenciones generales

La API utiliza HTTP y trabaja con información en formato JSON.

Los identificadores utilizados en el código y en la estructura técnica de la API se escriben en inglés.

Los mensajes destinados al usuario se presentan en español.

Las fechas e instantes se manejan en UTC.

## 3. Códigos HTTP

La API utiliza los códigos HTTP correspondientes al resultado de cada operación.

Entre los principales se encuentran:

- `200 OK`: operación o consulta realizada correctamente.
- `201 Created`: recurso u operación creada correctamente.
- `400 Bad Request`: solicitud inválida.
- `401 Unauthorized`: autenticación requerida o credenciales inválidas.
- `404 Not Found`: recurso no encontrado.
- `409 Conflict`: la operación entra en conflicto con el estado actual del sistema.
- `422 Unprocessable Entity`: los datos enviados no cumplen las validaciones.

## 4. Estructura de errores

Las respuestas de error deben mantener una estructura uniforme:

```json
{
  "code": "ERROR_CODE",
  "message": "Mensaje para el usuario en español.",
  "details": {}
}
```

Donde:

- `code`: identifica técnicamente el error.
- `message`: explica el resultado al usuario en español.
- `details`: contiene información adicional cuando sea necesaria.

# 5. Autenticación

## Iniciar sesión

`POST /api/login`

Permite autenticar a un asesor mediante sus credenciales.

### Solicitud

```json
{
  "email": "asesor@example.com",
  "password": "password"
}
```

### Resultado

Si las credenciales son válidas, la API permite continuar con las operaciones protegidas.

Si son inválidas, la solicitud debe ser rechazada.

# 6. Asesores

## Registrar asesor

`POST /api/advisors`

Registra un nuevo asesor.

### Datos principales

```json
{
  "name": "Nombre del asesor",
  "email": "asesor@example.com",
  "password": "password"
}
```

La contraseña debe almacenarse mediante hash y nunca en texto plano.

# 7. Trajes

## Listar trajes

`GET /api/costumes`

Devuelve los trajes disponibles para consulta en el catálogo.

## Consultar traje

`GET /api/costumes/{id}`

Devuelve la información correspondiente a un traje.

## Registrar traje

`POST /api/costumes`

Registra un nuevo traje en el catálogo.

### Datos principales

```json
{
  "reference": "COS-001",
  "name": "Traje de gala",
  "category_id": 1,
  "total_units": 5
}
```

## Actualizar traje

`PUT /api/costumes/{id}`

Actualiza la información permitida de un traje existente.

## Dar de baja un traje

`DELETE /api/costumes/{id}`

Realiza la baja lógica del traje.

La eliminación no debe borrar físicamente el registro del catálogo.

## Buscar trajes

`GET /api/costumes/search`

Permite buscar trajes registrados en el catálogo.

La búsqueda debe respetar el estado de los elementos y la disponibilidad correspondiente.

# 8. Categorías

## Listar categorías

`GET /api/categories`

Devuelve las categorías disponibles para clasificar los trajes.

Las categorías iniciales son:

1. Gala.
2. Folclor.
3. Teatro.
4. Infantiles.
5. Temporada.

# 9. Clientes

## Listar clientes

`GET /api/clients`

Devuelve los clientes registrados.

## Consultar cliente

`GET /api/clients/{id}`

Devuelve la información de un cliente específico.

## Registrar cliente

`POST /api/clients`

Registra un nuevo cliente.

## Actualizar cliente

`PUT /api/clients/{id}`

Actualiza la información permitida de un cliente.

# 10. Alquileres

## Listar alquileres

`GET /api/rentals`

Devuelve las operaciones de alquiler registradas.

## Consultar alquiler

`GET /api/rentals/{id}`

Devuelve la información de un alquiler específico.

## Registrar alquiler

`POST /api/rentals`

Registra una nueva operación de alquiler.

### Ejemplo de solicitud

```json
{
  "client_id": 1,
  "items": [
    {
      "costume_id": 1,
      "quantity": 1
    }
  ]
}
```

### Validaciones

Antes de confirmar el alquiler, la API debe comprobar:

- Que el cliente exista.
- Que el cliente no supere cinco trajes sin devolver.
- Que el cliente no tenga alquileres vencidos.
- Que las unidades solicitadas estén disponibles.
- Que la disponibilidad permanezca entre cero y el total de unidades.

El plazo del alquiler es de cuatro días.

La información correspondiente al traje debe quedar congelada en la línea de la operación.

# 11. Concurrencia en alquileres

Si dos operadores intentan alquilar simultáneamente la última unidad disponible, solamente una operación puede completarse.

La operación exitosa debe responder:

`201 Created`

La operación que no pueda obtener la última unidad debe responder:

`409 Conflict`

La disponibilidad nunca puede quedar por debajo de cero.

# 12. Devoluciones

## Registrar devolución

`POST /api/returns`

Registra la devolución de uno o varios elementos correspondientes a un alquiler.

### Ejemplo de solicitud

```json
{
  "rental_id": 1,
  "items": [
    {
      "costume_id": 1,
      "quantity": 1
    }
  ]
}
```

### Resultado

Una devolución válida debe:

- Registrar la operación.
- Actualizar el estado correspondiente.
- Recuperar las unidades disponibles.
- Mantener el registro histórico de la devolución.

Las devoluciones no deben eliminarse.

# 13. Alquileres vencidos

## Consultar vencidos

`GET /api/rentals/overdue`

Devuelve los alquileres que han superado su fecha límite y continúan pendientes de devolución.

Un cliente con alquileres vencidos no puede recibir nuevos trajes hasta realizar las devoluciones correspondientes.

# 14. Reporte de trajes más solicitados

## Consultar reporte

`GET /api/reports/most-requested-costumes`

Devuelve los trajes con mayor número de solicitudes de acuerdo con las operaciones de alquiler registradas.

La información histórica de los alquileres debe utilizarse para generar el reporte.

# 15. Disponibilidad

La API debe mantener en todo momento la siguiente condición:

`0 <= available_units <= total_units`

Un alquiler disminuye las unidades disponibles y una devolución válida las incrementa.

La API debe impedir cualquier operación que genere una disponibilidad inválida.

# 16. Conservación de información

Los alquileres y devoluciones forman parte del historial del sistema y no deben eliminarse.

Los cambios posteriores realizados sobre un traje del catálogo tampoco deben modificar la información congelada dentro de las líneas de alquiler.

# 17. Manejo de fechas

Todas las fechas e instantes intercambiados y almacenados por el sistema deben manejarse en UTC.

Esto incluye principalmente:

- Fecha del alquiler.
- Fecha límite de devolución.
- Fecha de devolución.
- Determinación de vencimientos.
