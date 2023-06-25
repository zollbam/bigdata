/*
mssql
날짜 23-05-20

https://youtu.be/DxONMn4Ks-A
https://youtu.be/yC8VEPhYEyI
https://youtu.be/HBSszA7ASzI
https://youtu.be/2PXtppy1dQo

Transact-SQL 고급

데이터 타입
 1. 숫자형
  - tinyint
  - smallint
  - int
  - bigint
  - decimal
  - smallmoney
  - money
 2. 문자형
  - char
  - varchar
  - nchar
  - nvarchar
 3. 날짜와 시간
  - datetime
  - datetime2
  - date
  - time
 4. 기타
  - rowversion
  - sysname
  - cursor
  - table
  - xml
  - geometry
  - geograpy
  - filestream: 2GB이상 대용량 데이터

사용자 정의 데이터 형식
 - create type [데이터형식명] from [데이터형식(ex. char(5) not null)]

변수 사용 => 일시적으로 사용되므로 재사용 불가
 - 변수 선언: declare @변수이름 데이터형식
 - 변수에 값 대입: set @변수이름 = 변수의 값
 - 변수의 값 출력: select @변수이름

데이터 형식 변환 함수
 - cast ( expression as 데이터형식[길이])
 - convert (데이터형식(길이), expression [, 스타일])
 - try_convert (데이터형식(길이), expression [, 스타일])
 - parse ( 문자열 as 데이터형식 )
 - try_parse ( 문자열 as 데이터형식 )

json은 2016버전부터 생김
*/
-- 복원
restore database sqldb 
	from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqlDB.bak' with replace;

-- 변수
use sqlDB;
go
declare @myVar1 int;
declare @myVar2 smallint, @myVar3 decimal(5,2);
declare @myVar4 nchar(20);

set @myVar1 = 5;
set @myVar2 = 3;
set @myVar3 = 4.25;
set @myVar4 = '가수 이름 ==> ';

select @myVar1;
select @myVar2 + @myVar3;
select @myVar4, Name from userTbl where height > 180;
go
declare @myVar1 int;
set @myVar1 = 3;
select top(@myVar1) name, height from userTbl order by height;

-- 데이터 형식 변환 함수
use sqlDB;
go
select avg(cast(amount as float) ) "평균 구매 개수"from buyTbl;
go
select avg(convert(float,amount) ) "평균 구매 개수"from buyTbl;
go
select price, amount, cast(cast(price as float)/amount as decimal(10,2)) "단가/수량"
from buyTbl;
/*price을 float로 변경하고 단가/수량한 계산을 다시 decimal(10,2)로 변환*/
go
select parse('2019년 9월 9일' as date);
select parse('2019년 9월 35일' as date);
/*parse은 실패하면 오류메세지*/
go
select cast(123.45 as int); /*정상실행*/
select try_parse(123.45 as int); /*오류메세지*/
select try_parse('123.45' as int); /*null*/
select try_parse('2019년 9월 35일' as date);
/*
try_parse는 인수1에 numeric이 되면 안 된다.
try_parse는 실패하면 null값 반환
*/
go
/*암시적인 형변환*/
declare @myVar1 char(3);
set @myVar1 = '100';
select @myVar1 + '200'; /*문자 + 문자 => 그대로 문자*/
select @myVar1 + 200; /*문자 + 정수 => 암시적으로 정수로 변환*/
select @myVar1 + 200.0; /*문자 + 실수 => 암시적으로 실수로 변환*/

-- 스칼라함수
/*구성함수: 현재 구성에 대한 정보*/
/*현재 설정된 어어의 코드번호*/
select @@langid;
/*현재 설정된 언어의 코드 확인*/
select @@language;
exec sp_helplanguage;
/*다른나라의 언어에 대한 id를 확인*/
go
/*현재 인스턴스의 이름을 확인*/
select @@SERVERNAME; 
go
/*현재 서비스의 이름을 확인*/
select @@SERVICENAME;
go
/*현재 사용자 프로세스의 세션 ID를 반환*/
select @@SPID;
select * from sys.dm_exec_sessions;
go
/*현재 버전 확인*/
select @@VERSION;

