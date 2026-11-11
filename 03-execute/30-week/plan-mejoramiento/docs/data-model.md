# Modelo de datos — Costumes

## 1. Propósito

Este documento describe el modelo de datos de `Costumes` y las principales entidades necesarias para gestionar asesores, clientes, categorías, trajes, alquileres y devoluciones.

El modelo debe conservar el historial de las operaciones y garantizar la consistencia de la disponibilidad de los trajes.

## 2. Entidades principales

El sistema utiliza las siguientes entidades:

- Asesor.
- Cliente.
- Categoría.
- Traje.
- Alquiler.
- Línea de alquiler.
- Devolución.

## 3. Asesor

Representa al usuario encargado de operar las funcionalidades administrativas del sistema.

### Datos principales

- Identificador.
- Nombre.
- Correo electrónico.
- Contraseña.
- Fecha de creación.
- Fecha de actualización.

### Consideraciones

- El correo electrónico permite identificar al asesor durante la autenticación.
- La contraseña debe almacenarse mediante hash y nunca en texto plano.

## 4. Cliente

Representa a la persona que puede recibir trajes en alquiler.

### Datos principales

- Identificador.
- Nombre.
- Documento.
- Información de contacto.
- Fecha de creación.
- Fecha de actualización.

### Relaciones

Un cliente puede tener múltiples alquileres.

### Consideraciones

Antes de registrar un nuevo alquiler se debe verificar:

- Que no tenga más de cinco trajes sin devolver.
- Que no tenga alquileres vencidos pendientes de devolución.

## 5. Categoría

Representa la clasificación de los trajes disponibles en el catálogo.

### Datos principales

- Identificador.
- Nombre.

### Categorías iniciales

El sistema cuenta inicialmente con:

1. Gala.
2. Folclor.
3. Teatro.
4. Infantiles.
5. Temporada.

### Relaciones

Una categoría puede estar asociada con múltiples trajes.

## 6. Traje

Representa un traje o disfraz disponible dentro del catálogo.

### Datos principales

- Identificador.
- Referencia.
- Nombre.
- Categoría.
- Unidades totales.
- Unidades disponibles.
- Estado.
- Fecha de creación.
- Fecha de actualización.

### Consideraciones

Cada traje debe identificarse mediante una referencia.

La disponibilidad debe cumplir permanentemente:

`0 <= unidades disponibles <= unidades totales`

Los trajes no se eliminan físicamente del catálogo. Cuando corresponda retirarlos, se utiliza baja lógica.

## 7. Alquiler

Representa la operación mediante la cual se entregan uno o varios trajes a un cliente.

### Datos principales

- Identificador.
- Cliente.
- Asesor.
- Fecha de alquiler.
- Fecha límite de devolución.
- Estado.
- Fecha de creación.
- Fecha de actualización.

### Relaciones

- Un alquiler pertenece a un cliente.
- Un alquiler es registrado por un asesor.
- Un alquiler contiene una o varias líneas de alquiler.

### Consideraciones

El plazo de alquiler es de cuatro días.

Las fechas e instantes deben manejarse en UTC.

Los alquileres forman parte del historial del sistema y no deben eliminarse.

## 8. Línea de alquiler

Representa cada traje incluido dentro de una operación de alquiler.

### Datos principales

- Identificador.
- Alquiler.
- Traje.
- Información congelada del traje.
- Cantidad.

### Relaciones

- Cada línea pertenece a un alquiler.
- Cada línea está relacionada con un traje.

### Información congelada

La información necesaria del traje debe conservarse dentro de la línea de la operación.

Los cambios posteriores realizados sobre el catálogo no deben modificar la información histórica del alquiler.

## 9. Devolución

Representa el registro del retorno de un traje previamente alquilado.

### Datos principales

- Identificador.
- Alquiler o línea correspondiente.
- Fecha de devolución.
- Cantidad devuelta.
- Fecha de creación.

### Consideraciones

Las devoluciones deben conservarse como parte del historial del sistema y no deben eliminarse.

Una devolución válida debe actualizar la disponibilidad correspondiente del traje.

Las fechas se manejan en UTC.

## 10. Relaciones principales

Las relaciones generales del modelo son:

**Categoría 1 → N Trajes**

Una categoría puede contener varios trajes.

**Cliente 1 → N Alquileres**

Un cliente puede realizar varios alquileres a lo largo del tiempo.

**Asesor 1 → N Alquileres**

Un asesor puede registrar múltiples alquileres.

**Alquiler 1 → N Líneas de alquiler**

Un alquiler puede incluir uno o varios trajes.

**Traje 1 → N Líneas de alquiler**

Un traje puede aparecer en diferentes operaciones de alquiler.

**Alquiler/Línea → Devolución**

Las devoluciones se relacionan con las operaciones previamente registradas.

## 11. Representación general

`Categoría`

↓

`Traje`

↓

`Línea de alquiler`

↓

`Alquiler`

↙        ↘

`Cliente`   `Asesor`

↓

`Devolución`

## 12. Integridad de disponibilidad

La cantidad disponible de un traje debe mantenerse consistente durante los alquileres y devoluciones.

Al registrar un alquiler:

`disponibles = disponibles - cantidad alquilada`

Al registrar una devolución válida:

`disponibles = disponibles + cantidad devuelta`

En ningún caso debe cumplirse:

`disponibles < 0`

ni:

`disponibles > unidades totales`

## 13. Concurrencia

Cuando dos operaciones intenten utilizar simultáneamente la última unidad disponible, el acceso a la disponibilidad debe controlarse para impedir que ambas operaciones sean confirmadas.

Solo una operación puede modificar exitosamente la disponibilidad.

La segunda debe ser rechazada con respuesta HTTP `409`.

## 14. Conservación histórica

El modelo debe preservar el historial de alquileres y devoluciones.

Por esta razón:

- Los alquileres no se eliminan.
- Las devoluciones no se eliminan.
- El catálogo utiliza baja lógica.
- La información congelada de las líneas de alquiler no cambia cuando se modifica posteriormente el catálogo.

## 15. Manejo de fechas

Las fechas e instantes almacenados por el sistema deben manejarse en UTC para mantener un criterio uniforme en alquileres, vencimientos y devoluciones.
