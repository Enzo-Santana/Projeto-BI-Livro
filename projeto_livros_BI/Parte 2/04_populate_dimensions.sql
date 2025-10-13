-- -----------------------------------------------------
-- ARQUIVO: 04_populate_dimensions.sql
-- DESCRIÇÃO: População das tabelas dimensionais
-- -----------------------------------------------------

USE livro_bi;

-- 1. Popular DIM_CANAL 
INSERT INTO dim_canal (channel_name)
SELECT DISTINCT channel FROM stg_orders WHERE channel IS NOT NULL;

-- 2. Popular DIM_CALENDARIO 
INSERT INTO dim_calendario (full_date, year, month, month_name, quarter, week, day_of_week, is_weekend)
SELECT DISTINCT 
    order_date,
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date),
    QUARTER(order_date),
    WEEK(order_date),
    DAYOFWEEK(order_date),
    CASE WHEN DAYOFWEEK(order_date) IN (1,7) THEN TRUE ELSE FALSE END
FROM stg_orders WHERE order_date IS NOT NULL;

-- 3. Popular DIM_LOCALIDADE 
INSERT INTO dim_localidade (city, state, region)
SELECT DISTINCT 
    city,
    state,
    CASE 
        WHEN state IN ('SP','RJ','MG','ES') THEN 'Sudeste'
        WHEN state IN ('RS','SC','PR') THEN 'Sul' 
        WHEN state IN ('DF','GO','MT','MS') THEN 'Centro-Oeste'
        WHEN state IN ('BA','SE','AL','PE','PB','RN','CE','PI','MA') THEN 'Nordeste'
        ELSE 'Outros'
    END as region
FROM (
    SELECT city, state FROM stg_orders
    UNION 
    SELECT city, state FROM stg_customers
) AS locais WHERE city IS NOT NULL;

-- 4. Popular DIM_PRODUTO 
INSERT INTO dim_produto (product_id, product_name, category, subcategory, cost, list_price, data_inicio, e_vigente)
SELECT 
    product_id, product_name, category, subcategory, cost, list_price,
    '2024-01-01', TRUE
FROM stg_products;

-- 5. Popular DIM_CLIENTE 
INSERT INTO dim_cliente (customer_id, segment, signup_date, data_inicio, e_vigente)
SELECT 
    customer_id, segment, signup_date,
    COALESCE(signup_date, '2024-01-01'), TRUE
FROM stg_customers;

-- 6. Popular DIM_MOTIVO_DEVOLUCAO 
INSERT INTO dim_motivo_devolucao (motivo_devolucao)
SELECT DISTINCT 
    TRIM(reason) -- Limpa possíveis espaços
FROM 
    staging_returns
WHERE 
    reason IS NOT NULL AND TRIM(reason) <> ''
ON DUPLICATE KEY UPDATE 
    motivo_devolucao = motivo_devolucao; 