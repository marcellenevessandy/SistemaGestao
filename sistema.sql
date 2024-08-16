-- Criando bancos e tabelas

CREATE DATABASE GestaoDespesas;

USE GestaoDespesas;

CREATE TABLE Usuarios (
    IdUsuario INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Nome VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Senha VARCHAR(8) NOT NULL
);

CREATE TABLE Categoria (
    IdCategoria INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    NomeCategoria VARCHAR(100) NOT NULL,
    DescricaoCategoria VARCHAR(100) DEFAULT NULL,
    Tipo VARCHAR(45) NOT NULL
);

CREATE TABLE ContasBancarias (
    IdContasBancarias INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    NomeBanco VARCHAR(45) NOT NULL,
    AgenciaConta VARCHAR(20) NOT NULL UNIQUE,
    NumeroConta VARCHAR(20) NOT NULL UNIQUE,
    Usuarios_IdUsuario INT NOT NULL,
    CONSTRAINT fk_ContasBancarias_Usuarios
        FOREIGN KEY (Usuarios_IdUsuario)
        REFERENCES Usuarios(IdUsuario)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);


CREATE TABLE Metas (
    IdMetas INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    DescricaoMeta VARCHAR(100) DEFAULT NULL,
    Tipo VARCHAR(45) NOT NULL,
    ValorAtual DECIMAL(10,2) NOT NULL,
    ValorMeta DECIMAL(10,2) NOT NULL,
    Status VARCHAR(45) NOT NULL,
    DataFinal DATE NOT NULL,
    Categoria_IdCategoria INT NOT NULL,
    CONSTRAINT fk_Metas_Categoria
        FOREIGN KEY (Categoria_IdCategoria)
        REFERENCES Categoria(IdCategoria)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

CREATE TABLE Movimentacoes (
    IdMovimentacoes INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    DescricaoMovimentacoes VARCHAR(100) DEFAULT NULL,
    Tipo VARCHAR(45) NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    DataMovimentacao DATE NOT NULL,
    ContasBancarias_IdContasBancarias INT NOT NULL,
    Categoria_IdCategoria INT NOT NULL,
    CONSTRAINT fk_Movimentacoes_ContasBancarias
        FOREIGN KEY (ContasBancarias_IdContasBancarias)
        REFERENCES ContasBancarias(IdContasBancarias)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Movimentacoes_Categoria
        FOREIGN KEY (Categoria_IdCategoria)
        REFERENCES Categoria(IdCategoria)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

-- Inserindo dados nas tabelas

INSERT INTO Usuarios (Nome, Email, Senha) VALUES
('João Silva', 'joao.silva@example.com', 'senha123'),
('Maria Oliveira', 'maria.oliveira@example.com', 'senha456'),
('Pedro Santos', 'pedro.santos@example.com', 'senha789');

INSERT INTO Categoria (NomeCategoria, DescricaoCategoria, Tipo) VALUES
('Alimentação', 'Despesas com alimentação', 'Despesa'),
('Salário', 'Receitas provenientes de salários', 'Receita'),
('Saúde', 'Despesas com saúde e bem-estar', 'Despesa');

INSERT INTO ContasBancarias (NomeBanco, AgenciaConta, NumeroConta, Usuarios_IdUsuario) VALUES
('Banco do Brasil', '1234', '567890123', 1),
('Caixa Econômica Federal', '4321', '987654321', 2),
('Santander', '6789', '456789123', 3);

INSERT INTO Metas (DescricaoMeta, Tipo, ValorAtual, ValorMeta, Status, DataFinal, Categoria_IdCategoria) VALUES
('Economizar para viagem', 'Poupança', 500.00, 2000.00, 'Em progresso', '2024-12-31', 1),
('Comprar novo computador', 'Poupança', 300.00, 1500.00, 'Em progresso', '2024-10-31', 1),
('Alcançar meta de vendas', 'Objetivo', 20000.00, 20000.00, 'Concluído', '2024-08-31', 2);

INSERT INTO Movimentacoes (DescricaoMovimentacoes, Tipo, Valor, ContasBancarias_IdContasBancarias, Categoria_IdCategoria, DataMovimentacao)
VALUES 
    ('Salário', 'Receita', 3000.00, 2, 2, '2024-08-15'),
    ('Compra de supermercado', 'Despesa', 150.75, 1, 1, '2024-08-16'),
    ('Conta de luz', 'Despesa', 85.00, 3, 2, '2024-08-17');


-- Criando selects simples

SELECT * FROM Usuarios;
SELECT * FROM Categoria;
SELECT * FROM ContasBancarias;
SELECT * FROM Metas;
SELECT * FROM Movimentacoes;

-- Total Gasto por Categoria

SELECT 
    c.NomeCategoria,
    SUM(m.Valor) AS TotalGasto
FROM 
    Movimentacoes m
JOIN 
    Categoria c ON m.Categoria_IdCategoria = c.IdCategoria
WHERE 
    m.Tipo = 'Despesa'
GROUP BY 
    c.NomeCategoria
ORDER BY 
    TotalGasto DESC;

-- Total de Receitas por Conta

SELECT 
    cb.NomeBanco,
    cb.AgenciaConta,
    cb.NumeroConta,
    COALESCE(SUM(m.Valor), 0) AS TotalReceita
FROM 
    ContasBancarias cb
LEFT JOIN 
    Movimentacoes m ON m.ContasBancarias_IdContasBancarias = cb.IdContasBancarias
    AND m.Tipo = 'Receita'
GROUP BY 
    cb.NomeBanco,
    cb.AgenciaConta,
    cb.NumeroConta
ORDER BY 
    TotalReceita DESC;

-- Balanço mensal

SELECT 
    DATE_FORMAT(m.DataMovimentacao, '%Y-%m') AS MesAno,
    SUM(CASE WHEN m.Tipo = 'Receita' THEN m.Valor ELSE 0 END) AS TotalReceita,
    SUM(CASE WHEN m.Tipo = 'Despesa' THEN m.Valor ELSE 0 END) AS TotalDespesa,
    SUM(CASE WHEN m.Tipo = 'Receita' THEN m.Valor ELSE 0 END) - 
    SUM(CASE WHEN m.Tipo = 'Despesa' THEN m.Valor ELSE 0 END) AS BalançoMensal
FROM 
    Movimentacoes m
GROUP BY 
    DATE_FORMAT(m.DataMovimentacao, '%Y-%m')
ORDER BY 
    MesAno DESC
LIMIT 1000;

-- Progresso Metas

SELECT 
    m.DescricaoMeta,
    m.Tipo AS TipoMeta,
    m.ValorAtual,
    m.ValorMeta,
    (m.ValorMeta - m.ValorAtual) AS FaltaParaConcluir,
    c.NomeCategoria
FROM 
    Metas m
JOIN 
    Categoria c ON m.Categoria_IdCategoria = c.IdCategoria
WHERE 
    m.ValorAtual < m.ValorMeta
ORDER BY 
    FaltaParaConcluir DESC;