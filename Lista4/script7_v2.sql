SCRIPT AULA 7

-- Trabalhando com Visões

-- Limpando o Esquema
DROP VIEW eempresa.v1
DROP VIEW eempresa.v2
DROP VIEW eempresa.v3
DROP MATERIALIZED VIEW eempresa.mv_emp_fem
DROP TABLE eempresa.tab_emp_fem
DELETE FROM eempresa.empregado WHERE enome='Gal'
UPDATE eempresa.empregado SET salario = 11000 WHERE enome = 'Pedrin'

SELECT * FROM eempresa.empregado

-- Criando a Visão v1

create view eempresa.v1 (nome_departamento, nome_empregado)
as
select d.dnome, e.enome
from eempresa.departamento d inner join eempresa.empregado e 
on d.codigo = e.cdep

-- Usando a Visão 1

EXPLAIN
select * 
from eempresa.v1

EXPLAIN
SELECT *
FROM (	
		select d.dnome as nome_departamento, e.enome as nome_empregado
		from eempresa.departamento d inner join eempresa.empregado e 
		on d.codigo = e.cdep
	 ) as tab

select nome_empregado
from eempresa.v1

select enome
from eempresa.v1

select nome_empregado
from eempresa.v1
where nome_departamento = 'Marketing'


-- Usando o Mesmo Comando da Visão 1

EXPLAIN
select * 
from eempresa.v1

EXPLAIN
select *
from (
        select d.dnome as nome_departamento, e.enome as nome_empregado
        from eempresa.departamento d inner join eempresa.empregado e 
        on d.codigo = e.cdep
      ) as tab

-- Usando a Visão 1

select nome_empregado
from eempresa.v1
where nome_departamento = 'Marketing'


-- Criando a Visão 2
DROP TABLE eempresa.dependente

