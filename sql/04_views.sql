-- =====================================================
-- Pizzaria DB: views para análise e dashboard
-- =====================================================

-- 1) Tabela "larga" com um pedido por linha (base principal do dashboard)
CREATE OR REPLACE VIEW vw_pedidos_detalhe AS
SELECT p.id                                          AS pedido_id,
       p.criado_em,
       p.criado_em::date                             AS data,
       EXTRACT(HOUR FROM p.criado_em)::int           AS hora,
       (ARRAY['Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado'])
           [EXTRACT(DOW FROM p.criado_em)::int + 1]  AS dia_semana,
       p.tipo,
       p.status,
       c.nome                                        AS cliente,
       b.nome                                        AS bairro,
       b.zona,
       pg.forma                                      AS forma_pagamento,
       p.taxa_entrega,
       p.total,
       ROUND(EXTRACT(EPOCH FROM (e.entregue_em - p.criado_em)) / 60) AS minutos_ate_entrega
FROM pedidos p
JOIN clientes c           ON c.id = p.cliente_id
LEFT JOIN enderecos en    ON en.id = p.endereco_id
LEFT JOIN bairros b       ON b.id = en.bairro_id
LEFT JOIN pagamentos pg   ON pg.pedido_id = p.id
LEFT JOIN entregas e      ON e.pedido_id = p.id;

-- 2) Faturamento por dia
CREATE OR REPLACE VIEW vw_faturamento_diario AS
SELECT p.criado_em::date        AS data,
       COUNT(*)                 AS pedidos,
       ROUND(SUM(p.total), 2)   AS faturamento,
       ROUND(AVG(p.total), 2)   AS ticket_medio
FROM pedidos p
WHERE p.status = 'entregue'
GROUP BY p.criado_em::date;

-- 3) Vendas por produto e tamanho
CREATE OR REPLACE VIEW vw_vendas_produto AS
SELECT c.nome  AS categoria,
       pr.nome AS produto,
       v.tamanho,
       SUM(i.quantidade)                                  AS quantidade,
       ROUND(SUM(i.quantidade * i.preco_unitario), 2)     AS faturamento
FROM itens_pedido i
JOIN pedidos p           ON p.id = i.pedido_id AND p.status = 'entregue'
JOIN variacoes_produto v ON v.id = i.variacao_id
JOIN produtos pr         ON pr.id = v.produto_id
JOIN categorias c        ON c.id = pr.categoria_id
GROUP BY c.nome, pr.nome, v.tamanho;

-- 4) Custo e margem de cada item do cardápio (custo vem da ficha técnica)
CREATE OR REPLACE VIEW vw_margem_produto AS
SELECT pr.nome AS produto,
       v.tamanho,
       v.preco,
       ROUND(SUM(f.quantidade * i.custo_unitario), 2)                    AS custo,
       ROUND(v.preco - SUM(f.quantidade * i.custo_unitario), 2)          AS margem,
       ROUND(100 * (v.preco - SUM(f.quantidade * i.custo_unitario)) / v.preco, 1) AS margem_percentual
FROM ficha_tecnica f
JOIN insumos i           ON i.id = f.insumo_id
JOIN variacoes_produto v ON v.id = f.variacao_id
JOIN produtos pr         ON pr.id = v.produto_id
GROUP BY pr.nome, v.tamanho, v.preco, v.id;

-- 5) Situação do estoque de cada insumo
CREATE OR REPLACE VIEW vw_situacao_estoque AS
SELECT i.id AS insumo_id,
       i.nome,
       i.unidade_medida,
       i.estoque_atual,
       i.estoque_minimo,
       ROUND(i.estoque_atual / NULLIF(i.estoque_minimo, 0), 2) AS cobertura_sobre_minimo,
       CASE WHEN i.estoque_atual <= i.estoque_minimo        THEN 'Crítico'
            WHEN i.estoque_atual <= i.estoque_minimo * 1.5  THEN 'Atenção'
            ELSE 'Ok' END AS situacao
FROM insumos i;

-- 6) Desempenho de cada entregador
CREATE OR REPLACE VIEW vw_desempenho_entregador AS
SELECT en.id AS entregador_id,
       en.nome AS entregador,
       en.veiculo,
       COUNT(*) AS entregas,
       ROUND(AVG(EXTRACT(EPOCH FROM (e.entregue_em - e.saiu_em)) / 60)) AS minutos_em_rota
FROM entregas e
JOIN entregadores en ON en.id = e.entregador_id
GROUP BY en.id, en.nome, en.veiculo;

-- 7) Entregas por zona da cidade
CREATE OR REPLACE VIEW vw_entregas_zona AS
SELECT b.zona,
       COUNT(*) AS entregas,
       ROUND(AVG(EXTRACT(EPOCH FROM (e.entregue_em - p.criado_em)) / 60)) AS minutos_medio,
       ROUND(AVG(p.taxa_entrega), 2) AS taxa_media
FROM entregas e
JOIN pedidos p    ON p.id = e.pedido_id
JOIN enderecos en ON en.id = p.endereco_id
JOIN bairros b    ON b.id = en.bairro_id
GROUP BY b.zona;


       ROUND(EXTRACT(EPOCH FROM (e.entregue_em - p.criado_em)) / 60) AS minutos_ate_entrega,
       EXTRACT(DOW FROM p.criado_em)::int                            AS dia_semana_num