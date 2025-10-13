-- -----------------------------------------------------
-- ARQUIVO: 02_dimension_tables.sql
-- DESCRIÇÃO: Criação das tabelas dimensionais (modelo estrela)
-- -----------------------------------------------------

USE livro_bi;

-- Dimensão Canal 
CREATE TABLE IF NOT EXISTS dim_canal (
    dim_canal_id INT AUTO_INCREMENT PRIMARY KEY,
    channel_name VARCHAR(50) UNIQUE NOT NULL
);

-- Dimensão Calendário 
CREATE TABLE IF NOT EXISTS dim_calendario (
    dim_calendario_id INT AUTO_INCREMENT PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    year INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    week INT,
    day_of_week INT,
    is_weekend BOOLEAN
);

-- Dimensão Localidade
CREATE TABLE IF NOT EXISTS dim_localidade (
    dim_localidade_id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(2),
    region VARCHAR(50)
);

-- Dimensão Produto 
CREATE TABLE IF NOT EXISTS dim_produto (
    dim_produto_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(255),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    cost DECIMAL(10,2),
    list_price DECIMAL(10,2),
    start_date DATE NOT NULL,          
    end_date DATE,                    
    is_current BOOLEAN NOT NULL       
);

-- Dimensão Cliente 
CREATE TABLE IF NOT EXISTS dim_cliente (
    dim_cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    segment VARCHAR(50),
    signup_date DATE,
    start_date DATE NOT NULL,         
    end_date DATE,                     
    is_current BOOLEAN NOT NULL        
);

CREATE TABLE IF NOT EXISTS dim_motivo_devolucao (
    dim_motivo_devolucao_id INT AUTO_INCREMENT PRIMARY KEY,
    motivo_devolucao VARCHAR(100) UNIQUE NOT NULL
);