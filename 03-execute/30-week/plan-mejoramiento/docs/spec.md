# Especificación — Costumes

## 1. Descripción

`costumes` es un sistema para gestionar el alquiler de trajes y disfraces. Permite administrar el catálogo de trajes, clientes, asesores, alquileres y devoluciones, así como consultar los trajes más solicitados.

El sistema debe respetar las reglas de negocio definidas para el dominio y mantener congruencia entre la documentación, la API, la aplicación y las pruebas automatizadas.

## 2. Entidades principales

- **Traje:** elemento del catálogo identificado por una referencia.
- **Unidad:** cantidad de ejemplares existentes y disponibles de un traje.
- **Categoría:** clasificación a la que pertenece un traje.
- **Cliente:** persona que recibe los trajes en alquiler.
- **Asesor:** persona encargada de registrar las operaciones.
- **Alquiler:** operación mediante la cual se entregan uno o varios trajes a un cliente.
- **Devolución:** registro del retorno de los trajes previamente alquilados.

## 3. Categorías

El sistema debe contar con cinco categorías sembradas:

1. Gala.
2. Folclor.
3. Teatro.
4. Infantiles.
5. Temporada.

# 4. Historias de usuario

## HU-01 — Autenticarse

Como asesor, quiero autenticarme en el sistema para acceder a las funcionalidades de gestión de alquileres.

### Criterios de aceptación

- El asesor puede ingresar utilizando sus credenciales.
- Las credenciales inválidas deben ser rechazadas.
- Las contraseñas no deben almacenarse en texto plano.
- Después de una autenticación válida, el asesor puede acceder a las operaciones protegidas.

## HU-02 — Registrar asesores

Como usuario autorizado, quiero registrar asesores para permitir que puedan operar el sistema.

### Criterios de aceptación

- Se pueden registrar los datos requeridos de un asesor.
- No se deben aceptar registros que incumplan las validaciones definidas.
- La contraseña debe almacenarse mediante hash.

## HU-03 — Gestionar trajes

Como asesor, quiero gestionar los trajes del catálogo para mantener actualizada la información disponible para los alquileres.

### Criterios de aceptación

- Se pueden registrar trajes.
- Cada traje se identifica mediante una referencia.
- Se puede consultar y actualizar la información permitida.
- El catálogo utiliza baja lógica.
- Las unidades disponibles deben mantenerse entre cero y el total de unidades.

## HU-04 — Buscar trajes

Como asesor, quiero buscar trajes para encontrar rápidamente los elementos disponibles en el catálogo.

### Criterios de aceptación

- El sistema permite consultar los trajes registrados.
- La búsqueda debe devolver información suficiente para identificar el traje.
- Los resultados deben respetar el estado del catálogo.

## HU-05 — Gestionar clientes

Como asesor, quiero gestionar clientes para asociarlos correctamente con sus alquileres.

### Criterios de aceptación

- Se pueden registrar clientes.
- Se pueden consultar los clientes existentes.
- Los datos deben validarse antes de ser almacenados.
- Los clientes deben poder relacionarse con sus operaciones de alquiler.

## HU-06 — Registrar alquiler

Como asesor, quiero registrar un alquiler para entregar trajes disponibles a un cliente.

### Criterios de aceptación

- El cliente puede tener como máximo cinco trajes sin devolver.
- El cliente no puede recibir nuevos trajes si tiene alquileres vencidos.
- El plazo del alquiler es de cuatro días.
- Solo pueden entregarse unidades disponibles.
- La disponibilidad debe actualizarse al registrar la operación.
- La información correspondiente a la línea del alquiler debe quedar congelada.
- Si dos operadores intentan entregar simultáneamente la última unidad, solo una operación debe completarse y la otra debe recibir `409`.

## HU-07 — Registrar devolución

Como asesor, quiero registrar la devolución de un traje para actualizar el estado del alquiler y recuperar su disponibilidad.

### Criterios de aceptación

