-- 스칼라 함수
create function f_plus(
	@value1 int,
	@value2 int
)
returns int
as 
begin
declare @sum_value int
set @sum_value=(@value1+@value2)
return @sum_value
end;

go
select dbo.f_plus(12,14);

use study
go 
select * from stockprice;

select * from companyinfo;

create function f_return( -- 수익률 계산
	@startdate date,
	@enddate date,
	@id int
)
returns decimal(12,10)
as 
begin
declare @startprice numeric
declare @endprice numeric

set @startdate = (select min(date_) from stockprice where id = @id and date_>=@startdate)
set @enddate = (select max(date_) from stockprice where id = @id and date_<=@enddate)
set @startprice = (select close_ from stockprice where id = @id and date_=@startdate)
set @endprice = (select min(close_) from stockprice where id = @id and date_=@enddate)
return (@endprice/@startprice - 1.0)
end;

drop function f_return;

select *, dbo.f_return('2020-10-01', '2020-10-12', ID) "ret"
from companyinfo
order by "ret" desc;

-- 테이블 함수
create function f_info(
	@id int
)
returns table
as 
return(
	select R.FIN_NAME,
	       R.FIN_VAL,
		   R.FDATE,
		   R.FPRD,
		   A.NAME
	from companyinfo A
	     join IDMap I
			on A.ID = I.ID 
	     join Ratios R
			on I.FIN_ID=R.FIN_ID
	where A.ID=@id
)
go 
select *
from dbo.f_info(40853);

create function f_info2(
	@id int
)
returns @return_table table(
	FIN_NAME varchar(300), 
	FIN_VAL float,
	FDATE date,
	FPRD int,
	Name nvarchar(3000)
)
as
begin
insert into @return_table
	select R.FIN_NAME,
	       R.FIN_VAL,
		   R.FDATE,
		   R.FPRD,
		   A.NAME
	from companyinfo A
	     join IDMap I 
			on a.id=i.id 
		 join Ratios R
			on i.FIN_ID=R.FIN_ID
	where A.ID=@ID
return
end
go 
select *
from dbo.f_info2(40853);

-- 함수 수정 및 삭제
-- 1) 삭제
drop function f_info2;

-- 2) 수정
alter function 
