-- Utilize a linguagem de consulta SQL e recupere as informações solicitadas a seguir:
-- 1) Recupere o nome e o salário de todos os empregados.

SELECT enome, salario 
FROM eempresa.empregado;

-- 2) Recupere o nome e o salário de todos os empregados do sexo feminino.

SELECT e.enome, e.salario 
FROM eempresa.empregado e
WHERE e.Sexo = 'F';

-- 3) Recupere o nome e o salário de todos os empregados do sexo feminino e que ganham salário maior que R$ 10.000,00.

SELECT e.enome, e.salario 
FROM eempresa.empregado e
WHERE e.Sexo = 'F' 
AND e.salario >10000;

-- 4) Recupere a quantidade de empregados.

SELECT COUNT(*)
FROM eempresa.empregado;

-- 5) Recupere o maior salário, o menor salário e a média salarial da empresa.

SELECT MAX(e.Salario) AS "Maior salário",
AVG(e.Salario) AS "Média do salário",
MIN(e.Salario) AS "Menor salário"
FROM eempresa.empregado e;

-- 6) Recupere o nome e o salário de todos os empregados que trabalham em Marketing.

SELECT e.enome, e.salario
FROM eempresa.empregado e
JOIN eempresa.departamento d
ON d.codigo = e.cdep
WHERE d.dnome = 'Marketing';

-- 7) Recupere o CPF dos empregados que possuem alguma tarefa.

SELECT distinct(t.cpf)
FROM eempresa.tarefa t;

-- 8) Recupere o CPF dos empregados que não possuem tarefa.

SELECT e.cpf
FROM eempresa.empregado e
LEFT JOIN eempresa.tarefa t
ON e.cpf = t.cpf
WHERE t.cpf IS NULL;

-- 9) Recupere o nome dos empregados que possuem alguma tarefa.

SELECT distinct(e.enome)
FROM eempresa.empregado e
JOIN eempresa.tarefa t
ON e.cpf = t.cpf;

-- ***** 10) Recupere o nome dos empregados que não possuem tarefa.

SELECT e.enome
FROM eempresa.empregado e
LEFT JOIN eempresa.tarefa t
ON e.cpf = t.cpf
WHERE t.cpf IS NULL;

-- 11) Recupere o CPF dos empregados que possuem pelo menos uma tarefa com mais de 30 horas.

SELECT distinct(t.cpf)
FROM eempresa.tarefa t
WHERE t.horas > 30;

-- 12) Recupere o nome dos empregados que possuem pelo menos uma tarefa com mais de 30 horas.

SELECT e.enome
FROM eempresa.empregado e
JOIN eempresa.tarefa t
ON e.cpf = t.cpf
WHERE t.horas > 30;

-- 13) Recupere para cada departamento o seu nome e o nome do seu gerente.

SELECT d.dnome, e.enome
FROM eempresa.departamento d
JOIN eempresa.empregado e
ON e.cpf = d.gerente;

-- 14) Recupere o CPF de todos os empregados que trabalham em Pesquisa ou que diretamente gerenciam um empregado que trabalha em Pesquisa.

SELECT DISTINCT(e.cpf)
FROM eempresa.empregado e
JOIN eempresa.departamento d
ON e.cpf = d.gerente OR e.cdep = d.codigo
WHERE d.dnome = 'Pesquisa';

-- ***** 15) Recupere o nome e a cidade dos projetos que envolvem (contêm) pelo menos um empregado que trabalha mais de 30 horas nesse projeto.

SELECT Distinct(p.pnome), p.cidade
FROM eempresa.projeto p
JOIN eempresa.empregado e
ON e.cdep = p.cdep
WHERE e.cpf IN (
	SELECT distinct(t.cpf)
	FROM eempresa.tarefa t
	WHERE t.horas > 30
);

-- 16) Recupere o nome e a data de nascimento dos gerentes de cada departamento.

SELECT e.enome,e.nasc
FROM eempresa.empregado e
JOIN eempresa.departamento d
ON e.cpf = d.gerente;

-- ***** 17) Recupere o nome e o endereço de todos os empregados que trabalham para o departamento “Pesquisa”.

SELECT e.enome,e.endereco
FROM eempresa.empregado e
JOIN eempresa.departamento d
ON e.cdep = d.codigo
WHERE d.dnome='Pesquisa';

-- 18) Para cada projeto localizado em Icapuí, recupere o código do projeto, o nome do departamento que o controla e o nome do seu gerente.

SELECT p.pcodigo, d.dnome, e.enome
FROM eempresa.projeto p
JOIN eempresa.departamento d
ON p.cdep = d.codigo
JOIN eempresa.empregado e
ON e.cpf = d.gerente
WHERE p.cidade = 'Icapuí';

-- 19) Recupere o nome e o sexo dos empregados que são gerentes.

SELECT e.enome, e.sexo
FROM eempresa.empregado e
JOIN eempresa.departamento d
ON d.gerente = e.cpf

-- **** 20) Recupere o nome e o sexo dos empregados que não são gerentes.

SELECT e.enome, e.sexo
FROM eempresa.empregado e
LEFT JOIN eempresa.departamento d
ON d.gerente = e.cpf
WHERE d.gerente IS NULL
