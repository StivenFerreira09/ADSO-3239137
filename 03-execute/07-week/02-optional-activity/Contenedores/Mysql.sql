USE bd_proyecto;

-- ============================================================
-- 1. INSERCIONES
-- ============================================================

-- continente
INSERT INTO continente (nombre, descripcion) VALUES
('América',  'Continente del hemisferio occidental'),
('Europa',   'Continente del hemisferio oriental norte'),
('Asia',     'Continente más grande del mundo'),
('África',   'Segundo continente más grande'),
('Oceanía',  'Continente del Pacífico sur');

-- pais
INSERT INTO pais (nombre, descripcion, id_continente) VALUES
('Colombia',   'País ubicado en el noroccidente de Suramérica', 1),
('México',     'País ubicado en América del Norte',             1),
('Argentina',  'País ubicado en el sur de Suramérica',         1),
('Brasil',     'País más grande de Suramérica',                1),
('Venezuela',  'País ubicado en el norte de Suramérica',       1);

-- departamento
INSERT INTO departamento (nombre, descripcion, id_pais) VALUES
('Antioquia',          'Departamento del noroeste colombiano', 1),
('Cundinamarca',       'Departamento del centro de Colombia',  1),
('Valle del Cauca',    'Departamento del occidente colombiano',1),
('Atlántico',          'Departamento del norte de Colombia',   1),
('Santander',          'Departamento del nororiente colombiano',1);

-- ciudad
INSERT INTO ciudad (nombre, id_departamento) VALUES
('Medellín',      1),
('Bogotá',        2),
('Cali',          3),
('Barranquilla',  4),
('Bucaramanga',   5);

-- barrio
INSERT INTO barrio (nombre, id_ciudad) VALUES
('El Poblado',    1),
('Chapinero',     2),
('San Antonio',   3),
('El Prado',      4),
('Cabecera',      5);

-- persona
INSERT INTO persona (nombre, apellido, documento, telefono, email, id_barrio) VALUES
('Carlos',    'Ramírez',  '10234567', '3001234567', 'carlos.ramirez@gmail.com',  1),
('Luisa',     'Gómez',    '20345678', '3012345678', 'luisa.gomez@gmail.com',     2),
('Andrés',    'Torres',   '30456789', '3023456789', 'andres.torres@hotmail.com', 3),
('Valentina', 'Herrera',  '40567890', '3034567890', 'vale.herrera@gmail.com',    4),
('Miguel',    'Castillo', '50678901', '3045678901', 'miguel.castillo@gmail.com', 5);

-- rol
INSERT INTO rol (nombre, descripcion) VALUES
('administrador', 'Acceso total al sistema'),
('vendedor',      'Puede registrar ventas y facturas'),
('bodeguero',     'Gestiona inventario y productos'),
('contador',      'Acceso a reportes financieros'),
('soporte',       'Atención al cliente y consultas');

-- usuario
INSERT INTO usuario (username, password, estado, id_persona) VALUES
('carlos.r',   MD5('pass1234'), 1, 1),
('luisa.g',    MD5('pass1234'), 1, 2),
('andres.t',   MD5('pass1234'), 1, 3),
('valentina.h',MD5('pass1234'), 1, 4),
('miguel.c',   MD5('pass1234'), 0, 5);

-- usuario_rol
INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- categoria
INSERT INTO categoria (nombre, descripcion) VALUES
('Electrónica',  'Dispositivos electrónicos y accesorios'),
('Ropa',         'Prendas de vestir y accesorios de moda'),
('Alimentos',    'Productos alimenticios y bebidas'),
('Hogar',        'Artículos para el hogar y decoración'),
('Deportes',     'Equipos y ropa deportiva');

-- producto
INSERT INTO producto (nombre, descripcion, precio, stock, id_categoria) VALUES
('Celular Samsung A54',  'Smartphone 128GB',          1200000.00, 20, 1),
('Camiseta deportiva',   'Talla M, algodón 100%',       45000.00, 50, 2),
('Aceite de cocina 1L',  'Aceite vegetal refinado',      8500.00, 100,3),
('Lámpara de escritorio','LED, luz cálida y fría',       75000.00, 30, 4),
('Balón de fútbol',      'Cuero sintético #5',           55000.00, 40, 5);

-- factura
INSERT INTO factura (fecha, total, id_persona, id_usuario) VALUES
('2024-01-10 10:30:00', 1200000.00, 1, 1),
('2024-02-14 14:00:00',   45000.00, 2, 2),
('2024-03-05 09:15:00',   85000.00, 3, 3),
('2024-04-20 16:45:00',  130000.00, 4, 4),
('2024-05-01 11:00:00',   55000.00, 5, 5);

