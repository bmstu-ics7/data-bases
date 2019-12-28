-- Степанов Александр ИУ7-53Б
-- Вариант 1

create database RK2

go

use RK2

go

-- Сотрудник
create table Employee(
    Id          int identity(1,1)  not null,
    Name        varchar(20)        not null,
    Year        int                not null,
    Position    varchar(20)        not null
)

go

-- Виды валют
create table Currency(
    Id          int identity(1,1)  not null,
    Name        varchar(20)        not null
)

go

-- Курсы валют
create table Courses(
    Id          int identity(1,1)  not null,
    Sale        int                not null,
    Purchase    int                not null
)

go

-- Операция обмена
create table Trade(
    Id          int identity(1,1)  not null,
    EmployeeId  int                not null,
    CourseId    int                not null,
    Sum         int                not null
)

go

-- Курсы валют к валютам
create table CoursesCurrently(
    CourseId    int               not null,
    CurrencyId  int               not null
)

go

alter table Employee add
    constraint PKEmployee primary key(id)


go

alter table Currency add
    constraint PKCurrency primary key(id)

go

alter table Courses add
    constraint PKCourses primary key(id)

go

alter table Trade add
    constraint PKTrade primary key(id),
    constraint FKTradeEmployee foreign key(EmployeeId) references Employee(Id),
    constraint FKTradeCourse foreign key(CourseId) references Courses(Id)

go

alter table CoursesCurrently add
    constraint FKCourse foreign key(CourseId) references Courses(Id),
    constraint FKCurrency foreign key(CurrencyId) references Currency(Id)

go

insert Employee (Name, Year, Position)
values
    ('Alex', 1999, 'Cassier'),
    ('Dima', 1990, 'Cassier'),
    ('Andrey', 1900, 'Director'),
    ('Nastya', 2000, 'Cassier'),
    ('Vanya', 2001, 'Trainee')

go

select * from Employee

go

insert Currency (Name)
values
    ('Rub'),
    ('USD'),
    ('UK'),
    ('AUS'),
    ('Bel')

go

select * from Currency

go

insert Courses (Sale, Purchase)
values
    (1, 2),
    (60, 65),
    (80, 85),
    (30, 38),
    (10, 13)

go

select * from Courses

go

insert Trade (EmployeeId, CourseId, Sum)
values
    (1, 5, 500),
    (1, 4, 200),
    (2, 5, 450),
    (4, 3, 70),
    (2, 1, 10)

go

select * from Trade

go

insert CoursesCurrently (CourseId, CurrencyId)
values
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1)

go

select * from CoursesCurrently

go

-- SELECT с CASE
-- Вывод зарплаты каждого сотрудника
select Name, Year,
    case Position
        when 'Director' then 100000000000
        when 'Cassier'  then 100000
        when 'Trainee'  then 1
        else 'Unknown'
    end as 'Salary'
from Employee

go

-- Оконную функцию
-- Вывести сколько в сумме обменял каждый сотрудник, который хоть что-то обменял
select S.EmployeeId, E.Name, S.Sum
from Employee E join
(
    select
        EmployeeId,
        sum(Sum) over(partition by EmployeeId) as Sum,
        row_number() over(partition by EmployeeId order by EmployeeId) as n
    from Trade
) S on E.Id = S.EmployeeId
where n = 1

go

-- GROUP BY и HAVING
-- Вывести имена сотрудников, совершивших больше 1 трейда
select E.Id, E.Name, C.CountTrades
from Employee E join
(
    select Em.Id, count(Tr.Id) as CountTrades
    from Employee Em join Trade Tr on Em.Id = Tr.EmployeeId
    group by Em.Id
    having count(Tr.Id) > 1
) C on E.Id = C.Id

go

-- Хранимая процедура
create procedure dbo.ProcSave
as
begin
    declare @databasename varchar(20)
    set @databasename = db_name()

    declare @filename varchar(20)
    set @filename = db_name() + '_' + format(getdate(), 'yyyyddMM') + '.bak'

    backup database @databasename
    to disk = @filename
end

go

exec ProcSave

go

use master

go

drop database RK2
