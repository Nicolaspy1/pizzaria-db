# 🍕 Pizzaria DB

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![DBeaver](https://img.shields.io/badge/DBeaver-382923?style=for-the-badge&logo=dbeaver&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

Banco de dados relacional para uma **pizzaria com delivery no Rio de Janeiro**: cardápio, estoque com ficha técnica, pedidos, pagamentos e entregas, com histórico de 90 dias, análise em Python e dashboard no Power BI.

> Todos os dados são **fictícios**, gerados em SQL para fins de portfólio.

## 📊 Dashboard

![Dashboard](docs/dashboard.png)

## 🗂️ Modelo de dados

![Diagrama ER](docs/diagrama_er.png)

O banco tem **14 tabelas** organizadas em três módulos:

| Módulo | Tabelas |
|---|---|
| Cardápio | `categorias`, `produtos`, `variacoes_produto` |
| Estoque | `insumos`, `ficha_tecnica`, `movimentacoes_estoque` |
| Vendas e entrega | `clientes`, `enderecos`, `bairros`, `pedidos`, `itens_pedido`, `pagamentos`, `entregadores`, `entregas` |

## ✨ Destaques técnicos

- **Modelagem normalizada:** o sabor (`produtos`) é separado do tamanho e do preço (`variacoes_produto`), e o preço é copiado para o pedido no momento da compra (`itens_pedido.preco_unitario`).
- **Ficha técnica (relação N:N):** cada variação de pizza consome insumos em quantidades definidas, o que permite calcular **custo e margem** de cada item.
- **Integridade de dados:** chaves primárias e estrangeiras, `UNIQUE`, `NOT NULL` e `CHECK` (por exemplo, estoque nunca negativo e entrega que não chega antes de sair).
- **Triggers de estoque:** ao enviar o pedido para a cozinha, o banco **verifica o saldo, registra a saída e desconta o estoque**. Se o pedido for cancelado depois, o estoque é **estornado**.
- **Views para análise:** 7 views alimentam o notebook e o dashboard (faturamento, vendas por produto, margem, estoque, entregas por zona).
- **Dados gerados em SQL puro:** `generate_series`, CTEs, arrays e `random()` com semente fixa, simulando picos de pedidos à noite e nos fins de semana.

## 🧰 Tecnologias

PostgreSQL, DBeaver, Python (pandas, SQLAlchemy, matplotlib), Jupyter Notebook, Power BI e Git.

## 📁 Estrutura do projeto

```
pizzaria-db/
├── sql/
│   ├── 01_schema.sql      # tabelas, chaves, restrições e índices
│   ├── 02_dados.sql       # cardápio, estoque, clientes e histórico de pedidos
│   ├── 03_triggers.sql    # baixa e estorno automático de estoque
│   ├── 04_views.sql       # views para análise e dashboard
│   └── 05_consultas.sql   # consultas de negócio
├── analise/
│   └── analise_vendas.ipynb
├── dashboard/
│   └── pizzaria.pbix
├── docs/                  # diagrama ER e print do dashboard
├── requirements.txt
└── README.md
```

## ▶️ Como executar

1. Instale o **PostgreSQL** e crie um banco vazio:
   ```sql
   CREATE DATABASE pizzaria;
   ```
2. Conectado a esse banco, execute os arquivos da pasta `sql/` **nesta ordem**:
   `01_schema.sql`, `02_dados.sql`, `03_triggers.sql` e `04_views.sql`.
3. Teste com as consultas do `05_consultas.sql`.

**Notebook de análise (opcional):**

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

Crie um arquivo `.env` na raiz com a conexão do seu banco:

```
DATABASE_URL=postgresql+psycopg2://usuario:senha@localhost:5432/pizzaria
```

Depois, abra `analise/analise_vendas.ipynb`.

**Dashboard:** abra `dashboard/pizzaria.pbix` no Power BI Desktop e, em **Transformar dados → Configurações da fonte de dados**, aponte para o seu servidor PostgreSQL.

## 🔎 Exemplo de consulta

Custo e margem de cada item do cardápio, calculados a partir da ficha técnica:

```sql
SELECT p.nome AS produto, v.tamanho, v.preco,
       ROUND(SUM(f.quantidade * i.custo_unitario), 2) AS custo,
       ROUND(v.preco - SUM(f.quantidade * i.custo_unitario), 2) AS margem
FROM ficha_tecnica f
JOIN insumos i           ON i.id = f.insumo_id
JOIN variacoes_produto v ON v.id = f.variacao_id
JOIN produtos p          ON p.id = v.produto_id
GROUP BY p.nome, v.tamanho, v.preco, v.id
ORDER BY p.nome, v.preco;
```

## 👤 Autor

**Nicolas Moreira Alves**
[LinkedIn](https://www.linkedin.com/in/nicolas-moreira-dev/) · [GitHub](https://github.com/Nicolaspy1)