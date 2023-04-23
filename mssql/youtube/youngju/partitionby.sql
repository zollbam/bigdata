-- 순위함수 => row_number, rank, dense_rank
use study
go
select name, employees, ROW_NUMBER() over (order by employees desc) "순위"
from companyinfo
where employees is not null
order by "순위";
/*
ROW_NUMBER()
8위와 9위는 employees가 451000로 동일 하지만 순위는 다르다.
*/

select name, employees, rank() over (order by employees desc) "순위"
from companyinfo
where employees is not null
order by "순위";
/*
rank()
employees가 451000인 값이 2개가 있는데 서로 순위는 동일
하지만 employees가 450000인 순위는 10위
if, 451000값을 가진 회사가 3개 였다면 450000의 순위는 11위
*/

select name, employees, dense_rank() over (order by employees desc) "순위"
from companyinfo
where employees is not null
order by "순위";
/*
dense_rank()
employees가 455095인 값이 2개가 있는데 서로 순위는 동일 => 6위
employees가 451000인 값이 2개가 있는데 서로 순위는 동일 => 7위
employees가 450000인 순위 => 8위
if, 451000값을 가진 회사가 3개 였어도 450000의 순위는 8위
*/

-- 이동함수 => lead, lag
select date_,
       lag(close_) over (order by date_) "어제종가",
       close_ "종가",
       lead(close_) over (order by date_) "내일종가"
from stockprice
where id=40853
order by date_;

select date_,
       close_/lag(close_) over (order by date_)-1 "오늘수익률",
       lead(close_) over (order by date_)/close_-1 "내일수익률"
from stockprice
where id=40853
order by date_;

-- partition by
select IncInCtryCode, 
       name, 
	   employees, 
	   rank() over (partition by IncInCtryCode order by employees desc) "순위"
from companyinfo
where IncInCtryCode is not null;

select name, 
       IncInCtryCode, 
	   employees, 
	   rank() over (partition by IncInCtryCode order by employees desc) "순위"
from companyinfo
where IncInCtryCode is not null;

select date_,
       id,
       close_/lag(close_) over (partition by id order by date_)-1 "순위" 
from stockprice;

select date_,
       id,
	   close_,
	   avg(close_) over (partition by id 
	                     order by date_ rows between 2 preceding and 0 preceding /*2일 이전부터 현재까지 날짜 3일간*/) "SMA3"
from stockprice;
