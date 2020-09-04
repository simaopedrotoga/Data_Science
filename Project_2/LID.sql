-- LID
-- Q1 - Somente para os casos em que o total da soma do valor ganho de cada fabricante
-- é superior à média do total da soma do valor ganho de todos os fabricantes, 
-- qual o fabricante que tem o maior valor? Indique o nome e o máximo.
create view fabricante_maior_valor as (select nome_fabricante, soma as valor from (select f.nome_fabricante, (sum(v.valor_venda) - sum(a.desconto)) - sum(a.valor_custo) as soma
                                                                                    from fabricantes f natural join vendas v natural join automoveis a
                                                                                    group by f.nome_fabricante
                                                                                    having (sum(v.valor_venda) - sum(a.desconto)) - sum(a.valor_custo) > (select avg(soma) from (select f.nome_fabricante, (sum(v.valor_venda) - sum(a.desconto)) - sum(a.valor_custo) as soma
                                                                                                                                                                                 from fabricantes f natural join vendas v natural join automoveis a
                                                                                                                                                                                 group by f.nome_fabricante)))
                                      where soma = (select max(soma) as maximo from (select f.nome_fabricante, (sum(v.valor_venda) - sum(a.desconto)) - sum(a.valor_custo) as soma
                                                                                    from fabricantes f natural join vendas v natural join automoveis a
                                                                                    group by f.nome_fabricante
                                                                                    having (sum(v.valor_venda) - sum(a.desconto)) - sum(a.valor_custo) > (select avg(soma) from (select f.nome_fabricante, (sum(v.valor_venda) - sum(a.desconto)) - sum(a.valor_custo) as soma
                                                                                                                                                                                 from fabricantes f natural join vendas v natural join automoveis a
                                                                                                                                                                                 group by f.nome_fabricante)))));
select * from fabricante_maior_valor;

-- Q2 - Para cada ano, para cada estado, quantas vendas foram feitas e qual o valor total ganho somente para o fabricante que tem o maior valor? Indique o ano, estado, numero de vendas e respetivo valor total.                                                                                                                                                                             
select extract(year from v1.data) as ano, c1.estado, count(*) as numero_de_vendas, sum(v1.valor_venda) as valor
from vendas v1 natural join clientes c1 natural join fabricantes f1
where extract(year from v1.data) in (select extract(year from v2.data) from vendas v2
                                   where extract(year from v2.data) = extract(year from v1.data)) and c1.estado in (select c2.estado from clientes c2
                                                                                                                   where c2.estado = c1.estado) and f1.nome_fabricante = (select nome_fabricante from fabricante_maior_valor)
group by extract(year from v1.data), c1.estado
order by extract(year from v1.data), sum(v1.valor_venda) desc;

-- Q3 - De todos os clientes, quais foram aqueles que compraram, pelo menos, um carro a todos os fabricantes e voltaram a comprar a, pelo menos, um fabricante? Indique quais os clientes e valor total gasto.
select nome_cliente, valor 
from ((select distinct nome_cliente from clientes
       minus
       select distinct nome_cliente cliente from (select nome_fabricante, nome_cliente from (select distinct nome_fabricante from fabricantes), (select distinct nome_cliente from clientes)
                                                  minus
                                                  select  nome_fabricante, nome_cliente from (select nome_fabricante, nome_cliente
                                                                                              from clientes natural join vendas natural join fabricantes)))
                                                  intersect
                                                  (select distinct nome_cliente from (select nome_fabricante, nome_cliente, count(*) as quantidade_comprada
                                                                                      from clientes natural join vendas natural join fabricantes
                                                                                      group by nome_fabricante, nome_cliente
                                                                                      having count(*) >= 2))) natural join (select c.nome_cliente, sum(v.valor_venda) - sum(a.desconto) as valor
                                                                                                                            from clientes c natural join vendas v natural join automoveis a
                                                                                                                            group by c.nome_cliente)
order by valor desc;

