/*
mssql
��¥ 23-05-20

https://youtu.be/DxONMn4Ks-A
https://youtu.be/yC8VEPhYEyI
https://youtu.be/HBSszA7ASzI
https://youtu.be/2PXtppy1dQo

Transact-SQL ���

������ Ÿ��
 1. ������
  - tinyint
  - smallint
  - int
  - bigint
  - decimal
  - smallmoney
  - money
 2. ������
  - char
  - varchar
  - nchar
  - nvarchar
 3. ��¥�� �ð�
  - datetime
  - datetime2
  - date
  - time
 4. ��Ÿ
  - rowversion
  - sysname
  - cursor
  - table
  - xml
  - geometry
  - geograpy
  - filestream: 2GB�̻� ��뷮 ������

����� ���� ������ ����
 - create type [���������ĸ�] from [����������(ex. char(5) not null)]

���� ��� => �Ͻ������� ���ǹǷ� ���� �Ұ�
 - ���� ����: declare @�����̸� ����������
 - ������ �� ����: set @�����̸� = ������ ��
 - ������ �� ���: select @�����̸�

������ ���� ��ȯ �Լ�
 - cast ( expression as ����������[����])
 - convert (����������(����), expression [, ��Ÿ��])
 - try_convert (����������(����), expression [, ��Ÿ��])
 - parse ( ���ڿ� as ���������� )
 - try_parse ( ���ڿ� as ���������� )

json�� 2016�������� ����
*/
-- ����
restore database sqldb 
	from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqlDB.bak' with replace;

-- ����
use sqlDB;
go
declare @myVar1 int;
declare @myVar2 smallint, @myVar3 decimal(5,2);
declare @myVar4 nchar(20);

set @myVar1 = 5;
set @myVar2 = 3;
set @myVar3 = 4.25;
set @myVar4 = '���� �̸� ==> ';

select @myVar1;
select @myVar2 + @myVar3;
select @myVar4, Name from userTbl where height > 180;
go
declare @myVar1 int;
set @myVar1 = 3;
select top(@myVar1) name, height from userTbl order by height;

-- ������ ���� ��ȯ �Լ�
use sqlDB;
go
select avg(cast(amount as float) ) "��� ���� ����"from buyTbl;
go
select avg(convert(float,amount) ) "��� ���� ����"from buyTbl;
go
select price, amount, cast(cast(price as float)/amount as decimal(10,2)) "�ܰ�/����"
from buyTbl;
/*price�� float�� �����ϰ� �ܰ�/������ ����� �ٽ� decimal(10,2)�� ��ȯ*/
go
select parse('2019�� 9�� 9��' as date);
select parse('2019�� 9�� 35��' as date);
/*parse�� �����ϸ� �����޼���*/
go
select cast(123.45 as int); /*�������*/
select try_parse(123.45 as int); /*�����޼���*/
select try_parse('123.45' as int); /*null*/
select try_parse('2019�� 9�� 35��' as date);
/*try_parse�� �����ϸ� null�� ��ȯ*/
go
/*�Ͻ����� ����ȯ*/
declare @myVar1 char(3);
set @myVar1 = '100';
select @myVar1 + '200'; /*���� + ���� => �״�� ����*/
select @myVar1 + 200; /*���� + ���� => �Ͻ������� ������ ��ȯ*/
select @myVar1 + 200.0; /*���� + �Ǽ� => �Ͻ������� �Ǽ��� ��ȯ*/

-- ��Į���Լ�
/*�����Լ�: ���� ������ ���� ����*/
select @@langid;
select @@language;
/*���� ������ ����� �ڵ� ��ȣ �� ��� Ȯ��*/
exec sp_helplanguage;
/*�ٸ������� �� ���� id�� Ȯ��*/
go
/*���� �ν��Ͻ��� �̸��� Ȯ��*/
select @@SERVERNAME; 
go
/*���� ������ �̸��� Ȯ��*/
select @@SERVICENAME;
go
/*���� ����� ���μ����� ���� ID�� ��ȯ*/
select @@SPID;
go
/*���� ���� Ȯ��*/
select @@VERSION;

