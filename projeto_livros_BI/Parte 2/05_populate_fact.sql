-- -----------------------------------------------------
-- ARQUIVO: 05_populate_fact.sql
-- DESCRIÇÃO: População da tabela fato_vendas
-- -----------------------------------------------------

USE livro_bi;

INSERT INTO fato_vendas (
    dim_produto_id, dim_cliente_id, dim_canal_id, dim_data_pedido_id, dim_localidade_id,
    order_id, status_pedido, quantidade, preco_unitario, desconto_unitario,
    receita_liquida, total_desconto_item, total_custo_item, flag_devolucao_item
)
SELECT 
    dp.dim_produto_id,
    dc.dim_cliente_id,
    dcanal.dim_canal_id,
    dcal.dim_calendario_id,
    dloc.dim_localidade_id,
    oi.order_id,
    o.status,
    oi.qty,
    oi.unit_price,
    oi.discount,
    (oi.qty * oi.unit_price),
    (oi.qty * oi.discount),
    (oi.qty * p.cost),
    CASE WHEN r.order_id IS NOT NULL THEN TRUE ELSE FALSE END
FROM stg_order_items oi
INNER JOIN stg_orders o ON oi.order_id = o.order_id
INNER JOIN stg_products p ON oi.product_id = p.product_id
INNER JOIN dim_produto dp ON p.product_id = dp.product_id AND dp.e_vigente = TRUE
INNER JOIN dim_cliente dc ON o.customer_id = dc.customer_id AND dc.e_vigente = TRUE
INNER JOIN dim_canal dcanal ON o.channel = dcanal.channel_name
INNER JOIN dim_calendario dcal ON o.order_date = dcal.full_date
INNER JOIN dim_localidade dloc ON o.city = dloc.city AND o.state = dloc.state
LEFT JOIN stg_returns r ON oi.order_id = r.order_id;