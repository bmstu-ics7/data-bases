create database Multiplication

go

use Multiplication

go

create table Numbers (
    id int not null
)

go

insert into Numbers values
    (1),
    (5),
    (10),
    (-4),
    (0)

go

select iif(result = -0, 0, result) as result from (
   select exp(sum(log(iif(id > 0, id, iif(id <> 0, -id, 1))))) *
          power(-1, sum(iif(id < 0, 1, 0))) *
          iif(sum(iif(id = 0, 1, 0)) > 0, 0, 1)
              as result
   from Numbers
) as num
