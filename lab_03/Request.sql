use StarSkyDB

go

-------------------------------------- ФУНКЦИИ --------------------------------------

-- 1) Скалярная функция
-- Определеяет по склонению звезды в каком полушарии она находится
create function dbo.Hemisphere(@Declination as float)
returns varchar(10)
begin
    if @Declination between 0 and 90 return "Noth"
    return "South"
end

go

select SName, dbo.Hemisphere(Declination) as Hemisphere
from Stars.Stars

go

-- 2) Подставляемая таблтчная функция
-- Получить список звезд в созвездии
create function dbo.StarsInConstellation(@Constellation as varchar(50))
returns table
return
select S1.StarId, S1.SName, S2.CName
from Stars.Stars S1 join Stars.Constellations S2 on S1.ConstellationId = S2.ConstellationId
where CName = @Constellation

go

select * from dbo.StarsInCOnstellation('Andromeda')
select * from dbo.StarsInCOnstellation('Unicorn')
select * from dbo.StarsInCOnstellation('Dragon')
select * from dbo.StarsInCOnstellation('Clock')

go

-- 3) Многооператорная табличная функция
-- Получить список звезд, открытых между веками
create function dbo.DiscoverBetween(@First as int, @Second as int)
returns @StarName table (
    StarId int primary key not null,
    SName  varchar(20)     not null
)
begin
    insert @StarName
    select S1.StarId, S1.SName
    from Stars.Stars S1 join Stars.ExtraInfo S2 on S1.StarId = S2.StarId
    join Stars.Scientists S3 on S2.ScientistId = S3.ScientistId
    where S3.Century between @First and @Second
    return
end

go

select * from dbo.DiscoverBetween(20, 21)
select * from dbo.DiscoverBetween(12,15)
select * from dbo.DiscoverBetween(-3, -1)

go

-- 4) Рекурсивная функция или функция с рекурсивным ОТВ
-- Вычисляет сумму масс звезд в таблице между @CurrentId и @EndId
create function dbo.SumMass(@CurrentId as int, @EndId as int)
returns int
begin
    if @CurrentId > @EndId return 0
    declare @mass int
    set @mass = (select Mass from Stars.ExtraInfo where StarId = @CurrentId)
    return @mass + dbo.SumMass(@CurrentId + 1, @EndId)
end

go

select dbo.SumMass(1, 10) as 'Sum of mass'
select dbo.SumMass(50, 73) as 'Sum of mass'
select dbo.SumMass(326, 327) as 'Sum of mass'

go

------------------------------------- ПРОЦЕДУРЫ -------------------------------------

-- 1) Хранимая процедура без параметров или с параметрами
-- Выводит все звезды данного типа
create procedure dbo.SelectStarsOfType(@TypeStar as varchar(20))
as
select S1.StarId, S1.SName, S2.TypeStar, S2.Mass, S1.Color, S3.CName
from Stars.Stars S1 join Stars.ExtraInfo S2 on S1.StarId = S2.StarId
join Stars.Constellations S3 on S1.ConstellationId = S3.ConstellationId
where S2.TypeStar = @TypeStar

go

exec dbo.SelectStarsOfType 'Dwarf'
exec dbo.SelectStarsOfType 'Giant'
exec dbo.SelectStarsOfType 'Supernova'
exec dbo.SelectStarsOfType 'Hypernova'

go

-- 2) Рекурсивная хранимая процедура
-- Выводит таблицы с именами звезд с конкретными массами от @CurrentMass до @EndMass
create procedure dbo.FindMasses(@CurrentMass as int, @EndMass as int)
as
begin
    if @CurrentMass > @EndMass return
    select S1.SName, S2.Mass
    from Stars.Stars S1 join Stars.ExtraInfo S2 on S1.StarId = S2.StarId
    where S2.Mass = @CurrentMass
    set @CurrentMass = @CurrentMass + 1
    exec dbo.FindMasses @CurrentMass, @EndMass
end

go

exec dbo.FindMasses 1, 10

go

-- 3) Хранимая процедура с курсором
-- Выводит имена всех звезд
create procedure dbo.PrintNames
as
begin
    declare @CurrentName varchar(50)
    declare @Count int
    set @Count = 0

    declare cur cursor
        local
        forward_only
        static
    for
        select SName from Stars.Stars

    open cur
    while @Count < 420
    begin
        fetch cur into @CurrentName
        print @CurrentName
        set @Count = @Count + 1
    end
    close cur
    deallocate cur
end

go

exec PrintNames

go

-- 4) Хранимая процедура доступа к метаданным
--
create procedure dbo.MetaData
as
begin
    select * from information_schema.tables
end

go

exec dbo.MetaData

go

------------------------------------- ТРИГГЕРЫ -------------------------------------

-- 1) Триггер arfter
-- После вставки новой строки, выводит всю таблицу
create trigger AddStars
on Stars.Stars
after insert
as
select *
from inserted

go

insert Stars.Stars(Letter, SName, RightAscension, Declination, SeeStarValue, Color, ConstellationId)
values
    ('asdsadasd', 'sadasdasd', 12, 12, 2, 'Red', 30)

go

-- 2) Триггер instead of
-- Вместо уаления строки, выводит всю страницу
create trigger DeleteStars
on Stars.Stars
instead of delete
as
select *
from deleted

go

delete Stars.Stars
where StarId = 420
