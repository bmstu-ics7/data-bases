use StarSkyDB
go

select *
from Stars.Stars
for xml auto
go

create procedure dbo.CountStarsOfType @TypeStar as varchar(20),
    @Count int out
as
select @Count = count(*)
from Stars.ExtraInfo
where TypeStar = @TypeStar
go
