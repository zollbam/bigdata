/*
mssql
날짜 23-05-20

https://youtu.be/L9LLnRlKm0c

SQL Server의 툴과 유틸리티 사용하기

SSMS: SQL Server엔진에 접속하기 위한 클라이언트 도구

[HumanResources].[Employee]에는 [dEmployee]트리거를 열어 쿼리문을 확인 할 수 있음

ctrl + shift + V 로 이전에 복사 한것을 순서대로 붙여넣기가 가능
*/

-- DB정보 확인
exec sp_helpdb 'ShopDB';

use [AdventureWorks];

-- 코드 조각 삽입
/*
쿼리 창에서 마우스 오른쪽을 누르고 코드 조각 삽입을 누르면
해당 기능에 대한 문법이 쿼리문 형태로 나오게 됨

단축키는 ctrl + K, ctrl + X
*/

-- 코드 감싸기
/*
쿼리문 전체를 if, while, begin 으로 감쌀수 있음

단축키는 ctrl + K, ctrl + S
*/

BEGIN

CREATE TABLE dbo.Sample_Table
(
    column_1 int NOT NULL,
    column_2 int NULL
); 

END

-- 텍스트 형태로 값 출력
/*
마우스 오른쪽 버튼을 눌러 결과 처리 방법에서 
텍스트로 결과 표시를 누르면 텍스트 형태로 값이 출력
*/
use AdventureWorks;
select * from Production.Product;

-- 쿼리 결과를 다른파일로 저장
/*
결과 창에서 오른쪽 마우스를 눌러 다른 이름으로 결과 저장을
눌러 결과가 표면 .csv나 .txt, 결과가 텍스트면 rpt로 출력가능
*/

-- 디버깅
/*
alt + f5로 디버깅을 시작하고 f11로 한줄씩 실행
*/
use tempdb;
declare @var1 int
declare @var2 int
set @var1 = 100
set @var2 = 200
print @var1 + @var2;

-- 프로 파일러
/*
설명
 - 최적화를 위해서 사용되는 유용한 도구
 - 고급 DB개발자의 경우에 상당히 자주 사용하는 도구

용도
 - 발생하는 각종 이벤트를 추적하고 수집
 - 서버의 성능을 떨어뜨리는 지를 쉽게 확인 가능

사용방법
 - 위의 메뉴창에서 도구 => SQL Server Profiler을 눌러
   sql과 연결
*/

use AdventureWorks;
go
select * from Person.Address; 
go
select * from Production.ProductCostHistory; 
go
select * from Sales.Customer;
go
