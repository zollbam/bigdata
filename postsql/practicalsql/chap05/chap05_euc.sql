-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- ���� ��
/*
�����Ͱ�  ����, ��õ, ���鸸���� ���� �ҷ����� �� ���ε� ������ insert������ �ҷ����� ������ ���� ���̴�.
postgresql������ copy����� ���� �뷮���� �����͸� ������ �� �ֽ��ϴ�.
copy��ɾ�� �����͸� �ҷ����� �������� ����� ��� ������ �ֽ��ϴ�.
MYSQL������ load data infile��, microsoft sql server���� ��ü bulk insert ������� �뷮 �������� �溱�� ���

������ �� ���ٿ� ���� �� �̸��� ���� �ִ� ��찡 ���� �ֽ��ϴ�. �̰��� ������̷��� �մϴ�.
postgresql������ ������� ������� �ʽ��ϴ�. �׷��� copy��ɿ��� header�ɼ��� ����Ͽ� ���ܽ�ŵ�ϴ�.

csv������ ������ ������ü������ �ְ� ������ �ؽ�Ʈ�� ��� ������ �� �� �� �ֱ� ������
������ �ҷ��� �� �׻� �����͸� �����ϴ� ������ �������� ����!!
*/

-- ���� �ҷ����� ����
create table supervisor (
    town varchar(15),
    supervisor varchar(10),
    salary numeric(6)
);
/*
copy ���̺�� ~~���� ������ �����ϴµ� DB�� �ش� ���̺��� �־�� ������ ������ ������ ��Ÿ��
������ ���̺��� ���� ���־�� �Ѵ�.
*/

copy supervisor
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header);
/*
���̺� �������� ���̸��� �־��� �����Ƿ� copy�� ������ �ҷ��� �� ������� �����ϰ� �����͸� �����ؾ� �Ѵ�.

with���� �ɼǵ��� ��� �˸� ���� => https://www.postgresql.org/docs/current/sql-copy.html ����  �˾ƺ���
������ �Ϲ������� ���� ��� ���� ���ҽ��ϴ�.
1. format
 - ���� �̸��� csv, text, binary �� �ֽ��ϴ�.
 - �ַ� csv�� ���� ����, text�� \r���� ASCII����(ĳ���� ����)�� �νĵ˴ϴ�.

2. HEADER
 - �����͸� �ҷ��� ���� ������ ������� �ִٴ� ���� �˷��ݴϴ�.
 - �����͸� ������ ���� ��� ���� ���Խ��� ���� ���� �ݴϴ�.

3. delimiter 
 - �������� ���� �������� ���Ͽ��� �����ڷ� ����� ���ڸ� ����
 - ����: delimiter '|'

4. quote
 - ������ �ؽ�Ʈ ������ ������ �ϴ� ���ڷ� �ѷ��ο� �ִ� ��쿡 ����Ѵ�.
*/

table supervisor;

-- �̱� ��� ī��Ƽ�� ���� �α� ����ġ ������
-- * ���̺� ����
create table us_counties_pop_est_2019(
    state_fips text, -- ���ڵ�
    county_fips text, -- ī��Ƽ �ڵ�
    region text, -- ī��Ƽ�� ��ġ => �ϵ���, �߼���, ����, ����
    state_name text, -- ���̸�
    county_name text, -- ī��Ƽ�̸�
    area_land bigint, -- ī��Ƽ�� �ִ� ���� ����
    area_water bigint, -- ī��Ƽ�� �ִ� �� ����
    internal_point_lat numeric(10, 7), -- ����(ī��Ƽ ���߾ƺ� �����̿� ��ġ�� ����)�� ����
    internal_point_lon numeric(10, 7), -- ����(ī��Ƽ ���߾ƺ� �����̿� ��ġ�� ����)�� �浵
    pop_est_2018 INTEGER, -- 2018�� 7�� 1�� ���� �α� ����ġ
    pop_est_2019 INTEGER, -- 2019�� 7�� 1�� ���� �α� ����ġ
    births_2019 INTEGER, -- 2018�� 7�� 1�Ϻ��� 2019�� 6�� 30�� ���� ����� ��
    deaths_2019 INTEGER, -- 2018�� 7�� 1�Ϻ��� 2019�� 6�� 30�� ���� ����� ��
    international_migr_2019 INTEGER, -- 2018�� 7�� 1�Ϻ��� 2019�� 6�� 30�� ���� �� ���� ������ ��
    domestic_migr_2019 INTEGER, -- 2018�� 7�� 1�Ϻ��� 2019�� 6�� 30�� ���� �� ���� ������ ��
    residual_2019 INTEGER, -- �ϰ����� ���� ����ġ�� �����ϴµ� ���Ǵ� ����
    constraint counties_2019_key  PRIMARY key (state_fips, county_fips)
);

-- * ���� �ҷ�����
copy us_counties_pop_est_2019
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\us_counties_pop_est_2019.csv'
with (format csv, header);

