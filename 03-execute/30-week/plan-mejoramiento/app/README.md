# Costumes - Aplicación Web

## Descripción

Esta carpeta contiene la aplicación web de Costumes, desarrollada con React y Vite.

La interfaz permite al personal autorizado gestionar el catálogo de trajes, clientes, alquileres, devoluciones y vencimientos desde un solo lugar. También habilita funciones administrativas como la gestión del catálogo, el registro de asesores y la consulta del informe de trajes más solicitados.

La aplicación se comunica exclusivamente con la API REST de Costumes y no accede directamente a la base de datos.

## Tecnologías

- React 19.
- React DOM 19.
- Vite 6.
- JavaScript.
- HTML.
- CSS.
- Fetch API.
- Node.js 22 en Docker.
- Docker.

## Estructura

```text
app/
├── src/
│   ├── main.jsx
│   └── style.css
├── .dockerignore
├── Dockerfile
├── index.html
├── package.json
├── README.md
└── vite.config.js
```

## Componentes principales

### `src/main.jsx`

Contiene la lógica principal de la interfaz, incluyendo:

- Inicio y cierre de sesión.
- Comunicación con la API.
- Gestión del catálogo.
- Búsqueda y filtrado de trajes.
- Registro de clientes.
- Registro de alquileres.
- Registro de devoluciones.
- Consulta de vencimientos.
- Gestión de fotografías.
- Consulta del informe de trajes más solicitados.
- Registro de asesores.
- Control de opciones visibles según el rol.

### `src/style.css`

Contiene los estilos visuales de la aplicación, incluyendo la distribución de la interfaz, formularios, tablas, tarjetas, navegación y adaptación a diferentes tamaños de pantalla.

### `vite.config.js`

Configura el servidor de desarrollo de Vite para ejecutarse en:

```text
0.0.0.0:5173
```

### `Dockerfile`

Construye el entorno del frontend utilizando Node.js 22 y ejecuta el servidor de desarrollo de Vite en el puerto `5173`.

## Requisitos

Para ejecutar la aplicación mediante la infraestructura completa se requiere:

- Docker Desktop instalado y en ejecución.
- Docker Compose disponible.
- API de Costumes funcionando.

Para ejecutarla directamente fuera de Docker se requiere:

- Node.js.
- npm.
- API de Costumes disponible.

## Instalación local

Desde la carpeta `app/`, instalar las dependencias:

```bash
npm install
```

## Ejecución

Para iniciar la aplicación en modo de desarrollo:

```bash
npm run dev
```

La aplicación queda disponible en:

```text
http://localhost:5173
```

Cuando se utiliza la infraestructura Docker del proyecto, el servicio `app` también utiliza el puerto `5173`.

## Construcción

Para generar la versión compilada de la aplicación:

```bash
npm run build
```

También se encuentra disponible el comando:

```bash
npm run preview
```

para previsualizar la versión generada.

## Configuración de la API

La aplicación utiliza la variable de entorno:

```text
VITE_API_URL
```

En la infraestructura del proyecto se configura como:

```text
http://localhost:8000/api/v1
```

Si `VITE_API_URL` no está definida, la aplicación construye automáticamente la dirección de la API utilizando el protocolo y el host actuales con el puerto `8000` y la ruta `/api/v1`.

## Autenticación

La aplicación permite iniciar sesión al personal autorizado mediante:

```text
POST /auth/login
```

Después de una autenticación correcta, conserva el token recibido durante la sesión de la aplicación y lo envía en las solicitudes protegidas mediante:

```text
Authorization: Bearer <token>
```

Los clientes no requieren usuario ni contraseña para ser registrados en el sistema.

## Roles

La interfaz reconoce dos roles:

### Administrador

El rol `admin` puede acceder a las funciones administrativas disponibles en la interfaz, incluyendo:

- Registrar trajes.
- Editar trajes.
- Retirar trajes del catálogo.
- Actualizar fotografías.
- Consultar el informe de trajes más solicitados.
- Registrar asesores.

### Asesor

El rol `advisor` dispone de las funciones operativas necesarias para:

- Consultar el catálogo.
- Registrar y consultar clientes.
- Registrar alquileres.
- Registrar devoluciones.
- Consultar alquileres vencidos.

La API realiza la validación final de los permisos correspondientes a cada operación.

## Catálogo

La sección de catálogo permite consultar los trajes registrados y visualizar:

