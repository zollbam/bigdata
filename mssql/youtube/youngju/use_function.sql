-- 데이터 타입
-- 1) 문자
/*
- char(n), varchar(n), varchar(max)
- nchar(n), nvarchar(n), nvarchar(max)
*/

-- 2) 숫자
/*
- tinyint, smallin, int, bigint
- decimal(p, s)
- numeric(p, s)
- smallmoney, money
- float, real
*/

-- 3) 날짜
/*
- datetime, datetime2, smalldatetime
- date, time
*/

-- 4) 바이너리, 이미지, xml 등


-- 내장함수
-- 1) 집계함수
use study 
go 
select sum(employees) "합계", 
       avg(employees) "평균",
	   max(employees) "최대",
	   min(employees) "최소",
	   count(employees) "개수"
from companyinfo;

-- 2) 문자열 함수
print len(' Abc Def Fed CBa '); -- 길이 오른쪽 공백 한개는 길이 포함 X
print len(' Abc Def Fed CBa  '); -- 공백이 2개여도 길이는 16
print ltrim(' Abc Def Fed CBa '); -- 왼쪽 공백제거
print rtrim(' Abc Def Fed CBa '); -- 오른쪽 공백제거
print upper(' Abc Def Fed CBa '); -- 대문자로
print lower(' Abc Def Fed CBa '); -- 소문자로
print left(' Abc Def Fed CBa ', 6); -- 왼쪽에서 6만큼 길이 추출
print right(' Abc Def Fed CBa ', 8); -- 오른쪽에서 8만큼 길이 추출
print reverse(' Abc Def Fed CBa '); -- 문자열을 거꾸로 추출
print replace(' Abc Def Fed CBa ', 'Abc', 'zzz'); -- 문자열 변환
print replicate('HI',10); -- 반복 추출
print '[' + space(10) + ']'; -- 대괄호 안에 공백이 열개
print str(12345) + '6789'; -- 문자열 합치기
print substring(' Abc Def Fed CBa ', 6, 3); -- 문자열 자르기
print charindex('Def', ' Abc Def Fed CBa '); -- 문자열이 위치 인덱스 반환

-- 날짜 함수
print getdate(); -- 지금 날짜 및 시간
print year(getdate()); -- 년 반환
print month(getdate()); -- 월 반환
print day(getdate()); -- 일 반환
print datediff(day, getdate(), '2012-12-25'); -- 날짜 일 단위로 빼기
print datediff(day, '2012-12-25', getdate()); -- 날짜 일 단위로 빼기
print datediff(year, '2012-12-25', getdate()); -- 날짜 일 단위로 빼기
print datediff(month, '2012-12-25', getdate()); -- 날짜 일 단위로 빼기
print dateadd(month, 3, getdate()); -- 날짜 월 단위로 더하기

-- 형식변환
-- print 2020+'년'; 숫자+문자는 오류
-- print cast(2020 as varchar) + '년'; '년'앞에 N을 붙이지 않으면 ssms는 한글을 인식 불가
print cast(2020 as varchar) + N'년';
print convert(varchar, 2020) + N'년';
print cast(getdate() as varchar);
print convert(varchar(8), getdate(), 112);
