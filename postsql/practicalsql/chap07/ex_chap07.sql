-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- 연습문제
-- * 1번
select *
from us_counties_pop_est_2019 c2019 join us_counties_pop_est_2010 c2010 using(state_fips, county_fips);

select c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019, 
       c2010.estimates_base_2010,
       round((c2019.pop_est_2019 - c2010.estimates_base_2010::numeric) / c2010.estimates_base_2010 * 100,1) dec_rate
from us_counties_pop_est_2019 c2019 join us_counties_pop_est_2010 c2010 using(state_fips, county_fips)
order by dec_rate;
/*
Concho County카운티 주에서 -33%로 가장 많은 인구가 감소 하였습니다.
감소 이유는 2017년 Eden Detention Center라는  교도소가 문을 닫아서 직원들이 일자리를 잃었다.
*/

-- * 2번
select county_name, state_name, '2010' "year", estimates_base_2010 from us_counties_pop_est_2010
union
select county_name, state_name, '2019' "year", pop_est_2019 from us_counties_pop_est_2019
ORDER BY county_name, state_name;

-- * 3번
select percentile_cont(0.5) within group (order by c2019.pop_est_2019) "2019_med",
       percentile_cont(0.5) within group (order by c2010.estimates_base_2010) "2020_med"
from us_counties_pop_est_2019 c2019 join us_counties_pop_est_2010 c2010 using(state_fips, county_fips);
/*
19년도와 10년도의 인구 추정치의 중앙값을 구해보았습니다.
*/

select percentile_cont(0.5) within group (order by rt.dec_rate) "rate_med"
from (select c2019.county_name,
             c2019.state_name,
             round((c2019.pop_est_2019 - c2010.estimates_base_2010::numeric) / c2010.estimates_base_2010 * 100,1) dec_rate
      from us_counties_pop_est_2019 c2019 join us_counties_pop_est_2010 c2010 using(state_fips, county_fips)) rt;
/*
10년 대비 19년도의 인구 비율의 중앙값을 찾아보았습니다.
*/
