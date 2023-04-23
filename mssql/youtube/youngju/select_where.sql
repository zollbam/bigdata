-- 테이블 불러오기
use study
go
select * from companyinfo;

select * from study.dbo.companyinfo;

select * from study..companyinfo;

-- select
select name, city, incinctrycode from study..companyinfo;

select distinct incinctrycode from companyinfo; 

-- where
select * from companyinfo where incinctrycode='KOR';
select * from companyinfo where incinctrycode='kor';

select * from companyinfo where employees>=100000;

select * 
from companyinfo 
where incinctrycode='kor' and  employees>=50000;

select *
from companyinfo
where city='seoul' or city='busan';
select *
from companyinfo
where city in ('seoul', 'busan');

select *
from companyinfo
where not IncInCtryCode='usa'

select *
from companyinfo
where not IncInCtryCode in ('usa', 'jpn'); 

select *
from companyinfo
where name like 'a%';

select *
from companyinfo
where name like 'a____';

-- order by
select incinctrycode, Employees, name
from companyinfo
order by incinctrycode;

select incinctrycode, Employees, name
from companyinfo
where incinctrycode is not null
order by incinctrycode;

select incinctrycode, Employees, name
from companyinfo
where incinctrycode is not null
order by incinctrycode, employees desc;
