 Projeto Livros BI: Modelagem Dimensional e Dashboard Analítico
Este repositório contém a solução completa de um desafio técnico focado em Business Intelligence (BI), abrangendo a modelagem de um Data Warehouse (DW), scripts de ETL em SQL e a criação de um Dashboard interativo no Power BI.

O objetivo é transformar dados transacionais brutos em um modelo dimensional Star Schema otimizado para análise de vendas, clientes, produtos e devoluções no domínio de e-commerce de livros.

 Tecnologias Utilizadas
 Estrutura do Projeto
A estrutura de pastas está organizada para refletir as etapas do projeto, desde os dados de origem até a interpretação dos resultados.

 Modelagem de Dados
A arquitetura do Data Warehouse segue o padrão Star Schema, com a granularidade no nível de Item do Pedido na tabela de fatos central.

Tabela Fato e Dimensões
 Passo a Passo para Executar o Projeto (ETL)
Siga os passos abaixo para configurar o banco de dados, carregar os dados e popular o modelo dimensional.

Pré-requisitos
MySQL Server: Versão 8.0+ instalada e acessível (porta padrão 3306).

Power BI Desktop: Instalado para visualização do dashboard.

Arquivos CSV: Todos os arquivos em csv/ prontos para importação.

1. Configuração e DDL
A execução dos scripts SQL deve seguir rigorosamente a ordem numérica para garantir a criação correta das estruturas.

2. Carregar Dados CSV (Staging)
Os dados brutos devem ser carregados nas tabelas de staging criadas na etapa 1.

Método Recomendado (MySQL Workbench):

Clique com o botão direito na tabela de staging (ex: stg_orders) → Table Data Import Wizard.

Alternativa (Comando LOAD DATA):
Use este comando no seu cliente MySQL, ajustando o caminho_absoluto e o delimitador se necessário:

 Atenção: Verifique a permissão do secure-file-priv no MySQL. O caminho do CSV deve estar no diretório permitido.

3. Popular Modelo Dimensional (ETL)
Execute os scripts que realizam a transformação e carga dos dados das tabelas de staging para o modelo dimensional.

4. Validação e Testes (QA)
 Dashboard Power BI
O dashboard interativo (Livros_BI.pbix) está pronto para uso após a conclusão do ETL.

Conectar e Atualizar os Dados
Abra o arquivo parte_3_dashboard/Livros_BI.pbix.

Se for a primeira vez, vá em Obter Dados → Banco de Dados MySQL.

Server: localhost (ou o IP do seu servidor MySQL)

Database: livro_bi

Insira as credenciais do MySQL.

Vá em Home → Transformar Dados → Configurações de Fonte de Dados.

Ajuste o servidor (localhost ou IP) para garantir que o Power BI aponte para o banco de dados correto.

Clique em Home → Atualizar (Refresh).

O dashboard exibirá os KPIs e filtros funcionais (por Canal, Estado, Categoria, Motivo de Devolução e Data).

 Supostos de Agendamento (Produção)
Este é o ciclo de atualização assumido para o modelo em um ambiente de produção:

 Solução de Problemas Comuns
Desenvolvedor: Enzo Santana
Data de Entrega: 13/10/2025
Versão: 1.0
