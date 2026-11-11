Este proyecto es la solución del plan de mejoramiento del aprendiz A05, ficha 3239137, dominio costumes.

# costumes · Alquiler de trajes y disfraces

Sistema para gestionar el alquiler de trajes y disfraces, incluyendo el catálogo de trajes, clientes, asesores, alquileres, devoluciones y el reporte de los trajes más solicitados.

## Qué gestiona

| **Concepto** | **Qué es en el sistema** |
|---|---|
| **Traje** | Elemento del catálogo identificado por una referencia. |
| **Unidad** | Existencias disponibles de cada traje. Las unidades disponibles deben mantenerse entre 0 y el total. |
| **Categoría** | Cinco categorías sembradas: gala, folclor, teatro, infantiles y temporada. |
| **Cliente** | Persona que alquila uno o varios trajes. |
| **Asesor** | Persona encargada de registrar las operaciones. |
| **Alquiler** | Operación mediante la cual se entregan trajes a un cliente por un plazo determinado. |
| **Devolución** | Registro de la devolución de los trajes previamente alquilados. |

## Reglas del sistema

- Un cliente puede tener máximo **5 trajes sin devolver**.
- El plazo de alquiler es de **4 días**.
- Un cliente con alquileres vencidos **no puede recibir nuevos trajes hasta devolverlos**.
- Las unidades disponibles deben permanecer **entre 0 y el total**.
- La información congelada en la línea de una operación **no cambia posteriormente con el catálogo**.
- Los alquileres y las devoluciones **no se eliminan**; el catálogo utiliza baja lógica.
- Las fechas se manejan en **UTC** y los mensajes dirigidos al usuario se muestran en español.
- Si dos operadores intentan entregar simultáneamente la última unidad disponible, solamente una operación debe realizarse y la otra debe recibir una respuesta `409`.
- El sistema genera el reporte de **trajes más solicitados**.

## Estructura del proyecto

| **Carpeta** | **Contenido** |
|---|---|
| `docs/` | Constitución, especificación, plan, arquitectura, modelo de datos, contrato de API, tareas y ADR. |
| `api/` | Backend desarrollado en PHP con Laravel. |
| `app/` | Frontend desarrollado en React. |
| `page/` | Sitio público estático para presentar el producto. |
| `infra/` | Contenedores y configuración de la base de datos. |
| `tool/` | Sembrador de datos de demostración mediante la API. |

## Documentación

La especificación del proyecto se encuentra en `docs/` e incluye:

- `constitution.md`
- `spec.md`
- `plan.md`
- `architecture.md`
- `data-model.md`
- `api-contract.md`
- `tasks.md`
- `adr/`

## Tecnologías

- **Frontend:** React
- **Backend:** PHP con Laravel
- **Infraestructura:** contenedores con base de datos
- **Sembrado de datos:** mediante la API

## Estado

Proyecto correspondiente al plan de mejoramiento individual A05:[`Plan-Mejoramiento-A05.pdf`](Plan-Mejoramiento-A05.pdf).
Su desarrollo y avance se registra mediante el historial de commits del repositorio.
