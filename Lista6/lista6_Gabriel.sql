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

-- 2.1. Crie uma stored procedure que receba como parâmetro de entrada três parâmetros
-- a matrícula do empregado, o ano e o mês. Este procedimento deve inserir uma tupla
-- no banco de horas referente ao empregado e período em questão.

CREATE OR REPLACE FUNCTION lista06.questao21(
	v_matricula INTEGER,
	v_ano INTEGER,
	v_mes INTEGER
)
returns VOID
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO lista06.banco_horas(
		ban_ano,
		ban_mes,
		emp_matricula,
		ban_total_horas
	) VALUES (v_ano,v_mes,v_matricula,0);
END;
$$;

select * from lista06.empregado
select * from lista06.banco_horas
select * from lista06.questao21(1,24,12)
-- 2.2. Crie uma stored procedure que receba como parâmetro de entrada dois parâmetros
-- o ano e o mês. Este procedimento deve inserir uma tupla no banco de horas para
-- todos os empregados referente período em questão.

CREATE OR REPLACE FUNCTION lista06.questao22(
	v_ano INTEGER,
	v_mes INTEGER
)
returns VOID
LANGUAGE plpgsql
AS $$
DECLARE
	cursor_emp CURSOR FOR 
		SELECT emp_matricula FROM lista06.empregado;
	v_matricula lista06.empregado.emp_matricula%TYPE;
BEGIN
	OPEN cursor_emp;
	LOOP
		FETCH cursor_emp INTO v_matricula;
		EXIT WHEN NOT FOUND;
		PERFORM lista06.questao21(v_matricula,v_ano,v_mes);
	END LOOP;
	CLOSE cursor_emp;
END;
$$;

select * from lista06.empregado
select * from lista06.banco_horas
select * from lista06.questao22(25,12)

-- 2.3. Crie uma stored procedure que receba como parâmetro de entrada dois parâmetros
-- o ano e o mês. Este procedimento deve retornar a matrícula do empregado com
-- maior número de horas no banco de horas.

CREATE OR REPLACE FUNCTION lista06.questao23(
	v_ano INTEGER,
	v_mes INTEGER
)
returns INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
	v_matricula INTEGER;
BEGIN
	SELECT emp_matricula INTO v_matricula 
	FROM lista06.banco_horas
	WHERE ban_ano = v_ano AND ban_mes = v_mes
	AND ban_total_horas >= ALL (
		SELECT ban_total_horas FROM lista06.banco_horas
		WHERE ban_ano = v_ano AND ban_mes = v_mes
	);
	return v_matricula;
END;
$$;

select * from lista06.questao23(25,12)

-- 2.4. Crie uma stored procedure que receba como parâmetro de entrada quatro
-- parâmetros a matrícula do empregado, o ano, o mês e o último dia do mês. Este
-- procedimento deve inserir um conjunto de tuplas na relação freqüência referentes
-- ao empregado e período em questão.

