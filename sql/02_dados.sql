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