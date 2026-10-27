-- =====================================================
-- Pizzaria DB: triggers de estoque
-- =====================================================

-- View de apoio: quanto de cada insumo um pedido consome
-- (itens do pedido x ficha técnica)
CREATE OR REPLACE VIEW vw_consumo_pedido AS
SELECT ip.pedido_id,
       ft.insumo_id,
       SUM(ft.quantidade * ip.quantidade) AS consumo
FROM itens_pedido ip
JOIN ficha_tecnica ft ON ft.variacao_id = ip.variacao_id
GROUP BY ip.pedido_id, ft.insumo_id;

-- 1) Baixa automática: pedido vai para a cozinha (recebido -> em_preparo)
CREATE OR REPLACE FUNCTION fn_baixa_estoque_pedido()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    faltando text;
BEGIN
    -- Confere se todos os insumos têm saldo suficiente
    SELECT string_agg(i.nome, ', ') INTO faltando
    FROM vw_consumo_pedido c
    JOIN insumos i ON i.id = c.insumo_id
    WHERE c.pedido_id = NEW.id
      AND i.estoque_atual < c.consumo;

    IF faltando IS NOT NULL THEN
        RAISE EXCEPTION 'Estoque insuficiente para o pedido %: %', NEW.id, faltando;
    END IF;

    -- Registra a saída de cada insumo no livro-razão
    INSERT INTO movimentacoes_estoque (insumo_id, pedido_id, tipo, quantidade, motivo)
    SELECT insumo_id, NEW.id, 'saida', consumo, 'Venda'
    FROM vw_consumo_pedido
    WHERE pedido_id = NEW.id;

    -- Atualiza o saldo
    UPDATE insumos i
    SET estoque_atual = i.estoque_atual - c.consumo
    FROM vw_consumo_pedido c
    WHERE c.pedido_id = NEW.id
      AND c.insumo_id = i.id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_baixa_estoque
AFTER UPDATE OF status ON pedidos
FOR EACH ROW
WHEN (OLD.status = 'recebido' AND NEW.status = 'em_preparo')
EXECUTE FUNCTION fn_baixa_estoque_pedido();

-- 2) Estorno: pedido cancelado depois de já ter consumido insumos
CREATE OR REPLACE FUNCTION fn_estorno_estoque_pedido()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO movimentacoes_estoque (insumo_id, pedido_id, tipo, quantidade, motivo)
    SELECT insumo_id, NEW.id, 'entrada', consumo, 'Estorno de pedido cancelado'
    FROM vw_consumo_pedido
    WHERE pedido_id = NEW.id;

    UPDATE insumos i
    SET estoque_atual = i.estoque_atual + c.consumo
    FROM vw_consumo_pedido c
    WHERE c.pedido_id = NEW.id
      AND c.insumo_id = i.id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_estorno_estoque
AFTER UPDATE OF status ON pedidos
FOR EACH ROW
WHEN (NEW.status = 'cancelado' AND OLD.status IN ('em_preparo', 'saiu_entrega'))
EXECUTE FUNCTION fn_estorno_estoque_pedido();