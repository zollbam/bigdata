-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- ��������
-- * 1��
-- ** ���̺� ����
CREATE TABLE actors1 (
    id integer,
    movie text,
    actor text
);

CREATE TABLE actors2 (
    id integer,
    movie text,
    actor text
);

-- ** ���� �ҷ�����
/*
å���� ������ ������δ� ������ ���ͼ� ������� ���� �Ͽ����ϴ�.
actor1.txt
id:movie:actor
50,#Mission: Impossible#,Tom Cruise

actor2.txt
id:movie:actor
50,"#Mission: Impossible#","Tom Cruise"
*/

COPY actors1
FROM 'D:\test\postgresql\practicalsql\actor1.txt'
WITH (FORMAT CSV, HEADER, QUOTE '#');

COPY actors2
FROM 'D:\test\postgresql\practicalsql\actor2.txt'
WITH (FORMAT CSV, HEADER, QUOTE '"');
/*
movie�� ���� #�� ���ʿ� ���� �˴ϴ�.
*/

table actors1;
table actors2;

-- * 2��
-- ** ���� ���
SELECT county_name, state_name, births_2019
from us_counties_pop_est_2019
order by births_2019 DESC
limit 20;

-- ** ���� ��������
copy (SELECT county_name, state_name, births_2019
      from us_counties_pop_est_2019
      order by births_2019 DESC
      limit 20)
to 'D:\test\postgresql\practicalsql\result1.txt'
with (format csv, header);

-- * 3��
/*
chap5_ex3.txt���Ͽ�
17519.668
20084.461
18976.355
�� ����Ǿ��ִٴ� �����Ͽ� ������ ����
*/

-- ** ���̺� ����
create table chap05_ex03 (
    flo numeric(3,8)
);
/*
�켱 ��ü�� 3�ڸ��ε�, �Ҽ����� 8�� ���� �Ѵٴ� ���� ���� ���� �ʽ��ϴ�.
�׷��� ������ ������ ��Ȳ�Դϴ�.
*/

create table chap05_ex03 (
    flo numeric(8,3)
);
/*
�켱 ��ü�� 8�ڸ��� �Ҽ����Ʒ� 3���� ����ϹǷ� �������� ���̺� ����
*/

-- ** ���Ϻҷ�����
copy chap05_ex03
from 'D:\test\postgresql\practicalsql\chap5_ex3.txt'
with (format csv);
/*
txt���Ͽ� ����� �� �״�� ���̺�� ������ �ȴ�.
*/

-- ** ���̺� Ȯ��
table chap05_ex03;
