use StarSkyDB

create table Constellation (
	ConstellationId	int identity(1, 1),
	CName			varchar (100) not null
)

go

create table Scientist (
	SName		varchar (100)		not null,
	ScientistId	int identity(1, 1),
	YearsLive	int					not null
)

go

create table Star (
	StarId			int identity(1, 1),
	Letter			varchar (20)		not null,
	SName			varchar (20)		not null,
	RightAscension	float				not null,
	Declination		float				not null,
	SeeStarValue	float				null,
	Color			varchar (20)		not null,
	ConstellationId	int					not null
)

go

create table ExtraInfo (
	StarId			int				not null,
	TypeStar		varchar (10)	null,
	Distance		int				null,
	Mass			int				null,
	Radius			bigint			null,
	AbsStarValue	float			null,
	Temperature		int				null,
	ScientistId		int				null
)