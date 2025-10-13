Estrutura do projeto 
```
teste_tecnico/
└── projeto_livros_BI/
    ├── csv
    │   ├── customers.csv               # CSVs para análise          
    │   ├── order_items.csv
    │   ├── orders.csv
    │   ├── payments.csv
    │   ├── products.csv
    │   └── returns.csv
    ├── parte_1_modelagem/             # Diagramas e regras de negócio
    │   ├── modelo_dimensional.drawio
    │   ├── modelo_dimensional.png
    │   └── regras_qualidade_dados.pdf
    │
    ├── parte_2_sql_scripts/           # Scripts ETL e DDL (executar em ordem numérica)
    │   ├── 01_staging_tables.sql       
    │   ├── 02_dimension_tables.sql     
    │   ├── 03_fact_table.sql           
    │   ├── 04_populate_dimensions.sql  
    │   ├── 05_populate_fact.sql        
    │   ├── 06_business_metrics.sql     
    │   ├── 07_analytical_queries.sql   
    │   └── 08_tests_validation.sql     
    │
    ├── parte_3_dashboard/             # Arquivo do Power BI Desktop
    │   └── Livros_BI.pbix
    │
    ├── parte_4_interpretacao_codigo/  # Respostas para questões de código
    │   └── respostas_interpretacao.pdf
    │
    └── parte_5_questoes_objetivas/    # Respostas para questões teóricas
        └── respostas_objetivas.pdf
```
```
INFORMAÇÕES TÉCNICAS

Item                Detalhe
SGBD          ----  MySQL 8.0+
Database      ----	livro_bi
Tecnologias   ----	MySQL, Power BI Desktop, Draw.io
Charset       ----	UTF-8
Modelo        ----	Star Schema

```
PASSO A PASSO PARA EXECUTAR O PROJETO

Pré-requisitos:

 * MySQL Server instalado e acessível (porta padrão 3306).
 * Power BI Desktop instalado.
 * Arquivos CSV de origem (orders.csv, order_items.csv, products.csv, etc.) prontos para importação.

Passo a Passo - Banco de Dados (ETL)
A execução dos scripts SQL deve seguir rigorosamente a ordem numérica para garantir a criação correta das estruturas e o carregamento dos dados.

Criar Estrutura DDL (Data Definition Language)
**Execute os scripts na ordem:**

SQL
```
01_staging_tables.sql    -- Cria tabelas temporárias para importação CSV.
02_dimension_tables.sql  -- Cria as tabelas de dimensões finais.
03_fact_table.sql        -- Cria a tabela de fatos 'fato_vendas'.
```
Carregar Dados CSV
 * Os dados brutos devem ser carregados nas tabelas de staging (Ex: stg_orders, stg_order_items, etc.).
 * Método Recomendado (MySQL Workbench): Clique com o botão direito na tabela de staging → Table Data Import Wizard.
 * Alternativa (Comando LOAD DATA): Use o comando abaixo, ajustando o caminho_absoluto e o delimitador se necessário.

Bash

LOAD DATA INFILE 'caminho_absoluto/orders.csv' 
INTO TABLE stg_orders 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Ignora a linha de cabeçalho
Atenção: Verifique a permissão do secure-file-priv no MySQL.

Popular Modelo Dimensional (Execução do ETL)
Execute os scripts que realizam a transformação e carga:

SQL
```
04_populate_dimensions.sql  -- Popula as dimensões (inclui lógica SCD Tipo 2 e ETL de Motivo Devolução).
05_populate_fact.sql        -- Popula a tabela fato_vendas (inclui cálculo de custo, receita e flags de devolução).
```

Execute os scripts de validação:

SQL
```
06_business_metrics.sql     -- Valida o cálculo das métricas chave (Receita, Custo, Lucro) antes do BI.
07_analytical_queries.sql   -- Demonstra consultas analíticas de alto nível (Ex: Vendas por Mês, Top N Produtos).
08_tests_validation.sql     -- Realiza testes de integridade de dados (Ex: NULLs, chaves pendentes).
```
Conectar ao Banco

Abra o arquivo Livros_BI.pbix.
Uma notificação de credenciais pode aparecer.
Se necessário, vá em Obter Dados → Banco de Dados MySQL.

 * Server: localhost (ou o IP do servidor)
 * Database: livro_bi

Atualizar Conexão
Após inserir as credenciais, vá em Home → Transformar Dados → Configurações de Fonte de Dados.
Ajuste o servidor (localhost ou IP) para que o Power BI aponte para o banco de dados correto.

Visualizar Dashboard
Clique em Home → Atualizar (Refresh). O dashboard deve carregar os dados atualizados e exibir os KPIs e filtros funcionais por Canal, Estado, Categoria, Motivo de Devolução e Data.

MODELAGEM DE DADOS
Arquitetura Star Schema 
A modelagem é baseada em um esquema Star com um grão de Item do Pedido na tabela de fatos, ligada às dimensões.
```
fato_vendas (Grão: Item do Pedido)
├── dim_produto (SCD Tipo 2: Histórico de preços e custos)
├── dim_cliente (SCD Tipo 2: Histórico de segmento e localidade) 
├── dim_canal
├── dim_calendario
├── dim_localidade
└── dim_motivo_devolucao  <-- Dimensão para análise de causa raiz de devoluções.
```

Regras de Qualidade Implementadas
 * KPIs Primários: Consideram apenas pedidos com status completed.
 * Métricas Financeiras: Cálculo correto de receita_liquida e custo_total.
 * Controle de Devoluções: Implementação de flag_devolucao_item e dim_motivo_devolucao_id na fato_vendas.

SUPOSTOS DE AGENDAMENTO (PRODUÇÃO)
Este é o ciclo de atualização assumido para um ambiente de produção:
```
Horário	    Ação	                         Descrição
06:00 AM	Carga Staging----------------Carregamento de novos dados CSV brutos (via LOAD DATA INFILE ou ferramenta).
06:30 AM	Atualização Dimensional------Atualização de SCDs e inserção de novos valores em dimensões (CALL sp_atualiza_dimensoes()).
07:00 AM	Refresh Fato-----------------Truncamento e reinserção dos dados da fato_vendas (Incremental ou Full, conforme o volume).
08:00 AM	Monitoramento----------------Verificação da qualidade de dados pós-carga (via 08_tests_validation.sql).
09:00 AM	Refresh Power BI-------------Atualização automática do relatório Power BI Service (via Data Gateway).
```
```
SOLUÇÃO DE PROBLEMAS
Problema			                    Solução
MySQL secure-file-priv    ----------    Verifique o diretório permitido (SHOW VARIABLES LIKE 'secure_file_priv';) e mova os CSVs para esse local.
Erro de Sintaxe no DAX    ----------    Substituir o caractere de multiplicação ∗ (Unicode) pelo asterisco padrão do teclado *.
Dados Não Atualizam no BI ----------    1. Verifique a conexão com o banco em Configurações de Fonte de Dados; 2. Clique em Home → Atualizar.
```
Desenvolvedor: Enzo Santana
Data de Entrega: 13/10/2025
Versão: 1.0




