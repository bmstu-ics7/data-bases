create database Chill

go

use Chill

go

create table Worker (
    Id          int identity(1,1)   not null,
    Name        varchar(20)         not null
)

go

create table Vacation (
    Id          int identity(1,1)   not null,
    IdWorker    int                 not null,
    Date        date                not null,
    Type        int                 not null
)

go

create table TypeVacation (
    Id          int identity(1,1)   not null,
    Type        varchar(20)         not null
)

go

alter table Worker add
    constraint PKWorker             primary key(Id)

go

alter table TypeVacation add
    constraint PKTypeVacation       primary key(Id)

go

alter table Vacation add
    constraint PKVacation           primary key(Id),
    constraint FKVacationWorker     foreign key(IdWorker) references Worker(Id),
    constraint FKVacationType       foreign key(Type) references TypeVacation(Id)

go

insert into Worker
values
    ('Alex'),
    ('Julia')

select * from Worker

go

insert into TypeVacation
values
    ('Own cash'),
    ('Pay chill'),
    ('Illness')

select * from TypeVacation

go

insert into Vacation
values
    (1, '2020-01-20', 1),
    (1, '2020-01-21', 1),
    (1, '2020-01-22', 1),
    (1, '2020-01-23', 2),
    (1, '2020-01-25', 3),
    (1, '2020-01-26', 3),
    (2, '2020-01-22', 2),
    (2, '2020-01-23', 2),
    (2, '2020-01-24', 2),
    (2, '2020-01-25', 2),
    (2, '2020-01-26', 2),
    (1, '2020-01-28', 1),
    (1, '2020-01-29', 1)

go

with tmp
as
(
    select *,
        lag(date)  over(partition by IdWorker, Type order by date) as PrevDate,
        lead(date) over(partition by IdWorker, Type order by date) as NextDate,
        count(*)   over(partition by IdWorker, Type order by date) as c
    from Vacation
)
select W.Name, T.Type, fromdate, todate
from
(
    select T1.IdWorker, T1.Type, T1.Date as "fromdate", T2.Date as "todate"
    from tmp T1 join tmp T2 on T1.IdWorker = T2.IdWorker and T1.Type = T2.Type
    where (T1.PrevDate is null or datepart(day, T1.Date) - datepart(day, T1.PrevDate) > 1) and
        (T2.NextDate is null or datepart(day, T2.NextDate) - datepart(day, T2.Date) > 1) and
        (datepart(day, T1.Date) <= datepart(day, T2.Date)) and
        (datepart(day, T2.Date) - datepart(day, T1.Date) <= T2.c)
) as TMP join Worker W on TMP.IdWorker = W.Id
join TypeVacation T on TMP.Type = T.Id

go

use master

go

drop database Chill
