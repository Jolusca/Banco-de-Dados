CREATE SCHEMA IF NOT EXISTS lista06;
CREATE TABLE lista06.empregado (
    emp_matricula   INT PRIMARY KEY,
    emp_nome        VARCHAR(50),
    emp_sexo        CHAR(1)
);

CREATE TABLE lista06.periodo (
    per_ano INT,
    per_mes INT,
    PRIMARY KEY (per_ano, per_mes)
);

CREATE TABLE lista06.banco_horas (
    ban_ano INT,
    ban_mes INT,
    emp_matricula INT,
    ban_total_horas REAL DEFAULT 0,
    PRIMARY KEY (ban_ano, ban_mes, emp_matricula),
    FOREIGN KEY (emp_matricula) REFERENCES lista06.empregado(emp_matricula)
);

CREATE TABLE lista06.frequencia (
    emp_matricula INT,
    freq_data DATE,
    freq_hora_entrada VARCHAR(5),
    freq_hora_saida VARCHAR(5),
    freq_horas_excedentes REAL DEFAULT 0,
    freq_horas_noturnas REAL DEFAULT 0,
    PRIMARY KEY (emp_matricula, freq_data),
    FOREIGN KEY (emp_matricula) REFERENCES lista06.empregado(emp_matricula)
);

CREATE TABLE lista06.feriado (
    fer_data DATE PRIMARY KEY,
    fer_descricao VARCHAR(60)
);

INSERT INTO lista06.empregado VALUES
(1, 'Ana Silva', 'F'),
(2, 'Carlos Pereira', 'M'),
(3, 'Marcos Dias', 'M');

INSERT INTO lista06.periodo VALUES
(2025, 1),
(2025, 2);

INSERT INTO lista06.feriado VALUES
('2025-01-01', 'Confraternização Universal'),
('2025-02-25', 'Carnaval');


select * from lista06.banco_horas

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- 2.1. Crie uma stored procedure que receba como parâmetro de entrada três parâmetros
-- a matrícula do empregado, o ano e o mês. Este procedimento deve inserir uma tupla
-- no banco de horas referente ao empregado e período em questão.

CREATE OR REPLACE FUNCTION lista06.q_21(
    p_matr INTEGER,
    p_ano INT,
    p_mes INT
)
RETURNS void
LANGUAGE plpgsql
AS
$body$
BEGIN
    INSERT INTO lista06.banco_horas
    VALUES (p_ano, p_mes, p_matr, 0);

    RETURN;
END;
$body$;

SELECT lista06.q_21(1, 2025, 1);


-- 2.2. Crie uma stored procedure que receba como parâmetro de entrada dois parâmetros
-- o ano e o mês. Este procedimento deve inserir uma tupla no banco de horas para
-- todos os empregados referente período em questão.
CREATE OR REPLACE FUNCTION lista06.q_22(
    p_ano INT,
    p_mes INT
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    c CURSOR FOR 
        SELECT emp_matricula 
        FROM lista06.empregado;

    v_matr INT;
BEGIN
    OPEN c;

    LOOP
        FETCH c INTO v_matr;
        EXIT WHEN NOT FOUND;

        INSERT INTO lista06.banco_horas (ban_ano, ban_mes, emp_matricula, ban_total_horas)
        VALUES (p_ano, p_mes, v_matr, 0);

    END LOOP;
    CLOSE c;
    RETURN;
END;
$$;

SELECT lista06.q_22(2025, 2);

SELECT *
FROM lista06.banco_horas
ORDER BY emp_matricula;



-- 2.3. Crie uma stored procedure que receba como parâmetro de entrada dois parâmetros
-- o ano e o mês. Este procedimento deve retornar a matrícula do empregado com
-- maior número de horas no banco de horas.


-- 2.4. Crie uma stored procedure que receba como parâmetro de entrada quatro
-- parâmetros a matrícula do empregado, o ano, o mês e o último dia do mês. Este
-- procedimento deve inserir um conjunto de tuplas na relação freqüência referentes
-- ao empregado e período em questão.


-- 2.5. Crie uma stored procedure que receba como parâmetro de entrada três parâmetros
-- a matrícula do empregado, o ano e o mês. Este procedimento deve atualizar o valor
-- do banco de horas neste mês para o empregado em questão.


-- 2.6. Crie uma stored procedure que receba como parâmetro de entrada dois parâmetros
-- (smallint) o ano e o mês. Este procedimento deve atualizar o valor do banco de
-- horas neste mês para todos os funcionários.


-- 2.7. Crie um trigger sobre a relação período com a seguinte finalidade: Quando um
-- período for inserido deve-se inserir também, para todos os empregados, na relação
-- freqüência, uma tupla para cada dia no período em questão. Além disso, deve-se
-- inserir também uma tupla para cada empregado no banco de horas.


-- 2.8. Crie um trigger sobre a tabela freqüência com o objetivo de atualizar o banco de
-- horas sempre a freqüência for atualizada.


-- 2.9. Crie um trigger para que ao se excluir um período sejam excluídas também todas
-- as freqüências referentes a este período. Deve-se excluir também todas as tuplas no
-- banco de horas referentes a este período.


-- 2.10. Crie um trigger para manter a seguinte regra de negócio. Cada empregado
-- que trabalha em um dia feriado deve receber seis horas no banco de horas. Além
-- disso, cada hora extra em um feriado vale o dobro no banco de horas. Considere a
-- inserção e a remoção de um feriado.