CREATE TABLE eempresa.dependente
(
    cpf_responsavel character varying(13) NOT NULL,
    nome character varying(50) NOT NULL,
    data_nasc date,
    CONSTRAINT dependente_pkey PRIMARY KEY (cpf_responsavel, nome),
    CONSTRAINT fk_dependente_empregado FOREIGN KEY (cpf_responsavel)
        REFERENCES eempresa.empregado (cpf) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

INSERT INTO eempresa.dependente VALUES('1234','Chiquin Jr','11/19/2018');
INSERT INTO eempresa.dependente VALUES('1234','Chiquinha','11/19/2018');
INSERT INTO eempresa.dependente VALUES('4321','Helenita Maria','11/19/2018');

SELECT * FROM eempresa.empregado
SELECT * FROM eempresa.dependente
									   

create view eempresa.v2 (nome_empregado, numero_de_dependentes)
as
select e.enome, (select count(*) from eempresa.dependente d where d.cpf_responsavel = e.cpf)
from eempresa.empregado e

-- Usando a Visão 2
select * 
from eempresa.v2

select *
from eempresa.v2
where numero_de_dependentes > 0

select nome_empregado
from eempresa.v2
where numero_de_dependentes >= ALL (
										select numero_de_dependentes
										from eempresa.v2
									)

-- Criando a Visão 3

SELECT *
FROM eempresa.empregado

create view eempresa.v3 (nome_empregado, salario)
as
select enome, salario
from eempresa.empregado e
where salario < 15000 with check option


SELECT * FROM eempresa.empregado where salario < 15000

-- Usando a Visão 3

select * 
from eempresa.v3

select *
from eempresa.v3
where salario > 10000

select *
from (
	select enome, salario
	from eempresa.empregado e
	where salario < 15000
	) as tab
where salario >10000

create view eempresa.v4 (nome_empregado, salario)
as
select *
from eempresa.v3
where salario > 10000

select *
from eempresa.v4

-- Atualizando a Visão 3

select *
from eempresa.v3

SELECT * 
FROM eempresa.empregado

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Pedrin'

-- Tradução Automática

update eempresa.empregado
set salario = salario + 3000
where enome = 'Pedrin'

SELECT * 
FROM eempresa.empregado

select *
from eempresa.v3

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Zefinha'

select * from eempresa.v3

select * from eempresa.empregado

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Zefinha'

update eempresa.empregado
set salario = salario + 3000
where enome = 'Zefinha'

select * from eempresa.v3

select * from eempresa.empregado

drop view eempresa.v4
drop view eempresa.v3

update eempresa.empregado
set salario = salario - 6000
where enome = 'Zefinha'

update eempresa.empregado
set salario = salario - 3000
where enome = 'Pedrin'

create view eempresa.v3 (nome_empregado, salario)
as
select enome, salario
from eempresa.empregado e
where salario < 15000

select *
from eempresa.v3

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Zefinha'

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Zefinha'

select * 
from eempresa.empregado

select *
from eempresa.v3

INSERT INTO eempresa.v3 VALUES ('Júlio', 10000)

-- Tradução
INSERT INTO eempresa.empregado VALUES ('Júlio', 10000)

drop view eempresa.v3

create view eempresa.v3 (nome_empregado, salario)
as
select enome, salario
from eempresa.empregado e
where salario < 15000 with check option

select *
from eempresa.v3

select enome, salario
from eempresa.empregado

update eempresa.v3
set salario = 16000
where nome_empregado = 'Zefinha'

UPDATE eempresa.empregado 
SET salario = 16000 
WHERE enome = 'Zefinha'


select * 
from eempresa.empregado

select *
from eempresa.v3

UPDATE eempresa.empregado 
SET salario = 10000 
WHERE enome = 'Zefinha'

UPDATE eempresa.empregado SET salario = 12000 
WHERE enome = 'Henrique Vieira'

UPDATE eempresa.empregado SET salario = 9000 
WHERE enome = 'Berlofa'

UPDATE eempresa.empregado SET salario = 12000 
WHERE enome = 'Djamila Ribeito'

select *
from eempresa.v3

-- Criando Visões Materializadas

SELECT *
FROM eempresa.empregado

CREATE MATERIALIZED VIEW eempresa.mv_emp_fem 
AS 
SELECT enome, cpf, nasc, salario, chefe, cdep
FROM eempresa.empregado
WHERE sexo='F'

EXPLAIN
SELECT * 
FROM eempresa.mv_emp_fem

SELECT * 
FROM eempresa.mv_emp_fem
WHERE salario > 10000


CREATE UNIQUE INDEX mv_emp_fem_pk
  ON eempresa.mv_emp_fem (cpf);

EXPLAIN
SELECT * 
FROM eempresa.mv_emp_fem

SELECT *
FROM eempresa.empregado

SELECT *
FROM eempresa.empregado
WHERE cpf ='6543'

CREATE UNIQUE INDEX emp_pk
  ON eempresa.empregado (cpf);


SELECT * 
FROM eempresa.mv_emp_fem

UPDATE eempresa.mv_emp_fem
SET salario = 20000 
WHERE enome='Zefinha'

UPDATE eempresa.empregado
SET salario = 20000 
WHERE enome='Zefinha'

SELECT *
FROM eempresa.empregado

SELECT * 
FROM eempresa.mv_emp_fem


CREATE TABLE eempresa.tab_emp_fem 
AS 
SELECT enome, cpf, nasc, salario, chefe, cdep
FROM eempresa.empregado
WHERE sexo='F'

SELECT * 
FROM eempresa.tab_emp_fem

UPDATE eempresa.tab_emp_fem
SET salario = 30000 
WHERE enome='Zefinha'

SELECT * 
FROM eempresa.tab_emp_fem

SELECT * 
FROM eempresa.empregado

SELECT * 
FROM eempresa.mv_emp_fem

UPDATE eempresa.empregado
SET salario = 10000 
WHERE enome='Zefinha'

SELECT * 
FROM eempresa.tab_emp_fem

SELECT * 
FROM eempresa.empregado

INSERT INTO eempresa.empregado 
VALUES('Gal','1111','Rua Gal','1990-12-12','F',10000,NULL,NULL)
    
SELECT * 
FROM eempresa.empregado

SELECT * 
FROM eempresa.mv_emp_fem

SELECT * 
FROM eempresa.tab_emp_fem

-- Cadê a Gal???

REFRESH MATERIALIZED VIEW eempresa.mv_emp_fem;

SELECT * 
FROM eempresa.mv_emp_fem

SELECT * 
FROM eempresa.tab_emp_fem

UPDATE eempresa.mv_emp_fem 
SET salario = 16000 WHERE enome = 'Gal'

SELECT *
FROM eempresa.empregado

SELECT e.cdep, avg(salario)
FROM eempresa.empregado e
GROUP BY e.cdep
HAVING avg(salario) > 10000

SELECT e.cdep, avg(salario) as avg_sal
FROM eempresa.empregado e
GROUP BY e.cdep
HAVING avg(salario) >= ALL (
								SELECT avg(salario), e.cdep
								FROM eempresa.empregado e
								GROUP BY e.cdep
							) 



SCRIPT AULA 7

-- Trabalhando com Visões

-- Limpando o Esquema
DROP VIEW eempresa.v1
DROP VIEW eempresa.v2
DROP VIEW eempresa.v3
DROP MATERIALIZED VIEW eempresa.mv_emp_fem
DROP TABLE eempresa.tab_emp_fem

DELETE FROM eempresa.empregado WHERE enome='Gal'
UPDATE eempresa.empregado SET salario = 11000 WHERE enome = 'Pedrin'

SELECT * FROM eempresa.empregado

-- Criando a Visão v1

create view eempresa.v1 (nome_departamento, nome_empregado)
as
select d."DNome", e."ENome"
from eempresa.departamento d inner join eempresa.empregado e 
on d."Codigo" = e."CDep"

-- Usando a Visão 1

EXPLAIN
select * 
from eempresa.v1

EXPLAIN
SELECT *
FROM (	
		select d."DNome" as nome_departamento, e."ENome" as nome_empregado
		from eempresa.departamento d inner join eempresa.empregado e 
		on d."Codigo" = e."CDep"
	 ) as tab

select nome_empregado
from eempresa.v1

select "ENome"
from eempresa.v1

select nome_empregado
from eempresa.v1
where nome_departamento = 'Marketing'


-- Usando o Mesmo Comando da Visão 1

EXPLAIN
select * 
from eempresa.v1

EXPLAIN
select *
from (
        select d.dnome as nome_departamento, e.enome as nome_empregado
        from eempresa.departamento d inner join eempresa.empregado e 
        on d.codigo = e.cdep
      ) as tab

-- Usando a Visão 1

select nome_empregado
from eempresa.v1
where nome_departamento = 'Marketing'


-- Criando a Visão 2
DROP TABLE eempresa.dependente

CREATE TABLE eempresa.dependente
(
    cpf_responsavel character varying(13) NOT NULL,
    nome character varying(50) NOT NULL,
    data_nasc date,
    CONSTRAINT dependente_pkey PRIMARY KEY (cpf_responsavel, nome),
    CONSTRAINT fk_dependente_empregado FOREIGN KEY (cpf_responsavel)
        REFERENCES eempresa.empregado ("CPF") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

INSERT INTO eempresa.dependente VALUES('1234','Chiquin Jr','11/11/2018');
INSERT INTO eempresa.dependente VALUES('1234','Chiquinha','11/11/2018');
INSERT INTO eempresa.dependente VALUES('4321','Helenita Maria','11/11/2018');

SELECT * FROM eempresa.empregado
SELECT * FROM eempresa.dependente
									   

create view eempresa.v2 (nome_empregado, numero_de_dependentes)
as
select e."ENome", (select count(*) from eempresa.dependente d where d.cpf_responsavel = e."CPF")
from eempresa.empregado e

-- Usando a Visão 2
select * 
from eempresa.v2

select *
from eempresa.v2
where numero_de_dependentes > 0

select nome_empregado
from eempresa.v2
where numero_de_dependentes > 0

select nome_empregado
from eempresa.v2
where numero_de_dependentes >= ALL (
										select numero_de_dependentes
										from eempresa.v2
									)

-- Criando a Visão 3

SELECT *
FROM eempresa.empregado

create view eempresa.v3 (nome_empregado, salario)
as
select "ENome", "Salario"
from eempresa.empregado e
where "Salario" < 15000 with check option


SELECT * FROM eempresa.empregado where "Salario" < 15000

-- Usando a Visão 3

select * 
from eempresa.v3

EXPLAIN
select *
from eempresa.v3
where salario > 10000

EXPLAIN
select *
from (
	select "ENome", "Salario"
	from eempresa.empregado e
	where "Salario" < 15000
	) as tab
where "Salario" >10000

create view eempresa.v4 (nome_empregado, salario)
as
select *
from eempresa.v3
where salario > 10000

select *
from eempresa.v4

-- Atualizando a Visão 3

select *
from eempresa.v3

SELECT * 
FROM eempresa.empregado

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Pedrin'

-- Tradução Automática

update eempresa.empregado
set salario = salario + 3000
where enome = 'Pedrin'

SELECT * 
FROM eempresa.empregado

select *
from eempresa.v3

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Zefinha'

select * from eempresa.v3

select * from eempresa.empregado

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Zefinha'

update eempresa.empregado
set "Salario" = "Salario" + 3000
where "ENome" = 'Zefinha'

select * from eempresa.v3

select * from eempresa.empregado

drop view eempresa.v4
drop view eempresa.v3

update eempresa.empregado
set "Salario" = "Salario" - 6000
where "ENome" = 'Zefinha'

update eempresa.empregado
set "Salario" = "Salario" - 3000
where "ENome" = 'Pedrin'

create view eempresa.v3 (nome_empregado, salario)
as
select "ENome", "Salario"
from eempresa.empregado e
where "Salario" < 15000

select *
from eempresa.v3

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Zefinha'

update eempresa.v3
set salario = salario + 3000
where nome_empregado = 'Zefinha'

select * 
from eempresa.empregado

select *
from eempresa.v3

INSERT INTO eempresa.v3 VALUES ('Júlio', 10000)

-- Tradução
INSERT INTO eempresa.empregado VALUES ('Júlio', 10000)

update eempresa.empregado
set "Salario" = "Salario" - 6000
where "ENome" = 'Zefinha'

drop view eempresa.v3

create view eempresa.v3 (nome_empregado, salario)
as
select "ENome", "Salario"
from eempresa.empregado e
where "Salario" < 15000 with check option

select *
from eempresa.v3

select enome, salario
from eempresa.empregado

update eempresa.v3
set salario = 16000
where nome_empregado = 'Zefinha'

UPDATE eempresa.empregado 
SET salario = 16000 
WHERE enome = 'Zefinha'


select * 
from eempresa.empregado

select *
from eempresa.v3

UPDATE eempresa.empregado 
SET salario = 10000 
WHERE enome = 'Zefinha'

UPDATE eempresa.empregado SET salario = 12000 
WHERE enome = 'Henrique Vieira'

UPDATE eempresa.empregado SET salario = 9000 
WHERE enome = 'Berlofa'

UPDATE eempresa.empregado SET salario = 12000 
WHERE enome = 'Djamila Ribeito'

select *
from eempresa.v3

-- Criando Visões Materializadas

SELECT *
FROM eempresa.empregado

CREATE MATERIALIZED VIEW eempresa.mv_emp_fem 
AS 
SELECT "ENome", "CPF", "Nasc", "Salario", "Chefe", "CDep"
FROM eempresa.empregado
WHERE "Sexo"='F'

EXPLAIN
SELECT * 
FROM eempresa.mv_emp_fem

SELECT * 
FROM eempresa.mv_emp_fem
WHERE "Salario" > 10000


CREATE UNIQUE INDEX mv_emp_fem_pk
  ON eempresa.mv_emp_fem ("CPF");

EXPLAIN
SELECT * 
FROM eempresa.mv_emp_fem

SELECT *
FROM eempresa.empregado

SELECT *
FROM eempresa.empregado
WHERE cpf ='6543'

CREATE UNIQUE INDEX emp_pk
  ON eempresa.empregado ("CPF");


SELECT * 
FROM eempresa.mv_emp_fem

UPDATE eempresa.mv_emp_fem
SET "Salario" = 20000 
WHERE "ENome"='Zefinha'

UPDATE eempresa.empregado
SET "Salario" = 20000 
WHERE "ENome"='Zefinha'

SELECT *
FROM eempresa.empregado

SELECT * 
FROM eempresa.mv_emp_fem


CREATE TABLE eempresa.tab_emp_fem 
AS 
SELECT "ENome", "CPF", "Nasc", "Salario", "Chefe", "CDep"
FROM eempresa.empregado
WHERE "Sexo"='F'

SELECT * 
FROM eempresa.tab_emp_fem

UPDATE eempresa.tab_emp_fem
SET "Salario" = 30000 
WHERE "ENome"='Zefinha'

SELECT * 
FROM eempresa.tab_emp_fem

SELECT * 
FROM eempresa.empregado

SELECT * 
FROM eempresa.mv_emp_fem

UPDATE eempresa.empregado
SET "Salario" = 10000 
WHERE "ENome"='Zefinha'

SELECT * 
FROM eempresa.tab_emp_fem

SELECT * 
FROM eempresa.empregado

INSERT INTO eempresa.empregado 
VALUES('Gal','1111','Rua Gal','1990-12-12','F',10000,NULL,NULL)
    
SELECT * 
FROM eempresa.empregado

SELECT * 
FROM eempresa.mv_emp_fem

SELECT * 
FROM eempresa.tab_emp_fem

-- Cadê a Gal???

REFRESH MATERIALIZED VIEW eempresa.mv_emp_fem;

SELECT * 
FROM eempresa.mv_emp_fem

SELECT * 
FROM eempresa.tab_emp_fem

UPDATE eempresa.mv_emp_fem 
SET "Salario" = 16000 WHERE "ENome" = 'Gal'

SELECT *
FROM eempresa.empregado

SELECT e.cdep, avg(salario)
FROM eempresa.empregado e
GROUP BY e.cdep
HAVING avg(salario) > 10000

SELECT e.cdep, avg(salario) as avg_sal
FROM eempresa.empregado e
GROUP BY e.cdep
HAVING avg(salario) >= ALL (
								SELECT avg(salario), e.cdep
								FROM eempresa.empregado e
								GROUP BY e.cdep
							) 





