DROP DATABASE IF EXISTS carrito20;
 
CREATE DATABASE carrito20
    CHARACTER SET utf8mb4
    COLLATE       utf8mb4_unicode_ci;
 
USE carrito20;
 
 
-- ================================================================
--  BLOQUE 1 · CATÁLOGOS BASE
-- ================================================================
 
CREATE TABLE type_document (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE continent (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(10)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE country (
    id           INT          NOT NULL AUTO_INCREMENT,
    continent_id INT          NOT NULL,
    code         VARCHAR(10)  NOT NULL UNIQUE,
    name         VARCHAR(100) NOT NULL,
    description  VARCHAR(255),
    iso_code     VARCHAR(10),
    phone_code   VARCHAR(10),
    PRIMARY KEY (id),
    CONSTRAINT fk_country_continent
        FOREIGN KEY (continent_id) REFERENCES continent (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE department (
    id          INT          NOT NULL AUTO_INCREMENT,
    country_id  INT          NOT NULL,
    code        VARCHAR(10)  NOT NULL,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id),
    CONSTRAINT fk_department_country
        FOREIGN KEY (country_id) REFERENCES country (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE city (
    id            INT          NOT NULL AUTO_INCREMENT,
    department_id INT          NOT NULL,
    code          VARCHAR(10),
    name          VARCHAR(100) NOT NULL,
    description   VARCHAR(255),
    postal_code   VARCHAR(20),
    PRIMARY KEY (id),
    CONSTRAINT fk_city_department
        FOREIGN KEY (department_id) REFERENCES department (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE address (
    id        INT            NOT NULL AUTO_INCREMENT,
    city_id   INT            NOT NULL,
    line_1    VARCHAR(255)   NOT NULL,
    line_2    VARCHAR(255),
    reference VARCHAR(255),
    zip_code  VARCHAR(20),
    latitude  DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    PRIMARY KEY (id),
    CONSTRAINT fk_address_city
        FOREIGN KEY (city_id) REFERENCES city (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
 
-- ================================================================
--  BLOQUE 2 · ARCHIVOS Y ESTADOS
-- ================================================================
 
CREATE TABLE file (
    id             INT          NOT NULL AUTO_INCREMENT,
    code           VARCHAR(20),
    name           VARCHAR(100) NOT NULL,
    description    VARCHAR(255),
    file_name      VARCHAR(255) NOT NULL,
    file_path      TEXT         NOT NULL,
    file_extension VARCHAR(20),
    mime_type      VARCHAR(100),
    size           INT UNSIGNED,
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE status (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    domain_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_status_code_domain (code, domain_name)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE order_status (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE payment_status (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE shipment_status (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE payment_method (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id)
);
 
 
-- ================================================================
--  BLOQUE 3 · SEGURIDAD Y ACCESO
-- ================================================================
 
CREATE TABLE role (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE module (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    route       VARCHAR(255),
    icon        VARCHAR(100),
    order_index INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE app_view (
    id          INT          NOT NULL AUTO_INCREMENT,
    module_id   INT          NOT NULL,
    code        VARCHAR(20)  NOT NULL,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    route       VARCHAR(255),
    order_index INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_app_view_module
        FOREIGN KEY (module_id) REFERENCES module (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE person (
    id               INT          NOT NULL AUTO_INCREMENT,
    type_document_id INT          NOT NULL,
    document_number  VARCHAR(50)  NOT NULL UNIQUE,
    first_name       VARCHAR(100) NOT NULL,
    middle_name      VARCHAR(100),
    last_name        VARCHAR(100) NOT NULL,
    second_last_name VARCHAR(100),
    email            VARCHAR(150) UNIQUE,
    phone            VARCHAR(50),
    birth_date       DATE,
    PRIMARY KEY (id),
    CONSTRAINT fk_person_type_document
        FOREIGN KEY (type_document_id) REFERENCES type_document (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE user_account (
    id            INT         NOT NULL AUTO_INCREMENT,
    person_id     INT         NOT NULL UNIQUE,
    username      VARCHAR(50) NOT NULL UNIQUE,
    password_hash TEXT        NOT NULL,
    last_login_at TIMESTAMP   NULL DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_user_account_person
        FOREIGN KEY (person_id) REFERENCES person (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE user_role (
    id              INT  NOT NULL AUTO_INCREMENT,
    user_account_id INT  NOT NULL,
    role_id         INT  NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    PRIMARY KEY (id),
    UNIQUE KEY uq_user_role (user_account_id, role_id),
    CONSTRAINT fk_user_role_account
        FOREIGN KEY (user_account_id) REFERENCES user_account (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_user_role_role
        FOREIGN KEY (role_id) REFERENCES role (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE role_module (
    id        INT NOT NULL AUTO_INCREMENT,
    role_id   INT NOT NULL,
    module_id INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_role_module (role_id, module_id),
    CONSTRAINT fk_role_module_role
        FOREIGN KEY (role_id) REFERENCES role (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_role_module_module
        FOREIGN KEY (module_id) REFERENCES module (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE module_view (
    id          INT NOT NULL AUTO_INCREMENT,
    module_id   INT NOT NULL,
    app_view_id INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_module_view (module_id, app_view_id),
    CONSTRAINT fk_module_view_module
        FOREIGN KEY (module_id) REFERENCES module (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_module_view_app_view
        FOREIGN KEY (app_view_id) REFERENCES app_view (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
 
-- ================================================================
--  BLOQUE 4 · CATÁLOGO DE PRODUCTOS
-- ================================================================
 
CREATE TABLE brand (
    id          INT          NOT NULL AUTO_INCREMENT,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id)
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE category (
    id                 INT          NOT NULL AUTO_INCREMENT,
    code               VARCHAR(20)  NOT NULL UNIQUE,
    name               VARCHAR(100) NOT NULL,
    description        VARCHAR(255),
    parent_category_id INT          NULL DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_category_parent
        FOREIGN KEY (parent_category_id) REFERENCES category (id)
        ON UPDATE CASCADE ON DELETE SET NULL
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE product (
    id          INT            NOT NULL AUTO_INCREMENT,
    category_id INT            NOT NULL,
    brand_id    INT            NOT NULL,
    code        VARCHAR(50)    NOT NULL UNIQUE,
    name        VARCHAR(100)   NOT NULL,
    description TEXT,
    sku         VARCHAR(50)    UNIQUE,
    barcode     VARCHAR(50)    UNIQUE,
    price       DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    cost        DECIMAL(10, 2) NOT NULL CHECK (cost  >= 0),
    weight      DECIMAL(10, 2),
    PRIMARY KEY (id),
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES category (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_product_brand
        FOREIGN KEY (brand_id) REFERENCES brand (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE product_image (
    id          INT     NOT NULL AUTO_INCREMENT,
    product_id  INT     NOT NULL,
    file_id     INT     NOT NULL,
    url         TEXT,
    is_main     BOOLEAN NOT NULL DEFAULT FALSE,
    order_index INT     NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_product_image_product
        FOREIGN KEY (product_id) REFERENCES product (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_image_file
        FOREIGN KEY (file_id) REFERENCES file (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE stock (
    id                 INT NOT NULL AUTO_INCREMENT,
    product_id         INT NOT NULL UNIQUE,
    quantity_available INT NOT NULL DEFAULT 0 CHECK (quantity_available >= 0),
    quantity_reserved  INT NOT NULL DEFAULT 0 CHECK (quantity_reserved  >= 0),
    reorder_level      INT NOT NULL DEFAULT 0,
    max_stock          INT NOT NULL DEFAULT 0,
    min_stock          INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_stock_product
        FOREIGN KEY (product_id) REFERENCES product (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE inventory_movement (
    id             INT            NOT NULL AUTO_INCREMENT,
    product_id     INT            NOT NULL,
    movement_type  VARCHAR(20)    NOT NULL COMMENT 'entrada / salida / ajuste',
    quantity       INT            NOT NULL,
    unit_cost      DECIMAL(10, 2),
    reference_type VARCHAR(50)             COMMENT 'order / purchase / adjustment',
    reference_id   INT,
    movement_date  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note           TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_inv_movement_product
        FOREIGN KEY (product_id) REFERENCES product (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
 
-- ================================================================
--  BLOQUE 5 · CLIENTES Y PROVEEDORES
-- ================================================================
 
CREATE TABLE customer (
    id             INT         NOT NULL AUTO_INCREMENT,
    person_id      INT         NOT NULL UNIQUE,
    customer_code  VARCHAR(50) NOT NULL UNIQUE,
    loyalty_points INT         NOT NULL DEFAULT 0 CHECK (loyalty_points >= 0),
    PRIMARY KEY (id),
    CONSTRAINT fk_customer_person
        FOREIGN KEY (person_id) REFERENCES person (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE customer_address (
    id           INT         NOT NULL AUTO_INCREMENT,
    customer_id  INT         NOT NULL,
    address_id   INT         NOT NULL,
    is_default   BOOLEAN     NOT NULL DEFAULT FALSE,
    address_type VARCHAR(50)          COMMENT 'billing / shipping',
    PRIMARY KEY (id),
    UNIQUE KEY uq_customer_address (customer_id, address_id),
    CONSTRAINT fk_cust_addr_customer
        FOREIGN KEY (customer_id) REFERENCES customer (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_cust_addr_address
        FOREIGN KEY (address_id) REFERENCES address (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE supplier (
    id            INT          NOT NULL AUTO_INCREMENT,
    person_id     INT          NOT NULL UNIQUE,
    supplier_code VARCHAR(50)  NOT NULL UNIQUE,
    contact_name  VARCHAR(100),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(50),
    PRIMARY KEY (id),
    CONSTRAINT fk_supplier_person
        FOREIGN KEY (person_id) REFERENCES person (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE supplier_address (
    id           INT         NOT NULL AUTO_INCREMENT,
    supplier_id  INT         NOT NULL,
    address_id   INT         NOT NULL,
    is_default   BOOLEAN     NOT NULL DEFAULT FALSE,
    address_type VARCHAR(50)          COMMENT 'billing / warehouse',
    PRIMARY KEY (id),
    UNIQUE KEY uq_supplier_address (supplier_id, address_id),
    CONSTRAINT fk_sup_addr_supplier
        FOREIGN KEY (supplier_id) REFERENCES supplier (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sup_addr_address
        FOREIGN KEY (address_id) REFERENCES address (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE supplier_product (
    id                    INT            NOT NULL AUTO_INCREMENT,
    supplier_id           INT            NOT NULL,
    product_id            INT            NOT NULL,
    supplier_product_code VARCHAR(50),
    purchase_price        DECIMAL(10, 2) NOT NULL CHECK (purchase_price >= 0),
    lead_time_days        INT            NOT NULL DEFAULT 1 CHECK (lead_time_days >= 0),
    is_primary            BOOLEAN        NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    UNIQUE KEY uq_supplier_product (supplier_id, product_id),
    CONSTRAINT fk_sup_prod_supplier
        FOREIGN KEY (supplier_id) REFERENCES supplier (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sup_prod_product
        FOREIGN KEY (product_id) REFERENCES product (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
 
-- ================================================================
--  BLOQUE 6 · CARRITO Y PEDIDOS
-- ================================================================
 
CREATE TABLE cart (
    id           INT            NOT NULL AUTO_INCREMENT,
    customer_id  INT            NOT NULL,
    opened_at    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at    TIMESTAMP      NULL     DEFAULT NULL,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (total_amount >= 0),
    total_items  INT            NOT NULL DEFAULT 0    CHECK (total_items  >= 0),
    PRIMARY KEY (id),
    CONSTRAINT fk_cart_customer
        FOREIGN KEY (customer_id) REFERENCES customer (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE cart_item (
    id         INT            NOT NULL AUTO_INCREMENT,
    cart_id    INT            NOT NULL,
    product_id INT            NOT NULL,
    quantity   INT            NOT NULL CHECK (quantity   > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    subtotal   DECIMAL(10, 2) NOT NULL CHECK (subtotal   >= 0),
    PRIMARY KEY (id),
    UNIQUE KEY uq_cart_item (cart_id, product_id),
    CONSTRAINT fk_cart_item_cart
        FOREIGN KEY (cart_id) REFERENCES cart (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_cart_item_product
        FOREIGN KEY (product_id) REFERENCES product (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE orders (
    id                  INT            NOT NULL AUTO_INCREMENT,
    customer_id         INT            NOT NULL,
    order_status_id     INT            NOT NULL,
    billing_address_id  INT            NOT NULL,
    shipping_address_id INT            NOT NULL,
    order_number        VARCHAR(50)    NOT NULL UNIQUE,
    order_date          TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subtotal            DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (subtotal         >= 0),
    tax_amount          DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (tax_amount        >= 0),
    discount_amount     DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (discount_amount   >= 0),
    shipping_amount     DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (shipping_amount   >= 0),
    total_amount        DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (total_amount      >= 0),
    note                TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customer (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orders_status
        FOREIGN KEY (order_status_id) REFERENCES order_status (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orders_billing_addr
        FOREIGN KEY (billing_address_id) REFERENCES address (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orders_shipping_addr
        FOREIGN KEY (shipping_address_id) REFERENCES address (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE order_item (
    id              INT            NOT NULL AUTO_INCREMENT,
    order_id        INT            NOT NULL,
    product_id      INT            NOT NULL,
    quantity        INT            NOT NULL CHECK (quantity        > 0),
    unit_price      DECIMAL(10, 2) NOT NULL CHECK (unit_price      >= 0),
    tax_amount      DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (tax_amount      >= 0),
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (discount_amount >= 0),
    subtotal        DECIMAL(10, 2) NOT NULL CHECK (subtotal        >= 0),
    total_amount    DECIMAL(10, 2) NOT NULL CHECK (total_amount    >= 0),
    PRIMARY KEY (id),
    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_item_product
        FOREIGN KEY (product_id) REFERENCES product (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
 
-- ================================================================
--  BLOQUE 7 · FACTURA, PAGO Y ENVÍO
-- ================================================================
 
CREATE TABLE invoice (
    id             INT            NOT NULL AUTO_INCREMENT,
    order_id       INT            NOT NULL UNIQUE,
    invoice_number VARCHAR(50)    NOT NULL UNIQUE,
    issue_date     DATE           NOT NULL,
    subtotal       DECIMAL(10, 2) NOT NULL CHECK (subtotal     >= 0),
    tax_amount     DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (tax_amount  >= 0),
    total_amount   DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    PRIMARY KEY (id),
    CONSTRAINT fk_invoice_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE payment (
    id                 INT            NOT NULL AUTO_INCREMENT,
    order_id           INT            NOT NULL,
    payment_method_id  INT            NOT NULL,
    payment_status_id  INT            NOT NULL,
    payment_date       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reference_number   VARCHAR(100),
    amount             DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    authorization_code VARCHAR(100),
    transaction_number VARCHAR(100),
    PRIMARY KEY (id),
    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_payment_method
        FOREIGN KEY (payment_method_id) REFERENCES payment_method (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_payment_status
        FOREIGN KEY (payment_status_id) REFERENCES payment_status (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ----------------------------------------------------------------
 
CREATE TABLE shipment (
    id                 INT            NOT NULL AUTO_INCREMENT,
    order_id           INT            NOT NULL,
    shipment_status_id INT            NOT NULL,
    address_id         INT            NOT NULL,
    shipment_date      DATE,
    delivered_date     DATE,
    tracking_number    VARCHAR(100),
    carrier_name       VARCHAR(100),
    shipping_cost      DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (shipping_cost >= 0),
    PRIMARY KEY (id),
    CONSTRAINT fk_shipment_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_shipment_status
        FOREIGN KEY (shipment_status_id) REFERENCES shipment_status (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_shipment_address
        FOREIGN KEY (address_id) REFERENCES address (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
 
-- ================================================================
--  VERIFICACIÓN FINAL
-- ================================================================
SHOW TABLES;