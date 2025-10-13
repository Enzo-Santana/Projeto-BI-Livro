-- -----------------------------------------------------
-- ARQUIVO: 08_tests_validation.sql
-- DESCRIÇÃO: Scripts de teste e validação
-- -----------------------------------------------------

USE livro_bi;

-- 1. Verificar contagem de registros
SELECT 
    'stg_orders' as tabela, COUNT(*) as total FROM stg_orders
UNION ALL SELECT 'stg_order_items', COUNT(*) FROM stg_order_items
UNION ALL SELECT 'stg_products', COUNT(*) FROM stg_products
UNION ALL SELECT 'stg_customers', COUNT(*) FROM stg_customers
UNION ALL SELECT 'dim_canal', COUNT(*) FROM dim_canal
UNION ALL SELECT 'dim_calendario', COUNT(*) FROM dim_calendario
UNION ALL SELECT 'dim_produto', COUNT(*) FROM dim_produto
UNION ALL SELECT 'dim_cliente', COUNT(*) FROM dim_cliente
UNION ALL SELECT 'fato_vendas', COUNT(*) FROM fato_vendas;

-- 2. Testar métricas básicas
SELECT 
    (SELECT COUNT(*) FROM fato_vendas WHERE status_pedido = 'completed') as pedidos_completed,
    (SELECT ROUND(SUM(receita_liquida), 2) FROM fato_vendas WHERE status_pedido = 'completed') as receita_total,
    (SELECT COUNT(DISTINCT order_id) FROM fato_vendas WHERE flag_devolucao_item = TRUE) as pedidos_com_devolucao;

-- 3. Verificar integridade dimensional
SELECT 
    'Produtos sem dimensão' as teste,
    COUNT(*) as problemas
FROM stg_products p
LEFT JOIN dim_produto dp ON p.product_id = dp.product_id AND dp.e_vigente = TRUE
WHERE dp.dim_produto_id IS NULL;