- Nombre.
- Diseñador o taller.
- Referencia.
- Categoría.
- Unidades disponibles.
- Unidades totales.
- Fotografía, cuando existe.

También permite buscar por nombre, diseñador o referencia y filtrar por categoría.

Las cinco categorías utilizadas por el sistema son:

- `gala`
- `folclor`
- `teatro`
- `infantiles`
- `temporada`

Las opciones para registrar, editar, retirar y actualizar fotografías se muestran únicamente al administrador.

## Clientes

La aplicación permite registrar clientes mediante:

- Nombre completo.
- Número de documento.

También presenta el listado de clientes registrados para facilitar las operaciones de alquiler.

## Alquileres

Para registrar un alquiler se selecciona:

1. El cliente.
2. Entre uno y tres trajes disponibles.

La interfaz limita la selección a un máximo de tres trajes por operación.

La API se encarga de validar las demás reglas de negocio, incluido el máximo global de cinco trajes sin devolver por cliente y las restricciones relacionadas con vencimientos y disponibilidad.

## Devoluciones

Los alquileres muestran sus líneas correspondientes y permiten registrar la devolución de los trajes que continúan pendientes.

Cuando una línea ya fue devuelta, la interfaz muestra su estado y deja de presentar la opción de devolución.

## Vencimientos

La sección `Vencidos` consulta los alquileres pendientes que han superado su fecha de devolución.

La interfaz presenta información como:

- Cliente.
- Traje.
- Fecha de vencimiento.
- Días de retraso.

Si no existen devoluciones vencidas, la aplicación informa que no hay registros pendientes.

## Informe

El administrador puede consultar el informe de trajes más solicitados indicando:

- Fecha inicial.
- Fecha final.

El resultado presenta:

- Nombre histórico del traje.
- Categoría histórica.
- Cantidad de veces alquilado.

Esta sección está disponible únicamente para el rol `admin`.

## Asesores

El administrador puede registrar nuevas cuentas de asesor.

El formulario solicita:

- Usuario.
- Contraseña.

La contraseña debe contener como mínimo 12 caracteres desde la interfaz.

El rol enviado para estas cuentas es:

```text
advisor
```

La API realiza la validación definitiva de esta regla.

## Fotografías

El administrador puede cargar fotografías para los trajes registrados.

La interfaz acepta archivos:

```text
image/png
image/jpeg
```

Las imágenes se solicitan a la API utilizando autenticación y se muestran dentro de las tarjetas del catálogo.

## Comunicación con la API

La aplicación utiliza Fetch API para realizar las solicitudes HTTP.

Todas las operaciones sobre la información del sistema se realizan mediante la API REST.

La aplicación no:

- Ejecuta instrucciones SQL.
- Se conecta directamente con PostgreSQL.
- Almacena credenciales de la base de datos.
- Modifica directamente los datos persistidos.

## Manejo de errores

Cuando la API devuelve un error, la aplicación intenta mostrar el mensaje recibido al usuario.

Si la respuesta del servidor no puede interpretarse correctamente, utiliza un mensaje general en español.

Los mensajes de éxito y error visibles en la interfaz se presentan en español.

## Idioma

Los identificadores técnicos del código se mantienen en inglés.

Los textos visibles para el usuario, como etiquetas, botones, mensajes, estados y avisos, se presentan en español.

Las categorías conservan los nombres definidos por el sistema:

```text
gala
folclor
teatro
infantiles
temporada
```

## Docker

El frontend utiliza la imagen:

```text
node:22-alpine
```

El contenedor instala las dependencias mediante:

```bash
npm install --no-audit --no-fund
```

y posteriormente inicia la aplicación con:

```bash
npm run dev
```

El servicio expone el puerto:

```text
5173
```

## Seguridad

- La aplicación no se conecta directamente con la base de datos.
- Las solicitudes protegidas utilizan el token de autenticación.
- Las contraseñas no se almacenan directamente en el código.
- La interfaz limita las funciones administrativas según el rol autenticado.
- La API realiza la validación definitiva de autenticación, autorización y reglas de negocio.
- Los clientes no necesitan credenciales de acceso.

## Interfaz

Costumes utiliza una interfaz enfocada en la gestión operativa de alquileres.

La navegación principal está organizada en:

```text
Catálogo
Clientes
Alquileres
Vencidos
```

Para el administrador también se habilitan:

```text
Informe
Asesores
```

La aplicación centraliza así las principales operaciones necesarias para administrar el catálogo, los clientes y el ciclo de alquiler y devolución de los trajes.
