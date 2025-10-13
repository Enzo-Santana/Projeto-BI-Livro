<h1 align="center">📘 Projeto Livros BI</h1>
<h3 align="center">Modelagem Dimensional e Dashboard Analítico</h3>

<p align="center">
  <img src="https://img.shields.io/badge/MySQL-8.0+-blue?logo=mysql&logoColor=white" />
  <img src="https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi" />
  <img src="https://img.shields.io/badge/Status-Concluído-brightgreen" />
  <img src="https://img.shields.io/badge/Versão-1.0-blueviolet" />
  <img src="https://img.shields.io/badge/Data%20de%20Entrega-13%2F10%2F2025-orange" />
</p>

---

## 🧾 Visão Geral

> Este projeto tem como objetivo desenvolver um **Data Warehouse (DW)** e um **Dashboard analítico em Power BI** para um e-commerce de livros.  
> Ele faz parte de um desafio técnico em **Business Intelligence (BI)**, aplicando **modelagem dimensional (Star Schema)**, **ETL em SQL** e **visualização de dados**.

🎯 **Meta:** transformar dados transacionais brutos em informações analíticas sobre **vendas, clientes, produtos e devoluções**.

---

## 🧠 Tecnologias Utilizadas

| 💡 Tecnologia | 🧩 Função |
|---------------|-----------|
| 🐬 **MySQL Server 8.0+** | Armazenamento e processamento de dados |
| 🧮 **SQL (ETL Scripts)** | Extração, transformação e carga (ETL) |
| 📊 **Power BI Desktop** | Criação do dashboard interativo |
| 📂 **Arquivos CSV** | Fonte de dados transacionais |
| 🧱 **Modelo Dimensional (Star Schema)** | Estrutura do Data Warehouse |

---

## 📁 Estrutura do Projeto


📂 Livros_BI
 ┣ 📂 csv/                  → Dados de origem (brutos)
 ┣ 📂 parte_1_ddl/          → Scripts DDL (criação do banco e tabelas)
 ┣ 📂 parte_2_etl/          → Scripts ETL (transformações e cargas)
 ┣ 📂 parte_3_dashboard/    → Dashboard Power BI (.pbix)
 ┗ 📄 README.md

🧩 Modelagem de Dados

A modelagem segue o padrão Star Schema, com granularidade no nível de item do pedido na tabela fato central.

🌟 Estrutura Dimensional

                +-------------------+
                |   DIM_CLIENTE     |
                +-------------------+
                         |
                         |
+-------------+    +-------------+    +-----------------+
| DIM_PRODUTO |----| FATO_VENDAS |----| DIM_CALENDARIO |
+-------------+    +-------------+    +-----------------+
                         |
                         |
              +---------------------+
              |   DIM_LOCALIDADE    |
              +---------------------+

🔹 Tabela Fato — FATO_VENDAS
Campo	                 Tipo	           Descrição
fato_vendas_id (PK)	   INT	            Identificador único
dim_produto_id (FK)	   INT	            Referência da dimensão produto
dim_cliente_id (FK)	   INT	            Referência da dimensão cliente
dim_canal_id (FK)	     INT	            Referência da dimensão canal
dim_calendario_id (FK)	INT	            Referência da dimensão calendário
dim_localidade_id (FK)	INT	            Referência da dimensão localidade
order_id	              VARCHAR(20)	    ID do pedido original
quantidade	            INT	            Quantidade vendida
preco_unitario	        DECIMAL(10,2)	  Valor unitário
desconto_unitario	     DECIMAL(10,2)	  Desconto aplicado
receita_liquida	       DECIMAL(12,2)	  Receita líquida final
<details> <summary><b>⚙️ Passo a Passo — Execução do Projeto (clique para expandir)</b></summary>
🔧 1. Pré-requisitos

MySQL Server 8.0+ (porta padrão 3306)

Power BI Desktop

Arquivos CSV disponíveis na pasta csv/

🧱 2. Criação de Estruturas (DDL)

Execute os scripts da pasta parte_1_ddl/ em ordem numérica:
1_create_database.sql
2_create_staging_tables.sql
3_create_dim_and_fact.sql

📤 3. Carga dos Dados (Staging)
Método 1 — Import Wizard

MySQL Workbench → clique com o botão direito na tabela → Table Data Import Wizard.

Método 2 — Comando SQL
LOAD DATA INFILE 'caminho_absoluto/arquivo.csv'
INTO TABLE stg_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

⚠️ Atenção: verifique o parâmetro secure-file-priv no MySQL.

🔄 4. ETL — Carga Dimensional

Execute os scripts em parte_2_etl/ para transferir e transformar os dados da staging area para as tabelas dimensionais e fato.

✅ 5. Validação (QA)

Verifique:

Integridade das chaves (PK/FK)

Consistência de valores e totalizações

Ausência de duplicatas

Coerência temporal e geográfica

</details>
📊 Dashboard Power BI

O dashboard Livros_BI.pbix permite análises interativas por canal, estado, categoria, motivo de devolução e período.

<details> <summary><b>🧭 Conexão e Atualização de Dados</b></summary>

Abra o arquivo parte_3_dashboard/Livros_BI.pbix.

Vá em Obter Dados → Banco de Dados MySQL.

Configure:

Server: localhost (ou IP do servidor)

Database: livro_bi

Insira as credenciais do MySQL.

Vá em Transformar Dados → Configurações de Fonte de Dados e ajuste o servidor.

Clique em Atualizar (Refresh).

</details>
📈 Principais KPIs e Filtros

💰 Receita Total

📦 Quantidade Vendida

🔁 Devoluções

🧍‍♂️ Clientes por Canal

📚 Categorias de Produto

🕓 Análises Temporais

🖼️ Visual do Dashboard

<p align="center"> <img src="https://imgur.com/a/wH1G2sP" alt="Dashboard Power BI - Livros BI"/> </p>
🕒 Supostos de Agendamento (Produção)
Etapa	Frequência	Responsável
Carga CSV → Staging	Diário	Automação/ETL
ETL → Dimensões/Fato	Diário	Scheduler
Atualização Power BI	Diária (06h)	Gateway Power BI
🚨 Solução de Problemas Comuns
Problema	Causa	Solução
ERROR 1290 ao usar LOAD DATA	secure-file-priv restrito	Ajustar diretório permitido
Power BI não conecta	Porta incorreta ou credenciais erradas	Verificar config. do MySQL
Dados duplicados	Falha de PK/FK na fato	Revisar joins no ETL
👨‍💻 Desenvolvedor

Enzo Santana
🎓 Ciência da Computação — UNASP-SP
📅 Data de Entrega: 13/10/2025
🏷️ Versão: 1.0
💼 Projeto Técnico — Business Intelligence (Livros BI)

<p align="center"> ⭐ <b>Se este projeto te ajudou, deixe uma estrela!</b> ⭐ <br> <sub>Feito com dedicação por <b>Enzo Santana</b></sub> </p> ```
