-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- ��������
-- * 1��
select 5^2*3.14;
/*
������ ���̰� 5�� ���� ����
*/

-- * 2��
select county_name, state_name, births_2019, deaths_2019, deaths_2019::numeric/births_2019 rate
from us_counties_pop_est_2019
where state_name ilike 'new york'
order by 5 desc;
/*
��� ��� ��� �ؼ� ����� �и�� ����� ���ڷ� ��ҽ��ϴ�.
����ô� ���� �����̻��� ī��Ƽ�� 1�� �Ѵ� ������ Ȯ�� �Ǿ����ϴ�.
�̸��� �¾�� ������� ����ϴ� ����� �� ���ٴ� ���� �ǹ��մϴ�.
*/

-- * 3��
SELECT state_name, percentile_cont(0.5) within group (order by pop_est_2019)
from us_counties_pop_est_2019
where state_name in ('New York','California')
group by state_name;
/*
Ķ�����Ͼ��� �߾Ӱ��� 187029, ������ 86687��
Ķ�����Ͼư� 2�� ������ ���� ������ ��Ÿ����.
*/
