-- LDD
-- Criar tabelas
create table Fabricantes(
    fabricante_id    number(10),
    nome_fabricante    varchar2(20)    not null,
    constraint restricao_fabricante_id primary key (fabricante_id),
    constraint restricao_nome_fabricante unique (nome_fabricante)
);

create table Clientes(
   cliente_id    number(10),
   nome_cliente    varchar(30)    not null,
   estado    varchar2(20)    not null,
   constraint restricao_cliente_id primary key (cliente_id),
   constraint restricao_nome_cliente unique (nome_cliente)
);

create table Automoveis(
    automovel_id    number(10),
    cor    varchar(20)    not null,
    modelo    varchar(20)    not null,
    valor_custo    number(10)    not null,
    custo_entrega    number(10)    not null,
    custo_mao_de_obra    number(10) not null,
    desconto    number(10)    not null,
    constraint restricao_automovel_id primary key (automovel_id)
);

create table Vendas(
    fabricante_id    number(10)    references Fabricantes(fabricante_id),
    cliente_id    number(10)    references Clientes(cliente_id),
    automovel_id    number(10)    references Automoveis(automovel_id),
    valor_venda    number(10)    not null,
    data    date    not null,
    constraint restricao_vendas primary key (fabricante_id, cliente_id, automovel_id)
);