-- Q4 - Crie uma nova coluna com a soma do custo de entrega e mão de obra em termos qualitativos. Calcule a frequência para cada categoria. 
select categoria, count(*) as frequencia from (select extract(year from data) as ano, estado, nome_fabricante, modelo, nome_cliente,
                                              case 
                                                when custo_entrega + custo_mao_de_obra <= 0.009 * valor_custo 
                                                    then '1. Muito baixo'
                                                when custo_entrega + custo_mao_de_obra > 0.00 * valor_custo and custo_entrega + custo_mao_de_obra <= 0.04 * valor_custo 
                                                    then '2. Baixo'
                                                when custo_entrega + custo_mao_de_obra > 0.04 * valor_custo and custo_entrega + custo_mao_de_obra <= 0.08 * valor_custo 
                                                    then '3. Normal'
                                                when custo_entrega + custo_mao_de_obra > 0.08 * valor_custo and custo_entrega + custo_mao_de_obra <= 0.12 * valor_custo then 
                                                    '4. Elevado'
                                                else 
                                                    '5. Muito elevado' 
                                                    end as categoria
                                                from fabricantes natural join vendas natural join clientes natural join automoveis)
group by categoria
order by categoria;

-- Q5 - Sabendo que os modelos mais atuais dos dois fabricantes com mais modelos têm como nome "DB9" e "Wraith", ordene a lista dos carros mais atuais dos dois fabricantes que têm mais modelos da cor que tenha como início da palavra a letra "V".
-- Criar tabela 
create table Modelos as select distinct modelo as nome_modelo from automoveis
                        where modelo in (select modelo from (select f.nome_fabricante, a.modelo
                                                             from fabricantes f natural join vendas natural join automoveis a
                                                             group by f.nome_fabricante, a.modelo
                                                             having f.nome_fabricante in (select nome_fabricante from (select nome_fabricante, count(modelo) as quantidade from (select f.nome_fabricante, a.modelo
                                                                                                                                                                                 from fabricantes f natural join vendas natural join automoveis a
                                                                                                                                                                                 group by f.nome_fabricante, a.modelo)
                                                                                                                       group by nome_fabricante
                                                                                                                       order by count(modelo) desc)
                                                                                          where rownum <= 2)
                                                                                          order by f.nome_fabricante, a.modelo))
                        order by modelo;
-- Criar sequência
create sequence num_id start with 1 increment by 1;

-- Complementar a tabela
alter table Modelos add modelo_id number(10) default num_id.nextval;
alter table Modelos add modelo_anterior_id number(10);
alter table Modelos add constraint restricao_modelo_id primary key (modelo_id);
alter table Modelos add constraint restricao_modelo_id_2 foreign key (modelo_anterior_id) references Modelos(modelo_id);
alter table Modelos add constraint restricao_nome_modelo unique (nome_modelo);

-- Atualizar a tabela
update modelos set modelo_anterior_id = 11 where modelo_id = 5;
update modelos set modelo_anterior_id = 12 where modelo_id = 11;
update modelos set modelo_anterior_id = 14 where modelo_id = 12;
update modelos set modelo_anterior_id = 2 where modelo_id = 14;
update modelos set modelo_anterior_id = 10 where modelo_id = 2;
update modelos set modelo_anterior_id = 4 where modelo_id = 10;
update modelos set modelo_anterior_id = 3 where modelo_id = 4;

update modelos set modelo_anterior_id = 7 where modelo_id = 13;
update modelos set modelo_anterior_id = 6 where modelo_id = 7;
update modelos set modelo_anterior_id = 8 where modelo_id = 6;
update modelos set modelo_anterior_id = 1 where modelo_id = 8;
update modelos set modelo_anterior_id = 9 where modelo_id = 1;
commit;

-- Consulta hierárquica
select distinct modelo, cor 
from (select nome_modelo as modelo from modelos
      start with nome_modelo = 'DB9'
      connect by modelo_id = prior modelo_anterior_id) natural join (select * from automoveis)
where cor like 'V%'
order by modelo, cor;

select distinct modelo, cor 
from (select nome_modelo as modelo from modelos
      start with nome_modelo = 'Wraith'
      connect by modelo_id = prior modelo_anterior_id) natural join (select * from automoveis)
where cor like 'V%'
order by modelo, cor;

-- Q6 - Quais foram os top 3 fabricantes que mais arrecadaram por ano?
select * from (select nome_fabricante, ano, soma,
              rank() over(partition by ano order by soma desc) posicao
              from (select nome_fabricante, extract(year from data) as ano, sum(valor_venda) as soma
                    from fabricantes natural join vendas
                    group by nome_fabricante, extract(year from data)))
where posicao <=3;