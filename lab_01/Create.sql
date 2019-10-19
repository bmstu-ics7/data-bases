create database StarSkyDB

go

use StarSkyDB

go

create schema Stars

go

-- Созвездия
create table Stars.Constellations(
    ConstellationId int identity(1,1)  not null,
    CName           varchar(40)       not null
)

go

-- Ученые
create table Stars.Scientists(
    ScientistId     int identity(1,1) not null,
    SName           varchar(40)      not null,
    Century         int               not null
)

go

-- Страны
create table Stars.Countries(
    CountryId       int identity(1,1) not null,
    CName           varchar(50)       not null
)

go

-- Звезды
create table Stars.Stars(
    StarId          int identity(1,1) not null,
    Letter          varchar(20)       not null,
    SName           varchar(20)       not null,
    RightAscension  float             not null,
    Declination     float             not null,
    SeeStarValue    float             null,
    Color           varchar(30)       not null,
    ConstellationId int               not null
)

go

-- Дополнительная информация о звезде
create table Stars.ExtraInfo(
    StarId          int                not null,
    TypeStar        varchar(10)        null,
    Distance        int                null,
    Mass            int                null,
    Radius          bigint             null,
    AbsStarValue    float              null,
    Temperature     int                null,
    ScientistId     int                null
)

go

-- В каких странах какие звезды видны
create table Stars.CountriesStars(
    StarId          int                not null,
    CountryId       int                not null,
    DaysInYear      int                not null
)

go

alter table Stars.Constellations add
    constraint PKConstellation      primary key(ConstellationId),
    constraint UKConstellation      unique(CName)

go

alter table Stars.Scientists add
    constraint PKScientist          primary key(ScientistId),
    constraint UKScientist          unique(SName),
    constraint CenturyCheck         check(Century between -10 and 21)

go

alter table Stars.Countries add
    constraint PKCountries          primary key(CountryId),
    constraint UKCountry            unique(CName)

go

alter table Stars.Stars add
    constraint PKStar               primary key(StarId),
    constraint UKStar               unique(SName),
    constraint FKStarsConstellation foreign key(ConstellationId) references Stars.Constellations(ConstellationId),
    constraint ColorCheck           check(Color = 'White' or
                                          Color = 'Orange' or
                                          Color = 'Red' or
                                          Color = 'Blue' or
                                          Color = 'Yellow')

go

alter table Stars.ExtraInfo add
    constraint PKExtra              primary key(StarId),
    constraint FKExtraInfoStars     foreign key(StarId) references Stars.Stars(StarId),
    constraint FKExtraInfoScientist foreign key(ScientistId) references Stars.Scientists(ScientistId),
    constraint TypeCheck            check(TypeStar = 'Dwarf' or
                                          TypeStar = 'Giant' or
                                          TypeStar = 'Supernova' or
                                          TypeStar = 'Hypernova')

go

alter table Stars.CountriesStars add
    constraint FKCountriesStars     foreign key(StarId) references Stars.Stars(StarId),
    constraint FKStarsCountries     foreign key(CountryId) references Stars.Countries(CountryId),
    constraint DaysCheck            check(DaysInYear between 1 and 365)

go

bulk insert Stars.Constellations from '\Constellations.csv'
with(
    fieldterminator = ';',
    rowterminator = '0x0a',
    check_constraints
    );

go

bulk insert Stars.Scientists from '\Scientists.csv'
with(
    fieldterminator = ';',
    rowterminator = '0x0a',
    check_constraints
    );

go

bulk insert Stars.Countries from '\Countries.csv'
with(
    fieldterminator = ';',
    rowterminator = '0x0a',
    check_constraints
    );

go

bulk insert Stars.Stars from '\Stars.csv'
with(
    fieldterminator = ';',
    rowterminator = '0x0a',
    check_constraints
    );

go

bulk insert Stars.ExtraInfo from '\ExtraInfo.csv'
with(
    fieldterminator = ';',
    rowterminator = '0x0a',
    check_constraints
    );

go

bulk insert Stars.CountriesStars from '\CountriesStars.csv'
with(
    fieldterminator = ';',
    rowterminator = '0x0a',
    check_constraints
    );
