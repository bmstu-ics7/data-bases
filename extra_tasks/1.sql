create database Multiplication

go

use Multiplication

go

drop table Numbers

go

create table Numbers (
    id int not null
)

go

insert into Numbers values
    (5),
    (-1),
    (8)

go

select exp(sum(log(iif(id > 0, id, iif(id <> 0, -id, 1))))) *
        iif(sum(iif(id = 0, 1, 0)) > 0, 0, 1) *
        power(-1, sum(iif(id < 0, 1, 0)))
            as result
from Numbers
