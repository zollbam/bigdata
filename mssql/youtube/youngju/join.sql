-- join의 이해
/*
- DB의 여러 테이블을 결합하여 자신이 원하는 형태로 변환
- 어떤 방식을 쓰는지에 따라 테이블의 형태가 상이
*/
use study
go
select ci.name, sp.date_, sp.close_
from companyinfo ci join
     stockprice sp
		on ci.id = sp.id;

-- join의 종류
-- 1) inner join

-- 2) left join
select ci.name, ci.ind_id, ii.IND_Name
from companyinfo ci left join 
     industryinfo ii
		on ci.IND_ID = ii.IND_ID;

-- 3) right join
select ci.name, ci.IND_ID, ii.IND_Name
from companyinfo ci right join
     industryinfo ii
		on ci.ind_id = ii.IND_ID;

-- 4) full outer join
select ci.Name, ci.IND_ID, ii.IND_Name
from companyinfo ci full outer join
     industryinfo ii
		on ci.IND_ID = ii.IND_ID;

-- 5) 여러 개의 join
select ci.name, ci.id, d.fin_id, d.Description
from companyinfo ci 
     join
     idmap im
		on ci.id = im.ID 
	 join
	 descriptions d
		on im.fin_id = d.fin_id;

select ci.ID, ci.name, ci.ind_id, ii.ind_name, sp.Date_, sp.close_
from companyinfo ci 
     join
	 stockprice sp
		on ci.id = sp.id 
	 join
	 industryinfo ii
		on ci.IND_ID = ii.IND_ID
order by ci.id, sp.date_;

select ci.ID, ci.name, ci.ind_id, ii.ind_name, sp.Date_, sp.close_
from companyinfo ci 
     full outer join
	 stockprice sp
		on ci.id = sp.id 
	 full outer join
	 industryinfo ii
		on ci.IND_ID = ii.IND_ID
order by ci.id, sp.date_;
