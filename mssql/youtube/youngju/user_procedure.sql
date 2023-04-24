-- 저장 프로시저 저장
use study
go
create procedure SP_SELECT_COMPANYINFO
as
begin
	select * from companyinfo 
end
go
exec SP_SELECT_COMPANYINFO;

-- 매개변수가 있는 프로시저
create procedure SP_SELECT_STOCKPRICE 
@ID INT,
@STARTDATE DATE,
@ENDDATE DATE
as
begin
	select Date_,close_
	from stockprice 
	where id = @id and
	      date_ between @startdate and @enddate
	order by date_ desc
end
go
exec SP_SELECT_STOCKPRICE 40853, '2020-10-01', '2020-10-13';

drop proc SP_SELECT_STOCKPRICE;

-- 프로시저 수정 및 삭제
-- 1) 수정
/*
alter procedure [프로시저명]
@[파라미터명]
as
begin
[쿼리문]
end
*/

-- 2)삭제
/*
drop proc [프로시저명]
*/

-- if else 문
declare @I int =111
if @I%2 = 0
	begin
		print N'짝수'
	end
else 
	begin
		print N'홀수'
	end;

-- while문
declare @I int = 1 
declare @added bigint = 0
while @I <= 100 -- (@I <= 100)로 괄호로 묶어도 실행 가능
	begin
		set @added = @added + @I
		print N'현재 숫자는 ' + cast(@I as varchar) + N'이고 총 합은 ' + cast(@added as varchar) + N'입니다.'
		set @I = @I + 1
	end
		print @added
print @added

-- contiune, break
declare @I int = 1 
declare @added bigint = 0
while @I <= 100
	begin
		if @I%9=0
			begin 
				print cast(@I as varchar) + N'은 9의 배수(더하기 진행 X)'
				set @I = @I + 1
				continue
			end
				-- set @I = @I + 1
		if @added >= 3000
			begin 
				print N'@added값이 ' + cast(@added as varchar) + N'이고 3000을 넘어 계산 종료'
				break
			end
		set @added = @added + @I
		print N'현재 숫자는 ' + cast(@I as varchar) + N'이고 총 합은 ' + cast(@added as varchar) -- + N'입니다.'
		set @I = @I + 1
	end
		print N'최종결과: ' + cast(@added as varchar);

-- 동적 SQL
create proc SP_SELECT_TABLE_INFO
	@TableName varchar(3000)	
	as 
	begin
		declare @sqlquery varchar(3000)
		set @sqlquery = 'select * from ' + @tablename

		exec(@sqlquery)
	end 
go
exec SP_SELECT_TABLE_INFO 'companyinfo';
exec SP_SELECT_TABLE_INFO 'stockprice';
