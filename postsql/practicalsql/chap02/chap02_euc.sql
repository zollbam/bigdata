-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- �����ͺ��̽� ����
create database gydb;

/*
���� gydb�� �ٽ� ��������!!
*/

-- ���̺� �����
-- * ���� ���� ���̺�
CREATE table teachers( -- teachers�� ���̺� �̸�
    id bigserial, -- id�� ���̸��̰� Ÿ���� bigserial
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

-- �� �߰�
insert into teachers(first_name, last_name, school, hire_date, salary) VALUES 
    ('Janet','Smith','F.D Roosevelt HS', '2011-10-30', 36200),
    ('Lee','Reynolds','F.D Roosevelt HS', '1993-05-22', 65000),
    ('Samuel','Cole','Myers Middle School', '2005-08-01', 43500),
    ('Samantha','Bush','Myers Middle School', '2011-10-30', 36200),
    ('Betty','Diaz','Myers Middle School', '2005-08-30', 43500),
    ('Kathleen','Roush','F.D Roosevelt HS', '2010-10-22', 38500);
/*
id���� bigserialŸ������ �ڵ����� ���ڰ� �����Ǿ� 1���� 6������ ���ڰ� ���� ������ �ԷµǾ���.
*/

-- ���̺� Ȯ��
SELECT *
from teachers;

-- ���̺� ����
drop table teachers CASCADE;
