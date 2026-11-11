# Tareas de implementación — Costumes

## 1. Propósito

Este documento organiza las tareas necesarias para implementar `Costumes` de acuerdo con su especificación funcional, arquitectura, modelo de datos y contrato de API.

Las tareas se limitan a las funcionalidades definidas para el producto.

## 2. Tareas

### T01 — Configurar el backend

Preparar el proyecto PHP con Laravel y la configuración inicial necesaria para desarrollar la API.

### T02 — Implementar el modelo de datos

Crear las migraciones y modelos necesarios para asesores, clientes, categorías, trajes, alquileres, líneas de alquiler y devoluciones.

### T03 — Implementar autenticación

Permitir que los asesores se autentiquen y proteger las operaciones que requieran acceso autorizado.

### T04 — Implementar gestión de asesores

Permitir el registro de asesores y almacenar sus contraseñas mediante hash.

### T05 — Implementar categorías

Crear la gestión necesaria para utilizar las categorías de los trajes y preparar las cinco categorías iniciales: gala, folclor, teatro, infantiles y temporada.

### T06 — Implementar gestión de trajes

Permitir registrar, consultar, actualizar y realizar la baja lógica de los trajes del catálogo.

### T07 — Implementar búsqueda de trajes

Permitir la búsqueda de trajes y verificar el requisito de rendimiento establecido para el catálogo.

### T08 — Implementar gestión de clientes

Permitir registrar, consultar y actualizar los clientes relacionados con los alquileres.

### T09 — Implementar registro de alquileres

Crear el proceso para registrar alquileres y sus respectivas líneas de operación.

### T10 — Aplicar límite de trajes sin devolver

Impedir que un cliente tenga más de cinco trajes sin devolver.

### T11 — Aplicar plazo de alquiler

Calcular la fecha límite de devolución utilizando un plazo de cuatro días y manejar las fechas en UTC.

### T12 — Implementar bloqueo por vencimientos

Impedir nuevos alquileres cuando el cliente tenga trajes vencidos pendientes de devolución.

### T13 — Controlar disponibilidad

Garantizar que las unidades disponibles permanezcan siempre entre cero y el total de unidades del traje.

### T14 — Implementar control de concurrencia

Proteger la última unidad disponible ante solicitudes simultáneas, permitiendo una operación exitosa y rechazando la otra con HTTP `409`.

### T15 — Conservar información congelada

Guardar en las líneas de alquiler la información necesaria para que los cambios posteriores del catálogo no alteren el historial de la operación.

### T16 — Implementar devoluciones

Registrar las devoluciones, actualizar el estado correspondiente y recuperar las unidades disponibles sin eliminar el historial.

### T17 — Implementar consulta de alquileres

Permitir listar y consultar las operaciones de alquiler registradas.

### T18 — Implementar consulta de vencidos

Permitir identificar los alquileres que superaron su fecha límite y continúan pendientes de devolución.

### T19 — Implementar reporte de trajes más solicitados

Generar el reporte de los trajes con mayor número de solicitudes utilizando el historial de alquileres.

### T20 — Implementar aplicación frontend

Desarrollar en React las interfaces necesarias para consumir las funcionalidades definidas en la API y presentar al usuario los mensajes en español.

### T21 — Implementar sitio público

Construir el sitio estático de presentación de `Costumes`, mostrando el producto y sus principales funcionalidades.

### T22 — Configurar infraestructura y sembrado

Preparar los contenedores y la base de datos para iniciar el entorno con un solo comando e implementar el sembrado de datos mediante la API.

### T23 — Implementar y ejecutar pruebas automatizadas

Crear las pruebas automatizadas necesarias para verificar las historias de usuario, reglas de negocio, requisitos no funcionales y contrato de la API, incluyendo el escenario de concurrencia de la última unidad disponible.

El proyecto debe contar con al menos 15 archivos de pruebas automatizadas.
