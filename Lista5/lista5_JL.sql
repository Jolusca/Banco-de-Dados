-- ============================================================
-- LISTA 5 — PROCEDURES E TRIGGERS
-- ============================================================

-- ============================================================
-- 2. FAÇA O QUE SE PEDE
-- ============================================================

Select * from eempresa.empregado

SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'eempresa'
ORDER BY table_name, ordinal_position;
-- ------------------------------------------------------------
-- 2.1 Crie um procedimento para cadastrar um empregado.
-- ------------------------------------------------------------

create or replace function eempresa.lista5_q21 (
	p_enome 		varchar,
	p_cpf 			varchar,
	p_salario 		int
)
returns void
language plpgsql
as $$
begin
	insert into eempresa.empregado(
		enome, cpf, salario
	)
	values(
		p_enome, p_cpf, p_salario
	);
end;
$$

select eempresa.lista5_q21('Pedro', '8888', 3500);

select * from eempresa.empregado
-- ------------------------------------------------------------
-- 2.2 Crie um procedimento que recebe como parâmetro:
--     - CPF de um empregado
--     - Número de horas
-- E insere uma tupla em Tarefa para cada projeto
-- (para este empregado e número de horas).
-- ------------------------------------------------------------
create or replace function eempresa.lista5_q22(
    pcpf character varying, 
    p_numhoras integer
)
returns void
language plpgsql
as $$
declare 
    c cursor for select pcodigo from eempresa.projeto;
    v_pcodigo varchar;
begin 
    open c;

    loop
        fetch c into v_pcodigo;
        exit when not found;

        insert into eempresa.tarefa(cpf, pcodigo, horas)
        values (pcpf, v_pcodigo, p_numhoras)
        on conflict do nothing;
    end loop;

    close c;
end;
$$;


select eempresa.lista5_q22('1234', 10);

-- ------------------------------------------------------------
-- 2.3 Crie um procedimento que retorne o CPF do empregado
--     com maior salário.
-- ------------------------------------------------------------
create or replace function eempresa.lista5_q23()
returns varchar
language plpgsql
as $$
declare cpf_maior varchar;
begin
	select cpf 
	into cpf_maior
	from eempresa.empregado
	where salario = (
		select max(salario) from eempresa.empregado
	);
	return cpf_maior;
end;
$$;

select * from eempresa.lista5_q23()

-- ------------------------------------------------------------
-- 2.4 Crie um procedimento que recebe como parâmetro
--     o código de um departamento e retorna o CPF
--     do empregado deste departamento com maior salário.
-- ------------------------------------------------------------
create or replace function eempresa.lista5_q24(pcdep int)
returns varchar
language plpgsql
as $$
declare 
	pcpf varchar;
begin
	select cpf 
	into pcpf
	from eempresa.empregado e
	where cdep = pcdep and salario >= (
		select max(salario)
		from eempresa.empregado
		where cdep=pcdep
	) limit 1;
	return pcpf;
end;
$$;

select * from eempresa.lista5_q24('2')
-- ------------------------------------------------------------
-- 2.5 Crie um procedimento que recebe como parâmetro
--     o código de um projeto e retorna o total de horas
--     deste projeto.
-- ------------------------------------------------------------

create or replace function eempresa.lista5_q25(
	p_pcodigo varchar
)
returns numeric
language plpgsql
as $$
declare
	total_horas numeric;
begin
	select sum(horas)
	into total_horas
	from eempresa.tarefa
	where pcodigo = p_pcodigo;

	return total_horas;
end;
$$

select eempresa.lista5_q25('PA');

-- ------------------------------------------------------------
-- 2.6 Crie um procedimento que recebe como parâmetro
--     a taxa de aumento de salário e atualiza o salário
--     de todos os empregados com esta taxa.
-- ------------------------------------------------------------

create or replace function eempresa.lista5_q26(
	p_taxa numeric
)
returns void
language plpgsql
as $$
begin
	update eempresa.empregado
	set salario = salario*p_taxa;
end;
$$


select eempresa.lista5_q26(0.1);

select salario from eempresa.empregado

-- ------------------------------------------------------------
-- 2.7 Crie uma trigger para impedir que seja excluído
--     um empregado que ainda esteja alocado em alguma tarefa.
-- ------------------------------------------------------------

create or replace function eempresa.trg_lista5_q27()
returns trigger
language plpgsql
as $$
begin 
	if exists(
		select 1
		from eempresa.tarefa
		where cpf = old.cpf
	) then
		raise exception 'Empregado possui tarefa';
	end if;

	return old;