/*날짜 함수*/
select sysdatetime(); /*현재 시간 날짜(나노초)*/
go
select getdate(); /*현재 시간 날짜(밀리초)*/
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
timefromparts 로도 시간 데이터 형식 만들기 가능*/
go
/*입력한 날짜의 마지날 날짜 반환*/
select EOMONTH('2019-02-12');
select EOMONTH('2020-02-12');
select EOMONTH('2020-02-12', 3); /*입력 날짜의 3개월 후 마지막 날짜*/
go
select abs(-12);
go
select round(123.24255,2);
select round(-12.4588633,2);
go
select rand(); /*0~1사이 랜덤*/
go
select SQRT(4);
go
select power(4,2);

/*메타데이터 함수*/
/*테이블의 컬럼 길이 반환*/
select COL_LENGTH('[sqldb].[dbo].[buyTbl]','num');
select COL_LENGTH('[sqldb].[dbo].[buyTbl]','price');
select COL_LENGTH('[sqldb].[dbo].[buyTbl]','userID');
select * from INFORMATION_SCHEMA.columns where TABLE_name='buytbl';
go
/*db의 id와 이름 반환*/
select db_id('AdventureWorks');
select db_name(6);
exec sp_helpdb;
/*
sp_helpdb의 dbid열로 id 확인하고
sp_helpdb의 name열로 name 확인
*/
go
select object_id('userTbl');
select object_name(565577053);
select * from sys.objects where name='userTbl';
/*
sys.objects의 object_id열로 id 확인하고
sys.objects의 name열로 name 확인
*/

/*논리 함수*/
/*여러 값중 지정된 위치의 값 반환*/
select choose(2,'SQL','Server','2016','DVD');
select choose(5,'SQL','Server','2016','DVD'); 
go
select iif(100>200, '맞다', '틀리다');

/*문자열 함수*/
/*문자열 => 아스키 코드*/
select ascii('A');
go
/*아스키 코드 => 문자열*/
select	;
go
select concat('A','B');
select 'A' + 'B';
/*문자열 => 유니코드*/
select unicode('가');
go
/*유니코드 => 문자열*/
select nchar(44032);
go
select charindex('Server','SQL Server 2016');
select charindex('Server','SQL server 2016');
/*대소문자 구분 X*/
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
/*오른쪽 공백은 가변길이 때문에 사라지는 걸로 예상*/
select len(rtrim(' SQL   '));
go
select replace('ABC','c','S');
go
select replicate('ABC',3);
go 
select reverse('ABC');
go
/*공백 반환*/
select space(5);
select len(space(5) + '1');
go
select str(5);
go
select stuff('SQL 서버 2016', 5, 2, 'Server');
go
select format(getdate(), 'yyyy:MM:dd');
/*MM은 월, mm은 분*/

-- 대용량 데이터 입력 예제
use sqlDB;
go
create table maxTbl(
	col1 varchar(max),
	col2 nvarchar(max),
);
insert into maxTbl values
	(REPLICATE('A',1000000), REPLICATE('가',1000000));
select len(col1) "varchar(max)", len(col2) "nvarchar(max)" from maxTbl;
go
insert into maxTbl values
	(REPLICATE(cast('A' as varchar(max)),1000000), 
	 REPLICATE(convert(nvarchar(max),'가'),1000000));
select len(col1) "varchar(max)", len(col2) "nvarchar(max)" from maxTbl;
go
update maxTbl set col1 = replace((select col1 from maxTbl), 'A', 'B'),
                  col2 = replace((select col2 from maxTbl), '가', '나');
select reverse(col1) from maxTbl;
select substring(col2, 999991,10) from maxTbl;
go
update maxTbl set col1 = stuff(col1,999991,10,replicate('C',10)),
                  col2 = stuff(col2,999991,10,replicate('다',10));
select substring(col1, 999981,20), substring(col2, 999981,20) from maxTbl;
go
update maxTbl set col1.write('DDDDD', 999995,5),
                  col2.write('라라라라라', 999995,5);
select substring(col1, 999981,21), substring(col2, 999981,20) from maxTbl;

