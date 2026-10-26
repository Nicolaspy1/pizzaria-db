-- =====================================================
-- Pizzaria DB: dados iniciais (parte 1)
-- =====================================================

INSERT INTO categorias (nome) VALUES
('Pizzas salgadas'),
('Pizzas doces'),
('Bebidas'),
('Sobremesas');

INSERT INTO bairros (nome, zona, taxa_entrega) VALUES
('Centro',           'Centro', 6.00),
('Copacabana',       'Sul',    8.00),
('Ipanema',          'Sul',    9.00),
('Botafogo',         'Sul',    8.00),
('Tijuca',           'Norte',  7.00),
('Méier',            'Norte',  8.00),
('Madureira',        'Norte',  9.00),
('Barra da Tijuca',  'Oeste', 12.00),
('Recreio',          'Oeste', 14.00),
('Jacarepaguá',      'Oeste', 11.00);

-- Produtos: a categoria é buscada pelo nome, sem precisar decorar ids
INSERT INTO produtos (categoria_id, nome, descricao)
SELECT c.id, v.nome, v.descricao
FROM (VALUES
    ('Pizzas salgadas', 'Calabresa',            'Calabresa fatiada e cebola'),
    ('Pizzas salgadas', 'Mussarela',            'Mussarela e orégano'),
    ('Pizzas salgadas', 'Portuguesa',           'Presunto, ovo, cebola e azeitona'),
    ('Pizzas salgadas', 'Margherita',           'Mussarela, tomate e manjericão'),
    ('Pizzas salgadas', 'Frango com Catupiry',  'Frango desfiado e catupiry'),
    ('Pizzas doces',    'Chocolate',            'Chocolate ao leite e granulado'),
    ('Pizzas doces',    'Banana com Canela',    'Banana, açúcar e canela'),
    ('Bebidas',         'Coca-Cola',            NULL),
    ('Bebidas',         'Guaraná',              NULL),
    ('Sobremesas',      'Brownie',              'Brownie de chocolate')
) AS v(categoria, nome, descricao)
JOIN categorias c ON c.nome = v.categoria;

-- Variações (tamanho e preço): o produto também é buscado pelo nome
INSERT INTO variacoes_produto (produto_id, tamanho, preco)
SELECT p.id, v.tamanho, v.preco
FROM (VALUES
    ('Calabresa',           'Broto',  28.00),
    ('Calabresa',           'Média',  42.00),
    ('Calabresa',           'Grande', 58.00),
    ('Mussarela',           'Broto',  26.00),
    ('Mussarela',           'Média',  40.00),
    ('Mussarela',           'Grande', 55.00),
    ('Portuguesa',          'Broto',  30.00),
    ('Portuguesa',          'Média',  45.00),
    ('Portuguesa',          'Grande', 62.00),
    ('Margherita',          'Broto',  28.00),
    ('Margherita',          'Média',  42.00),
    ('Margherita',          'Grande', 58.00),
    ('Frango com Catupiry', 'Broto',  30.00),
    ('Frango com Catupiry', 'Média',  45.00),
    ('Frango com Catupiry', 'Grande', 62.00),
    ('Chocolate',           'Broto',  30.00),
    ('Chocolate',           'Grande', 60.00),
    ('Banana com Canela',   'Broto',  28.00),
    ('Banana com Canela',   'Grande', 56.00),
    ('Coca-Cola',           'Lata 350ml', 6.00),
    ('Coca-Cola',           '2 Litros',  13.00),
    ('Guaraná',             'Lata 350ml', 5.50),
    ('Guaraná',             '2 Litros',  11.00),
    ('Brownie',             'Unidade',    9.00)
) AS v(produto, tamanho, preco)
JOIN produtos p ON p.nome = v.produto;





-- =====================================================
-- Pizzaria DB: dados iniciais (parte 2: insumos e ficha técnica)
-- =====================================================

INSERT INTO insumos (nome, unidade_medida, estoque_atual, estoque_minimo, custo_unitario) VALUES
('Massa de pizza',        'g',   50000, 10000, 0.0080),
('Molho de tomate',       'ml',  20000,  4000, 0.0060),
('Mussarela',             'g',   30000,  6000, 0.0450),
('Calabresa',             'g',    8000,  2000, 0.0350),
('Cebola',                'g',    6000,  1500, 0.0050),
('Presunto',              'g',    6000,  1500, 0.0300),
('Ovo cozido',            'g',    4000,  1000, 0.0150),
('Azeitona',              'g',    3000,   800, 0.0300),
('Tomate',                'g',    5000,  1200, 0.0080),
('Manjericão',            'g',     500,   150, 0.0400),
('Orégano',               'g',     500,   100, 0.0300),
('Frango desfiado',       'g',    8000,  2000, 0.0280),
('Catupiry',              'g',    6000,  1500, 0.0400),
('Chocolate ao leite',    'g',    5000,  1200, 0.0350),
('Granulado',             'g',    2000,   500, 0.0200),
('Banana',                'g',    6000,  1500, 0.0070),
('Açúcar',                'g',    5000,  1000, 0.0040),
('Canela',                'g',     500,   100, 0.0300),
('Coca-Cola lata 350ml',  'un',    120,    30, 3.2000),
('Coca-Cola 2L',          'un',     48,    12, 7.5000),
('Guaraná lata 350ml',    'un',    120,    30, 3.0000),
('Guaraná 2L',            'un',     48,    12, 6.5000),
('Brownie pronto',        'un',     40,    10, 4.0000);

