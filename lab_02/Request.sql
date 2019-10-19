use StarSkyDB

go

-- 1) Получить имена всех звезд типа карлик
select S1.SName, S2.TypeStar
from Stars.Stars S1 join Stars.ExtraInfo S2 on S1.StarId = S2.StarId
where S2.TypeStar = 'Dwarf'

-- 2) Получить имена ученых, живших между 10 и 12 веками
select SName, Century
from Stars.Scientists
where Century between 10 and 12

-- 3) Получить имена звезд, открытых учеными, у которых в имени есть 'alex'
select S1.SName as Star, S3.SName as Scientist
from Stars.Stars S1 join Stars.ExtraInfo S2 on S1.StarId = S2.StarId
join Stars.Scientists S3 on S2.ScientistId = S3.ScientistId
where S3.SName like '%alex%'

-- 4) Получить имена звезд, дистанция до которых больше 99000
select SName
from Stars.Stars
where StarId in
    (
        select StarId
        from Stars.ExtraInfo
        where Distance > 99000
    )

-- 5) Получить имена карликов, абсолютная звездная велечина которых неизвестена
select S1.StarId, S1.SName, S2.TypeStar, S2.AbsStarValue
from Stars.Stars S1 join Stars.ExtraInfo S2 on S1.StarId = S2.StarId
where S2.TypeStar = 'Dwarf' and exists
    (
        select S3.StarId
        from Stars.Stars S3 join Stars.ExtraInfo S4 on S3.StarId = S4.StarId
        where S4.AbsStarValue is null and S3.StarId = S1.StarId
    )

-- 6) Получить имена звезд, которые меньше всех гигантов
select S1.Sname, S2.Mass
from Stars.Stars S1 join Stars.ExtraInfo S2 on S1.StarId = S2.StarId
where S2.Mass < all
    (
        select Mass
        from Stars.ExtraInfo
        where TypeStar = 'Giant'
    )

-- 7) Среднее значение массы всех звезд
select avg(Mass) as 'Average mass', sum(Mass) / count(*) as 'Calc it'
from Stars.ExtraInfo

-- 8) Получить средние значения масс для всех типов звезд
select
    (
        select avg(Mass)
        from Stars.ExtraInfo
        where TypeStar = 'Dwarf'
    ) as "Dwarf's average",
    (
        select avg(Mass)
        from Stars.ExtraInfo
        where TypeStar = 'Giant'
    ) as "Giant's average",
    (
        select avg(Mass)
        from Stars.ExtraInfo
        where TypeStar = 'Supernova'
    ) as "Sypernova's average",
    (
        select avg(Mass)
        from Stars.ExtraInfo
        where TypeStar = 'Hypernova'
    ) as "Hypernova's average"

-- 9) Получить имена карликов и их принадлежность к теплым или холодным цветам
select S1.SName, S1.Color,
    case S1.Color
        when 'White' then 'Cold'
        when 'Blue' then 'Cold'
        else 'Hot'
    end as Color
from Stars.Stars S1 join Stars.ExtraInfo S2 on S1.StarId = S2.StarId
where S2.TypeStar = 'Dwarf'

-- 10) Вывести имена ученых и их принадлежность к найшей эре
select SName as Scientist,
    case
        when Century < 0 then 'Before our era'
        else 'In out era'
    end as era
from Stars.Scientists

-- 11) Сохранить в локальную таблицу для каждой звезды, в скольких странах ее видно
select StarId, count(*) as 'Count Countries'
into #CountCountries
from Stars.CountriesStars
group by StarId

select * from #CountCountries

-- 12) Получить имена звезд с самым большим радиусом и самым маленьким
select S1.SName, S2.Radius
from Stars.Stars S1 join
    (
        select top(1) StarId, Radius
        from Stars.ExtraInfo
        order by Radius desc
    ) S2 on S1.StarId = S2.StarId
union
select S1.SName, S2.Radius
from Stars.Stars S1 join
    (
        select top(1) StarId, Radius
        from Stars.ExtraInfo
        order by Radius asc
    ) S2 on S1.StarId = S2.StarId