-- 순위함수
use sqldb;
go
/*키가 큰 순서대로*/
select row_number() over(order by height desc) "키큰순위", name, addr, height
from userTbl;
go
/*키가 큰 순서대로 + 키가 같으면 이름을 오름차 순서대로*/
select row_number() over(order by height desc, name) "키큰순위", name, addr, height
from userTbl;
go
/*주소별로 키가 큰 순서대로*/
select addr, row_number() over(partition by addr order by height desc, name) "키큰순위", name, height
from userTbl;
/*partition by는 group by와 비슷한 기능*/
go
/*rank는 중복된 값이 있는경우 같은 등수*/
select addr, rank() over(order by height desc) "키큰순위", name, height
from userTbl;
/*2등이 2명 있으면 다음 등수는 4등*/
go
/*rank는 중복된 값이 있는경우 같은 등수*/
select addr, dense_rank() over(order by height desc) "키큰순위", name, height
from userTbl;
/*2등이 2명 있으면 다음 등수는 3등*/
go
/*순위 별로 그룹을 만들기*/
select addr, ntile(2) over(order by height desc) "키큰순위", name, height
from userTbl;
/*키가 큰 팀, 작은 팀*/
go
select addr, ntile(3) over(order by height desc) "키큰순위", name, height
from userTbl;
/*키가 큰 팀, 키가 중간팀, 작은 팀*/

-- 분석함수
/*다음 사람과 키 차이가 궁금*/
use sqldb;
go
select name,addr, height as "키",
       height - (lead(height, 1, 1) over (order by height desc)) as"다음 사람과 키 차이"
from usertbl;
go
select name,addr, height as "키",
       height - (lead(height, 1, 0) over (order by height desc)) as"다음 사람과 키 차이"
from usertbl;
go
select name,addr, height as "키",
       height - (lead(height, 2, 0) over (order by height desc)) as"다음 사람과 키 차이"
from usertbl;
/*
2번째 인수는 몇칸 다음 것을 비교하지 이고
3번째 인수는 기본값을 의미하여 마지막에 값과 계산
*/
go
/*이전 사람과 키 차이가 궁금*/
select name,addr, height as "키",
       height - (lag(height, 1, 0) over (order by height desc)) as"이전 사람과 키 차이"
from usertbl;
go
select name,addr, height as "키",
       height - (lag(height, 1, 1) over (order by height desc)) as"이전 사람과 키 차이"
from usertbl;
go
select name,addr, height as "키",
       height - (lag(height, 2, 0) over (order by height desc)) as"이전 사람과 키 차이"
from usertbl;
go
/*가장 큰 사람과 비교*/
select name,addr, height as "키",
       height - (first_value(height) over (order by height desc)) as"키 큰 사람과 키 차이"
from usertbl;
go
select name,addr, height as "키",
       height - (first_value(height) over (partition by addr order by height desc)) as"지역별 키 큰 사람과 키 차이"
from usertbl;
go
/*백분율*/
select addr, name, height "가입일",
       (CUME_DIST() over (partition by addr order by height desc)) * 100 "누적인원 백분율 %"
from usertbl;
go
/*중앙값*/
select distinct addr,
       percentile_cont(0.5) within group (order by height) over (partition by addr) "지역별 중앙값"
from usertbl;
go
select distinct addr,
       percentile_cont(0.25) within group (order by height) over (partition by addr) "지역별 하위 25%"
from usertbl
where addr='서울';
/*percentile_cont는 정확한 중간값 숫자를 나타내므로 열안에 있는 값이 안 나올 수 있음*/
go
select distinct addr,
       percentile_disc(0.5) within group (order by height) over (partition by addr) "지역별 정확한 위치값"
from usertbl;
/*percentile_disc는 정확한 중간값 위치가 나타나므로 무조건 열안에 있는 값이 반환*/

-- pivot/unpivot
/*
pivot: long => wide
unpivot: wide => long
*/
/*pivot 예제*/
create table pivottest(
	uname nchar(3),
	season nchar(2),
	amount int
);
insert into pivottest values
	('김범수', '겨울', 10),
    ('윤종신', '여름', 15),
	('김범수', '가을', 25),
	('김범수', '봄', 3),
	('김범수', '봄', 37),
	('윤종신', '겨울', 40),
	('김범수', '여름', 14),
	('김범수', '겨울', 22),
	('윤종신', '여름', 64);
select * from pivottest
pivot(sum(amount)
      for season
	  in ([봄],[여름],[가을],[겨울])) "resultpivot";
select * from pivottest
pivot(sum(amount) /*합계*/
      for season /*어떤 열을 열이름으로 지정할지*/
	  in ([겨울],[가을],[여름],[봄])) "resultpivot"; /*열 순서*/