/*��¥ �Լ�*/
select sysdatetime(); /*���� �ð� ��¥(������)*/
go
select getdate(); /*���� �ð� ��¥(�и���)*/
go
select dateadd(day, 100, '2019/10/10');
go
select datediff(day, getdate(), '2019/10/10');
select datediff(week, getdate(), '2019/10/10');
go
select datename(year, getdate());
select datename(WEEKDAY, '2018/12/25');
go
select year('2018/12/25');
select month('2018/12/25');
select day('2018/12/25');
go
select datefromparts('2018','12','25');
/*
datetime2fromparts
datetimefromparts
datetimeoffsetfromparts
smalldatetimefromparts
timefromparts �ε� �ð� ������ ���� ����� ����*/
go
/*�Է��� ��¥�� ������ ��¥ ��ȯ*/
select EOMONTH('2019-02-12');
select EOMONTH('2020-02-12');
select EOMONTH('2020-02-12', 3); /*�Է� ��¥�� 3���� �� ������ ��¥*/
go
select abs(-12);
go
select round(123.24255,2);
select round(-12.4588633,2);
go
select rand(); /*0~1���� ����*/
go
select SQRT(4);
go
select power(4,2);

/*��Ÿ������ �Լ�*/
/*���̺��� �÷� ���� ��ȯ*/
select COL_LENGTH('[dbo].[buyTbl]','num');
select COL_LENGTH('[dbo].[buyTbl]','price');
select COL_LENGTH('[dbo].[buyTbl]','userID');
go
/*db�� id�� �̸� ��ȯ*/
select db_id('AdventureWorks');
select db_name(6);
exec sp_helpdb;
/*
sp_helpdb�� dbid���� id Ȯ���ϰ�
sp_helpdb�� name���� name Ȯ��
*/
go
select object_id('userTbl');
select object_name(565577053);
select * from sys.objects where name='userTbl';
/*
sys.objects�� object_id���� id Ȯ���ϰ�
sys.objects�� name���� name Ȯ��
*/

/*�� �Լ�*/
/*���� ���� ������ ��ġ�� �� ��ȯ*/
select choose(2,'SQL','Server','2016','DVD');
select choose(5,'SQL','Server','2016','DVD'); 
go
select iif(100>200, '�´�', 'Ʋ����')

/*���ڿ� �Լ�*/
/*���ڿ� => �ƽ�Ű �ڵ�*/
select ascii('A');
go
/*�ƽ�Ű �ڵ� => ���ڿ�*/
select char(65);
go
select concat('A','B');
select 'A' + 'B';
/*���ڿ� => �����ڵ�*/
select unicode('��');
go
/*�����ڵ� => ���ڿ�*/
select nchar(44032);
go
select charindex('Server','SQL Server 2016');
select charindex('Server','SQL server 2016');
/*��ҹ��� ���� X*/
go
select left('SQL server 2016', 5);
select right('SQL server 2016', 8);
select substring('SQL server 2016', 4,3);
go
select len('SQL server 2016');
go
select lower('SQL server 2016');
select upper('SQL server 2016');
go
select len(ltrim('  SQL server 2016  '));
/*������ ������ �������� ������ ������� �ɷ� ����*/
select len(rtrim(' SQL   '));
go
select replace('ABC','c','S');
go
select replicate('ABC',3);
go 
select reverse('ABC');
go
/*���� ��ȯ*/
select space(5);
select len(space(5) + '1');
go
select str(5);
go
select stuff('SQL ���� 2016', 5, 2, 'Server');
go
select format(getdate(), 'yyyy:MM:dd');
/*MM�� ��, mm�� ��*/

-- ��뷮 ������ �Է� ����
use sqlDB;
go
create table maxTbl(
	col1 varchar(max),
	col2 nvarchar(max),
);
insert into maxTbl values
	(REPLICATE('A',1000000), REPLICATE('��',1000000));
select len(col1) "varchar(max)", len(col2) "nvarchar(max)" from maxTbl;
go
insert into maxTbl values
	(REPLICATE(cast('A' as varchar(max)),1000000), 
	 REPLICATE(convert(nvarchar(max),'��'),1000000));
select len(col1) "varchar(max)", len(col2) "nvarchar(max)" from maxTbl;
go
update maxTbl set col1 = replace((select col1 from maxTbl), 'A', 'B'),
                  col2 = replace((select col2 from maxTbl), '��', '��');
select reverse(col1) from maxTbl;
select substring(col2, 999991,10) from maxTbl;
go
update maxTbl set col1 = stuff(col1,999991,10,replicate('C',10)),
                  col2 = stuff(col2,999991,10,replicate('��',10));
