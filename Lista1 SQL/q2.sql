-- 2. QUESTÃO
-- Utilize a linguagem de consulta SQL e recupere as informações solicitadas a seguir:
-- a) Recupere o nome e o salário de todos os empregados que trabalham em Marketing.
SELECT e.enome,e.salario 
FROM eempresa.Empregado e
JOIN eempresa.Departamento d ON e.cdep = d.codigo
AND d.dnome = 'Marketing';

-- b) Recupere o CPF de todos os empregados que trabalham em Pesquisa ou que
-- diretamente gerenciam um empregado que trabalha em Pesquisa.
SELECT DISTINCT e.cpf 
FROM eempresa.Empregado e
JOIN eempresa.Departamento d 
ON e.cdep = d.codigo
AND d.dnome = 'Pesquisa' 
OR e.cpf IN (
	SELECT e.chefe 
	FROM eempresa.Empregado e
	JOIN eempresa.Departamento d 
	ON e.cdep = d.codigo
	AND d.dnome = 'Pesquisa'
);

-- c) Recupere o nome e a cidade dos projetos que envolvem (contêm) pelo menos um
-- empregado que trabalha mais de 30 horas nesse projeto.
SELECT Distinct p.pnome,p.cidade
FROM eempresa.Projeto p
JOIN eempresa.Tarefa t
ON p.pcodigo = t.pcodigo
WHERE t.horas > 30

-- d) Recupere o nome e a data de nascimento dos gerentes de cada departamento.
SELECT e.enome,e.nasc 
FROM eempresa.Empregado e
JOIN eempresa.Departamento d
ON d.gerente = e.cpf

-- e) Recupere o nome e o endereço de todos os empregados que trabalham para o
-- departamento “Pesquisa”.

SELECT e.enome,e.endereco 
FROM eempresa.Empregado e
JOIN eempresa.Departamento d 
ON e.cdep = d.codigo
AND d.dnome = 'Pesquisa';

-- f) Para cada projeto localizado em Icapuí, recupere o código do projeto, o nome do
-- departamento que o controla e o nome do seu gerente.

SELECT p.pcodigo, d.dnome, e.enome
FROM eempresa.Projeto p
JOIN eempresa.Departamento d ON p.cdep = d.codigo
JOIN eempresa.Empregado e ON d.gerente = e.cpf
WHERE p.cidade = 'Icapuí'

-- g) Recupere o nome e o sexo dos empregados que não são gerentes.

SELECT e.enome, e.sexo
FROM eempresa.Empregado e
WHERE E.CPF NOT IN (SELECT gerente FROM eempresa.Departamento)

