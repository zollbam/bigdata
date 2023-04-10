-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- ��������
-- * 1��
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
Concho Countyī��Ƽ �ֿ��� -33%�� ���� ���� �α��� ���� �Ͽ����ϴ�.
���� ������ 2017�� Eden Detention Center���  �����Ұ� ���� �ݾƼ� �������� ���ڸ��� �Ҿ���.
*/

-- * 2��
select county_name, state_name, '2010' "year", estimates_base_2010 from us_counties_pop_est_2010
union
select county_name, state_name, '2019' "year", pop_est_2019 from us_counties_pop_est_2019
ORDER BY county_name, state_name;

-- * 3��
select percentile_cont(0.5) within group (order by c2019.pop_est_2019) "2019_med",
       percentile_cont(0.5) within group (order by c2010.estimates_base_2010) "2020_med"
from us_counties_pop_est_2019 c2019 join us_counties_pop_est_2010 c2010 using(state_fips, county_fips);
/*
19�⵵�� 10�⵵�� �α� ����ġ�� �߾Ӱ��� ���غ��ҽ��ϴ�.
*/

select percentile_cont(0.5) within group (order by rt.dec_rate) "rate_med"
from (select c2019.county_name,
             c2019.state_name,
             round((c2019.pop_est_2019 - c2010.estimates_base_2010::numeric) / c2010.estimates_base_2010 * 100,1) dec_rate
      from us_counties_pop_est_2019 c2019 join us_counties_pop_est_2010 c2010 using(state_fips, county_fips)) rt;
/*
10�� ��� 19�⵵�� �α� ������ �߾Ӱ��� ã�ƺ��ҽ��ϴ�.
*/