-- detalle_factura
INSERT INTO detalle_factura (cantidad, subtotal, id_factura, id_producto) VALUES
(1, 1200000.00, 1, 1),
(1,   45000.00, 2, 2),
(2,   17000.00, 3, 3),
(1,   75000.00, 4, 4),
(1,   55000.00, 5, 5);


-- ============================================================
-- 2. ACTUALIZACIONES
-- ============================================================

-- continente
UPDATE continente SET descripcion = 'Continente con mayor diversidad cultural' WHERE id_continente = 1;
UPDATE continente SET descripcion = 'Continente con la mayor cantidad de países' WHERE id_continente = 2;

-- pais
UPDATE pais SET descripcion = 'País conocido por su biodiversidad y café' WHERE id_pais = 1;
UPDATE pais SET nombre = 'República de Colombia' WHERE id_pais = 1;

-- departamento
UPDATE departamento SET descripcion = 'Ciudad de la eterna primavera' WHERE id_departamento = 1;
UPDATE departamento SET descripcion = 'Capital y centro político del país' WHERE id_departamento = 2;

-- ciudad
UPDATE ciudad SET nombre = 'Medellín (Antioquia)' WHERE id_ciudad = 1;
UPDATE ciudad SET nombre = 'Bogotá D.C.' WHERE id_ciudad = 2;

-- barrio
UPDATE barrio SET nombre = 'El Poblado Norte' WHERE id_barrio = 1;
UPDATE barrio SET nombre = 'Chapinero Alto' WHERE id_barrio = 2;

-- persona
UPDATE persona SET telefono = '3109876543' WHERE id_persona = 1;
UPDATE persona SET email = 'luisa.nueva@gmail.com' WHERE id_persona = 2;

-- rol
UPDATE rol SET descripcion = 'Control total de usuarios y configuración' WHERE id_rol = 1;
UPDATE rol SET descripcion = 'Registra ventas y atiende clientes' WHERE id_rol = 2;

-- usuario
UPDATE usuario SET estado = 1 WHERE id_usuario = 5;
UPDATE usuario SET username = 'carlos.ramirez' WHERE id_usuario = 1;

-- usuario_rol
UPDATE usuario_rol SET id_rol = 2 WHERE id_usuario = 5 AND id_rol = 5;
UPDATE usuario_rol SET id_rol = 1 WHERE id_usuario = 3 AND id_rol = 3;

-- categoria
UPDATE categoria SET descripcion = 'Celulares, computadores y más' WHERE id_categoria = 1;
UPDATE categoria SET descripcion = 'Ropa casual y formal para todo público' WHERE id_categoria = 2;

-- producto
UPDATE producto SET precio = 1150000.00 WHERE id_producto = 1;
UPDATE producto SET stock = stock + 10 WHERE id_producto = 3;

-- factura
UPDATE factura SET total = 1150000.00 WHERE id_factura = 1;
UPDATE factura SET fecha = '2024-01-15 08:00:00' WHERE id_factura = 1;

-- detalle_factura
UPDATE detalle_factura SET subtotal = 1150000.00 WHERE id_detalle = 1;
UPDATE detalle_factura SET cantidad = 3 WHERE id_detalle = 3;


-- ============================================================
-- 3. ELIMINACIONES (respetando llaves foráneas)
-- ============================================================

-- Primero se eliminan los registros hijos antes que los padres

-- detalle_factura (no tiene hijos)
DELETE FROM detalle_factura WHERE id_detalle = 5;
DELETE FROM detalle_factura WHERE id_factura = 4;

-- factura
DELETE FROM factura WHERE id_factura = 5;
DELETE FROM factura WHERE id_factura = 4;

-- usuario_rol
DELETE FROM usuario_rol WHERE id_usuario = 5 AND id_rol = 2;
DELETE FROM usuario_rol WHERE id_usuario = 3 AND id_rol = 1;

-- usuario (primero se eliminó usuario_rol de ese usuario)
DELETE FROM usuario WHERE id_usuario = 5;

-- persona (primero se eliminó el usuario asociado)
DELETE FROM persona WHERE id_persona = 5;

-- producto
DELETE FROM producto WHERE id_producto = 5;
DELETE FROM producto WHERE stock = 0;

-- categoria (solo si no tiene productos asociados)
DELETE FROM categoria WHERE id_categoria = 5;

-- rol (solo si no tiene usuarios asociados)
DELETE FROM rol WHERE id_rol = 5;

-- barrio (solo si no tiene personas asociadas)
DELETE FROM barrio WHERE id_barrio = 5;

-- ciudad (solo si no tiene barrios asociados)
DELETE FROM ciudad WHERE id_ciudad = 5;

-- departamento
DELETE FROM departamento WHERE id_departamento = 5;

-- pais
DELETE FROM pais WHERE id_pais = 5;

-- continente
DELETE FROM continente WHERE id_continente = 5;


