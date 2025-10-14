--Questão 2
select * from eempresa.empregado
-- 1) Recupere o nome e o salário de todos os empregados.

select enome, salario 
from eempresa.empregado

-- 2) Recupere o nome e o salário de todos os empregados do sexo feminino.

select enome, salario 
from eempresa.empregado
where sexo = 'F'

-- 3) Recupere o nome e o salário de todos os empregados do sexo feminino e que ganham salário maior que R$ 10.000,00.

select enome, salario 
from eempresa.empregado
where sexo = 'F'
AND salario > 10000

-- 4) Recupere a quantidade de empregados.

select Count(*) as qtd_empregados
from eempresa.empregado

-- 5) Recupere o maior salário, o menor salário e a média salarial da empresa.

select max(salario) as max_salario,
min(salario) as min_salario,
round(avg(salario), 2) as med_salario
from eempresa.empregado

-- 6) Recupere o nome e o salário de todos os empregados que trabalham em Marketing.

select enome, salario
from eempresa.empregado e join eempresa.departamento d
on e.cdep = d.codigo 
where d.dnome = 'Marketing'

-- 7) Recupere o CPF dos empregados que possuem alguma tarefa.
-- vou adicionar um empregado sem tarefa para essa questão e a próxima e excluir depois 
insert into eempresa.empregado (enome, cpf, endereco, nasc, sexo, salario, chefe, cdep) values ('joao', 9999, 'rua 9,9', '2002-11-19' , 'M', 90000.00, NULL , 4)
select * from eempresa.empregado

select * from eempresa.tarefa

select distinct e.cpf 
from eempresa.empregado e join eempresa.tarefa t
on e.cpf = t.cpf

-- 8) Recupere o CPF dos empregados que não possuem tarefa.

select distinct e.cpf 
from eempresa.empregado e 
left join eempresa.tarefa t
on e.cpf = t.cpf
where t.cpf is null

-- 9) Recupere o nome dos empregados que possuem alguma tarefa.

select distinct e.enome 
from eempresa.empregado e join eempresa.tarefa t
on e.cpf = t.cpf

-- 10) Recupere o nome dos empregados que não possuem tarefa.

select distinct e.enome 
from eempresa.empregado e 
left join eempresa.tarefa t
on e.cpf = t.cpf
where t.cpf is null

--removendo o empregado adicionado sem uma tarefa
delete from eempresa.empregado  where enome = 'joao'

-- 11) Recupere o CPF dos empregados que possuem pelo menos uma tarefa com mais de 30 horas.

select distinct cpf
from eempresa.tarefa 
where horas > 30

-- 12) Recupere o nome dos empregados que possuem pelo menos uma tarefa com mais de 30 horas.

select enome
from eempresa.empregado e
join eempresa.tarefa t
on e.cpf = t.cpf
where e.cpf in(
	select distinct cpf
	from eempresa.tarefa 
	where t.horas > 30)

-- 13) Recupere para cada departamento o seu nome e o nome do seu gerente.



-- 14) Recupere o CPF de todos os empregados que trabalham em Pesquisa ou que diretamente gerenciam um empregado que trabalha em Pesquisa.

-- 15) Recupere o nome e a cidade dos projetos que envolvem (contêm) pelo menos um empregado que trabalha mais de 30 horas nesse projeto.

-- 16) Recupere o nome e a data de nascimento dos gerentes de cada departamento.

-- 17) Recupere o nome e o endereço de todos os empregados que trabalham para o departamento “Pesquisa”.

-- 18) Para cada projeto localizado em Icapuí, recupere o código do projeto, o nome do departamento que o controla e o nome do seu gerente.

-- 19) Recupere o nome e o sexo dos empregados que são gerentes.

-- 20) Recupere o nome e o sexo dos empregados que não são gerentes.
