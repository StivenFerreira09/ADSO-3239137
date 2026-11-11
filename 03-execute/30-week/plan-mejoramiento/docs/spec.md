# Especificación — Costumes

## 1. Descripción

`costumes` es un sistema para gestionar el alquiler de trajes y disfraces. Permite administrar el catálogo de trajes, clientes, asesores, alquileres y devoluciones, además de consultar los trajes más solicitados.

## 2. Dominio

El sistema utiliza las siguientes entidades principales:

- **Traje:** elemento del catálogo identificado por una referencia.
- **Unidad:** cantidad de ejemplares existentes de un traje.
- **Cliente:** persona que recibe los trajes en alquiler.
- **Asesor:** persona encargada de registrar las operaciones.
- **Alquiler:** operación mediante la cual se entregan uno o varios trajes a un cliente.
- **Devolución:** registro del retorno de los trajes alquilados.
- **Categoría:** clasificación de los trajes.

## 3. Categorías

El sistema debe contar con cinco categorías sembradas:

1. Gala.
2. Folclor.
3. Teatro.
4. Infantiles.
5. Temporada.

## 4. Reglas de negocio

### RN-01 — Límite de trajes

Un cliente puede tener como máximo cinco (5) trajes sin devolver.

### RN-02 — Plazo

El plazo del alquiler es de cuatro (4) días.

### RN-03 — Alquileres vencidos

Un cliente que tenga alquileres vencidos no puede recibir nuevos trajes hasta realizar las devoluciones correspondientes.

### RN-04 — Disponibilidad

Las unidades disponibles de un traje deben mantenerse siempre entre cero (0) y el total de unidades.

### RN-05 — Información congelada

La información congelada en la línea de una operación debe conservar los valores registrados en el momento de realizarla y no debe cambiar posteriormente junto con el catálogo.

### RN-06 — Conservación de registros

Los alquileres y las devoluciones no se eliminan. Los elementos del catálogo utilizan baja lógica.

## 5. Fechas e idioma

- Las fechas se manejan en UTC.
- Los mensajes dirigidos al usuario se presentan en español.
- Los identificadores del código se escriben en inglés.

## 6. Reporte

El sistema debe proporcionar un reporte de los trajes más solicitados.

## 7. Concurrencia

Si dos operadores intentan entregar simultáneamente la última unidad disponible de un traje:

- Una sola operación debe completarse.
- La otra debe recibir una respuesta HTTP `409`.
- Las unidades disponibles no pueden quedar en un valor negativo.

## 8. Alcance

El proyecto debe contemplar:

- 10 historias de usuario.
- 6 reglas de negocio.
- 5 requisitos no funcionales.
- Todos los endpoints equivalentes definidos en el contrato.
- 23 tareas.
- Pruebas automatizadas con un mínimo de 15 archivos.

No deben implementarse funciones fuera de esta especificación.

## 9. Producto

El producto debe incluir:

- Frontend desarrollado en React.
- Backend desarrollado en PHP con Laravel.
- Sitio público estático para presentar el producto.
- Contenedores con base de datos que puedan levantarse con un solo comando.
- Sembrador de datos mediante la API.
