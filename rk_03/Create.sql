create database RK3

go

use RK3

go

create table Office (
    Id              int identity(1,1)   not null,
    Name            varchar(20)         not null,
    Adress          varchar(20)         not null,
    Telephone       varchar(20)         not null
)

go

create table Worker (
    Id              int identity(1,1)   not null,
    Name            varchar(20)         not null,
    Birthday        date                not null,
    Department      varchar(20)         not null,
    OfficeId        int                 not null
)

go

insert Office
values
    ('Mocsow', 'pr-t World, 5', '456-78-23'),
    ('Novosib', 'kek street, 10', '543-62-34'),
    ('Saratov', 'Syhova street, 44', '452-56-11'),
    ('Tomsk', 'Gercen, 7', '987-46-74')

select * from Office

go

insert Worker
values
    ('Ivanov', '1990-09-25', 'IT', 1),
    ('Petrov', '1987-11-12', 'Money', 3)

select * from Worker

go

create procedure dbo.MinOffice
as
select O.Name
from Worker W join Office O on W.OfficeId = O.Id
group by O.Id, O.Name
having count(*) in (
    select min(Count) as Count
    from (
        select count(W.Id) as "Count"
        from Worker W join Office O on W.OfficeId = O.Id
        group by O.Id, O.Name
) as result )

go

exec dbo.MinOffice