-- * ���̺� Ȯ��
table us_counties_pop_est_2019;
/*
3142�� 16���� ���� ���̺��̴�.
�� �����ʹ� 2020�� �� ������ �����ͷ� �̱��� ��� ��� ����� ���̿� ����, ����, �������� ������ �� �����ʹ� 
435���� �̱��Ͽ��� �� ���� �ǿ��� �� �� ��ġ���� �����ϴµ� ����ϱ� ���� ������ �ҷ��Խ��ϴ�.

���ڵ带 int�� �ƴ� text�� �����ϴ� ������ ���� ������ �����Ͽ� 02��� ���� �����ϸ� 0�� ������� 2�� ���⶧���� ���߿� ���ǹ����� 02=2���� ������ ���� �� �ִ�.
*/

-- * ������ �˻��ϱ�
SELECT county_name, state_name, area_land
from us_counties_pop_est_2019
order by area_land DESC
limit 3;
/*
���̸�, ī��Ƽ �̸�, �������̸� �ҷ��ͼ� ���� ���̸� �������� ���������� �ϰ� ������ 3���� �ุ �����Ѵ�.
��, �� ���� �������̰� ū 3���� ���̸��� ī��Ƽ �̸��� ������ִ� �����Դϴ�.
*/

SELECT county_name, state_name, internal_point_lat, internal_point_lon
from us_counties_pop_est_2019
order by internal_point_lon DESC
limit 5;
/*
�浵�� �������� ū ������ ������������ ���� 5���� �ุ �����ϴ� �����Դϴ�.
*/

-- ���̺� ��� ���� ���� �����Ͱ� �������� �ʾƵ� �����Ϳ� �ִ� ���� �����Ͽ� �������� ���
-- * ���̺� ����
create table supervisor_salaries(
    id integer generated always as identity primary key,
    town text,
    county text,
    supervisor text,
    start_date date,
    salary numeric(10,2),
    benefits NUMERIC(10,2)
);

-- * ���� ��������
copy supervisor_salaries
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header);
/*
�ҷ��� csv���ϰ� ���̺��� ���� ����� �޶� ������ ����ϴ�.
*/

copy supervisor_salaries(town, supervisor, salary)
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header);
/*
(town, supervisor, salary)���� ���� �����Ͱ� �� ���� ������ �ݴϴ�.
���� ���� ���� ������ null�� ��ü �˴ϴ�.
*/

-- * ���̺� Ȯ��
table supervisor_salaries;

-- ���Ͽ��� �ʿ� �ุ �����ͼ� ���̺� �����ϱ�
-- * ���̺� �� ������ ����
DELETE from supervisor_salaries;
/*
���̺��� �״�� ���� �ְ� �����͸� ������ �ȴ�.
*/

-- * �ش� ���� �����͸� ���̺� ����
copy supervisor_salaries(town, supervisor, salary)
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header)
where town = 'New Brillig';
/*
town���� New Brillig�� �ุ ���̺� �߰� �ȴ�.
*/

-- * ���̺� Ȯ��
table supervisor_salaries;

-- * �ٸ� �������� �����͸� ����
DELETE from supervisor_salaries;

copy supervisor_salaries(town, supervisor, salary)
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header)
where town <> 'New Brillig';
/*
town�� New Brillig�� �ƴϸ� �� ����
*/

table supervisor_salaries;

-- ���� �����ý� ���ο� ���� �߰��ϱ�
/*
���� �ҷ��� �� ���ο� ���� �߰��ϱ� ���ؼ��� �ӽ� ���̺� ������ �����ϰ�
�ӽ����̺� ���ο� ���� �߰��ϰ� ���� ���̺� �����ϴ� ������� ������ ����Դϴ�.
*/
-- * ���̺� �� ������ ����
delete from supervisor_salaries;

-- * �ӽ����̺� ����
create TEMPORARY table supervisor_salaries_temp
    (like supervisor_salaries including all);
/*
supervisor_salaries_temp��� �ӽ� ���̺��� �����Ͽ� supervisor_salaries�� ������ �����ؿͼ�
���̸��̳� Ÿ�� ���� �����Խ��ϴ�.

including all�� ���̺� ��� ���Ӹ��� �ƴ϶� �ε��� �� identity ������ ���� ���� ��ҵ� ����
*/

-- * ���� �ҷ�����
copy supervisor_salaries_temp(town, supervisor, salary)
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header);

-- * ���ο� �� �߰�
insert into supervisor_salaries(town, county, supervisor, salary)
select town, 'Mills', supervisor, salary
from supervisor_salaries_temp;

-- �ӽ����̺� ����
drop table supervisor_salaries_temp;

-- ���̺� Ȯ��
table supervisor_salaries;

-- ��� ������ �������� 
copy supervisor_salaries
TO 'D:\test\postgresql\practicalsql\supervisor_salaries_export.txt'
with (format csv, header, delimiter '|');
