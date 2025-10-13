-- -----------------------------------------------------
-- ARQUIVO: 06_business_metrics.sql
-- DESCRIÇÃO: Queries das métricas de negócio (individuais)
-- -----------------------------------------------------

USE livro_bi;

-- 1. RECEITA TOTAL 
SELECT ROUND(SUM(oi.qty * oi.unit_price), 2) as receita_total
FROM stg_order_items oi
INNER JOIN stg_orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed';

-- 2. DESCONTO TOTAL
SELECT ROUND(SUM(oi.qty * oi.discount), 2) as desconto_total  
FROM stg_order_items oi
INNER JOIN stg_orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed';

-- 3. TICKET MÉDIO
SELECT 
    ROUND(SUM(oi.qty * oi.unit_price) / COUNT(DISTINCT oi.order_id), 2) as ticket_medio
FROM stg_order_items oi
INNER JOIN stg_orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed';

-- 4. % DEVOLUÇÃO
SELECT 
    ROUND(COUNT(DISTINCT r.order_id) * 100.0 / COUNT(DISTINCT o.order_id), 2) as perc_devolucao
FROM stg_orders o
LEFT JOIN stg_returns r ON o.order_id = r.order_id
WHERE o.status = 'completed';

-- 5. % PEDIDOS COMPLETOS
SELECT 
    ROUND(COUNT(CASE WHEN status = 'completed' THEN order_id END) * 100.0 / COUNT(order_id), 2) as perc_pedidos_completos
FROM stg_orders;