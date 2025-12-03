/* =======================================================================
   Universidade Federal do Ceará – UFC
   Centro de Ciências – CC
   Departamento de Computação – DC
   Disciplina: Fundamentos de Bancos de Dados

   Exercício: Visões Virtuais e Materializadas
   Objetivo : Criação e atualização de visões
   Data     : 02/12/2025
   ======================================================================= */


/* =======================================================================
   1 - INTRODUÇÃO
   =======================================================================

   Uma visão é uma maneira alternativa de visualização dos dados derivados
   de uma ou mais tabelas em um banco de dados. Seu objetivo é disponibilizar
   dados ao usuário final com maior segurança.

   O usuário passa a visualizar apenas partes selecionadas das informações
   armazenadas no banco. As visões também permitem definir informações
   derivadas e calculadas.

   -----------------------------------------------------------------------
   VANTAGENS DAS VISÕES
   -----------------------------------------------------------------------
   • Permitem ao usuário visualizar apenas os dados de seu interesse.
   • Simplificam a manipulação dos dados.
   • Otimizam a forma como os usuários enxergam o banco de dados.
   • Provêm segurança, pois restringem o acesso direto às tabelas.
   • Permitem a criação de visões sobre outras visões.

   -----------------------------------------------------------------------
   RESTRIÇÕES DE SINTAXE
   -----------------------------------------------------------------------
   • Obrigatório o uso da cláusula SELECT.
   • Não é permitido o uso de:
     - SELECT INTO
     - ORDER BY
     - COMPUTE / COMPUTE BY
     - UNION
   • Não podem referenciar tabelas temporárias.
   • Não é possível criar triggers diretamente sobre visões.
   • Não é possível criar índices (dependende do SGBD).
   • Máximo de 250 colunas por visão.

   -----------------------------------------------------------------------
   RESTRIÇÕES DE ATUALIZAÇÃO EM VISÕES
   -----------------------------------------------------------------------
   • A modificação não pode afetar mais de uma tabela base.
   • Não é permitido alterar:
     - Colunas derivadas
     - Funções
     - Agregações
   • Colunas NOT NULL fora da visão podem causar erro.
   • Se a visão for criada com SELECT *, novas colunas da tabela não aparecem 
     automaticamente na visão.
   • Se a tabela base for removida, a visão deixa de funcionar.

   ======================================================================= */

-- ========================
-- 3 - EXERCÍCIO
-- ========================

-- 3.1. Crie as visões solicitadas a seguir.

-- 3.2. Para cada operação de atualização (UPDATE, INSERT e DELETE) sobre as visões:
-- a) Indicar se a atualização é permitida ou não.
-- b) Caso permitida, indicar a tradução para as tabelas base.
-- c) Caso não permitida, justificar e explicar a semântica.
-- d) (Opcional) Criar Stored Procedures para permitir as atualizações.

-- ========================
-- 4 - TAREFAS
-- ========================

-- 4.1. Criar uma visão que recupere para cada empregado:
-- - Nome
-- - Sexo
-- - Salário

create or replace view v_empregado_resumo as
select 
    enome
    sexo
    salario
from eempresa.empregado;

select * from v_empregado_resumo;

-- 4.2. Usando a visão anterior, recuperar o nome do funcionário com maior salário.

select enome from v_empregado_resumo 
where salario = (
	select max(salario)
	from v_empregado_resumo
);

-- 4.3. Usando a visão anterior, efetuar uma atualização que conceda um aumento de 10%.

update v_empregado_resumo
set salario = salario*0.90

-- 4.4. Criar uma visão que recupere para cada departamento:
--      - Nome do departamento
--      - Nome do gerente

create or replace view v_dep_resumo as 
select 
	d.dnome,
	e.enome
from eempresa.departamento d
join eempresa.empregado e 
on d.gerente = e.cpf
	
select * from v_dep_resumo

-- 4.5. Usando a visão anterior, alterar o nome do gerente do departamento de Pesquisa.

--Update não permitido, pois usa o Join entre duas tabelas
--para permitir, precisaria ter o procedure abaixo

create or replace procedure atualizar_gerente_dept(
	p_dnome text,
	p_novo_nome text
)
language plpgsql
as $$
begin
	update eempresa.empregado
	set enome = p_novo_nome
	where cpf = (
		select d.gerente
		from eempresa.departamento d
		where d.dnome = p_dnome
	);
end;
$$

call atualizar_gerente_dept('Pesquisa', 'Chico')

-- 4.6. Usando a visão anterior, alterar o nome do departamento do empregado Chiquin.

