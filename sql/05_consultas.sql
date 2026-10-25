-- =====================================================
-- Pizzaria DB: consultas de negócio
-- =====================================================




-- Produtos mais vendidos
SELECT p.nome AS produto, SUM(i.quantidade) AS vendidas
FROM itens_pedido i
JOIN pedidos ped         ON ped.id = i.pedido_id
JOIN variacoes_produto v ON v.id = i.variacao_id
JOIN produtos p          ON p.id = v.produto_id
WHERE ped.status = 'entregue'
GROUP BY p.nome
ORDER BY vendidas DESC;

-- Tempo médio de entrega por zona (do pedido até a chegada, em minutos)
SELECT b.zona,
       ROUND(AVG(EXTRACT(EPOCH FROM (e.entregue_em - p.criado_em)) / 60)) AS minutos
FROM entregas e
JOIN pedidos p    ON p.id = e.pedido_id
JOIN enderecos en ON en.id = p.endereco_id
JOIN bairros b    ON b.id = en.bairro_id
GROUP BY b.zona
ORDER BY minutos;




--  Quais produtos mais vendem? (considera só pedidos entregues)
SELECT p.nome AS produto, SUM(i.quantidade) AS vendidas
FROM itens_pedido i
JOIN pedidos ped         ON ped.id = i.pedido_id
JOIN variacoes_produto v ON v.id = i.variacao_id
JOIN produtos p          ON p.id = v.produto_id
WHERE ped.status = 'entregue'
GROUP BY p.nome
ORDER BY vendidas DESC;

--  Quanto tempo leva a entrega em cada zona? (do pedido até a chegada, em minutos)
SELECT b.zona,
       ROUND(AVG(EXTRACT(EPOCH FROM (e.entregue_em - p.criado_em)) / 60)) AS minutos
FROM entregas e
JOIN pedidos p    ON p.id = e.pedido_id
JOIN enderecos en ON en.id = p.endereco_id
JOIN bairros b    ON b.id = en.bairro_id
GROUP BY b.zona
ORDER BY minutos;

--  Quanto a pizzaria fatura por mês? (o primeiro e o último mês são parciais)
SELECT TO_CHAR(DATE_TRUNC('month', p.criado_em), 'YYYY-MM') AS mes,
       COUNT(*)                 AS pedidos,
       ROUND(SUM(p.total), 2)   AS faturamento
FROM pedidos p
WHERE p.status = 'entregue'
GROUP BY DATE_TRUNC('month', p.criado_em)
ORDER BY mes;

--  Em quais horários há mais pedidos?
SELECT EXTRACT(HOUR FROM p.criado_em)::int AS hora,
       COUNT(*) AS pedidos
FROM pedidos p
WHERE p.status <> 'cancelado'
GROUP BY hora
ORDER BY hora;

-- Como os clientes pagam? (quantidade e valor por forma de pagamento)
SELECT pg.forma,
       COUNT(*)                AS pagamentos,
       ROUND(SUM(pg.valor), 2) AS total_pago
FROM pagamentos pg
WHERE pg.status = 'pago'
GROUP BY pg.forma
ORDER BY total_pago DESC;

--  Qual o custo e a margem de cada pizza? (custo vem da ficha técnica)
SELECT p.nome AS produto,
       v.tamanho,
       v.preco,
       ROUND(SUM(f.quantidade * i.custo_unitario), 2)           AS custo,
       ROUND(v.preco - SUM(f.quantidade * i.custo_unitario), 2) AS margem
FROM ficha_tecnica f
JOIN insumos i           ON i.id = f.insumo_id
JOIN variacoes_produto v ON v.id = f.variacao_id
JOIN produtos p          ON p.id = v.produto_id
GROUP BY p.nome, v.tamanho, v.preco, v.id
ORDER BY p.nome, v.preco;

--  Quem são os 10 clientes que mais gastaram?
SELECT c.nome,
       COUNT(*)               AS pedidos,
       ROUND(SUM(p.total), 2) AS total_gasto
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
WHERE p.status = 'entregue'
GROUP BY c.id, c.nome
ORDER BY total_gasto DESC
LIMIT 10;

--  Como está o desempenho de cada entregador?
SELECT en.nome AS entregador,
       COUNT(*) AS entregas,
       ROUND(AVG(EXTRACT(EPOCH FROM (e.entregue_em - e.saiu_em)) / 60)) AS minutos_em_rota
FROM entregas e
JOIN entregadores en ON en.id = e.entregador_id
GROUP BY en.id, en.nome
ORDER BY entregas DESC;