select substring(col1, 999981,20), substring(col2, 999981,20) from maxTbl;
go
update maxTbl set col1.write('DDDDD', 999995,5),
                  col2.write('������', 999995,5);
select substring(col1, 999981,21), substring(col2, 999981,20) from maxTbl;

-- �����Լ�
use sqldb;
go
/*Ű�� ū �������*/
select row_number() over(order by height desc) "Űū����", name, addr, height
from userTbl;
go
/*Ű�� ū ������� + Ű�� ������ �̸��� ������ �������*/
select row_number() over(order by height desc, name) "Űū����", name, addr, height
from userTbl;
go
/*�ּҺ��� Ű�� ū �������*/
select addr, row_number() over(partition by addr order by height desc, name) "Űū����", name, height
from userTbl;
/*partition by�� group by�� ����� ���*/
go
/*rank�� �ߺ��� ���� �ִ°�� ���� ���*/
select addr, rank() over(order by height desc) "Űū����", name, height
from userTbl;
/*2���� 2�� ������ ���� ����� 4��*/
go
/*rank�� �ߺ��� ���� �ִ°�� ���� ���*/
select addr, dense_rank() over(order by height desc) "Űū����", name, height
from userTbl;
/*2���� 2�� ������ ���� ����� 3��*/
go
/*���� ���� �׷��� �����*/
select addr, ntile(2) over(order by height desc) "Űū����", name, height
from userTbl;
/*Ű�� ū ��, ���� ��*/
go
select addr, ntile(3) over(order by height desc) "Űū����", name, height
from userTbl;
/*Ű�� ū ��, Ű�� �߰���, ���� ��*/

-- �м��Լ�
/*���� ����� Ű ���̰� �ñ�*/
use sqldb;
go
select name,addr, height as "Ű",
       height - (lead(height, 1, 1) over (order by height desc)) as"���� ����� Ű ����"
from usertbl;
go
select name,addr, height as "Ű",
       height - (lead(height, 1, 0) over (order by height desc)) as"���� ����� Ű ����"
from usertbl;
go
select name,addr, height as "Ű",
       height - (lead(height, 2, 0) over (order by height desc)) as"���� ����� Ű ����"
from usertbl;
/*
2��° �μ��� ��ĭ ���� ���� ������ �̰�
3��° �μ��� �⺻���� �ǹ��Ͽ� �������� ���� ���
*/
go
/*���� ����� Ű ���̰� �ñ�*/
select name,addr, height as "Ű",
       height - (lag(height, 1, 0) over (order by height desc)) as"���� ����� Ű ����"
from usertbl;
go
select name,addr, height as "Ű",
       height - (lag(height, 1, 1) over (order by height desc)) as"���� ����� Ű ����"
from usertbl;
go
select name,addr, height as "Ű",
       height - (lag(height, 2, 0) over (order by height desc)) as"���� ����� Ű ����"
from usertbl;
go
/*���� ū ����� ��*/
select name,addr, height as "Ű",
       height - (first_value(height) over (order by height desc)) as"Ű ū ����� Ű ����"
from usertbl;
go
select name,addr, height as "Ű",
       height - (first_value(height) over (partition by addr order by height desc)) as"������ Ű ū ����� Ű ����"
from usertbl;
go
/*�����*/
select addr, name, height "������",
       (CUME_DIST() over (partition by addr order by height desc)) * 100 "�����ο� ����� %"
from usertbl;
go
/*�߾Ӱ�*/
select distinct addr,
       percentile_cont(0.5) within group (order by height) over (partition by addr) "������ �߾Ӱ�"
from usertbl;
go
select distinct addr,
       percentile_cont(0.25) within group (order by height) over (partition by addr) "������ �߾Ӱ�"
from usertbl
where addr='����';
/*percentile_cont�� ��Ȯ�� �߰��� ���ڸ� ��Ÿ���Ƿ� ���ȿ� �ִ� ���� �� ���� �� ����*/
go
select distinct addr,
       percentile_disc(0.5) within group (order by height) over (partition by addr) "������ ��Ȯ�� ��ġ��"
from usertbl;
/*percentile_disc�� ��Ȯ�� �߰��� ��ġ�� ��Ÿ���Ƿ� ������ ���ȿ� �ִ� ���� ��ȯ*/

