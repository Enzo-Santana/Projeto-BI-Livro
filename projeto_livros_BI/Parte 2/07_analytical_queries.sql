-- -----------------------------------------------------
-- ARQUIVO: 07_analytical_queries.sql
-- DESCRIÇÃO: 5 consultas analíticas solicitadas
-- -----------------------------------------------------

USE livro_bi;

-- A) Receita mensal e variação vs mês anterior
SELECT 
    CONCAT(dc.year, '-', LPAD(dc.month, 2, '0')) as ano_mes,
    dc.month_name as mes,
    ROUND(SUM(fv.receita_liquida), 2) as receita_mensal,
    ROUND(LAG(SUM(fv.receita_liquida)) OVER (ORDER BY dc.year, dc.month), 2) as receita_mes_anterior,
    ROUND(((SUM(fv.receita_liquida) - LAG(SUM(fv.receita_liquida)) OVER (ORDER BY dc.year, dc.month)) / 
          LAG(SUM(fv.receita_liquida)) OVER (ORDER BY dc.year, dc.month)) * 100, 2) as variacao_percentual
FROM fato_vendas fv
INNER JOIN dim_calendario dc ON fv.dim_data_pedido_id = dc.dim_calendario_id
WHERE fv.status_pedido = 'completed'
GROUP BY dc.year, dc.month, dc.month_name
ORDER BY dc.year, dc.month;

-- B) Top 10 produtos por Receita (filtrável por canal)
SELECT 
    p.product_name,
    p.category as categoria,
    dc.channel_name as canal,
    ROUND(SUM(fv.receita_liquida), 2) as receita_total
FROM fato_vendas fv
INNER JOIN dim_produto dp ON fv.dim_produto_id = dp.dim_produto_id
INNER JOIN stg_products p ON dp.product_id = p.product_id
INNER JOIN dim_canal dc ON fv.dim_canal_id = dc.dim_canal_id
WHERE fv.status_pedido = 'completed'
  -- AND dc.channel_name = 'Web'  -- Descomente para filtrar por canal
GROUP BY p.product_name, p.category, dc.channel_name
ORDER BY receita_total DESC
LIMIT 10;

-- C) Receita por Estado e % participação
SELECT 
    dl.state as estado,
    ROUND(SUM(fv.receita_liquida), 2) as receita_estado,
    ROUND((SUM(fv.receita_liquida) / 
          (SELECT SUM(receita_liquida) FROM fato_vendas WHERE status_pedido = 'completed')) * 100, 2) as participacao_percentual
FROM fato_vendas fv
INNER JOIN dim_localidade dl ON fv.dim_localidade_id = dl.dim_localidade_id
WHERE fv.status_pedido = 'completed'
GROUP BY dl.state
ORDER BY receita_estado DESC;

-- D) Ticket Médio por Canal e tendência mensal
SELECT 
    dc.channel_name as canal,
    CONCAT(dcal.year, '-', LPAD(dcal.month, 2, '0')) as ano_mes,
    ROUND(SUM(fv.receita_liquida) / COUNT(DISTINCT fv.order_id), 2) as ticket_medio
FROM fato_vendas fv
INNER JOIN dim_canal dc ON fv.dim_canal_id = dc.dim_canal_id
INNER JOIN dim_calendario dcal ON fv.dim_data_pedido_id = dcal.dim_calendario_id
WHERE fv.status_pedido = 'completed'
GROUP BY dc.channel_name, dcal.year, dcal.month
ORDER BY canal, dcal.year, dcal.month;

-- E) Taxa de devolução por Categoria e mês
SELECT 
    p.category as categoria,
    CONCAT(dcal.year, '-', LPAD(dcal.month, 2, '0')) as ano_mes,
    ROUND(COUNT(DISTINCT CASE WHEN fv.flag_devolucao_item = TRUE THEN fv.order_id END) * 100.0 / 
          COUNT(DISTINCT fv.order_id), 2) as taxa_devolucao_percentual
FROM fato_vendas fv
INNER JOIN dim_produto dp ON fv.dim_produto_id = dp.dim_produto_id
INNER JOIN stg_products p ON dp.product_id = p.product_id
INNER JOIN dim_calendario dcal ON fv.dim_data_pedido_id = dcal.dim_calendario_id
WHERE fv.status_pedido = 'completed'
GROUP BY p.category, dcal.year, dcal.month
ORDER BY categoria, dcal.year, dcal.month;