
CREATE DATABASE lanchonete_db;

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco NUMERIC(10,2) NOT NULL CHECK (preco > 0),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_produtos_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('recebido', 'em_preparo', 'pronto', 'entregue', 'cancelado')),
    tipo_entrega VARCHAR(20) NOT NULL CHECK (tipo_entrega IN ('retirada', 'entrega_local')),
    observacoes TEXT,
    valor_total NUMERIC(10,2) DEFAULT 0 CHECK (valor_total >= 0),
    CONSTRAINT fk_pedidos_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE itens_pedido (
    id_item_pedido SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
    subtotal NUMERIC(10,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    CONSTRAINT fk_itens_pedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_itens_pedido_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL UNIQUE,
    forma_pagamento VARCHAR(20) NOT NULL CHECK (forma_pagamento IN ('dinheiro', 'cartao', 'pix')),
    status_pagamento VARCHAR(20) NOT NULL CHECK (status_pagamento IN ('pendente', 'pago', 'cancelado')),
    data_pagamento TIMESTAMP,
    valor_pago NUMERIC(10,2) NOT NULL CHECK (valor_pago >= 0),
    CONSTRAINT fk_pagamentos_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Dados de exemplo para teste

INSERT INTO clientes (nome, telefone, email) VALUES
('João Silva', '21999990001', 'joao@email.com'),
('Maria Souza', '21999990002', 'maria@email.com'),
('Carlos Lima', '21999990003', 'carlos@email.com');

INSERT INTO categorias (nome) VALUES
('Lanches'),
('Bebidas'),
('Sobremesas');

INSERT INTO produtos (id_categoria, nome, descricao, preco) VALUES
(1, 'X-Burguer', 'Pão, carne, queijo e molho especial', 18.00),
(1, 'X-Salada', 'Pão, carne, queijo, alface e tomate', 20.00),
(2, 'Refrigerante Lata', '350ml', 6.00),
(2, 'Suco Natural', 'Copo 300ml', 8.00),
(3, 'Pudim', 'Fatia de pudim caseiro', 10.00);

INSERT INTO pedidos (id_cliente, status, tipo_entrega, observacoes, valor_total) VALUES
(1, 'recebido', 'retirada', 'Sem cebola', 24.00),
(2, 'em_preparo', 'entrega_local', 'Adicionar ketchup', 28.00),
(3, 'entregue', 'retirada', NULL, 30.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 18.00),
(1, 3, 1, 6.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(2, 2, 1, 20.00),
(2, 4, 1, 8.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(3, 1, 1, 18.00),
(3, 3, 2, 6.00);

INSERT INTO pagamentos (id_pedido, forma_pagamento, status_pagamento, data_pagamento, valor_pago) VALUES
(1, 'pix', 'pago', CURRENT_TIMESTAMP, 24.00),
(2, 'cartao', 'pendente', NULL, 28.00),
(3, 'dinheiro', 'pago', CURRENT_TIMESTAMP, 30.00);

-- Consultas dos dados de exemplos

SELECT 
    p.id_pedido,
    c.nome AS cliente,
    p.data_pedido,
    p.status,
    p.tipo_entrega,
    p.valor_total
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
ORDER BY p.data_pedido DESC;

SELECT
    ip.id_pedido,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.subtotal
FROM itens_pedido ip
JOIN produtos pr ON ip.id_produto = pr.id_produto
WHERE ip.id_pedido = 1;

SELECT
    p.id_pedido,
    c.nome AS cliente,
    p.status,
    pg.forma_pagamento,
    pg.status_pagamento,
    pg.valor_pago
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
LEFT JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
ORDER BY p.id_pedido;

SELECT
    c.nome,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.nome
ORDER BY total_pedidos DESC;

SELECT
    pr.nome AS produto,
    SUM(ip.quantidade) AS total_vendido
FROM itens_pedido ip
JOIN produtos pr ON ip.id_produto = pr.id_produto
GROUP BY pr.nome
ORDER BY total_vendido DESC;

SELECT
    SUM(valor_pago) AS faturamento_total
FROM pagamentos
WHERE status_pagamento = 'pago';

SELECT
    p.id_pedido,
    c.nome AS cliente,
    p.status,
    p.data_pedido
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.status IN ('recebido', 'em_preparo', 'pronto')
ORDER BY p.data_pedido;

SELECT
    cat.nome AS categoria,
    pr.nome AS produto,
    pr.preco
FROM produtos pr
JOIN categorias cat ON pr.id_categoria = cat.id_categoria
ORDER BY cat.nome, pr.nome;

