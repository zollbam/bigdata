-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- theachers���̺� �ҷ�����
-- * ���1
SELECT *
from teachers;

-- * ���2
table teachers;

-- �ʿ��� �� ������ �ޱ�
select last_name, first_name, salary
from teachers;

-- ������ �����ϱ�
-- * ���̸�����
select last_name, first_name, salary
from teachers
order by salary desc;
/*
salary�� �������� �������� ������
*/

-- * ���ڷ�
select first_name, last_name, salary
from teachers
order by 3 desc;
/*
select���� ���ǵ� ������ ������ �°� 1���� ���۵ȴ�.
3�� 3��° ���� salary�� ����Ų�ٰ� �� �� �ִ�.
*/

-- * ���� ���� �������� �����ϱ�
select last_name, school, hire_date
from teachers
order by school, hire_date desc;
/*
school�� ���� �����ϰ� ���� ���� �ִٸ� hire_date�� �������� �����Ѵ�.
���� �ֱٿ� ���� �������� ���� ������ �Ǿ� �ִ�.
*/

-- �ߺ� ������ �����ϱ�
-- * �ϳ��� ��
select distinct school
from teachers
order by 1;

-- * ���� ���� ��
select distinct school, salary
from teachers
order by 1, 2;
/*
school�� salary ��� �ߺ��� �� ���� ���Ű� �Ǿ� ��������.
*/

-- ��(����) ������
/*
=: ����
<>, !=: ���� ����
>: �ʰ�
<: �̸�
>=: �̻�
<=: ����
between a and b: a�̻� b����
in: �� �� �ϳ� �̻� ��ġ
like: ������ġ(��ҹ��� ����)
ilike: ������ġ(��ҹ��� �������� ����)
not: ������ ��
*/

-- Ư�� ���ǿ� �����ϴ� �� �˻�
select last_name, first_name, salary
from teachers
where salary >=75000;

select last_name, school, hire_date
from teachers
where school='Myers Middle School';

select  first_name, last_name, school
from teachers
where first_name = 'Janet';

select first_name, last_name, school
from teachers
where school <> 'F.D Roosevelt HS';

SELECT first_name, last_name, hire_date
from teachers
where hire_date < '2000-01-01';

select first_name, last_name, salary
from teachers
where salary >= 43500;

select first_name, last_name, school, salary
from teachers
where salary between 40000 and 65000;

select first_name, last_name, school, salary
from teachers
where salary >= 40000 and salary <= 65000;

select first_name
from teachers
where first_name like 'sam%';
/*
��ҹ��� ���� => samtha(O), Samtha(X), sAmtha(X)
*/

select first_name
from teachers
where first_name ilike 'sam%';
/*
��ҹ��� ���� => samtha(O), Samtha(O), sAmtha(O)
*/

-- and�� or�� ���� ���� ��ġ��
select *
from teachers
where school = 'Myers Middle School' and salary < 40000;

select *
from teachers
where last_name = 'Cole' or last_name = 'Bush';

select *
from teachers
where school = 'F.D Roosevelt HS' and (salary < 38000 or salary > 40000);
/*
���ǿ� ��ȣ�� ������ �ش� ���� ���� ������ ���� �˴ϴ�.
������ ��ȣ�� ���ٸ� and���� ���� ���� �� or������ �������� ���� �˴ϴ�.
*/

select *
from teachers
where school = 'F.D Roosevelt HS' and salary < 38000 or salary > 40000;
/*
school���� F.D Roosevelt HS�̸鼭 salary�� 38000�̸��� ���
school�� ������� salary�� 40000�ʰ��� ���� �˻��Ѵ�.

�̰��� ������ ������ �ʾҴ� �����͸� ���� ���ɼ��� �����Ƿ� ������ ���鶧 ��ȣ�� ��� ���� ������ �� �����ϰ� ����
*/

-- 3�� �Ѹ���
select first_name, last_name, school, hire_date, salary
from teachers
where school like '%Roos%'
order by hire_date desc;
