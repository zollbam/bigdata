-- 연습문제
-- * 1번
select school, last_name
from teachers
order by school, last_name;

-- * 2번
select first_name, last_name
from teachers
where first_name like 'S%' and salary >= 40000;

-- * 3번
select first_name, last_name, salary
from teachers
where hire_date >= '2010-01-01';


