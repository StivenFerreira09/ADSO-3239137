-- Crear esquema
DROP SCHEMA IF EXISTS bd_proyecto CASCADE;
CREATE SCHEMA bd_proyecto;
SET search_path TO bd_proyecto;

-- Crear tablas (PostgreSQL usa SERIAL en vez de AUTO_INCREMENT)

CREATE TABLE continente (
    id_continente SERIAL       PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    descripcion   VARCHAR(255)
);

CREATE TABLE pais (
    id_pais       SERIAL       PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    descripcion   VARCHAR(255),
    id_continente INT          NOT NULL,
    CONSTRAINT fk_pais_continente FOREIGN KEY (id_continente)
        REFERENCES continente (id_continente)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE departamento (
    id_departamento SERIAL       PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    descripcion     VARCHAR(255),
    id_pais         INT          NOT NULL,
    CONSTRAINT fk_dep_pais FOREIGN KEY (id_pais)
        REFERENCES pais (id_pais)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ciudad (
    id_ciudad       SERIAL       PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    id_departamento INT          NOT NULL,
    CONSTRAINT fk_ciu_dep FOREIGN KEY (id_departamento)
        REFERENCES departamento (id_departamento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE barrio (
    id_barrio SERIAL       PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    id_ciudad INT          NOT NULL,
    CONSTRAINT fk_barrio_ciudad FOREIGN KEY (id_ciudad)
        REFERENCES ciudad (id_ciudad)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE persona (
    id_persona INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL,
    apellido   VARCHAR(100) NOT NULL,
    documento  VARCHAR(20)  NOT NULL UNIQUE,
    telefono   VARCHAR(20),
    email      VARCHAR(150) UNIQUE,
    id_barrio  INT          NOT NULL,
    CONSTRAINT fk_per_barrio FOREIGN KEY (id_barrio)
        REFERENCES barrio (id_barrio)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE rol (
    id_rol      SERIAL       PRIMARY KEY,
    nombre      VARCHAR(80)  NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

CREATE TABLE usuario (
    id_usuario SERIAL       PRIMARY KEY,
    username   VARCHAR(80)  NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    estado     SMALLINT     NOT NULL DEFAULT 1,
    id_persona INT          NOT NULL UNIQUE,
    CONSTRAINT fk_usu_persona FOREIGN KEY (id_persona)
        REFERENCES persona (id_persona)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL,
    id_rol     INT NOT NULL,
    PRIMARY KEY (id_usuario, id_rol),
    CONSTRAINT fk_ur_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ur_rol FOREIGN KEY (id_rol)
        REFERENCES rol (id_rol)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE categoria (
    id_categoria SERIAL       PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL UNIQUE,
    descripcion  VARCHAR(255)
);

CREATE TABLE producto (
    id_producto  SERIAL         PRIMARY KEY,
    nombre       VARCHAR(150)   NOT NULL,
    descripcion  VARCHAR(255),
    precio       NUMERIC(10, 2) NOT NULL CHECK (precio >= 0),
    stock        INT            NOT NULL DEFAULT 0 CHECK (stock >= 0),
    id_categoria INT            NOT NULL,
    CONSTRAINT fk_prod_cat FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE factura (
    id_factura SERIAL          PRIMARY KEY,
    fecha      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total      NUMERIC(10, 2)  NOT NULL DEFAULT 0.00 CHECK (total >= 0),
    id_persona INT             NOT NULL,
    id_usuario INT             NOT NULL,
    CONSTRAINT fk_fac_persona FOREIGN KEY (id_persona)
        REFERENCES persona (id_persona)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_fac_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE detalle_factura (
    id_detalle  SERIAL         PRIMARY KEY,
    cantidad    INT            NOT NULL CHECK (cantidad > 0),
    subtotal    NUMERIC(10, 2) NOT NULL CHECK (subtotal >= 0),
    id_factura  INT            NOT NULL,
    id_producto INT            NOT NULL,
    CONSTRAINT fk_det_factura FOREIGN KEY (id_factura)
        REFERENCES factura (id_factura)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_det_producto FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ============================================================
-- 1. INSERCIONES
-- ============================================================

INSERT INTO continente (nombre, descripcion) VALUES
('América',  'Continente del hemisferio occidental'),
('Europa',   'Continente del hemisferio oriental norte'),
('Asia',     'Continente más grande del mundo'),
('África',   'Segundo continente más grande'),
('Oceanía',  'Continente del Pacífico sur');

INSERT INTO pais (nombre, descripcion, id_continente) VALUES
('Colombia',  'País ubicado en el noroccidente de Suramérica', 1),
('México',    'País ubicado en América del Norte',             1),
('Argentina', 'País ubicado en el sur de Suramérica',         1),
('Brasil',    'País más grande de Suramérica',                1),
('Venezuela', 'País ubicado en el norte de Suramérica',       1);

INSERT INTO departamento (nombre, descripcion, id_pais) VALUES
('Antioquia',       'Departamento del noroeste colombiano',  1),
('Cundinamarca',    'Departamento del centro de Colombia',   1),
('Valle del Cauca', 'Departamento del occidente colombiano', 1),
('Atlántico',       'Departamento del norte de Colombia',    1),
('Santander',       'Departamento del nororiente colombiano',1);

INSERT INTO ciudad (nombre, id_departamento) VALUES
('Medellín',     1),
('Bogotá',       2),
('Cali',         3),
('Barranquilla', 4),
('Bucaramanga',  5);

INSERT INTO barrio (nombre, id_ciudad) VALUES
('El Poblado',  1),
('Chapinero',   2),
('San Antonio', 3),
('El Prado',    4),
('Cabecera',    5);

INSERT INTO persona (nombre, apellido, documento, telefono, email, id_barrio) VALUES
('Carlos',    'Ramírez',  '10234567', '3001234567', 'carlos.ramirez@gmail.com',  1),
('Luisa',     'Gómez',    '20345678', '3012345678', 'luisa.gomez@gmail.com',     2),
('Andrés',    'Torres',   '30456789', '3023456789', 'andres.torres@hotmail.com', 3),
('Valentina', 'Herrera',  '40567890', '3034567890', 'vale.herrera@gmail.com',    4),
('Miguel',    'Castillo', '50678901', '3045678901', 'miguel.castillo@gmail.com', 5);

INSERT INTO rol (nombre, descripcion) VALUES
('administrador', 'Acceso total al sistema'),
('vendedor',      'Puede registrar ventas y facturas'),
('bodeguero',     'Gestiona inventario y productos'),
('contador',      'Acceso a reportes financieros'),
('soporte',       'Atención al cliente y consultas');

INSERT INTO usuario (username, password, estado, id_persona) VALUES
('carlos.r',    md5('pass1234'), 1, 1),
('luisa.g',     md5('pass1234'), 1, 2),
('andres.t',    md5('pass1234'), 1, 3),
('valentina.h', md5('pass1234'), 1, 4),
('miguel.c',    md5('pass1234'), 0, 5);

INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
(1, 1),(2, 2),(3, 3),(4, 4),(5, 5);

INSERT INTO categoria (nombre, descripcion) VALUES
('Electrónica', 'Dispositivos electrónicos y accesorios'),
('Ropa',        'Prendas de vestir y accesorios de moda'),
('Alimentos',   'Productos alimenticios y bebidas'),
('Hogar',       'Artículos para el hogar y decoración'),
('Deportes',    'Equipos y ropa deportiva');

INSERT INTO producto (nombre, descripcion, precio, stock, id_categoria) VALUES
('Celular Samsung A54',   'Smartphone 128GB',         1200000.00, 20, 1),
('Camiseta deportiva',    'Talla M, algodón 100%',      45000.00, 50, 2),
('Aceite de cocina 1L',   'Aceite vegetal refinado',     8500.00,100, 3),
('Lámpara de escritorio', 'LED, luz cálida y fría',     75000.00, 30, 4),
('Balón de fútbol',       'Cuero sintético #5',          55000.00, 40, 5);

INSERT INTO factura (fecha, total, id_persona, id_usuario) VALUES
('2024-01-10 10:30:00', 1200000.00, 1, 1),
('2024-02-14 14:00:00',   45000.00, 2, 2),
('2024-03-05 09:15:00',   85000.00, 3, 3),
('2024-04-20 16:45:00',  130000.00, 4, 4),
('2024-05-01 11:00:00',   55000.00, 5, 5);

INSERT INTO detalle_factura (cantidad, subtotal, id_factura, id_producto) VALUES
(1, 1200000.00, 1, 1),
(1,   45000.00, 2, 2),
(2,   17000.00, 3, 3),
(1,   75000.00, 4, 4),
(1,   55000.00, 5, 5);

-- ============================================================
-- 2. ACTUALIZACIONES
-- ============================================================

UPDATE continente SET descripcion = 'Continente con mayor diversidad cultural' WHERE id_continente = 1;
UPDATE continente SET descripcion = 'Continente con más países del mundo' WHERE id_continente = 2;

UPDATE pais SET descripcion = 'País conocido por su biodiversidad y café' WHERE id_pais = 1;
UPDATE pais SET nombre = 'República de Colombia' WHERE id_pais = 1;

UPDATE departamento SET descripcion = 'Ciudad de la eterna primavera' WHERE id_departamento = 1;
UPDATE departamento SET descripcion = 'Capital y centro político del país' WHERE id_departamento = 2;

UPDATE ciudad SET nombre = 'Medellín (Antioquia)' WHERE id_ciudad = 1;
UPDATE ciudad SET nombre = 'Bogotá D.C.' WHERE id_ciudad = 2;

UPDATE barrio SET nombre = 'El Poblado Norte' WHERE id_barrio = 1;
UPDATE barrio SET nombre = 'Chapinero Alto' WHERE id_barrio = 2;

UPDATE persona SET telefono = '3109876543' WHERE id_persona = 1;
UPDATE persona SET email = 'luisa.nueva@gmail.com' WHERE id_persona = 2;

UPDATE rol SET descripcion = 'Control total de usuarios y configuración' WHERE id_rol = 1;
UPDATE rol SET descripcion = 'Registra ventas y atiende clientes' WHERE id_rol = 2;

UPDATE usuario SET estado = 1 WHERE id_usuario = 5;
UPDATE usuario SET username = 'carlos.ramirez' WHERE id_usuario = 1;

UPDATE usuario_rol SET id_rol = 2 WHERE id_usuario = 5 AND id_rol = 5;
UPDATE usuario_rol SET id_rol = 1 WHERE id_usuario = 3 AND id_rol = 3;

UPDATE categoria SET descripcion = 'Celulares, computadores y más' WHERE id_categoria = 1;
UPDATE categoria SET descripcion = 'Ropa casual y formal para todo público' WHERE id_categoria = 2;

UPDATE producto SET precio = 1150000.00 WHERE id_producto = 1;
UPDATE producto SET stock = stock + 10 WHERE id_producto = 3;

UPDATE factura SET total = 1150000.00 WHERE id_factura = 1;
UPDATE factura SET fecha = '2024-01-15 08:00:00' WHERE id_factura = 1;

UPDATE detalle_factura SET subtotal = 1150000.00 WHERE id_detalle = 1;
UPDATE detalle_factura SET cantidad = 3 WHERE id_detalle = 3;

-- ============================================================
-- 3. ELIMINACIONES
-- ============================================================

DELETE FROM detalle_factura WHERE id_detalle = 5;
DELETE FROM detalle_factura WHERE id_factura = 4;
DELETE FROM factura WHERE id_factura = 5;
DELETE FROM factura WHERE id_factura = 4;
DELETE FROM usuario_rol WHERE id_usuario = 5 AND id_rol = 2;
DELETE FROM usuario_rol WHERE id_usuario = 3 AND id_rol = 1;
DELETE FROM usuario WHERE id_usuario = 5;
DELETE FROM persona WHERE id_persona = 5;
DELETE FROM producto WHERE id_producto = 5;
DELETE FROM categoria WHERE id_categoria = 5;
DELETE FROM rol WHERE id_rol = 5;
DELETE FROM barrio WHERE id_barrio = 5;
DELETE FROM ciudad WHERE id_ciudad = 5;
DELETE FROM departamento WHERE id_departamento = 5;
DELETE FROM pais WHERE id_pais = 5;
DELETE FROM continente WHERE id_continente = 5;

-- ============================================================
-- 4. CONSULTAS SELECT
-- ============================================================

SELECT * FROM continente;
SELECT id_continente, nombre FROM continente WHERE nombre = 'América';

SELECT p.nombre AS pais, c.nombre AS continente
FROM pais p JOIN continente c ON p.id_continente = c.id_continente;
SELECT * FROM pais WHERE nombre ILIKE '%colombia%';

SELECT d.nombre AS departamento, p.nombre AS pais
FROM departamento d JOIN pais p ON d.id_pais = p.id_pais
WHERE p.nombre ILIKE '%colombia%';
SELECT * FROM departamento WHERE nombre = 'Antioquia';

SELECT c.nombre AS ciudad, d.nombre AS departamento
FROM ciudad c JOIN departamento d ON c.id_departamento = d.id_departamento;
SELECT * FROM ciudad WHERE nombre ILIKE '%bogotá%';

SELECT b.nombre AS barrio, c.nombre AS ciudad
FROM barrio b JOIN ciudad c ON b.id_ciudad = c.id_ciudad;
SELECT b.nombre FROM barrio b
JOIN ciudad c ON b.id_ciudad = c.id_ciudad WHERE c.nombre ILIKE '%medellín%';

SELECT p.nombre, p.apellido, b.nombre AS barrio, c.nombre AS ciudad
FROM persona p
JOIN barrio b ON p.id_barrio = b.id_barrio
JOIN ciudad c ON b.id_ciudad = c.id_ciudad;
SELECT * FROM persona WHERE documento = '10234567';

SELECT * FROM rol;
SELECT * FROM rol WHERE nombre = 'administrador';

SELECT u.username, u.estado, p.nombre, p.apellido
FROM usuario u JOIN persona p ON u.id_persona = p.id_persona WHERE u.estado = 1;
SELECT * FROM usuario WHERE username = 'luisa.g';

SELECT u.username, r.nombre AS rol
FROM usuario_rol ur
JOIN usuario u ON ur.id_usuario = u.id_usuario
JOIN rol r ON ur.id_rol = r.id_rol;
SELECT r.nombre FROM usuario_rol ur
JOIN rol r ON ur.id_rol = r.id_rol WHERE ur.id_usuario = 1;

SELECT * FROM categoria;
SELECT * FROM categoria WHERE nombre = 'Electrónica';

SELECT p.nombre AS producto, p.precio, p.stock, c.nombre AS categoria
FROM producto p JOIN categoria c ON p.id_categoria = c.id_categoria;
SELECT nombre, precio, stock FROM producto WHERE stock > 10;

SELECT f.id_factura, f.fecha, f.total,
       CONCAT(p.nombre,' ',p.apellido) AS cliente, u.username AS vendedor
FROM factura f
JOIN persona p ON f.id_persona = p.id_persona
JOIN usuario u ON f.id_usuario = u.id_usuario;
SELECT * FROM factura WHERE EXTRACT(YEAR FROM fecha) = 2024;

SELECT df.id_detalle, f.id_factura, pr.nombre AS producto, df.cantidad, df.subtotal
FROM detalle_factura df
JOIN factura f ON df.id_factura = f.id_factura
JOIN producto pr ON df.id_producto = pr.id_producto;
SELECT df.cantidad, df.subtotal, pr.nombre AS producto
FROM detalle_factura df
JOIN producto pr ON df.id_producto = pr.id_producto WHERE df.id_factura = 1;