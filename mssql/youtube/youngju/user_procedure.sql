-- ���� ���ν��� ����
use study
go
create procedure SP_SELECT_COMPANYINFO
as
begin
	select * from companyinfo 
end
go
exec SP_SELECT_COMPANYINFO;

-- �Ű������� �ִ� ���ν���
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

-- ���ν��� ���� �� ����
-- 1) ����
/*
alter procedure [���ν�����]
@[�Ķ���͸�]
as
begin
[������]
end
*/

-- 2)����
/*
drop proc [���ν�����]
*/

-- if else ��
declare @I int =111
if @I%2 = 0
	begin
		print N'¦��'
	end
else 
	begin
		print N'Ȧ��'
	end;

-- while��
declare @I int = 1 
declare @added bigint = 0
while @I <= 100 -- (@I <= 100)�� ��ȣ�� ��� ���� ����
	begin
		set @added = @added + @I
		print N'���� ���ڴ� ' + cast(@I as varchar) + N'�̰� �� ���� ' + cast(@added as varchar) + N'�Դϴ�.'
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
				print cast(@I as varchar) + N'�� 9�� ���(���ϱ� ���� X)'
				set @I = @I + 1
				continue
			end
				-- set @I = @I + 1
		if @added >= 3000
			begin 
				print N'@added���� ' + cast(@added as varchar) + N'�̰� 3000�� �Ѿ� ��� ����'
				break
			end
		set @added = @added + @I
		print N'���� ���ڴ� ' + cast(@I as varchar) + N'�̰� �� ���� ' + cast(@added as varchar) -- + N'�Դϴ�.'
		set @I = @I + 1
	end
		print N'�������: ' + cast(@added as varchar);

-- ���� SQL
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
