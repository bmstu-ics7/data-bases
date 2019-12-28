use StarSkyDB
go

select *
from Stars.Scientists
where Century = 21
for XML raw
go

select *
from Stars.Scientists
where Century = 21
for XML auto
go

select *
from Stars.Scientists
where Century = 21
for XML explicit
go

select *
from Stars.Scientists
where Century = 21
for XML path
go

declare @idoc int
declare @doc xml
select @doc = Scientists from openrowset(bulk "/document.xml", single_blob) as temp(Scientists)
exec sp_xml_preparedocument @idoc OUTPUT, @doc
insert into Stars.Scientists
select *
from openxml(@idoc, '/Stars/Scientists', 1)
with Stars.Scientists
go

select * from Stars.Scientists
where Century = 21