end;
$$;

create trigger impede_excluir_empregado
before delete on eempresa.empregado
for each row 
execute function eempresa.trg_lista5_q27()

delete from eempresa.empregado
where cpf = '1234';

-- ------------------------------------------------------------
-- 2.8 Crie uma trigger para que sempre que seja excluído
--     um projeto sejam automaticamente excluídas
--     todas as suas tarefas.
-- ------------------------------------------------------------

create or replace function eempresa.trg_lista5_q28()
returns trigger
language plpgsql
as $$
begin
 	delete from eempresa.tarefa
	where pcodigo = old.pcodigo;
	return old;

end;
$$;

create trigger exclui_tarefas
before delete on eempresa.projeto
for each row 
execute function eempresa.trg_lista5_q28();

-- ------------------------------------------------------------
-- 2.9 Crie uma trigger para que sempre que seja cadastrado
--     um novo empregado, seja alocado para ele uma tarefa
--     de 20 horas no projeto com menor número de horas.
-- ------------------------------------------------------------


create or replace function eempresa.trg_aloca_tarefa()
returns trigger
language plpgsql
as $$
declare
	projeto_encontrado varchar;
begin
    -- Encontra o projeto com menor total de horas
	select pcodigo
	into projeto_encontrado
	from eempresa.tarefa
	group by pcodigo
	order by sum(horas)
	limit 1;

    -- Aloca o novo empregado nesse projeto com 20 horas
	insert into eempresa.tarefa (cpf, pcodigo, horas)
	values (new.cpf, projeto_encontrado, 20);

	return new;
end;
$$;

create trigger aloca_tarefa
after insert on eempresa.empregado
for each row
execute function eempresa.trg_aloca_tarefa();

select * from eempresa.tarefa

SELECT pcodigo, SUM(horas)
FROM eempresa.tarefa
GROUP BY pcodigo;

INSERT INTO eempresa.empregado
(enome, cpf, endereco, nasc, sexo, salario, chefe, cdep)
VALUES
('Teste Trigger2', '7777', 'Rua X', '2000-01-01', 'M', 5000, '8765', 3);

SELECT *
FROM eempresa.tarefa
WHERE cpf = '7777';


-- ============================================================
-- 3. IMPLEMENTE AS REGRAS DE NEGÓCIO UTILIZANDO TRIGGERS
-- ============================================================


-- ------------------------------------------------------------
-- 3.a Todo e qualquer departamento deve possuir uma unidade
--     na cidade de “Fortaleza”.
-- ------------------------------------------------------------

create or replace function eempresa.lista5_3a()
returns trigger
language plpgsql
as $$
begin
	if not exists(
		select 1
		from eempresa.dunidade
		where dcodigo = new.codigo
		and dcidade = 'Fortaleza'

	) then
	raise exception 'Dept.não possui unidade em Fortaleza';

	end if;
return new;
end;
$$;


create trigger trg_lista5_q3a
before insert or update
on eempresa.departamento
for each row
execute function eempresa.lista5_3a();


-- ------------------------------------------------------------
-- 3.b Um empregado não pode ter salário maior que o do
--     seu gerente.
-- ------------------------------------------------------------

create or replace function eempresa.lista5_3b()
returns trigger
language plpgsql
as $$
declare
	salario_chefe numeric;
begin
	if new.chefe is not null then
		select salario into salario_chefe
		from eempresa.empregado
		where cpf = new.chefe;

		if new.salario > salario_chefe then
			raise exception 'salario não deve ultrapassar o do chefe';
		end if;
	end if;

	return new;
end;
$$;

create or replace trigger trg_salario_chefe
before insert or update on eempresa.empregado
for each row
execute function eempresa.lista5_3b

-- ------------------------------------------------------------
-- 3.c Cada empregado não pode trabalhar mais do que 40 horas.
-- ------------------------------------------------------------

create or replace function eempresa.lista5_3c()
returns trigger
language plpgsql
as $$
declare soma_horas numeric;
begin
	select sum(horas) + new.horas
	into soma_horas
	from eempresa.tarefa
	where cpf = new.cpf;

	if soma_horas > 40 then
		raise exception 'Empregado não pode ter mais do que 40 horas';
	end if;

	return new;
end;
$$;

create or replace trigger trg_hora_max
before insert or update on eempresa.tarefa
for each row
execute function eempresa.lista5_3c();