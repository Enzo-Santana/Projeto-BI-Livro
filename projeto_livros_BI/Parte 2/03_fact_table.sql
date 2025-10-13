-- -----------------------------------------------------
-- ARQUIVO: 03_fact_table.sql
-- DESCRIÇÃO: Criação da tabela fato principal
-- -----------------------------------------------------

USE livro_bi;

CREATE TABLE fato_vendas (
    -- Chave primária substituta
    fato_vendas_id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Chaves estrangeiras das dimensões
    dim_produto_id INT NOT NULL,
    dim_cliente_id INT NOT NULL,
    dim_canal_id INT NOT NULL,
    dim_data_pedido_id INT NOT NULL,
    dim_localidade_id INT NOT NULL,
    
    -- Chaves naturais para auditoria
    order_id INT NOT NULL,
    status_pedido VARCHAR(20),
    
    -- Métricas (grão: item do pedido)
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    desconto_unitario DECIMAL(10,2),
    receita_liquida DECIMAL(10,2),
    total_desconto_item DECIMAL(10,2),
    total_custo_item DECIMAL(10,2),
    flag_devolucao_item BOOLEAN DEFAULT FALSE,
    
    -- Timestamp de criação
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    FOREIGN KEY (dim_produto_id) REFERENCES dim_produto(dim_produto_id),
    FOREIGN KEY (dim_cliente_id) REFERENCES dim_cliente(dim_cliente_id),
    FOREIGN KEY (dim_canal_id) REFERENCES dim_canal(dim_canal_id),
    FOREIGN KEY (dim_data_pedido_id) REFERENCES dim_calendario(dim_calendario_id),
    FOREIGN KEY (dim_localidade_id) REFERENCES dim_localidade(dim_localidade_id)
);

-- Índices para performance
CREATE INDEX idx_fato_produto ON fato_vendas(dim_produto_id);
CREATE INDEX idx_fato_cliente ON fato_vendas(dim_cliente_id);
CREATE INDEX idx_fato_data ON fato_vendas(dim_data_pedido_id);
CREATE INDEX idx_fato_canal ON fato_vendas(dim_canal_id);