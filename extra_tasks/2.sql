create database Names

go

create table Table1 (
    id          int         not null,
    var1        varchar(10) not null,
    valid_from  date        not null,
    valid_to    date        not null
)

go

create table Table2 (
    id          int         not null,
    var2        varchar(10) not null,
    valid_from  date        not null,
    valid_to    date        not null
)

go

insert into Table1 values
    (1, 'A', '2018-09-01', '2018-09-15'),
    (1, 'B', '2018-09-16', '5999-12-31'),
    (2, 'A', '2016-09-01', '2017-09-14'),
    (2, 'B', '2017-09-15', '2018-09-16'),
    (2, 'C', '2018-09-17', '5999-12-31'),
    (10, 'A', '2018-01-01', '2019-01-01'),
    (10, 'B', '2019-01-01', '2019-01-01'),
    (10, 'C', '2019-01-01', '5999-12-31')


insert into Table2 values
    (1, 'A', '2018-09-01', '2018-09-18'),
    (1, 'B', '2018-09-19', '5999-12-31'),
    (2, 'A', '2016-09-01', '2016-09-18'),
    (2, 'B', '2016-09-19', '2018-03-19'),
    (2, 'C', '2018-03-20', '2018-09-19'),
    (2, 'D', '2018-09-19', '5999-12-31'),
    (10, 'A', '2018-01-01', '2020-01-01'),
    (10, 'B', '2020-02-01', '5999-12-31')

go

select * from Table1
select * from Table2

select *
from (
    select T1.id, T1.var1, T2.var2,
        case
            when T1.valid_from > T2.valid_from then T1.valid_from
            else T2.valid_from
        end as valid_from,
        case
            when T1.valid_to < T2.valid_to then T1.valid_to
            else T2.valid_to
        end as valid_to
    from Table1 T1 join Table2 T2 on T1.id = T2.id
) as result
where valid_from <= valid_to

go

drop table Table1

go

drop table Table2

go

use master

go

drop database Names