-- json
/*테이블 => json*/
use sqldb;
go
select name, height 
from usertbl
where height >= 180
for json auto;
go
declare @json varchar(max)
set @json=N'{"userTBL" :
                 [ {"name":"임재범", "height":182},
				   {"name":"이승기", "height":182},
				   {"name":"성시경", "height":186} ]
		     }'
select isjson(@json);
select json_query(@json, '$.userTBL');
select json_query(@json, '$.userTBL[0]');
select json_value(@json, '$.userTBL[0].name');
select * from openjson(@json, '$.userTBL')
with (
		name nchar(8) '$.name',
		height int '$.height');

-- xml 참고
select name, height 
from usertbl
where height >= 180
for xml path('');

-- 조인
/*inner join*/
use sqldb;
go
select b.userid, u.name, b.prodName, u.addr, u.mobile1 + u.mobile2 "연락처"
from buyTbl b
     inner join
	 userTbl u
		on b.userID = u.userID;
-- where b.userID = 'JYP';
go
/*쇼핑을 한번이라도 한 사람 찾기*/
select distinct b.userid, u.name, u.addr
from buyTbl b
     inner join
	 userTbl u
		on b.userID = u.userID;
go
/*right outer join*/
select b.userid, u.name, b.prodName, u.addr, u.mobile1 + u.mobile2 "연락처"
from buyTbl b
     right outer join
	 userTbl u
		on b.userID = u.userID;
go
/*left outer join*/
select b.userid, u.name, b.prodName, u.addr, u.mobile1 + u.mobile2 "연락처"
from userTbl u
     left outer join
	 buyTbl b
		on u.userID = b.userID;
go
/*구매 목록이 없는 유저만 뽑자*/
select u.userid, u.name, b.prodname, u.addr, u.mobile1 + u.mobile2 "연락처"
from userTbl u
     left outer join
	 buytbl b
		on u.userID = b.userid
where b.prodName is null
order by u.userID;
go
/*3개테이블 조인 예제*/
use sqldb;
go
create table stdTbl (
	name nvarchar(3),
	addr nvarchar(2),
	primary key (name)
);
insert into stdTbl values 
	('김범수', '경남'),
	('성시경', '서울'),
	('조용필', '경기'),
	('은지원', '경북'),
	('바비킴', '서울');
create table clubTbl (
	club_name nvarchar(4),
	club_room nvarchar(4),
	primary key (club_name)
);
insert into clubTbl values 
	('수영', '101호'),
	('바둑', '102호'),
	('축구', '103호'),
	('봉사', '104호');
create table stdclubTbl (
	no int,
	name nvarchar(3) foreign key references stdTbl(name),
	club_name nvarchar(4) foreign key references clubTbl(club_name),
);
insert into stdclubTbl values 
	(1, '김범수', '바둑'),
	(2, '김범수', '축구'),
	(3, '조용필', '축구'),
	(4, '은지원', '축구'),
	(5, '은지원', '봉사'),
	(6, '바비킴', '봉사');
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
수영을 배우는 학생은 1명도 없음
성시경은 동아리에 가입 X
김범수와 은지원은 동아리 2개 가입
*/
go
/*cross join*/
use sqldb;
go
select *
from buytbl cross join usertbl;
go
/*count_big => count와 같은 기능이지만 오버플로우 될 때 사용*/
use AdventureWorks;
go
select count_big(*) "데이터개수"
from sales.salesorderdetail
     cross join
	 sales.salesorderheader;
/*12만 건 X 3만 건 = 36억 건*/
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
	('나사장', null, null),
	('김재무','나사장','재무부'),
	('김부장','김재무','재무부'),
	('이부장','김재무','재무부'),
	('우대리','이부장','재무부'),
	('지사원','이부장','재무부'),
	('이영업','나사장','영업부'),
	('한과장','이여업','영업부'),
	('최정보','나사장','정보부'),
	('윤차장','최정보','정보부'),
	('이주임','윤차장','정보부');
go
select e1.emp "부하직원", e2.emp "직속상관", e2.department "직속상관부서"
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
/*union all과 union의 차이는 중복 제거*/
go
/*except => 차집합*/
select name, mobile1 + mobile2 from userTbl
except
select name, mobile1 + mobile2 from userTbl where mobile1 is null;
go
/*intersect => 교집합*/
select name, mobile1 + mobile2 from userTbl
intersect
select name, mobile1 + mobile2 from userTbl where mobile1 is null;

-- if else
declare @var1 int
set @var1 = 100
-- declare @var1 int = 100