-- pivot/unpivot
/*
pivot: long => wide
unpivot: wide => long
*/
/*pivot ����*/
create table pivottest(
	uname nchar(3),
	season nchar(2),
	amount int
);
insert into pivottest values
	('�����', '�ܿ�', 10),
    ('������', '����', 15),
	('�����', '����', 25),
	('�����', '��', 3),
	('�����', '��', 37),
	('������', '�ܿ�', 40),
	('�����', '����', 14),
	('�����', '�ܿ�', 22),
	('������', '����', 64);
select * from pivottest
pivot(sum(amount)
      for season
	  in ([��],[����],[����],[�ܿ�])) "resultpivot";
select * from pivottest
pivot(sum(amount) /*�հ�*/
      for season /*� ���� ���̸����� ��������*/
	  in ([�ܿ�],[����],[����],[��])) "resultpivot"; /*�� ����*/

-- json
/*���̺� => json*/
use sqldb;
go
select name, height 
from usertbl
where height >= 180
for json auto;
go
declare @json varchar(max)
set @json=N'{"userTBL" :
                 [ {"name":"�����", "height":182},
				   {"name":"�̽±�", "height":182},
				   {"name":"���ð�", "height":186} ]
		     }'
select isjson(@json);
select json_query(@json, '$.userTBL');
select json_query(@json, '$.userTBL[0]');
select json_value(@json, '$.userTBL[0].name');
select * from openjson(@json, '$.userTBL')
with (
		name nchar(8) '$.name',
		height int '$.height');

-- xml ����
select name, height 
from usertbl
where height >= 180
for xml path('');

-- ����
/*inner join*/
use sqldb;
go
select b.userid, u.name, b.prodName, u.addr, u.mobile1 + u.mobile2 "����ó"
from buyTbl b
     inner join
	 userTbl u
		on b.userID = u.userID;
-- where b.userID = 'JYP';
go
/*������ �ѹ��̶� �� ��� ã��*/
select distinct b.userid, u.name, u.addr
from buyTbl b
     inner join
	 userTbl u
		on b.userID = u.userID;
go
/*right outer join*/
select b.userid, u.name, b.prodName, u.addr, u.mobile1 + u.mobile2 "����ó"
from buyTbl b
     right outer join
	 userTbl u
		on b.userID = u.userID;
go
/*left outer join*/
select b.userid, u.name, b.prodName, u.addr, u.mobile1 + u.mobile2 "����ó"
from userTbl u
     left outer join
	 buyTbl b
		on u.userID = b.userID;
go
/*���� ����� ���� ������ ����*/
select u.userid, u.name, b.prodname, u.addr, u.mobile1 + u.mobile2 "����ó"
from userTbl u
     left outer join
	 buytbl b
		on u.userID = b.userid
where b.prodName is null
order by u.userID;
go
/*3�����̺� ���� ����*/
use sqldb;
go
create table stdTbl (
	name nvarchar(3),
	addr nvarchar(2),
	primary key (name)
);
insert into stdTbl values 
	('�����', '�泲'),
	('���ð�', '����'),
	('������', '���'),
	('������', '���'),
	('�ٺ�Ŵ', '����');
create table clubTbl (
	club_name nvarchar(4),
	club_room nvarchar(4),
	primary key (club_name)
);
insert into clubTbl values 
	('����', '101ȣ'),
	('�ٵ�', '102ȣ'),
	('�౸', '103ȣ'),
	('����', '104ȣ');
create table stdclubTbl (
	no int,
	name nvarchar(3) foreign key references stdTbl(name),
	club_name nvarchar(4) foreign key references clubTbl(club_name),
);
insert into stdclubTbl values 
	(1, '�����', '�ٵ�'),
	(2, '�����', '�౸'),
	(3, '������', '�౸'),
	(4, '������', '�౸'),
	(5, '������', '����'),
	(6, '�ٺ�Ŵ', '����');
select s.name, s.addr, c.club_name, c.club_room
from stdTbl s
	 inner join
	 stdclubtbl sc
		on s.name = sc.name
	 inner join
	 clubtbl c
		on sc.club_name = c.club_name