-- 4.7. Criar uma visão que recupere para cada empregado com salário menor que 5000:
--      - Nome
--      - Sexo
--      - Salário

--valor ajustado para o meu banco de dados

create or replace view eempresa.lista4_q47 as 
select 
	enome as nome_empregado,
	sexo as  sexo_empregado,
	salario as salario_empregado
from eempresa.empregado	
where salario <= 9000


select * from eempresa.lista4_q47

-- 4.8. Usando a visão anterior, conceder um aumento de 600 a todos os empregados da visão.

update eempresa.lista4_q47
set salario_empregado = salario_empregado + 60

-- 4.9. Usando a mesma visão, excluir os empregados com salário entre 1000 e 2000.

delete from eempresa.lista4_q47
where salario_empregado between 6300 and 6500;
/*/
ERROR:  atualização ou exclusão em tabela "empregado" viola restrição de chave estrangeira "tarefa_cpf_fkey" em "tarefa"
Chave (cpf)=(5678) ainda é referenciada pela tabela "tarefa". */


-- 4.10. Ainda usando essa visão, inserir uma nova tupla.
--as colunas fora da visão não permitem valores nulos. não é possível
insert into eempresa.lista4_q47 (nome_empregado, sexo_empregado, salario_empregado)
values ('Carlos', 'M', 4800);


-- 4.11. Criar uma visão que recupere para cada departamento:
--       - Código do departamento
--       - Nome do departamento
--       - CPF do gerente
--       - Nome do gerente
create or replace view eempresa.lista4_q411 as
select 
	d.codigo as codigo,
	d.dnome as nome,
	d.gerente as cpf_gerente,
	e.enome as nome_gerente
from eempresa.departamento d join
eempresa.empregado e on e.cpf = d.gerente;

select * from eempresa.lista4_q411	

-- 4.12. Usando a visão anterior, alterar o código do departamento de informática.

create or replace procedure eempresa.atualiza_codigo_dep(
    p_nome_dep text,
    p_novo_codigo int
)
language plpgsql
as $$
begin
    update eempresa.departamento
    set codigo = p_novo_codigo
    where dnome = p_nome_dep;
end;
$$;


call eempresa.atualiza_codigo_dep('Pesquisa', 10);

-- alteração viola chave primária e referenciado como chave estrangeira em empregado.


-- 4.13. Usando a mesma visão, alterar o CPF do empregado Chiquin.

create or replace procedure eempresa.atualiza_cpf(
    p_nome_emp text,
    p_novo_cpf int
)
language plpgsql
as $$
begin
    update eempresa.empregado
    set cpf = p_novo_cpf
    where enome = p_nome_emp;
end;
$$;

CALL eempresa.atualiza_cpf('Chico', 9999);

-- não funciona pelo mesmo motivo
select * from eempresa.empregado

-- 4.14. Ainda com a mesma visão, alterar o nome do empregado Chiquin.

create or replace procedure eempresa.atualiza_nome(
    p_nome_emp text,
    p_novo_nome text
)
language plpgsql
as $$
begin
    update eempresa.empregado
    set enome = p_novo_nome
    where enome = p_nome_emp;
end;
$$;
-- Funciona por não ser chave estrangeira
CALL eempresa.atualiza_nome('Chiquin', 'Chico');
select * from eempresa.empregado

-- 4.15. Criar uma visão que recupere para cada departamento:
--       - Código
--       - Nome
--       - Quantidade de empregados
--       - Maior salário
--       - Menor salário
--       - Média salarial

create or replace view eempresa.lista4_q415 as
select 
	d.codigo 			as cod_dep,
	d.dnome 			as nome_dep,
	count(e.cpf) 	as quantidade_empregados,
	max(e.salario)	as maior_salario,
	min(e.salario)	as menor_salario,
	avg(e.salario)	as media_salario
from eempresa.departamento d
left join eempresa.empregado e
	on d.codigo = e.cdep
group by d.codigo, d.dnome;

select * from eempresa.lista4_q415
-- 4.16. Usando a visão anterior:
--       - Alterar a média salarial do departamento de código 1.
--       - Alterar a quantidade de empregados do departamento de código 1.
--       - Excluir o departamento de código 1.
--       - Inserir um novo departamento.
--       - Alterar o nome de um dos departamentos que aparecem na visão.


-- Nenhuma das operações da questão 4.16 pode ser realizada
-- diretamente na visão da 4.15 de forma automática.
-- Todas exigem tradução explícita para as tabelas base,
-- preferencialmente por meio de stored procedures.
