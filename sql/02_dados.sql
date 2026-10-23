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