order by s.name;
go
select c.club_name, c.club_room, s.name, s.addr
from stdTbl s
	 inner join
	 stdclubtbl sc
		on s.name = sc.name
	 inner join
	 clubtbl c
		on sc.club_name = c.club_name
order by c.club_name;
go
/*full join*/
select s.name, s.addr, c.club_name, c.club_room
from stdTbl s
	 full join
	 stdclubtbl sc
		on s.name = sc.name
	 full join
	 clubtbl c
		on sc.club_name = c.club_name
order by 1;
/*
������ ���� �л��� 1�� ����
���ð��� ���Ƹ��� ���� X
������� �������� ���Ƹ� 2�� ����
*/
go
/*cross join*/
use sqldb;
go
select *
from buytbl cross join usertbl;
go
/*count_big => count�� ���� ��������� �����÷ο� �� �� ���*/
use AdventureWorks;
go
select count_big(*) "�����Ͱ���"
from sales.salesorderdetail
     cross join
	 sales.salesorderheader;
/*12�� �� X 3�� �� = 36�� ��*/
go
/*self join*/
use sqldb;
go
create table emptbl (
	emp nvarchar(3),
	manager nvarchar(3),
	department nvarchar(3)
);
insert into emptbl values
	('������', null, null),
	('���繫','������','�繫��'),
	('�����','���繫','�繫��'),
	('�̺���','���繫','�繫��'),
	('��븮','�̺���','�繫��'),
	('�����','�̺���','�繫��'),
	('�̿���','������','������'),
	('�Ѱ���','�̿���','������'),
	('������','������','������'),
	('������','������','������'),
	('������','������','������');
go
select e1.emp "��������", e2.emp "���ӻ��", e2.department "���ӻ���μ�"
from emptbl e1
     inner join
	 emptbl e2
		on e1.manager = e2.emp;
go
/*union all*/
select name, addr from stdTbl
union all
select club_name, club_room from clubTbl;
go
select name, addr from stdTbl
union 
select club_name, club_room from clubTbl;
/*union all�� union�� ���̴� �ߺ� ����*/
go
/*except => ������*/
select name, mobile1 + mobile2 from userTbl
except
select name, mobile1 + mobile2 from userTbl where mobile1 is null;
go
/*intersect => ������*/
select name, mobile1 + mobile2 from userTbl
intersect
select name, mobile1 + mobile2 from userTbl where mobile1 is null;

-- if else
declare @var1 int
set @var1 = 100
-- declare @var1 int = 100

if @var1 = 100
	begin
		print '@var1�� 100�̴�'
	end
else
	begin
		print '@var1�� 100�� �ƴϴ�'
	end;
go
use AdventureWorks;
declare @hireDate smalldatetime
declare @curDate smalldatetime
declare @years decimal(5,2)
declare @days int

select @hireDate = HireDate /*�����ȣ 111�� �Ի����� @hireDate�� ����*/
from HumanResources.Employee
where BusinessEntityID = 111
set @curDate = getdate()
set @years = datediff(year, @hireDate, @curDate)
set @days = datediff(day, @hireDate, @curDate)

if @years >= 5
	begin
		print N'�Ի��� ��' + cast(@days as nchar(5)) + N'���̳� �������ϴ�'
		print N'�����մϴ�'
	end
else
	begin
		print N'�Ի��� ��' + cast(@days as nchar(5)) + N'�Ϲۿ� �� �Ǿ��׿�'
		print N'������ ���ϼ���'
	end;

-- case
declare @point int = 77, @credit nchar(1)

if @point >= 90
	set @credit = 'A'
else
	if @point >= 80
		set @credit = 'B'
	else
		if @point >= 70
			set @credit = 'C'
		else
			if @point >= 60
				set @credit = 'D'
			else
				set @credit = 'F';
print N'������� ==> ' + cast(@point as nchar(3))
print N'���� ==> ' + @credit;
go
declare @point int = 55, @credit nchar(1)

set @credit = case 
			    when @point >=90 then 'A'
				when @point >=80 then 'B'
				when @point >=70 then 'C'
				when @point >=60 then 'D'
				else 'F'
			  end

print N'������� ==> ' + cast(@point as nchar(3))
print N'���� ==> ' + @credit;
go
/*case ����*/
use sqldb;

