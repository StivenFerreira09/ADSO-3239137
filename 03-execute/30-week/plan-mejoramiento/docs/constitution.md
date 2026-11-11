# Constitución — Costumes (A05)

## Propósito

Este documento establece los principios que deben respetarse durante el desarrollo del sistema `costumes`, correspondiente al plan de mejoramiento A05.

El proyecto está orientado a la gestión del alquiler de trajes y disfraces y debe mantenerse dentro del alcance definido en su especificación.

## Artículo I — Dominio del proyecto

El sistema pertenece al dominio de alquiler de trajes y disfraces (`costumes`).

Las equivalencias principales del dominio son:

- Libro → Traje.
- Socio → Cliente.
- Bibliotecario → Asesor.
- Préstamo → Alquiler.
- Ejemplares → Unidades.

Los trajes se identifican por referencia y sus ejemplares se administran como unidades.

Las cinco categorías que deben estar sembradas son:

1. Gala.
2. Folclor.
3. Teatro.
4. Infantiles.
5. Temporada.

## Artículo II — Límite de alquiler

Un cliente puede tener como máximo cinco (5) trajes sin devolver.

El sistema no debe permitir una operación que supere este límite.

## Artículo III — Plazo del alquiler

El plazo establecido para los alquileres es de cuatro (4) días.

## Artículo IV — Alquileres vencidos

Un cliente que tenga alquileres vencidos no puede recibir nuevos trajes hasta realizar la devolución correspondiente.

## Artículo V — Disponibilidad de unidades

La cantidad de unidades disponibles debe mantenerse siempre entre cero (0) y el total de unidades existentes.

La disponibilidad no puede ser negativa ni superar el total.

## Artículo VI — Información de las operaciones

La información congelada en la línea de una operación debe conservarse y no debe modificarse posteriormente por cambios realizados en el catálogo.

## Artículo VII — Conservación de operaciones

Los alquileres y las devoluciones no se eliminan.

El catálogo utiliza baja lógica en lugar de eliminación física.

## Artículo VIII — Fechas y mensajes

Las fechas del sistema deben manejarse en UTC.

Los mensajes presentados al usuario deben estar en español.

Los identificadores utilizados en el código deben estar en inglés.

## Artículo IX — Concurrencia

Si dos operadores intentan entregar al mismo tiempo la última unidad disponible de un traje, solamente una de las operaciones puede realizarse.

La otra operación debe recibir una respuesta HTTP `409`.

## Artículo X — Reporte

El sistema debe permitir obtener un reporte de los trajes más solicitados.

## Artículo XI — Tecnologías

El producto debe utilizar:

- React para el frontend.
- PHP con Laravel para el backend.
- Contenedores con base de datos que puedan levantarse con un solo comando.
- Sembrado de datos mediante la API.

También debe existir un sitio público estático destinado a presentar el producto.

## Artículo XII — Alcance de la especificación

La implementación debe mantenerse dentro de lo establecido en la especificación del proyecto.

No deben incorporarse funciones que estén fuera del `spec`.

La documentación, las tareas, las pruebas y la implementación deben conservar congruencia con la especificación definida para `costumes`.
