-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- join�� ����
/*
������ JOIN ... ON ~~ �ε� �Ϲ������� ON�ڿ��� ���� ���� ����ϱ� ���� =�� ��κ� ������
���� ON tablea.keya >= tableb.keyb���� �ε�ȣ�� join�� �ϴ� ��쵵 ������ �˾Ƶ���
*/

-- ���� ���̺� ����
create table departments(
    dept_id integer,
    dept text,
    city text,
    constraint dept_key primary key (dept_id),
    constraint dept_city_unique unique (dept, city)
);
/*
unique�� �ϳ� �̻� ������ �����ϴ�.
���⼭�� dept�� city�� ���ÿ� ����ũ �̹Ƿ� �ػ罺�� tax�μ��� 1���� �ִٴ� ���� �� �� �ִ�.
*/

create table employees (
    emp_id INTEGER,
    first_name text,
    last_name text,
    salary numeric(10,2),
    dept_id integer references departments (dept_id),
    constraint emp_key primary key (emp_id)
);
/*
�⺻Ű�� ������ ���� unique�����ϰ� �������� null���� ��� �Ѵ�.
�ܷ�Ű�� �⺻Ű�� �ٸ��� null���� �ߺ����� ���� �� ������ ������ ������ �⺻Ű �ȿ� �ش� ���� �־�� �Ѵ�.
*/

insert into departments values 
                (1, 'Tax', 'Atlanta'),
                (2, 'IT', 'Boston');
INSERT INTO employees VALUES
                (1, 'Julia', 'Reyes', 115300, 1),
                (2, 'Janet', 'King', 115300, 1),
                (3, 'Arthur', 'Pappas', 72700, 2),
                (4, 'Michael', 'Taylor', 89500, 2);

table departments;
table employees;

-- join�� ����
/*
1. JOIN
  - ���̺���� ���ε� ������ ��ġ�ϴ� ���� �ִ� �� ���̺��� ���� ��ȯ
  - ��ü�� inner join

2. left JOIN
  - ���� ���̺��� ��� ���� ��ȯ
  - ������ ���̺��� ��ġ�ϴ� ���� ���� ���� ã���� �ش� ���� ���� ����� ���Ե�����
    �׷��� ������ ������ ���̺� ���� ����� ���Ե��� �ʽ��ϴ�.

3. RIGHT JOIN
  - ������ ���̺��� ��� ���� ��ȯ
  - ���� ���̺��� ��ġ�ϴ� ���� ���� ���� ã���� �ش� ���� ���� ����� ���Ե�����
    �׷��� ������ ���� ���̺� ���� ����� ���Ե��� �ʽ��ϴ�.

4. FULL JOIN
  - ���̺��� ��� ���� ��ȯ�ϰ� ���� ��ġ�ϴ� ���� ����
  - ���� OR ������ ���̺� ��ġ�ϴ� �� ���� ���� ����� �ٸ� ���̺� ���� ���� ����

5. CROSS JOIN
  - �����̺��� ������ ��� �� ������ ��ȯ
*/

-- 2�� ���̺� join�ϱ�
select *
from employees join departments
               on employees.dept_id = departments.dept_id
order by employees.dept_id;

-- ������ ���� join����
-- * ���̺� �����
create table district_2020 (
    id integer constraint id_key_2020 primary key,
    school_2020 text
);

create table district_2035 (
    id integer constraint id_key_2035 PRIMARY key,
    school_2035 text
);

insert into district_2020 values
                (1, 'Oak Street School'),
                (2, 'Roosevelt High School'),
                (5, 'Dover Middle School'),
                (6, 'Webutuck High School');

insert into district_2035 values
                (1, 'Oak Street School'),
                (2, 'Roosevelt High School'),
                (3, 'Morrison Elementary'),
                (4, 'Chase Magnet Academy'),
                (6, 'Webutuck High School');

-- * (inner) join
select *
from district_2020 join district_2035 
                   on district_2020.id = district_2035.id
