CREATE TABLE eempresa.Empregado(
	enome varchar(50) NOT NULL,
	cpf VARCHAR(11) PRIMARY KEY,
	endereco VARCHAR(30),
	nasc DATE,
	sexo CHAR(1),
	salario NUMERIC(10,2) NOT NULL,
	chefe VARCHAR(11),
	cdep INT
);

ALTER TABLE eempresa.Empregado
ADD CONSTRAINT fk_empregado_chefe
FOREIGN KEY (chefe) REFERENCES eempresa.Empregado(cpf);

CREATE TABLE eempresa.Departamento(
	dnome varchar(50) NOT NULL,
	codigo INT PRIMARY KEY,
	gerente VARCHAR(11),
	FOREIGN KEY (gerente) REFERENCES eempresa.Empregado(cpf)
);

-- Inserção dos empregados
INSERT INTO eempresa.Empregado (enome, cpf, endereco, nasc, sexo, salario, chefe, cdep) VALUES
('Chiquin', '1234', 'rua 1, 1', '1962-02-02', 'M', 10000.00, '8765', 3),
('Helenita', '4321', 'rua 2, 2', '1963-03-03', 'F', 12000.00, '6543', 2),
('Pedrin',   '5678', 'rua 3, 3', '1964-04-04', 'M',  9000.00, '6543', 2),
('Valtin',   '8765', 'rua 4, 4', '1965-05-05', 'M', 15000.00, NULL,   4),
('Zulmira',  '3456', 'rua 5, 5', '1966-06-06', 'F', 12000.00, '8765', 3),
('Zefinha',  '6543', 'rua 6, 6', '1967-07-07', 'F', 10000.00, '8765', 2);

-- Inserção dos departamentos (primeiro, pois empregados referenciam eles)
INSERT INTO eempresa.Departamento (dnome, codigo, gerente) VALUES
('Pesquisa', 3, '1234'),
('Marketing', 2, '6543'),
('Administração', 4, '8765');

ALTER TABLE eempresa.Empregado
ADD CONSTRAINT fk_empregado_cdep
FOREIGN KEY (cdep) REFERENCES eempresa.Departamento(codigo);

CREATE TABLE eempresa.Projeto(
	pnome varchar(50) NOT NULL,
	pcodigo varchar(10) PRIMARY KEY,
	cidade VARCHAR(50),
    cdep INT,
    FOREIGN KEY (cdep) REFERENCES eempresa.Departamento(codigo)
);

CREATE TABLE eempresa.Tarefa (
    cpf VARCHAR(11),
    pcodigo VARCHAR(10),
    horas NUMERIC(5,1),
    PRIMARY KEY (cpf, pcodigo),
    FOREIGN KEY (cpf) REFERENCES eempresa.Empregado(cpf),
    FOREIGN KEY (pcodigo) REFERENCES eempresa.Projeto(pcodigo)
);

CREATE TABLE eempresa.DUnidade(
	dcodigo INT,
	dcidade VARCHAR(50),
	PRIMARY KEY (dcidade, dcodigo),
    FOREIGN KEY (dcodigo) REFERENCES eempresa.Departamento(codigo)
);

-- Projetos
INSERT INTO eempresa.Projeto (pnome, pcodigo, cidade, cdep) VALUES
('ProdutoA', 'PA', 'Cumbuco', 3),
('ProdutoB', 'PB', 'Icapuí', 3),
('Informatização', 'Inf', 'Fortaleza', 4),
('Divulgação', 'Div', 'Morro Branco', 2);

-- Tarefas dos empregados em projetos
INSERT INTO eempresa.Tarefa (cpf, pcodigo, horas) VALUES
('1234', 'PA', 30.0),
('1234', 'PB', 10.0),
('4321', 'PA', 5.0),
('4321', 'Div', 35.0),
('5678', 'Div', 40.0),
('8765', 'Inf', 32.0),
('8765', 'Div', 8.0),
('3456', 'PA', 10.0),
('3456', 'PB', 25.0),
('3456', 'Div', 5.0),
('6543', 'PB', 40.0);

-- Unidades dos departamentos
INSERT INTO eempresa.DUnidade (dcodigo, dcidade) VALUES
(2, 'Morro Branco'),
(3, 'Cumbuco'),
(3, 'Prainha'),
(3, 'Taíba'),
(3, 'Icapuí'),
(4, 'Fortaleza');