if @var1 = 100
	begin
		print '@var1이 100이다'
	end
else
	begin
		print '@var1이 100이 아니다'
	end;
go
use AdventureWorks;
declare @hireDate smalldatetime
declare @curDate smalldatetime
declare @years decimal(5,2)
declare @days int

select @hireDate = HireDate /*사원번호 111의 입사일이 @hireDate에 대입*/
from HumanResources.Employee
where BusinessEntityID = 111
set @curDate = getdate()
set @years = datediff(year, @hireDate, @curDate)
set @days = datediff(day, @hireDate, @curDate)

if @years >= 5
	begin
		print N'입사한 지' + cast(@days as nchar(5)) + N'일이나 지났습니다'
		print N'축하합니다'
	end
else
	begin
		print N'입사한 지' + cast(@days as nchar(5)) + N'일밖에 안 되었네요'
		print N'열심히 일하세요'
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
print N'취득점수 ==> ' + cast(@point as nchar(3))
print N'학점 ==> ' + @credit;
go
declare @point int = 55, @credit nchar(1)

set @credit = case 
			    when @point >=90 then 'A'
				when @point >=80 then 'B'
				when @point >=70 then 'C'
				when @point >=60 then 'D'
				else 'F'
			  end

print N'취득점수 ==> ' + cast(@point as nchar(3))
print N'학점 ==> ' + @credit;
go
/*case 예제*/
use sqldb;

select u.userID, u.name, sum(price * amount) "총구매액",
       case 
	     when sum(price * amount) >= 1500 then '최우수고객'
	     when sum(price * amount) >= 1000 then '우수고객'
	     when sum(price * amount) >= 1 then '일반고객'
	     else '유령회원'
	   end "고객등급"
from buyTbl b
	 right join
	 userTbl u
		on b.userID = u.userID
group by u.userID, u.name
order by "총구매액" desc;

-- while(break, continue, return)
declare @i int = 1
declare @hap bigint = 0

while (@i <= 100)
	begin
		set @hap += @i
		set @i +=1
	end

print N'총 합은 ' + cast(@hap as varchar);
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

print N'7의 배수를 뺀 총 합은 ' + cast(@hap as varchar);
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

print N'7의 배수를 뺀 총 합에서 1000이 넘었다!!!!' + char(13) + char(10) + 
      N'@i의 값은 ' + cast(@i as varchar) + '이고' +  char(13) + char(10) + 
	  N'이때 총 합은' + cast(@hap as varchar);
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
  print N'7의 배수를 뺀 총 합에서 1000이 넘었다!!!!' + char(13) + char(10) + 
        N'@i의 값은 ' + cast(@i as varchar) + '이고' + char(13) + char(10) + 
	    N'이때 총 합은' + cast(@hap as varchar);
go
/*waitfor*/
waitfor delay '00:00:05';
print N'5초간 멈춘 후 진행되었음';

waitfor time '00:39:00';
print N'00시 39분 00초까지 멈춘 후 진행되었음';

-- try - catch
/*
begin try
	[원래 사용하던 SQL 문장들]
end try
begin catch
	[만약 begin ,,, try에서 오류가 발생하면 처리할 일]
end catch
*/
use sqldb;
begin try
	 insert into usertbl values
		('LSG','이상구', 1988, '서울', null, null, 170, getdate())
		print N'정상적으로 입력되었다'
end try
begin catch
	print N'오류가 발생했다 ㅜㅜ'
	print N'오류 번호'
	print error_number()
	print N'오류 메세지'
	print error_message()
	print N'오류 상태 코드'
	print error_state()
	print N'오류 심각도'
	print error_severity()
	print N'오류 발생 행번호'
	print error_line()
	print N'오류 발생 프로시저/트리거'
	print error_procedure()
end catch

-- raiserrpr, throw => 오류 강제 발생
raiserror(N'이건 Raiseerror 오류발생', 16, 1);
/*16은 오류 심각도, 1은 오류 상태*/
raiserror(N'이건 Raiseerror 오류발생', 14, 2);
throw 55555, N'이건 THROW 오류 발생' , 1;
/*
55555는 에러 번호
throw에서 오류 심각도는 항상 16
*/

-- 동적 SQL
use sqlDB;
declare @sql varchar(100)
set @sql = 'select * from userTbl where userid = ''EJW'''
exec(@sql);
/*exec @sql로 실행하면 오류 발생*/
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