order by district_2020.id;
/*
(inner) join�� �����̺��� id�� ������ �����ϰ� �ִ� ��쿡�� ���� ������ ���ִ� �������� ���¶�� ���� �˴ϴ�.
���̺��� �ִ� �����ʹ� ���� ����� ������ �ʽ��ϴ�.
*/

-- ** using�� ���
select *
from district_2020 join district_2035 using(id)
order by district_2020.id;
/*
using�� ���Ϸ��� �ΰ��� ���̺��� ���̸��� ���� ��쿡�� ����� �� �ֽ��ϴ�.
on��� using�� ����Ͽ� �ߺ� ��µǴ� ���� ���̰� �������� ���� �� �ֽ��ϴ�.
on���� id�� 2�� ������ �;� �ϳ��� �پ�� ���� Ȯ�� �� �� �ֽ��ϴ�.
���� 2�� �̻��� ���� �����ϴ� ��쿡�� ��ǥ�� �����ؼ� ������ �ȴ�. => ���� ��� (id, class)��
*/

-- * left join
select *
from district_2020 left join district_2035 using(id)
order by district_2020.id;

select *
from district_2020 left join district_2035 using(id)
order by id;
/*
���� 2���� ������ ��� ���� ����� ������ �ȴ�.
using���� ���� ���̺��� �տ� ���̺��.�� ���� �ʾƵ� ������ �߻����� �ʴ´�.
*/

select *
from district_2020 left join district_2035 using(id)
order by district_2035.id;
/*
district_2035���̺��� id�� 5�� �����Ͱ� ��� ���� ���ؿ� ��� ���� �ؿ� �ִ� ���� Ȯ�� �Ͽ����ϴ�.
*/

-- * right join
select *
from district_2020 right join district_2035 using(id)
order by id;
/*
left join�̳� right join�� �ڽ��� ���� ������ + ������ �����Ͷ�� �����ϸ� �ȴ�.
*/

-- * full (outer) join
select *
from district_2020 full outer join district_2035 using(id)
order by id;

select *
from district_2020 full join district_2035 using(id)
order by id;
/*
full outer join���� �ص� �ǰ� outer�� ������ full join���� �ص� �ȴ�.
�����̺� �ִ� ��� �����Ͱ� ���ԵǴ� ������ ���·� ������ �˴ϴ�.
*/

-- * cross join = cartesian product(��ī��Ʈ ��)
select *
from district_2020 cross join district_2035
order by district_2020.id;
/*
��ī��Ʈ���� ������ ��� �� ������ ��Ÿ���ϴ�. �׷��� on�� �ʿ䰡 �����ϴ�.
�׷��� using�ᵵ ������ ������ �ȴ�.
district_2020���̺� 4��� district_2035���̺� 5�� ��� ������ 4*5 = 20���� ������ �ȴ�.
*/

-- * null�� �ִ� ������ ã��
select *
from district_2020 left join district_2035 using(id)
where school_2035 is null
order by id;
/*
������ ����� id�� �����ϸ鼭 �������̺��� �ִµ� ������ ���̺��� ���� �����͸� �����ϰ� �ȴ�.
*/

select *
from district_2020 right join district_2035
                   on district_2020.id = district_2035.id
where district_2020.id is null;

select *
from district_2020 right join district_2035 using(id)
where school_2020 is null
order by id;
/*
���� 2�� ������ ����� ���� ���̺�� ��ġ���� �ʴ� ������ ���̺��� ���� ���� ���ؼ� ����� ����
*/

-- ���̸��� �ָŸ�ȣ
select district_2020.id
from district_2020 left join district_2035
                   on district_2020.id = district_2035.id
order by district_2035.id;
/*
id��� ���̸��� district_2020�� district_2035���̺� ��ο� id��� ���� �����ȷ�
� ���̺��� id�� ����ϴ��� �Ǵ��� ���� ������ �߻��մϴ�.
*/

select district_2020.id, district_2020.school_2020, district_2035.school_2035
from district_2020 left join district_2035
                   on district_2020.id = district_2035.id;
/*
�̷��� Ư�� ���̺��� ���̸��� �������־�� �������� ������ ��ȯ�մϴ�.
*/

