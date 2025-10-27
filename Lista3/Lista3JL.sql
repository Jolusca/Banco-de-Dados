-- 1. Recuperar o nome do departamento com maior média salarial.

SELECT d.dnome
FROM eempresa.departamento d
JOIN eempresa.empregado e
ON e.cdep = d.codigo
GROUP BY d.dnome 
ORDER BY AVG(e.salario) DESC
LIMIT 1;


-- 2. Recuperar para cada departamento: o seu nome, o maior e o menor salário recebido
-- por empregados do departamento e a média salarial do departamento.

SELECT d.dnome, MAX(e.salario) as maior_salario, MIN(e.salario) as menor_salario,ROUND(AVG(e.salario), 2) as media_salario
FROM eempresa.departamento d
left JOIN eempresa.empregado e
ON e.cdep = d.codigo
GROUP BY d.dnome 

-- 3. Recuperar para cada departamento: o seu nome, o nome do seu gerente, a
-- quantidade de empregados, a quantidade de projetos do departamento e a
-- quantidade de unidades do departamento.

SELECT d.dnome, emp.enome as gerente,
COUNT ( DISTINCT e.cpf) AS "qntd de empregados",
COUNT ( DISTINCT p.pcodigo) AS "qntd de projetos",
COUNT ( DISTINCT (u.dcodigo, dcidade)) AS "qntd de unidades do departamento"
FROM eempresa.departamento d
JOIN eempresa.empregado e ON d.codigo = e.cdep
JOIN eempresa.empregado emp on emp.cpf = d.gerente
LEFT JOIN eempresa.projeto p ON p.cdep = d.codigo
LEFT JOIN eempresa.dunidade u ON u.dcodigo = d.codigo
GROUP BY d.dnome, emp.enome

-- 4. Recuperar o nome do projeto que consome o maior número de horas.

SELECT p.pnome
FROM eempresa.projeto as p
JOIN eempresa.tarefa as t ON t.pcodigo = p.pcodigo
GROUP BY p.pnome
HAVING SUM(t.horas) >= ALL (
	SELECT SUM(t.horas)
	FROM eempresa.tarefa t
	GROUP BY t.pcodigo
)

-- 5. Recuperar o nome do projeto mais caro. (sopmatório de salários)

SELECT p.pnome FROM eempresa.empregado e
JOIN eempresa.projeto p
ON p.cdep = e.cdep
GROUP BY p.pnome
ORDER BY SUM(e.salario) DESC
LIMIT 1;

-- 6. Recuperar para cada projeto: o seu nome, o nome gerente do departamento que
-- controla o projeto, a quantidade total de horas alocadas ao projeto, a quantidade de
-- empregados alocados ao projeto e o custo mensal do projeto.

SELECT p.pnome, e.enome, SUM(DISTINCT(t.horas)), COUNT(DISTINCT(emp.cpf)), SUM((emp.salario))
FROM eempresa.projeto p
LEFT JOIN eempresa.departamento d ON d.codigo = p.cdep
JOIN eempresa.empregado e ON e.cpf = d.gerente
LEFT JOIN eempresa.tarefa t ON t.pcodigo = p.pcodigo
RIGHT JOIN eempresa.empregado emp ON emp.cdep = p.cdep
GROUP BY p.pnome, e.enome

-- 7. Recuperar o nome dos gerentes com sobrenome ‘Silva’.

SELECT e.enome FROM eempresa.empregado e
WHERE e.enome LIKE '% Silva %'

-- 8. Recupere o nome dos gerentes que estão alocados em algum projeto (ou seja,
-- possuem “alguma” tarefa em “algum” projeto).

SELECT DISTINCT (e.enome )
FROM eempresa.empregado e
JOIN eempresa.departamento d ON d.gerente = e.cpf
JOIN eempresa.tarefa t ON t.cpf = e.cpf

-- 9. Recuperar o nome dos empregados que participam de projetos que não são
-- gerenciados pelo seu departamento.

SELECT e.enome
FROM eempresa.empregado e
JOIN eempresa.tarefa t ON t.cpf = e.cpf
JOIN eempresa.projeto p ON p.pcodigo = t.pcodigo AND e.cdep <> p.cdep

-- 10. Recuperar o nome dos empregados que participam de todos os projetos.

SELECT e.enome
FROM eempresa.empregado e
JOIN eempresa.tarefa t ON t.cpf = e.cpf
GROUP BY e.cpf, e.enome
HAVING COUNT(DISTINCT t.pcodigo) = (
  SELECT COUNT(*) FROM eempresa.projeto
);

-- 11. Recuperar para cada funcionário (empregado): o seu nome, o seu salário e o nome
-- do seu departamento. O resultado deve estar em ordem decrescente de salário.
-- Mostrar os empregados sem departamento e os departamentos sem empregados.

SELECT e.enome, e.salario, d.dnome
FROM eempresa.empregado e
FULL OUTER JOIN eempresa.departamento d 
ON e.cdep=d.codigo
ORDER BY e.salario DESC

-- 12. Recuperar para cada funcionário (empregado): o seu nome, o nome do seu chefe e
-- o nome do gerente do seu departamento.

SELECT e.enome, emp.enome as chefe, ep.enome as gerente
FROM eempresa.empregado e
LEFT JOIN eempresa.empregado emp ON e.chefe=emp.cpf
JOIN eempresa.departamento d ON d.codigo = e.cdep
JOIN eempresa.empregado ep ON d.gerente = ep.cpf

-- 13. Listar nome dos departamentos com média salarial maior que a média salarial da
-- empresa.

SELECT d.dnome FROM eempresa.departamento d
JOIN eempresa.empregado e
ON e.cdep=d.codigo
GROUP BY d.dnome
HAVING AVG(e.salario) >= ( SELECT AVG(e1.salario) FROM eempresa.empregado e1 )

-- 14. Listar todos os empregados que possuem salário maior que a média salarial de
-- seus departamentos.

SELECT e.enome FROM eempresa.empregado e
JOIN eempresa.departamento d ON d.codigo = e.cdep
WHERE e.salario > (
	SELECT AVG(e2.salario)
	FROM eempresa.empregado e2
	WHERE e2.cdep=e.cdep
)

-- 15. Listar os empregados lotados nos departamentos localizados em “Fortaleza”.

SELECT e.enome FROM eempresa.empregado e
JOIN eempresa.dunidade d ON e.cdep=d.dcodigo
WHERE d.dcidade = 'Fortaleza'

-- 16. Listar nome de departamentos com empregados ganhando duas vezes mais que a
-- média do departamento

SELECT e.enome FROM eempresa.empregado e
JOIN eempresa.departamento d ON d.codigo = e.cdep
WHERE e.salario >= 2 * (
	SELECT AVG(e1.salario)
	FROM eempresa.empregado e1
	WHERE e.cdep=e1.cdep
)

-- 17. Recuperar o nome dos empregados com salário entre R$ 700 e R$ 2800.

SELECT e.enome FROM eempresa.empregado e
WHERE e.salario BETWEEN 700 AND 2800

-- **** 18. Recuperar o nome dos departamentos que controlam projetos com mais de 50
-- empregados e que também controlam projetos com menos de 5 empregados.
