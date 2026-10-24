-- =====================================================
-- Pizzaria DB: schema (bloco 1: clientes, cardápio, estoque)
-- =====================================================

-- Região de entrega
CREATE TABLE bairros (
    id            SERIAL PRIMARY KEY,
    nome          VARCHAR(80) NOT NULL UNIQUE,
    zona          VARCHAR(20) NOT NULL
                  CHECK (zona IN ('Sul','Norte','Oeste','Centro')),
    taxa_entrega  NUMERIC(8,2) NOT NULL CHECK (taxa_entrega >= 0)
);

-- Clientes
CREATE TABLE clientes (
    id            SERIAL PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE,
    telefone      VARCHAR(20) NOT NULL,
    data_cadastro TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE enderecos (
    id          SERIAL PRIMARY KEY,
    cliente_id  INT NOT NULL REFERENCES clientes(id),
    bairro_id   INT NOT NULL REFERENCES bairros(id),
    logradouro  VARCHAR(150) NOT NULL,
    numero      VARCHAR(10) NOT NULL,
    complemento VARCHAR(60),
    referencia  VARCHAR(100)
);

-- Cardápio
CREATE TABLE categorias (
    id   SERIAL PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE produtos (
    id           SERIAL PRIMARY KEY,
    categoria_id INT NOT NULL REFERENCES categorias(id),
    nome         VARCHAR(100) NOT NULL,
    descricao    TEXT,
    ativo        BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE variacoes_produto (
    id         SERIAL PRIMARY KEY,
    produto_id INT NOT NULL REFERENCES produtos(id),
    tamanho    VARCHAR(50) NOT NULL,
    preco      NUMERIC(10,2) NOT NULL CHECK (preco >= 0),
    UNIQUE (produto_id, tamanho)
);

-- Estoque
CREATE TABLE insumos (
    id              SERIAL PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL UNIQUE,
    unidade_medida  VARCHAR(10) NOT NULL,
    estoque_atual   NUMERIC(12,3) NOT NULL DEFAULT 0 CHECK (estoque_atual >= 0),
    estoque_minimo  NUMERIC(12,3) NOT NULL DEFAULT 0,
    custo_unitario  NUMERIC(10,4) NOT NULL CHECK (custo_unitario >= 0)
);

CREATE TABLE ficha_tecnica (
    variacao_id INT NOT NULL REFERENCES variacoes_produto(id),
    insumo_id   INT NOT NULL REFERENCES insumos(id),
    quantidade  NUMERIC(12,3) NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (variacao_id, insumo_id)
);

-- =====================================================
-- Bloco 2: entregas, pedidos e movimentação de estoque
-- =====================================================

CREATE TABLE entregadores (
    id       SERIAL PRIMARY KEY,
    nome     VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    veiculo  VARCHAR(10) NOT NULL CHECK (veiculo IN ('moto','bicicleta','carro')),
    ativo    BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE pedidos (
    id           SERIAL PRIMARY KEY,
    cliente_id   INT NOT NULL REFERENCES clientes(id),
    endereco_id  INT REFERENCES enderecos(id),
    tipo         VARCHAR(10) NOT NULL CHECK (tipo IN ('entrega','retirada')),
    status       VARCHAR(15) NOT NULL DEFAULT 'recebido'
                 CHECK (status IN ('recebido','em_preparo','saiu_entrega','entregue','cancelado')),
    taxa_entrega NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (taxa_entrega >= 0),
    total        NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (total >= 0),
    observacao   VARCHAR(200),
    criado_em    TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (tipo = 'retirada' OR endereco_id IS NOT NULL)
);

CREATE TABLE itens_pedido (
    id             SERIAL PRIMARY KEY,
    pedido_id      INT NOT NULL REFERENCES pedidos(id),
    variacao_id    INT NOT NULL REFERENCES variacoes_produto(id),
    quantidade     INT NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
    observacao     VARCHAR(200)
);

CREATE TABLE pagamentos (
    id         SERIAL PRIMARY KEY,
    pedido_id  INT NOT NULL REFERENCES pedidos(id),
    forma      VARCHAR(10) NOT NULL CHECK (forma IN ('pix','credito','debito','dinheiro')),
    valor      NUMERIC(10,2) NOT NULL CHECK (valor > 0),
    status     VARCHAR(10) NOT NULL DEFAULT 'pendente'
               CHECK (status IN ('pendente','pago','recusado')),
    pago_em    TIMESTAMP
);

CREATE TABLE entregas (
    id            SERIAL PRIMARY KEY,
    pedido_id     INT NOT NULL UNIQUE REFERENCES pedidos(id),
    entregador_id INT NOT NULL REFERENCES entregadores(id),
    saiu_em       TIMESTAMP,
    entregue_em   TIMESTAMP,
    CHECK (entregue_em IS NULL OR saiu_em IS NOT NULL),
    CHECK (entregue_em IS NULL OR entregue_em >= saiu_em)
);

CREATE TABLE movimentacoes_estoque (
    id         SERIAL PRIMARY KEY,
    insumo_id  INT NOT NULL REFERENCES insumos(id),
    pedido_id  INT REFERENCES pedidos(id),
    tipo       VARCHAR(10) NOT NULL CHECK (tipo IN ('entrada','saida','perda','ajuste')),
    quantidade NUMERIC(12,3) NOT NULL CHECK (quantidade > 0),
    motivo     VARCHAR(150),
    criado_em  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Índices (o PostgreSQL não cria índice automático nas chaves estrangeiras)
CREATE INDEX idx_pedidos_cliente    ON pedidos(cliente_id);
CREATE INDEX idx_pedidos_criado_em  ON pedidos(criado_em);
CREATE INDEX idx_itens_pedido       ON itens_pedido(pedido_id);
CREATE INDEX idx_itens_variacao     ON itens_pedido(variacao_id);
CREATE INDEX idx_mov_estoque_insumo ON movimentacoes_estoque(insumo_id);