-- ���̺� ��Ī���� ���� ���� �ܼ�ȭ��Ű��
select d20.id, d20.school_2020, d35.school_2035
from district_2020 d20 right join district_2035 d35
                       on d20.id = d35.id;
/*
���̺� ��Ī�� �����ϸ鼭 ������ �ܼ������� �ٸ� ������� �������� �������� �Ǿ�
���⼺�� �ٿ� �ִ� ȿ���� �� �� �ֽ��ϴ�.
*/

-- ���� ���̺� join�ϱ� => 3�� �̻� ����
-- * ���� ���̺� ����
create table district_2020_enrollment (
    id integer,
    enrollment integer
);

create table district_2020_grades (
    id integer,
    grades varchar(10)
);

insert into district_2020_enrollment values
                (1, 360),
                (2, 1001),
                (5, 450),
                (6, 927);

insert into district_2020_grades values
                (1, 'K-3'),
                (2, '9-12'),
                (5, '6-8'),
                (6, '9-12');

-- * 3�� ���̺� join
select d20.id, d20.school_2020, en.enrollment, gr.grades
from district_2020 d20 join district_2020_enrollment en
                       on d20.id = en.id
                       join district_2020_grades gr
                       on d20.id = gr.id
order by d20.id;

select id, school_2020, enrollment, grades
from district_2020 d20 join district_2020_enrollment en using(id)
                       join district_2020_grades gr using(id)
order by id desc;
/*
id�� ������������ �����Ͽ��� using�� ����Ͽ� ������ �ٿ� ���ҽ��ϴ�.
*/

-- ���տ����ڷ� ���� ��� �����ϱ�
/*
1. union(������)
  - �ι�° ���� ���� ù��° ������ �࿡ �߰��ϰ� �ߺ��� ����
  - union all�� �ϸ� �ߺ��� ������ ä�� ����� �����ش�.
  - ��������� �� �� ����!!!
  - school_2020�� school_2035�� ���̸��� �޶� �������.
*/
select * from district_2020
UNION
select * from district_2035
order by id;

select * from district_2020
UNION all
select * from district_2035
order by id;

select '2020' "year", school_2020 school from district_2020
union
select '2035' "year", school_2035 school from district_2035
order by school, "year";
/*
�� ���� � ���̺��� �Դ����� Ȯ�� �����ϴ�.
*/

/*
2. intersect(������)
  - �� ������ ��� �����ϴ� �ุ ��ȯ�ϰ� �ߺ��� ����
*/
select * from district_2020
INTERSECT
select * from district_2035
order by id;

select '2020' "year", school_2020 school from district_2020
INTERSECT
select '2035' "year", school_2035 school from district_2035;
/*
year�� ������ 2���� ���̺� �ߺ��Ǵ� ���� �����Ƿ� ����� �ƹ��͵� �� ���´�.
*/

/*
3. except(������)
  - ù��° �������� ������ �ι�° �������� ���� ���� ��ȯ
*/
select * from district_2020
except
select * from district_2035
order by id;

-- ���ε� ���̺�� ���� ����ϱ�
-- * ���� ������ ����
create table us_counties_pop_est_2010 (
    state_fips text,
    county_fips text,
    regopm smallint,
    state_name text,
    county_name text,
    estimates_base_2010 integer,
    constraint counties_2010_key PRIMARY key (state_fips, county_fips)
);

copy us_counties_pop_est_2010
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_07\us_counties_pop_est_2010.csv'
with (format csv, header);

-- * join ���̺� ���� ���
select c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019,
       c2010.estimates_base_2010 pop_2010,
       c2019.pop_est_2019 - c2010.estimates_base_2010 row_change,
       round((c2019.pop_est_2019::numeric - c2010.estimates_base_2010) / c2010.estimates_base_2010 * 100, 1) pct_change
from us_counties_pop_est_2019 c2019 join us_counties_pop_est_2010 c2010 using(state_fips, county_fips)
order by pct_change desc;
/*
pct_change�� 100�� �Ѵ� �����͵��� 10�⵵�� ���� 19�⵵�� 2�� �̻� �α��� ���� �ߴٰ� ����.
*/
