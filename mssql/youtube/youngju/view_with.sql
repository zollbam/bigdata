-- 테이블 형태의 서브쿼리
use study 
go 
select seoul.name, seoul.close_
from (select ci.name, sp.date_, sp.close_
      from companyinfo ci
	       join
		   stockprice sp
		       on ci.id = sp.id 
      where city='seoul' and sp.date_ = '20201012') seoul
where close_>=500000
order by close_ desc;

-- 단일값 형태의 서브쿼리
select *
from stockprice
where id=40853 and close_=(select max(close_) 
                           from stockprice
						   where id=40853);

-- 단일 열 테이블 형태의 서브쿼리
select name 
from companyinfo
where id in (select id
             from stockprice sp
			 group by id
			 having max(close_) >=500000);

-- view
-- 1) 생성
create view vw_stockpircewithname
as
select ci.name, ci.id, sp.date_, sp.close_
from companyinfo ci 
     join
	 stockprice sp
		on ci.id = sp.id;

-- 2) 확인
select *
from vw_stockpircewithname
where name='nvidia'
order by date_;

-- 3) 삭제
drop view vw_stockpircewithname;

-- with
with with_stockpricewithname as(
	select ci.name, ci.id, sp.date_, sp.close_
	from companyinfo ci 
         join
		stockprice sp
			on ci.id = sp.id
)
select *
from with_stockpricewithname
where name='nvidia'
order by date_;
