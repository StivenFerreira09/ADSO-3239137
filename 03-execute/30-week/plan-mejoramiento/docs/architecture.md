# Arquitectura — Costumes

## 1. Propósito

Este documento describe la arquitectura de `Costumes`, un sistema para la gestión del alquiler de trajes y disfraces.

La solución separa la interfaz de usuario, la lógica de negocio, la persistencia de datos, el sitio público, la infraestructura y las herramientas de apoyo, permitiendo mantener responsabilidades claramente definidas entre los diferentes componentes.

## 2. Estructura del sistema

El proyecto está organizado en los siguientes componentes:

- `docs/`: documentación funcional y técnica del sistema.
- `api/`: backend y API desarrollados con PHP y Laravel.
- `app/`: aplicación frontend desarrollada con React.
- `page/`: sitio público estático para presentar el producto.
- `infra/`: configuración de contenedores y base de datos.
- `tool/`: herramientas auxiliares, incluido el sembrado de datos mediante la API.

## 3. Arquitectura general

El flujo principal de la aplicación es:

**Usuario → Aplicación React → API Laravel → Base de datos**

La aplicación frontend consume los servicios proporcionados por la API. El acceso y modificación de los datos se realizan desde el backend, donde también se aplican las reglas de negocio del sistema.

## 4. Frontend — `app/`

La aplicación frontend está desarrollada con React y proporciona la interfaz de interacción con los usuarios.

Sus principales responsabilidades son:

- Permitir la autenticación.
- Presentar y consultar el catálogo de trajes.
- Gestionar clientes.
- Registrar alquileres.
- Registrar devoluciones.
- Consultar alquileres y vencimientos.
- Visualizar el reporte de trajes más solicitados.
- Consumir los servicios de la API.
- Presentar al usuario mensajes en español.

Las reglas de negocio deben ser validadas por el backend para garantizar su cumplimiento independientemente de la interfaz utilizada.

## 5. Backend — `api/`

El backend está desarrollado con PHP y Laravel y concentra la lógica de negocio del sistema.

Sus responsabilidades incluyen:

- Gestionar la autenticación.
- Gestionar asesores.
- Gestionar trajes.
- Permitir la búsqueda de trajes.
- Gestionar clientes.
- Registrar alquileres.
- Registrar devoluciones.
- Consultar y listar alquileres.
- Identificar alquileres vencidos.
- Generar el reporte de trajes más solicitados.
- Controlar la disponibilidad de unidades.
- Aplicar las reglas de negocio.
- Gestionar la persistencia de datos.
- Proporcionar respuestas HTTP a los clientes de la API.

## 6. Persistencia de datos

La base de datos conserva la información necesaria para la operación del sistema, incluyendo:

- Asesores.
- Clientes.
- Categorías.
- Trajes.
- Alquileres.
- Líneas de alquiler.
- Devoluciones.

Los alquileres y las devoluciones se conservan como parte del historial del sistema y no deben eliminarse.

Los elementos del catálogo utilizan baja lógica.

## 7. Gestión de disponibilidad

Cada traje dispone de una cantidad total de unidades y una cantidad de unidades disponibles.

La disponibilidad debe cumplir permanentemente:

`0 <= unidades disponibles <= unidades totales`

Al registrar un alquiler, se descuentan las unidades correspondientes.

Al registrar una devolución válida, se recupera la disponibilidad correspondiente.

El sistema no debe permitir que la cantidad disponible sea negativa ni superior a la cantidad total.

## 8. Gestión de alquileres

El backend es responsable de validar las condiciones necesarias antes de registrar un alquiler.

Entre estas condiciones se encuentran:

- Un cliente puede tener como máximo cinco trajes sin devolver.
- El plazo de alquiler es de cuatro días.
- Un cliente con alquileres vencidos no puede recibir nuevos trajes hasta realizar las devoluciones correspondientes.
- Solo pueden alquilarse unidades disponibles.

La información congelada en las líneas del alquiler debe conservarse aunque posteriormente cambien los datos del catálogo.

## 9. Control de concurrencia

La disponibilidad debe protegerse ante operaciones simultáneas.

Cuando dos operadores intenten alquilar al mismo tiempo la última unidad disponible de un traje, únicamente una operación puede completarse.

El resultado esperado es:

- Una operación exitosa con respuesta HTTP `201`.
- Una operación rechazada con respuesta HTTP `409`.

Este control evita que dos alquileres utilicen una misma unidad disponible y garantiza que la disponibilidad nunca quede por debajo de cero.

## 10. Gestión de devoluciones

Las devoluciones actualizan el estado correspondiente de la operación y permiten recuperar la disponibilidad de los trajes devueltos.

Los registros de devolución forman parte del historial y deben conservarse.

## 11. Información histórica

Los datos congelados en una línea de alquiler representan la información existente al momento de realizar la operación.

Los cambios posteriores en el catálogo no deben modificar esta información histórica.

De esta forma, una actualización de un traje no altera los datos de alquileres realizados anteriormente.

## 12. Manejo de fechas

Las fechas e instantes utilizados por el sistema se manejan en UTC.

Este criterio se aplica especialmente a:

- Registro de alquileres.
- Fecha límite de devolución.
- Registro de devoluciones.
- Identificación de alquileres vencidos.

## 13. Sitio público — `page/`

El componente `page/` corresponde al sitio público estático de `Costumes`.

Su función es presentar el producto y permitir que los visitantes conozcan sus principales características y funcionalidades.

Este componente es independiente de la aplicación operativa ubicada en `app/`.

## 14. Infraestructura — `infra/`

El componente `infra/` contiene la configuración necesaria para ejecutar los servicios del sistema mediante contenedores.

La infraestructura debe permitir levantar la aplicación y la base de datos con un solo comando.

También debe permitir preparar la estructura requerida por Laravel mediante las migraciones correspondientes.

## 15. Herramientas — `tool/`

El componente `tool/` contiene herramientas auxiliares necesarias para preparar o apoyar el funcionamiento del sistema.

El sembrado de datos debe realizarse consumiendo la API.

Las categorías iniciales del catálogo son:

1. Gala.
2. Folclor.
3. Teatro.
4. Infantiles.
5. Temporada.

## 16. Comunicación entre componentes

La comunicación principal del sistema se representa de la siguiente manera:

**Usuario**

↓

**`app/` — React**

↓

**HTTP**

↓

**`api/` — Laravel**

↓

**Base de datos**

Por otra parte:

**`tool/` → API Laravel**

El componente `tool/` utiliza la API para realizar el sembrado de datos.

El componente `page/` funciona como sitio público estático y `infra/` proporciona la configuración necesaria para ejecutar el entorno del sistema.

## 17. Convenciones

Para mantener consistencia en el desarrollo:

- Los identificadores del código se escriben en inglés.
- Los mensajes destinados al usuario se presentan en español.
- Las fechas se manejan en UTC.
- Las funcionalidades implementadas deben corresponder con las definidas en la especificación.