-- Ficha técnica das pizzas: receita base da Grande x fator de cada tamanho
WITH receita (produto, insumo, qtd_grande) AS (VALUES
    ('Calabresa',           'Massa de pizza',     400),
    ('Calabresa',           'Molho de tomate',    120),
    ('Calabresa',           'Mussarela',          250),
    ('Calabresa',           'Calabresa',          150),
    ('Calabresa',           'Cebola',              60),
    ('Mussarela',           'Massa de pizza',     400),
    ('Mussarela',           'Molho de tomate',    120),
    ('Mussarela',           'Mussarela',          350),
    ('Mussarela',           'Orégano',              2),
    ('Portuguesa',          'Massa de pizza',     400),
    ('Portuguesa',          'Molho de tomate',    120),
    ('Portuguesa',          'Mussarela',          220),
    ('Portuguesa',          'Presunto',           120),
    ('Portuguesa',          'Ovo cozido',          60),
    ('Portuguesa',          'Cebola',              50),
    ('Portuguesa',          'Azeitona',            30),
    ('Margherita',          'Massa de pizza',     400),
    ('Margherita',          'Molho de tomate',    120),
    ('Margherita',          'Mussarela',          250),
    ('Margherita',          'Tomate',             120),
    ('Margherita',          'Manjericão',           5),
    ('Frango com Catupiry', 'Massa de pizza',     400),
    ('Frango com Catupiry', 'Molho de tomate',    120),
    ('Frango com Catupiry', 'Mussarela',          200),
    ('Frango com Catupiry', 'Frango desfiado',    160),
    ('Frango com Catupiry', 'Catupiry',           100),
    ('Chocolate',           'Massa de pizza',     400),
    ('Chocolate',           'Chocolate ao leite', 200),
    ('Chocolate',           'Granulado',           30),
    ('Banana com Canela',   'Massa de pizza',     400),
    ('Banana com Canela',   'Banana',             250),
    ('Banana com Canela',   'Açúcar',              40),
    ('Banana com Canela',   'Canela',               3)
),
fator (tamanho, fator) AS (VALUES
    ('Broto',  0.40),
    ('Média',  0.70),
    ('Grande', 1.00)
)
INSERT INTO ficha_tecnica (variacao_id, insumo_id, quantidade)
SELECT v.id, i.id, ROUND(r.qtd_grande * f.fator, 3)
FROM receita r
JOIN produtos p          ON p.nome = r.produto
JOIN variacoes_produto v ON v.produto_id = p.id
JOIN fator f             ON f.tamanho = v.tamanho
JOIN insumos i           ON i.nome = r.insumo;

-- Bebidas e sobremesa: cada unidade vendida consome 1 unidade do estoque
INSERT INTO ficha_tecnica (variacao_id, insumo_id, quantidade)
SELECT v.id, i.id, 1
FROM (VALUES
    ('Coca-Cola', 'Lata 350ml', 'Coca-Cola lata 350ml'),
    ('Coca-Cola', '2 Litros',   'Coca-Cola 2L'),
    ('Guaraná',   'Lata 350ml', 'Guaraná lata 350ml'),
    ('Guaraná',   '2 Litros',   'Guaraná 2L'),
    ('Brownie',   'Unidade',    'Brownie pronto')
) AS x(produto, tamanho, insumo)
JOIN produtos p          ON p.nome = x.produto
JOIN variacoes_produto v ON v.produto_id = p.id AND v.tamanho = x.tamanho
JOIN insumos i           ON i.nome = x.insumo;



-- =====================================================
-- Pizzaria DB: dados iniciais (parte 3: clientes, endereços e entregadores)
-- =====================================================

-- Fixa a semente do random(): os dados saem iguais toda vez que o script é rodado
SELECT setseed(0.42);