- Solo se pueden devolver elementos correspondientes a un alquiler registrado.
- La devolución debe quedar registrada.
- La disponibilidad del traje debe actualizarse correctamente.
- Los registros históricos de alquileres y devoluciones no deben eliminarse.

## HU-08 — Consultar y listar alquileres

Como asesor, quiero consultar los alquileres registrados para conocer su información y estado.

### Criterios de aceptación

- El sistema permite listar los alquileres.
- Debe conservarse la información histórica de las operaciones.
- Los cambios posteriores realizados en el catálogo no deben modificar la información congelada en las líneas de alquiler.

## HU-09 — Ver vencidos

Como asesor, quiero consultar los alquileres vencidos para identificar los clientes que deben realizar devoluciones.

### Criterios de aceptación

- Se identifican como vencidas las operaciones que superen el plazo correspondiente y continúen sin devolución.
- Las fechas se manejan en UTC.
- Un cliente con elementos vencidos no puede recibir un nuevo alquiler hasta realizar la devolución correspondiente.

## HU-10 — Reporte de trajes más solicitados

Como asesor, quiero consultar los trajes más solicitados para conocer cuáles presentan mayor demanda.

### Criterios de aceptación

- El reporte utiliza las operaciones de alquiler registradas.
- Los resultados permiten identificar los trajes con mayor número de solicitudes.
- La información histórica debe conservarse para generar el reporte.

# 5. Reglas de negocio

## RN-01 — Máximo de trajes sin devolver

Un cliente puede tener como máximo cinco (5) trajes sin devolver.

## RN-02 — Plazo de alquiler

El plazo de un alquiler es de cuatro (4) días.

## RN-03 — Bloqueo por vencimientos

Un cliente que tenga trajes vencidos no puede recibir nuevos alquileres hasta realizar las devoluciones correspondientes.

## RN-04 — Disponibilidad

Las unidades disponibles deben permanecer siempre entre cero (0) y el total de unidades.

## RN-05 — Información congelada

La información congelada en la línea de una operación no debe modificarse posteriormente como consecuencia de cambios realizados en el catálogo.

## RN-06 — Conservación de registros

Los alquileres y las devoluciones no se eliminan. El catálogo utiliza baja lógica.

# 6. Requisitos no funcionales

## RNF-01 — Rendimiento de búsqueda

La búsqueda debe responder en menos de 300 ms con un volumen de 5.000 trajes.

## RNF-02 — Concurrencia

Ante dos solicitudes simultáneas sobre la última unidad disponible, solamente una puede completar el alquiler.

El resultado esperado es:

- Una respuesta HTTP `201`.
- Una respuesta HTTP `409`.

La disponibilidad nunca puede quedar por debajo de cero.

## RNF-03 — Seguridad de contraseñas

Las contraseñas deben almacenarse utilizando hash y no deben persistirse en texto plano.

## RNF-04 — Respuestas de error

Los errores HTTP deben utilizar una estructura uniforme:

`code`

`message`

`details`

Los mensajes destinados al usuario deben presentarse en español.

## RNF-05 — Ejecución mediante contenedores

El proyecto debe poder iniciarse mediante:

`docker compose up --build`

El entorno debe incluir los servicios necesarios para ejecutar la aplicación y la base de datos, junto con las migraciones correspondientes de Laravel.

# 7. Tecnologías y producto

El proyecto debe contar con:

- Frontend desarrollado en React.
- Backend desarrollado en PHP con Laravel.
- Sitio público estático que presente el producto.
- Contenedores con base de datos que puedan levantarse con un solo comando.
- Sembrador de datos realizado mediante la API.

# 8. Pruebas

La implementación debe contar con pruebas automatizadas asociadas a las funcionalidades y reglas del sistema.

El proyecto debe incluir al menos 15 archivos de pruebas automatizadas.

Debe verificarse especialmente el escenario de concurrencia correspondiente a la última unidad disponible.

# 9. Restricción de alcance

La implementación debe mantenerse dentro de lo definido en esta especificación.

No deben agregarse funciones fuera del `spec`.
