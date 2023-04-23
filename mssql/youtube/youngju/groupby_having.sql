-- 해당 id정보 확인
use study
go 
select * from companyinfo
where id=40853;

-- 집계함수
select max(close_) "최고가", min(close_) "최소가", avg(close_) "평균가"
from stockprice
where id=40853;

-- group by
select id, max(close_) "최고가", min(close_) "최소가", avg(close_) "평균가", count(close_) "거래일수"
from stockprice
group by id
order by "거래일수";

select city, 
       sum(employees) "고용인",
	   max(employees) "최대고용",
	   count(*) "회사수"
from companyinfo
group by city
order by "고용인" desc;

-- having
select city, 
       sum(employees) "고용인", 
	   max(employees) "최대고용", 
	   count(*) "회사수"
from companyinfo
group by city
having sum(employees)>=2000000
order by "고용인" desc;
