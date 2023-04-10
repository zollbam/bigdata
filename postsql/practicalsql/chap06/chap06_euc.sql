-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- ������ ����
/*
1. �� ������ integer�� ��ȯ
2. ������ ���� numericŸ���� ���ڰ� �ϳ��� ������ numeric�� ��ȯ
3. �ε� �Ҽ��� ���ڰ� ������ �ε� �Ҽ��� Ÿ���� double precision�� ��ȯ
4. ����, ������, ���丮�� ���� ��쿡�� �Է��� �������� numeric�� floating-point�� ��ȯ
*/

-- �⺻����
select 2+2 "���ϱ�";
select 9-1 "����";
select 3*4 "���ϱ�";
select 20/5 "������";
select 20/6 "�Ҽ��� ������";
/*
�Ҽ������� ������ �˾Ҵ� ���� integerŸ������ ��ȯ�Ǿ� ���� ������ ����� �Ǿ���.
*/

select (20/6)::float8 "�Ҽ��� ������";
/*
������ ���Ǿ� ���� 3�� �Ǽ������� ��ġ�� ���̹Ƿ� ������ ���ϴ� 3.33333...�� ���� ������ �ʴ´�.
*/

select (20/cast(6 as float8)) "�Ҽ��� ������";
select 20/6::float8 "�Ҽ��� ������";
select 20::float8/6 "�Ҽ��� ������";
select 20.0/6 "�Ҽ��� ������";
/*
������ �Ǿ� �ִ� �ƹ� ���� �ϳ��� �Ǽ������� ������ �ؾ� �ڽ��� ���ϴ� �������ڸ� ���ڷ� ��ȯ�� �˴ϴ�.
*/

-- �׿� ���� ���� ����
select 3^4 "n�� m��";
select |/10 "������(��Ʈ)";
select sqrt(10) "������(��Ʈ)";
select ||/10 "��������";
select |||/81 "��������";
/*
�������ٵ� �ֳ� ������ ��� ������ ���´�. ��������
*/

select 4 !;
select 4 ! "���丮��";
/*
!�� portgresql13�������Ͽ����� ��� ���� �ϹǷ� ���̻��� ���������� ������ ���´�.
*/

select factorial(5) "���丮��";

-- ���� ����
/*
1. ������ ��
2. ���ϱ�, ������, ���
3. ���ϱ�, ����

* ���� ����ϰ� ������ �ִٸ� ��ȣ�� ����Ͽ� ������
*/

select 7+8*9; -- ���ϱ� ����
select (7+8)*9; -- ���ϱ� ����
select 3^3-1; -- ������ ����
select 3^(3-1); -- ���� ����

-- �α����� ���̺� ���� �̿��� ����ϱ�
-- * ����� ���̺� �ҷ�����
SELECT county_name county,
       state_name state,
       pop_est_2019 pop,
       births_2019 births,
       deaths_2019 deaths,
       international_migr_2019 int_migr,
       domestic_migr_2019 dom_migr,
       residual_2019 residual
from us_counties_pop_est_2019;

SELECT * from us_counties_pop_est_2019;

-- ���� ���� ����
SELECT county_name county,
       state_name state,
       births_2019 births,
       deaths_2019 deaths,
       births_2019 - deaths_2019 natural_increase
FROM us_counties_pop_est_2019
order by state_name, county_name;

SELECT county_name county,
       state_name state,
       pop_est_2019 pop,
       pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 + residual_2019 "components_total",
       pop_est_2019 - (pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 + residual_2019) "difference"
FROM us_counties_pop_est_2019
order by difference desc;

-- ������ ��ü ����� ���ϱ�
select county_name county,
       state_name state,
       area_water::numeric / (area_land + area_water) *100 pct_water
from us_counties_pop_est_2019
order by pct_water desc;
/*
���� ��ü ������ �󸶳� �����ϴ��� �˾ƺ��� ���� ���
*/

-- ��ȭ�� ���
/*
�� ���ں��� �󸶳� ū�����ϰų� �ð��� ���� ��ȭ�� �м��� �� �ַ� ���
*/

-- * ���̺� ����
create table percent_change (
    department text,
    spend_2019 numeric(10,2),
    spend_2022 numeric(10,2)
);

-- * ������ ����
insert into percent_change VALUES
                ('Assessor', 178556, 179500),
                ('Building', 250000, 289000),
                ('Clerk', 451980, 650000),
                ('Library', 87777, 90001),
                ('Parks', 250000, 223000),
                ('Water', 199000, 195000);