-- 300 clientes com nomes, telefones e datas de cadastro gerados
INSERT INTO clientes (nome, email, telefone, data_cadastro)
SELECT
    (ARRAY['Ana','Bruno','Carla','Diego','Eduarda','Felipe','Gabriela','Henrique',
           'Isabela','João','Karen','Lucas','Mariana','Nicolas','Olívia','Pedro',
           'Rafaela','Thiago','Vanessa','Yuri'])[1 + floor(random() * 20)::int]
    || ' ' ||
    (ARRAY['Silva','Santos','Oliveira','Souza','Pereira','Costa','Rodrigues',
           'Almeida','Nascimento','Lima','Araújo','Ribeiro','Carvalho','Gomes',
           'Martins'])[1 + floor(random() * 15)::int],
    CASE WHEN random() < 0.3 THEN NULL
         ELSE 'cliente' || g || '@exemplo.com' END,
    '(21) 9' || lpad(floor(random() * 10000)::int::text, 4, '0')
             || '-' || lpad(floor(random() * 10000)::int::text, 4, '0'),
    NOW() - (120 + random() * 120) * INTERVAL '1 day'
FROM generate_series(1, 300) AS g;

-- 1 endereço por cliente, em um bairro sorteado
WITH b AS (SELECT array_agg(id) AS ids FROM bairros)
INSERT INTO enderecos (cliente_id, bairro_id, logradouro, numero, complemento)  
SELECT
    c.id,
    b.ids[1 + floor(random() * cardinality(b.ids))::int],
    (ARRAY['Rua Barão da Torre','Av. Atlântica','Rua Conde de Bonfim',
           'Rua Dias da Cruz','Av. das Américas','Rua Visconde de Pirajá',
           'Rua Real Grandeza','Av. Brasil','Rua Haddock Lobo',
           'Estrada do Itanhangá'])[1 + floor(random() * 10)::int],
    (1 + floor(random() * 1500))::int::text,
    CASE WHEN random() < 0.5
         THEN 'Apto ' || (100 + floor(random() * 400))::int
         ELSE NULL END
FROM clientes c
CROSS JOIN b;

-- 6 entregadores
INSERT INTO entregadores (nome, telefone, veiculo) VALUES
('Marcelo Tavares',  '(21) 98811-1001', 'moto'),
('Rodrigo Menezes',  '(21) 98811-1002', 'moto'),
('Leandro Batista',  '(21) 98811-1003', 'moto'),
('Fábio Teixeira',   '(21) 98811-1004', 'moto'),
('Camila Duarte',    '(21) 98811-1005', 'bicicleta'),
('Wesley Cardoso',   '(21) 98811-1006', 'moto');



-- =====================================================
-- Pizzaria DB: dados iniciais (parte 4: pedidos, itens, pagamentos e entregas)
-- =====================================================

SELECT setseed(0.42);

-- 1) Pedidos: ~2.000 nos últimos 90 dias (mais movimento nos fins de semana e à noite)
WITH dias AS (
    SELECT CURRENT_DATE - g AS dia,
           (CASE WHEN extract(dow FROM CURRENT_DATE - g) IN (0,5,6) THEN 32 ELSE 16 END
            * (0.7 + random() * 0.6))::int AS qtd
    FROM generate_series(1, 90) AS g
),
cli AS (
    SELECT array_agg(id ORDER BY id) AS ids FROM clientes
),
horas AS (
    SELECT ARRAY[11,12,12,13,13,14,15,17,18,18,19,19,19,20,20,20,20,21,21,21,22,22,23] AS h
),
base AS (
    SELECT d.dia,
           cli.ids[1 + floor(power(random(), 2) * cardinality(cli.ids))::int] AS cliente_id,
           CASE WHEN random() < 0.8 THEN 'entrega' ELSE 'retirada' END AS tipo,
           horas.h[1 + floor(random() * cardinality(horas.h))::int] AS hora,
           floor(random() * 60)::int AS minuto,
           random() AS r
    FROM dias d
    CROSS JOIN LATERAL generate_series(1, d.qtd) AS n
    CROSS JOIN cli
    CROSS JOIN horas
)
INSERT INTO pedidos (cliente_id, endereco_id, tipo, status, taxa_entrega, total, criado_em)
SELECT b.cliente_id,
       CASE WHEN b.tipo = 'entrega' THEN e.id END,
       b.tipo,
       CASE WHEN b.r < 0.04 THEN 'cancelado' ELSE 'entregue' END,
       CASE WHEN b.tipo = 'entrega' THEN bb.taxa_entrega ELSE 0 END,
       0,
       b.dia + make_interval(hours => b.hora, mins => b.minuto)
FROM base b
JOIN enderecos e ON e.cliente_id = b.cliente_id
JOIN bairros bb  ON bb.id = e.bairro_id
ORDER BY b.dia, b.hora, b.minuto;