select u.userID, u.name, sum(price * amount) "�ѱ��ž�",
       case 
	     when sum(price * amount) >= 1500 then '�ֿ����'
	     when sum(price * amount) >= 1000 then '�����'
	     when sum(price * amount) >= 1 then '�Ϲݰ�'
	     else '����ȸ��'
	   end "�����"
from buyTbl b
	 right join
	 userTbl u
		on b.userID = u.userID
group by u.userID, u.name
order by "�ѱ��ž�" desc;

-- while(break, continue, return)
declare @i int = 1
declare @hap bigint = 0

while (@i <= 100)
	begin
		set @hap += @i
		set @i +=1
	end

print N'�� ���� ' + cast(@hap as varchar);
go
declare @i int = 1
declare @hap bigint = 0

while (@i <= 100)
	begin
		if (@i % 7 = 0)
			begin
				set @i +=1
				continue
			end
		else
			begin
				set @hap += @i
				set @i +=1
			end
	end

print N'7�� ����� �� �� ���� ' + cast(@hap as varchar);
go
declare @i int = 1
declare @hap bigint = 0

while (@i <= 100)
	begin
		if (@hap >1200)
					begin
						break
					end
		else
			if (@i % 7 = 0)
				begin
					set @i +=1
					continue
				end
			else 
				begin
					set @hap += @i
					set @i +=1
				end
	end

print N'7�� ����� �� �� �տ��� 1000�� �Ѿ���!!!!' + char(13) + char(10) + 
      N'@i�� ���� ' + cast(@i as varchar) + '�̰�' +  char(13) + char(10) + 
	  N'�̶� �� ����' + cast(@hap as varchar);
go
/*goto*/
declare @i int = 1
declare @hap bigint = 0

while (@i <= 100)
	begin
		if (@i % 7 = 0)
			begin
				set @i +=1
				continue
			end
		set @hap += @i
		if (@hap > 1000) goto endprint
		set @i +=1
	end

endprint:
  print N'7�� ����� �� �� �տ��� 1000�� �Ѿ���!!!!' + char(13) + char(10) + 
        N'@i�� ���� ' + cast(@i as varchar) + '�̰�' + char(13) + char(10) + 
	    N'�̶� �� ����' + cast(@hap as varchar);
go
/*waitfor*/
waitfor delay '00:00:05';
print N'5�ʰ� ���� �� ����Ǿ���';

waitfor time '00:39:00';
print N'00�� 39�� 00�ʱ��� ���� �� ����Ǿ���';

-- try - catch
/*
begin try
	[���� ����ϴ� SQL �����]
end try
begin catch
	[���� begin ,,, try���� ������ �߻��ϸ� ó���� ��]
end catch
*/
use sqldb;
begin try
	 insert into usertbl values
		('LSG','�̻�', 1988, '����', null, null, 170, getdate())
		print N'���������� �ԷµǾ���'
end try
begin catch
	print N'������ �߻��ߴ� �̤�'
	print N'���� ��ȣ'
	print error_number()
	print N'���� �޼���'
	print error_message()
	print N'���� ���� �ڵ�'
	print error_state()
	print N'���� �ɰ���'
	print error_severity()
	print N'���� �߻� ���ȣ'
	print error_line()
	print N'���� �߻� ���ν���/Ʈ����'
	print error_procedure()
end catch

-- raiserrpr, throw => ���� ���� �߻�
raiserror(N'�̰� Raiseerror �����߻�', 16, 1);
/*16�� ���� �ɰ���, 1�� ���� ����*/
raiserror(N'�̰� Raiseerror �����߻�', 14, 2);
throw 55555, N'�̰� THROW ���� �߻�' , 1;
/*
55555�� ���� ��ȣ
throw���� ���� �ɰ����� �׻� 16
*/

-- ���� SQL
use sqlDB;
declare @sql varchar(100)
set @sql = 'select * from userTbl where userid = ''EJW'''
exec(@sql);
/*exec @sql�� �����ϸ� ���� �߻�*/
go
use sqlDB;
declare @curdate date
declare @curyear varchar(4)
declare @curmonth varchar(2)
declare @curday varchar(2)
declare @sql varchar(max)

set @curdate = getdate()
set @curyear = year(@curdate)
set @curmonth = month(@curdate)
set @curday = day(@curdate)

set @sql = 'create table mytbl' + @curyear + '_' + @curmonth + '_' + @curday
set @sql += '(id int, name NCHAR(10))'

execute(@sql);