-- * ��ȭ�� ���
select department, spend_2019, spend_2022, round((spend_2022 - spend_2019)/spend_2019*100, 1) pct_change
from percent_change;

-- �ش� ���� ��� �� ���� �����Ա� ���
SELECT sum(pop_est_2019) county_sum,
       round(avg(pop_est_2019), 0) county_average
from us_counties_pop_est_2019;

-- �߾Ӱ� ã��
-- * ���� ���̺� ����
create table percentile_test(
    numbers integer
);

insert into percentile_test (numbers) VALUES
            (1), (2), (3), (4), (5), (6);

-- * ���1. ������� �Լ� ���
select percentile_cont(0.5) within group (order by numbers),
       percentile_disc(0.5) within group (order by numbers)
from percentile_test;
/*
percentile_cont�� ���� �߾Ӱ��� �Ǽ� ���·� ��ȯ
percentile_disc�� ���� �߾Ӱ��� ���� ���·� ��ȯ
*/

SELECT sum(pop_est_2019) county_sum,
       round(avg(pop_est_2019), 0) county_average,
       percentile_cont(0.5) within group (order by pop_est_2019) county_median
from us_counties_pop_est_2019;
/*
�α� �������� 2019�� ���� �α� ���� ����, ���, �߾Ӱ��� ã�ҽ��ϴ�.
*/

select percentile_cont(array[0.25, 0.5, 0.75]) within group (order by pop_est_2019) quartiles
from us_counties_pop_est_2019;
/*
������� �Լ��δ� �߾Ӱ��� ã�� �� �ִ� ���� �ƴϴ�. 10%, 20% �� �ڽ��� ���ϴ� ������ ��� ���� ��ȯ ���� ���� �ֽ��ϴ�.
array�� �������� ��������� ������ �� �ֽ��ϴ�. ���⼭�� 0.25�� 1�������, 0.75�� 3���������� �Ѵ�.
array�� ����� ���� �ٷ� �ڿ� ()�� �ƴ� []�� �������
*/

-- *
select array['1�������', '2�������', '3�������'];

-- �迭�� ������ �ٲٱ�
select unnest(array['��1�������', '��2�������', '��3�������']) "n�������",
       unnest(percentile_cont(array[0.25, 0.5, 0.75]) within group (order by pop_est_2019)) quartiles
from us_counties_pop_est_2019;
/*
unnest()�Լ��� �迭�� ������ �ٲپ��ִ� ����� �ٷ� �� ����ó�� �迭�� ��ȯ �Ǿ��� ��
���� ���� �ϱ� ���� ������ ��ȭ���� �ְ� ���� �� �����ϴ�.
*/

-- �ֺ� ã��
SELECT mode() within group (order by births_2019)
from us_counties_pop_est_2019;
/*
�� ���� ��� ī��Ƽ���� ����� ���� �����Ѱ� ���� ���� ���� ��Ÿ����.
�ֺ��� �ִ밪�� �ƴ϶� �ش� ������ �� ������ ���� ���� ������ ���� �����ִ� ���̴�.
percentile_..�� ������� �Լ��� ������ ����ϴ�.
*/

select count(*)
from us_counties_pop_est_2019
where births_2019=86;
/*
����� ���� 86���� �¾ ī��Ƽ�� �� 16���̴�.
*/

-- * ���� �ֹݰ��� 2�� �̸�??
create table mode_tbl(
    num integer
);

select mode() within group (order by a.num)
from (select unnest(array[1,1,1,2,2,2]) num) a;
/*
���� ���ϴ� ���� �ֺ��� 2�� ���;� �ϴµ� �Ѱ��� ���Դ�.
*/

with temp_mode_tbl as (
    select a.num, count(*) coun
    from (select unnest(array[1,1,1,2,2,2,3,3,3,4,5,5,6,6,7]) num) a
    group by a.num
    order by 2 desc
), temp_mode_maxcount as (
    select max(coun) max_coun
    from temp_mode_tbl
)
SELECT tmt.num
from temp_mode_tbl tmt, temp_mode_maxcount tmm
where tmt.coun = tmm.max_coun
order by 1;
/*
�ֹݰ��� ���� ���� Ű �����͸� �� ���·� ��ȯ�Ͽ����ϴ�.
*/
