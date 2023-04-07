-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- 데이터베이스 생성
create database gydb;

/*
만든 gydb로 다시 접속하자!!
*/

-- 테이블 만들기
-- * 교사 연봉 테이블
CREATE table teachers( -- teachers는 테이블 이름
    id bigserial, -- id는 열이름이고 타입은 bigserial
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

-- 행 추가
insert into teachers(first_name, last_name, school, hire_date, salary) VALUES 
    ('Janet','Smith','F.D Roosevelt HS', '2011-10-30', 36200),
    ('Lee','Reynolds','F.D Roosevelt HS', '1993-05-22', 65000),
    ('Samuel','Cole','Myers Middle School', '2005-08-01', 43500),
    ('Samantha','Bush','Myers Middle School', '2011-10-30', 36200),
    ('Betty','Diaz','Myers Middle School', '2005-08-30', 43500),
    ('Kathleen','Roush','F.D Roosevelt HS', '2010-10-22', 38500);
/*
id열은 bigserial타입으로 자동으로 숫자가 증가되어 1부터 6까지의 숫자가 열의 값으로 입력되었다.
*/

-- 테이블 확인
SELECT *
from teachers;

-- 테이블 삭제
drop table teachers CASCADE;