-- 13) Вывести список стран, в которых видно Сириус
select CName
from Stars.Countries
where CountryId in
    (
        select CountryId
        from Stars.CountriesStars
        where StarId =
        (
            select StarId
            from Stars.ExtraInfo
            where StarId =
            (
                select StarId
                from Stars.Stars
                where SName = 'Sirius'
            )
        )
    )

-- 14) Вывести сколько звезд видно в каждой стране
select C1.CName, Stars
from Stars.Countries C1 join
    (
        select Stars.CountriesStars.CountryId, count(*) as Stars
        from Stars.CountriesStars
        group by CountryId
    ) C2 on C1.CountryId = C2.CountryId

-- 15) Получить Id звезд, у которых кол-во стран выше среднего, и их среднюю видимость
select StarId, avg(DaysInYear) as 'Average see'
from Stars.CountriesStars
group by StarId
having count(CountryId) >
    (
        select avg(countries)
        from
            (
                select StarId, count(*) as countries
                from Stars.CountriesStars
                group by StarId
            ) as CountCountries
    )

-- 16) Добавление несуществующих ученых в таблицу ученых
insert Stars.Scientists (SName, Century)
values
    ('NotExists first', 21),
    ('NotExists second', 21),
    ('NotExists third', 21)

-- 17) Добавление видимости Сириуса в России на максимальное кол-во дней в году
insert Stars.CountriesStars (StarId, CountryId, DaysInYear)
select
    (
        select StarId
        from Stars.Stars
        where SName = 'Sirius'
    ),
    (
        select CountryId
        from Stars.Countries
        where CName like 'Russia%'
    ),
    (
        select max(DaysInYear)
        from Stars.CountriesStars
    )

-- 18) Добавить к радиусу всех Гиперновых 1
update Stars.ExtraInfo
set Radius = Radius + 1
where TypeStar = 'Hypernova'

-- 19) Ничего не делает
update Stars.ExtraInfo
set Mass =
    (
        select Mass
        from Stars.ExtraInfo
        where StarId = 10
    )
where StarId = 10

-- 20) Удалить всех несуществущих ученых
delete Stars.Scientists
where SName like 'NotExists%'

-- 21) Удалить записи видимости для звезд, которых видно меньше 5 дней
delete from Stars.CountriesStars
where StarId in
    (
        select StarId
        from Stars.CountriesStars
        where DaysInYear < 5
    )
    and CountryId in
    (
        select CountryId
        from Stars.CountriesStars
        where DaysInYear < 5
    )

go

-- 22) Среднее количество стран, в которых видно каждую звезду
with CC(StarId, CountCountries)
as
    (
        select StarId, count(*) as CountCountries
        from Stars.CountriesStars
        group by StarId
    )
select avg(CountCountries) as 'Average count countries'
from CC

go

-- 23) Вывести все имена созвездий с маленькой буквы большими
with AsciiCode as
    (
        select ascii('A') as code
    ),
RecursiveReplace(Name, Code, Replaced) as
    (
        select CName as Name,
            Code,
            replace(lower(left(Cname, 1)) + upper(substring(CName, 2, len(CName) - 1)), ' ' + char(Code), ' ' + char(Code)) as Replaced
            from AsciiCode, Stars.Countries

            union all

            select name,
                Code + 1 as Code,
                replace(Replaced, ' ' + char(Code + 1), ' ' + char(Code + 1)) as Replaced
            from RecursiveReplace
            where Code < ascii('Z')
    )
select Name, Replaced
from RecursiveReplace
where code = ascii('Z')

-- 24) Получить для каждого типа максимальную, среднюю и минимальную массу
select TypeStar,
    avg(Mass) over(partition by TypeStar) as AvgMass,
    max(Mass) over(partition by TypeStar) as MaxMass,
    min(Mass) over(partition by TypeStar) as MinMass
from Stars.ExtraInfo

-- 25) Устанить дубли в предыдущем выражении
select TypeStar, AvgMass, MaxMass, MinMass
from
    (
        select TypeStar,
            avg(Mass) over(partition by TypeStar) as AvgMass,
            max(Mass) over(partition by TypeStar) as MaxMass,
            min(Mass) over(partition by TypeStar) as MinMass,
            row_number() over(partition by TypeStar order by StarId) as n
        from Stars.ExtraInfo
    ) as Types
where n = 1
