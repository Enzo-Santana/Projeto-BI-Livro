-- -----------------------------------------------------
-- ARQUIVO: 01_staging_tables.sql
-- DESCRIÇÃO: Criação das tabelas staging (dados brutos dos CSVs)
-- -----------------------------------------------------

CREATE DATABASE IF NOT EXISTS livro_bi;
USE livro_bi;

DROP TABLE IF EXISTS stg_orders;

-- Tabela para orders.csv
CREATE TABLE stg_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    channel VARCHAR(50),
    status VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(2)
);

DROP TABLE IF EXISTS stg_order_items;

-- Tabela para order_items.csv  
CREATE TABLE stg_order_items (
    order_id INT,
    product_id INT,
    qty INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(10,2)
);

DROP TABLE IF EXISTS stg_products;

-- Tabela para products.csv
CREATE TABLE stg_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    cost DECIMAL(10,2),
    list_price DECIMAL(10,2)
);

DROP TABLE IF EXISTS stg_customers;

-- Tabela para customers.csv
CREATE TABLE stg_customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE,
    segment VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(2)
);

DROP TABLE IF EXISTS stg_payments;

-- Tabela para payments.csv
CREATE TABLE stg_payments (
    order_id INT,
    payment_method VARCHAR(50),
    amount DECIMAL(10,2),
    paid_date DATE
);

DROP TABLE IF EXISTS stg_returns;

-- Tabela para returns.csv
CREATE TABLE stg_returns (
    order_id INT,
    return_date DATE,
    reason VARCHAR(100)
);

DROP TABLE IF EXISTS staging_returns;

CREATE TABLE staging_returns (
    order_id INT NOT NULL,
    return_date DATE,
    reason VARCHAR(100)
);