-- 2) Itens: 1 a 3 itens por pedido (as primeiras variações do cardápio vendem mais)
WITH var AS (
    SELECT array_agg(id ORDER BY id) AS ids FROM variacoes_produto
),
sorteio AS (
    SELECT p.id AS pedido_id,
           var.ids[1 + floor(power(random(), 1.6) * cardinality(var.ids))::int] AS variacao_id,
           CASE WHEN random() < 0.8 THEN 1 ELSE 2 END AS quantidade
    FROM (
        SELECT id,
               CASE WHEN r < 0.45 THEN 1 WHEN r < 0.80 THEN 2 ELSE 3 END AS n
        FROM (SELECT id, random() AS r FROM pedidos) s
    ) p
    CROSS JOIN LATERAL generate_series(1, p.n) AS g
    CROSS JOIN var
)
INSERT INTO itens_pedido (pedido_id, variacao_id, quantidade, preco_unitario)
SELECT s.pedido_id, s.variacao_id, SUM(s.quantidade)::int, vp.preco
FROM sorteio s
JOIN variacoes_produto vp ON vp.id = s.variacao_id
GROUP BY s.pedido_id, s.variacao_id, vp.preco
ORDER BY s.pedido_id;

-- 3) Total do pedido = soma dos itens + taxa de entrega
UPDATE pedidos p
SET total = p.taxa_entrega + s.subtotal
FROM (
    SELECT pedido_id, SUM(quantidade * preco_unitario) AS subtotal
    FROM itens_pedido
    GROUP BY pedido_id
) s
WHERE s.pedido_id = p.id;

-- 4) Pagamentos: um por pedido não cancelado
INSERT INTO pagamentos (pedido_id, forma, valor, status, pago_em)
SELECT p.id,
       CASE WHEN p.r < 0.50 THEN 'pix'
            WHEN p.r < 0.75 THEN 'credito'
            WHEN p.r < 0.90 THEN 'debito'
            ELSE 'dinheiro' END,
       p.total,
       'pago',
       p.criado_em + (1 + floor(random() * 5)) * INTERVAL '1 minute'
FROM (SELECT id, total, criado_em, random() AS r
      FROM pedidos
      WHERE status <> 'cancelado') p;

-- 1) Estoque inicial: o saldo atual vira o ponto de partida, 91 dias atrás
INSERT INTO movimentacoes_estoque (insumo_id, tipo, quantidade, motivo, criado_em)
SELECT id, 'entrada', estoque_atual, 'Estoque inicial', (CURRENT_DATE - 91) + TIME '07:00'
FROM insumos
WHERE estoque_atual > 0;

-- 2) Saídas: consumo de insumos de cada pedido (ficha técnica x quantidade vendida)
INSERT INTO movimentacoes_estoque (insumo_id, pedido_id, tipo, quantidade, motivo, criado_em)
SELECT ft.insumo_id, p.id, 'saida', SUM(ft.quantidade * i.quantidade), 'Venda', p.criado_em
FROM pedidos p
JOIN itens_pedido i   ON i.pedido_id = p.id
JOIN ficha_tecnica ft ON ft.variacao_id = i.variacao_id
WHERE p.status <> 'cancelado'
GROUP BY ft.insumo_id, p.id, p.criado_em;

-- 3) Entradas: compra semanal, cobrindo o consumo da semana + 10% de folga
WITH consumo AS (
    SELECT insumo_id,
           DATE_TRUNC('week', criado_em) AS semana,
           SUM(quantidade)               AS total
    FROM movimentacoes_estoque
    WHERE tipo = 'saida'
    GROUP BY insumo_id, DATE_TRUNC('week', criado_em)
)
INSERT INTO movimentacoes_estoque (insumo_id, tipo, quantidade, motivo, criado_em)
SELECT insumo_id,
       'entrada',
       CEIL(total * 1.10),
       'Compra semanal',
       GREATEST(semana + INTERVAL '8 hours', (CURRENT_DATE - 90) + TIME '08:00')
FROM consumo;

-- 4) Perdas: cerca de 2% do consumo semanal
WITH consumo AS (
    SELECT insumo_id,
           DATE_TRUNC('week', criado_em) AS semana,
           SUM(quantidade)               AS total
    FROM movimentacoes_estoque
    WHERE tipo = 'saida'
    GROUP BY insumo_id, DATE_TRUNC('week', criado_em)
)
INSERT INTO movimentacoes_estoque (insumo_id, tipo, quantidade, motivo, criado_em)
SELECT insumo_id,
       'perda',
       ROUND(total * 0.02, 3),
       'Desperdício / validade',
       LEAST(semana + INTERVAL '6 days 22 hours', NOW())
FROM consumo
WHERE ROUND(total * 0.02, 3) > 0;

-- 5) Saldo atual de cada insumo = soma do livro-razão
UPDATE insumos i
SET estoque_atual = s.saldo
FROM (
    SELECT insumo_id,
           SUM(CASE tipo WHEN 'entrada' THEN quantidade ELSE -quantidade END) AS saldo
    FROM movimentacoes_estoque
    GROUP BY insumo_id
) s
WHERE s.insumo_id = i.id;