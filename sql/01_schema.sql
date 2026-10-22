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