CREATE OR REPLACE FUNCTION lista06.questao24(
	v_ano INTEGER,
	v_mes INTEGER,
	v_dia INTEGER,
	v_matricula INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
	v_date DATE;
BEGIN
	v_date := make_date(v_ano, v_mes, v_dia);
	INSERT INTO lista06.frequencia (
		emp_matricula,
		freq_data,
		freq_hora_entrada,
		freq_hora_saida,
		freq_horas_excedentes,
		freq_horas_noturnas
	) VALUES (
		v_matricula,
		v_date,
		'8:00',
		'18:00',
		0.00,
		0.00
	);
END;
$$;

SELECT * FROM lista06.questao24(2025,12,02,1);
SELECT * FROM lista06.frequencia

-- 2.5. Crie uma stored procedure que receba como parâmetro de entrada três parâmetros
-- a matrícula do empregado, o ano e o mês. Este procedimento deve atualizar o valor
-- do banco de horas neste mês para o empregado em questão.

CREATE OR REPLACE FUNCTION lista06.questao25(
	v_matricula INTEGER,
	v_ano INTEGER,
	v_mes INTEGER,
	v_total_horas NUMERIC
)
returns VOID
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE lista06.banco_horas
	SET ban_total_horas = v_total_horas
	WHERE emp_matricula = v_matricula AND
	ban_ano = v_ano AND
	ban_mes = v_mes;
END;
$$;

select * from lista06.empregado
select * from lista06.banco_horas
SELECT * FROM lista06.questao25(1,25,12,15)


-- 2.6. Crie uma stored procedure que receba como parâmetro de entrada dois parâmetros
-- (smallint) o ano e o mês. Este procedimento deve atualizar o valor do banco de
-- horas neste mês para todos os funcionários.

CREATE OR REPLACE FUNCTION lista06.questao26(
	v_ano INTEGER,
	v_mes INTEGER
)
returns VOID
LANGUAGE plpgsql
AS $$
DECLARE
	cursor_emp CURSOR FOR 
		SELECT emp_matricula FROM lista06.empregado;
	v_matricula lista06.empregado.emp_matricula%TYPE;
BEGIN
	OPEN cursor_emp;
	LOOP
		FETCH cursor_emp INTO v_matricula;
		EXIT WHEN NOT FOUND;
		PERFORM lista06.questao25(v_matricula,v_ano,v_mes,10);
	END LOOP;
	CLOSE cursor_emp;
END;
$$;

select * from lista06.empregado
select * from lista06.banco_horas
select * from lista06.questao26(25,12)

-- 2.7. Crie um trigger sobre a relação período com a seguinte finalidade: Quando um
-- período for inserido deve-se inserir também, para todos os empregados, na relação
-- freqüência, uma tupla para cada dia no período em questão. Além disso, deve-se
-- inserir também uma tupla para cada empregado no banco de horas.

CREATE OR REPLACE FUNCTION lista06.questao27()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	cursor_emp CURSOR FOR 
		SELECT emp_matricula FROM lista06.empregado;
	v_matricula lista06.empregado.emp_matricula%TYPE; 
BEGIN
	OPEN cursor_emp;
	LOOP
		FETCH cursor_emp INTO v_matricula;
		EXIT WHEN NOT FOUND;
		FOR i IN 1..30 LOOP
			INSERT INTO lista06.frequencia (
				emp_matricula,
				freq_data,
				freq_hora_entrada,
				freq_hora_saida,
				freq_horas_excedentes,
				freq_horas_noturnas
			) VALUES (
				v_matricula,
				make_date(NEW.per_ano, NEW.per_mes, i),
				'08:00',
				'18:00',
				0,     
				0     
			);

		END LOOP;
		INSERT INTO lista06.banco_horas (
			ban_ano,
			ban_mes,
			emp_matricula,
			ban_total_horas
		) VALUES (
			NEW.per_ano,
			NEW.per_mes,
			v_matricula,
			0
		);		
	END LOOP;
	CLOSE cursor_emp;
	RETURN NEW;
END;
$$;

CREATE TRIGGER tr_periodo
AFTER INSERT ON lista06.periodo
FOR EACH ROW 
EXECUTE PROCEDURE lista06.questao27();

INSERT INTO lista06.periodo (per_ano, per_mes)
VALUES (2025, 6);

SELECT * FROM lista06.frequencia
SELECT * FROM lista06.banco_horas
SELECT * FROM lista06.periodo

DELETE FROM lista06.frequencia
DELETE FROM lista06.banco_horas
DELETE FROM lista06.periodo

-- 2.8. Crie um trigger sobre a tabela freqüência com o objetivo de atualizar o banco de
-- horas sempre a freqüência for atualizada.

CREATE OR REPLACE FUNCTION lista06.questao28()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	v_ano INTEGER;
	v_mes INTEGER;
BEGIN
	v_ano := EXTRACT(YEAR FROM freq_data);
	v_mes := EXTRACT(MONTH FROM freq_data);
	
	UPDATE lista06.banco_horas
	SET ban_total_horas = (
		SELECT COALESCE (SUM(freq_horas_excedentes),0)
		FROM lista06.frequencia
		WHERE emp_matricula = NEW.emp_matricula
          AND EXTRACT(YEAR FROM freq_data) = v_ano
          AND EXTRACT(MONTH FROM freq_data) = v_mes
	)	
	WHERE emp_matricula = NEW.emp_matricula
	  AND ban_ano = v_ano
	  AND ban_mes = v_mes;

	
	RETURN NEW;
END;
$$;

CREATE TRIGGER tr_update_frequencia
AFTER UPDATE ON lista06.frequencia
FOR EACH ROW 
EXECUTE PROCEDURE lista06.questao28();

-- 2.9. Crie um trigger para que ao se excluir um período sejam excluídas também todas
-- as freqüências referentes a este período. Deve-se excluir também todas as tuplas no
-- banco de horas referentes a este período.

CREATE OR REPLACE FUNCTION lista06.questao29()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM lista06.frequencia
	WHERE EXTRACT(YEAR FROM freq_data) = OLD.per_ano
      AND EXTRACT(MONTH FROM freq_data) = OLD.per_mes;
	
	DELETE FROM lista06.banco_horas
	WHERE OLD.per_ano=ban_ano 
		AND OLD.per_mes=ban_mes;
	
	RETURN OLD;
END;
$$;

CREATE TRIGGER tr_delete_periodo
BEFORE DELETE ON lista06.periodo
FOR EACH ROW 
EXECUTE PROCEDURE lista06.questao29();

-- 2.10. Crie um trigger para manter a seguinte regra de negócio. Cada empregado
-- que trabalha em um dia feriado deve receber seis horas no banco de horas. Além
-- disso, cada hora extra em um feriado vale o dobro no banco de horas. Considere a
-- inserção e a remoção de um feriado.



