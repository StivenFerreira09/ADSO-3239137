# Plan de implementación — Costumes

## 1. Objetivo

Construir y dejar completamente terminado el proyecto `costumes`, correspondiente al plan de mejoramiento A05, manteniendo la implementación dentro del alcance definido en la especificación.

## 2. Componentes del proyecto

El proyecto se organiza en seis componentes:

- `docs/`: documentación y especificación.
- `api/`: backend en PHP con Laravel.
- `app/`: frontend en React.
- `page/`: sitio público estático para presentar el producto.
- `infra/`: contenedores y base de datos.
- `tool/`: sembrador de datos mediante la API.

## 3. Fases de implementación

### Fase 1 — Documentación

Construir la especificación del proyecto mediante:

- `constitution.md`
- `spec.md`
- `plan.md`
- `architecture.md`
- `data-model.md`
- `api-contract.md`
- `tasks.md`
- Al menos tres ADR.

### Fase 2 — Backend

Desarrollar el backend utilizando PHP con Laravel e implementar las operaciones necesarias para cumplir las historias de usuario, reglas de negocio y contrato de la API.

### Fase 3 — Frontend

Desarrollar el frontend en React e integrarlo con la API.

Los mensajes presentados al usuario deben estar en español y los identificadores del código deben estar en inglés.

### Fase 4 — Sitio público

Construir un sitio público estático que presente el producto `costumes` 

### Fase 5 — Infraestructura

Configurar los contenedores y la base de datos para que el proyecto pueda levantarse con un solo comando.

### Fase 6 — Sembrado de datos

Implementar el sembrador de datos mediante la API.

Las cinco categorías iniciales son:

1. Gala.
2. Folclor.
3. Teatro.
4. Infantiles.
5. Temporada.

### Fase 7 — Pruebas

Implementar las pruebas automatizadas correspondientes a las tareas y reglas del sistema.

El proyecto debe contar con al menos 15 archivos de pruebas automatizadas.

También debe comprobarse el escenario de concurrencia en el que dos operadores intentan entregar simultáneamente la última unidad disponible.

### Fase 8 — Verificación

Antes de la entrega se debe comprobar:

- Congruencia entre especificación e implementación.
- Cumplimiento de las reglas de negocio.
- Funcionamiento de los endpoints.
- Funcionamiento del frontend.
- Funcionamiento del sitio público.
- Inicio de los contenedores con un solo comando.
- Sembrado de datos mediante la API.
- Ejecución de las pruebas automatizadas.
- Ausencia de funciones fuera del `spec`.
