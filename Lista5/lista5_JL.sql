-- ============================================================
-- LISTA 5 — PROCEDURES E TRIGGERS
-- ============================================================

-- ============================================================
-- 2. FAÇA O QUE SE PEDE
-- ============================================================


-- ------------------------------------------------------------
-- 2.1 Crie um procedimento para cadastrar um empregado.
-- ------------------------------------------------------------
create or replace function eempresa.lista5_q21 ()



-- ------------------------------------------------------------
-- 2.2 Crie um procedimento que recebe como parâmetro:
--     - CPF de um empregado
--     - Número de horas
-- E insere uma tupla em Tarefa para cada projeto
-- (para este empregado e número de horas).
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 2.3 Crie um procedimento que retorne o CPF do empregado
--     com maior salário.
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 2.4 Crie um procedimento que recebe como parâmetro
--     o código de um departamento e retorna o CPF
--     do empregado deste departamento com maior salário.
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 2.5 Crie um procedimento que recebe como parâmetro
--     o código de um projeto e retorna o total de horas
--     deste projeto.
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 2.6 Crie um procedimento que recebe como parâmetro
--     a taxa de aumento de salário e atualiza o salário
--     de todos os empregados com esta taxa.
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 2.7 Crie uma trigger para impedir que seja excluído
--     um empregado que ainda esteja alocado em alguma tarefa.
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 2.8 Crie uma trigger para que sempre que seja excluído
--     um projeto sejam automaticamente excluídas
--     todas as suas tarefas.
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 2.9 Crie uma trigger para que sempre que seja cadastrado
--     um novo empregado, seja alocado para ele uma tarefa
--     de 20 horas no projeto com menor número de horas.
-- ------------------------------------------------------------




-- ============================================================
-- 3. IMPLEMENTE AS REGRAS DE NEGÓCIO UTILIZANDO TRIGGERS
-- ============================================================


-- ------------------------------------------------------------
-- 3.a Todo e qualquer departamento deve possuir uma unidade
--     na cidade de “Fortaleza”.
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 3.b Um empregado não pode ter salário maior que o do
--     seu gerente.
-- ------------------------------------------------------------




-- ------------------------------------------------------------
-- 3.c Cada empregado não pode trabalhar mais do que 40 horas.
-- ------------------------------------------------------------