-- ============================================================
-- 4. CONSULTAS SELECT
-- ============================================================

-- ---- CONTINENTE ----
-- Ver todos los continentes
SELECT * FROM continente;

-- Buscar continente por nombre
SELECT id_continente, nombre FROM continente
WHERE nombre = 'América';

-- ---- PAIS ----
-- Ver todos los países con su continente
SELECT p.nombre AS pais, c.nombre AS continente
FROM pais p
JOIN continente c ON p.id_continente = c.id_continente;

-- Buscar país específico
SELECT * FROM pais WHERE nombre LIKE '%Colombia%';

-- ---- DEPARTAMENTO ----
-- Ver departamentos de Colombia
SELECT d.nombre AS departamento, p.nombre AS pais
FROM departamento d
JOIN pais p ON d.id_pais = p.id_pais
WHERE p.nombre LIKE '%Colombia%';

-- Buscar departamento por nombre
SELECT * FROM departamento WHERE nombre = 'Antioquia';

-- ---- CIUDAD ----
-- Ver ciudades con su departamento
SELECT c.nombre AS ciudad, d.nombre AS departamento
FROM ciudad c
JOIN departamento d ON c.id_departamento = d.id_departamento;

-- Buscar ciudad específica
SELECT * FROM ciudad WHERE nombre LIKE '%Bogotá%';

-- ---- BARRIO ----
-- Ver barrios con su ciudad
SELECT b.nombre AS barrio, c.nombre AS ciudad
FROM barrio b
JOIN ciudad c ON b.id_ciudad = c.id_ciudad;

-- Barrios de Medellín
SELECT b.nombre FROM barrio b
JOIN ciudad c ON b.id_ciudad = c.id_ciudad
WHERE c.nombre LIKE '%Medellín%';

-- ---- PERSONA ----
-- Ver personas con su barrio y ciudad
SELECT p.nombre, p.apellido, p.documento, b.nombre AS barrio, c.nombre AS ciudad
FROM persona p
JOIN barrio b ON p.id_barrio = b.id_barrio
JOIN ciudad c ON b.id_ciudad = c.id_ciudad;

-- Buscar persona por documento
SELECT * FROM persona WHERE documento = '10234567';

-- ---- ROL ----
-- Ver todos los roles
SELECT * FROM rol;

-- Buscar rol administrador
SELECT * FROM rol WHERE nombre = 'administrador';

-- ---- USUARIO ----
-- Ver usuarios activos con su persona
SELECT u.username, u.estado, p.nombre, p.apellido
FROM usuario u
JOIN persona p ON u.id_persona = p.id_persona
WHERE u.estado = 1;

-- Buscar usuario por username
SELECT * FROM usuario WHERE username = 'luisa.g';

-- ---- USUARIO_ROL ----
-- Ver usuarios con sus roles asignados
SELECT u.username, r.nombre AS rol
FROM usuario_rol ur
JOIN usuario u ON ur.id_usuario = u.id_usuario
JOIN rol r ON ur.id_rol = r.id_rol;

-- Ver qué roles tiene el usuario 1
SELECT r.nombre FROM usuario_rol ur
JOIN rol r ON ur.id_rol = r.id_rol
WHERE ur.id_usuario = 1;

-- ---- CATEGORIA ----
-- Ver todas las categorías
SELECT * FROM categoria;

-- Buscar categoría por nombre
SELECT * FROM categoria WHERE nombre = 'Electrónica';

-- ---- PRODUCTO ----
-- Ver productos con su categoría
SELECT p.nombre AS producto, p.precio, p.stock, c.nombre AS categoria
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria;

-- Productos con stock mayor a 10
SELECT nombre, precio, stock FROM producto WHERE stock > 10;

-- ---- FACTURA ----
-- Ver facturas con nombre del cliente y usuario que la registró
SELECT f.id_factura, f.fecha, f.total,
       CONCAT(p.nombre,' ',p.apellido) AS cliente,
       u.username AS registrada_por
FROM factura f
JOIN persona p ON f.id_persona = p.id_persona
JOIN usuario u ON f.id_usuario = u.id_usuario;

-- Facturas del año 2024
SELECT * FROM factura WHERE YEAR(fecha) = 2024;

-- ---- DETALLE_FACTURA ----
-- Ver detalles con nombre del producto y factura
SELECT df.id_detalle, f.id_factura, pr.nombre AS producto,
       df.cantidad, df.subtotal
FROM detalle_factura df
JOIN factura f ON df.id_factura = f.id_factura
JOIN producto pr ON df.id_producto = pr.id_producto;

-- Ver detalle de una factura específica
SELECT df.cantidad, df.subtotal, pr.nombre AS producto
FROM detalle_factura df
JOIN producto pr ON df.id_producto = pr.id_producto
WHERE df.id_factura = 1;