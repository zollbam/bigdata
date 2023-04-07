-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- 연습문제
-- * 1번
select 5^2*3.14;
/*
반지름 길이가 5인 원의 면적
*/

-- * 2번
select county_name, state_name, births_2019, deaths_2019, deaths_2019::numeric/births_2019 rate
from us_counties_pop_est_2019
where state_name ilike 'new york'
order by 5 desc;
/*
출생 대비 라고 해서 출생을 분모로 사망을 분자로 삼았습니다.
뉴욕시는 거의 절반이상의 카운티가 1을 넘는 것으로 확인 되었습니다.
이말은 태어나는 사람보다 사망하는 사람이 더 많다는 것을 의미합니다.
*/

-- * 3번
SELECT state_name, percentile_cont(0.5) within group (order by pop_est_2019)
from us_counties_pop_est_2019
where state_name in ('New York','California')
group by state_name;
/*
캘리포니아의 중앙값은 187029, 뉴욕은 86687로
캘리포니아가 2배 가까이 높은 것으로 나타났다.
*/
