-- Limpando e criando as tabelas

DROP TABLE IF EXISTS simulado.matricula;
DROP TABLE IF EXISTS simulado.disciplina;
DROP TABLE IF EXISTS simulado.estudante;
DROP TABLE IF EXISTS simulado.faculdade;

create table simulado.estudante (
	enum int Primary key,
	enome varchar(30),
	nivel varchar(30),
	idade int
);


create table simulado.disciplina (
	dnome varchar (30) primary key,
	hora time,
	sala varchar (30),
	fid int
	);

create table simulado.matricula (
	enum int,
	dnome varchar (30),
	FOREIGN KEY (enum) references simulado.estudante(enum),
	FOREIGN KEY (dnome) references simulado.disciplina(dnome)
);

create table simulado.faculdade (
	fid int primary key,
	fnome varchar (30)
);


-------Populando as tabelas:

-- FACULDADES
INSERT INTO simulado.faculdade (fid, fnome) VALUES
(1, 'FAFOR'),
(2, 'FANÓIS'),
(3, 'FATEC');

-- ESTUDANTES
INSERT INTO simulado.estudante (enum, enome, nivel, idade) VALUES
(1, 'Ana', 'Graduação', 18),
(2, 'Bruno', 'Graduação', 21),
(3, 'Carlos', 'Graduação', 22),
(4, 'Daniela', 'Graduação', 19),
(5, 'Elisa', 'Graduação', 17);

-- DISCIPLINAS
INSERT INTO simulado.disciplina (dnome, hora, sala, fid) VALUES
('BD',  '08:00', '101', 1),
('POO', '10:00', '102', 1),
('Redes', '14:00', '103', 1),
('IA',  '08:00', '201', 2),
('Calc', '10:00', '202', 2);

-- MATRÍCULAS
INSERT INTO simulado.matricula (enum, dnome) VALUES
(1, 'BD'),
(1, 'POO'),

(2, 'BD'),
(2, 'Calc'),

(3, 'BD'),
(3, 'POO'),
(3, 'Redes'),

(4, 'IA'),
(4, 'Calc'),

(5, 'POO');

/* =========================================================
   QUESTÃO 1 (6 pontos) — Consultas em SQL
   Especifique, em SQL, as seguintes consultas:
   ========================================================= */

/* A)
   Ache o nome da faculdade que não possui aluno algum.
*/

select distinct fnome from simulado.faculdade f
left join simulado.disciplina d on f.fid =d.fid
left join simulado.matricula m on d.dnome = m.dnome
where d.dnome is null

/* B)
   Encontre o nome dos estudantes matriculados em todas as
   disciplinas da faculdade “FAFOR”.
*/

select distinct enome from simulado.estudante e
join simulado.matricula m on e.enum = m.enum
join simulado.disciplina d on d.dnome = m.dnome
join simulado.faculdade f on f.fid = d.fid
where f.fnome = 'FAFOR'
group by e.enum, e.enome
having count(*)= (
	select count(*) from simulado.faculdade f
	join simulado.disciplina d on d.fid = f.fid
	where f.fnome = 'FAFOR'
)
/* C)
   Recupere o nome e a idade dos estudantes que foram ou são
   estudantes da faculdade “FAFOR”, mas que nunca estudaram
   na faculdade “FANÓIS”.
*/

select distinct enome, idade from simulado.estudante e 
join simulado.matricula m on e.enum = m.enum
join simulado.disciplina d on d.dnome = m.dnome
join simulado.faculdade f on f.fid = d.fid
where f.fnome = 'FAFOR'
except
select distinct enome, idade from simulado.estudante e 
join simulado.matricula m on e.enum = m.enum
join simulado.disciplina d on d.dnome = m.dnome
join simulado.faculdade f on f.fid = d.fid
where f.fnome = 'FANÓIS'

/* D)
   Recupere a quantidade de disciplinas da faculdade “FAFOR”.
*/

	select count(*) from simulado.faculdade f
	join simulado.disciplina d on d.fid = f.fid
	where f.fnome = 'FAFOR'


/* E)
   Ache o nome dos estudantes com idade acima de 20 anos que
   estão matriculados em pelo menos uma disciplina da
   faculdade “FAFOR”.
*/

select distinct enome from simulado.estudante e
join simulado.matricula m on e.enum = m.enum
join simulado.disciplina d on d.dnome = m.dnome
join simulado.faculdade f on f.fid = d.fid
where f.fnome = 'FAFOR' AND e.idade >20


/* F)
   Recupere o número e o nome dos estudantes com idade menor
   que 19 anos.
*/

select distinct enum , enome from simulado.estudante e
where e.idade < 19

/* =========================================================
   QUESTÃO 2 (2 pontos) — Visão SQL
   ========================================================= */

/* a)
   Defina uma Visão SQL, denominada VRESUMO, que recupere
   para cada estudante o seu nome e a quantidade de
   disciplinas em que ele/ela está matriculado(a).
*/

/* b)
   Considerando que estamos utilizando o PostgreSQL em sua
   versão mais recente, justifique o que irá ocorrer ao se
   tentar executar o comando a seguir:

   UPDATE VRESUMO
   SET enome = 'Gal'
   WHERE enome = 'Gil';
*/


/* =========================================================
   QUESTÃO 3 (1 ponto) — Trigger
   ========================================================= */

/*
   Defina um gatilho (trigger) a fim de assegurar que cada
   estudante se matricule em no máximo 5 disciplinas.
*/


/* =========================================================
   QUESTÃO 4 (1 ponto) — Procedure Armazenada
   ========================================================= */

/*
   Escreva um procedimento armazenado que recebe como
   parâmetro de entrada o identificador de um estudante (eid)
   e, em seguida, faz com que esse estudante seja matriculado
   em todas as disciplinas da faculdade “FANÓIS”.
*/

