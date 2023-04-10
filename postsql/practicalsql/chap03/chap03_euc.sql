-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- theachers테이블 불러오기
-- * 방법1
SELECT *
from teachers;

-- * 방법2
table teachers;

-- 필요한 열 정보만 받기
select last_name, first_name, salary
from teachers;

-- 데이터 정렬하기
-- * 열이름으로
select last_name, first_name, salary
from teachers
order by salary desc;
/*
salary를 기준으로 내림차순 정렬함
*/

-- * 숫자로
select first_name, last_name, salary
from teachers
order by 3 desc;
/*
select문에 정의된 기준의 순서에 맞게 1부터 시작된다.
3은 3번째 열로 salary를 가르킨다고 볼 수 있다.
*/

-- * 여러 개의 기준으로 정렬하기
select last_name, school, hire_date
from teachers
order by school, hire_date desc;
/*
school로 먼저 정렬하고 같은 값이 있다면 hire_date를 기준으로 정렬한다.
제일 최근에 고용된 기준으로 위에 나오게 되어 있다.
*/

-- 중복 데이터 제거하기
-- * 하나의 열
select distinct school
from teachers
order by 1;

-- * 여러 개의 열
select distinct school, salary
from teachers
order by 1, 2;
/*
school과 salary 모두 중복일 때 행이 제거가 되어 보여진다.
*/

-- 비교(관계) 연산자
/*
=: 같음
<>, !=: 같지 않음
>: 초과
<: 미만
>=: 이상
<=: 이하
between a and b: a이상 b이하
in: 값 중 하나 이상 일치
like: 패턴일치(대소문자 구분)
ilike: 패턴일치(대소문자 구분하지 않음)
not: 조건의 역
*/

-- 특정 조건에 부합하는 행 검색
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
대소문자 구분 => samtha(O), Samtha(X), sAmtha(X)
*/

select first_name
from teachers
where first_name ilike 'sam%';
/*
대소문자 구분 => samtha(O), Samtha(O), sAmtha(O)
*/

-- and와 or로 여러 조건 합치기
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
조건에 괄호가 있으면 해당 조건 먼저 판정이 시작 됩니다.
하지만 괄호가 없다면 and조건 먼저 판정 후 or조건이 마지막에 판정 됩니다.
*/

select *
from teachers
where school = 'F.D Roosevelt HS' and salary < 38000 or salary > 40000;
/*
school값이 F.D Roosevelt HS이면서 salary가 38000미만인 행과
school값 상관없이 salary가 40000초과인 행을 검색한다.

이것은 본인이 원하지 않았던 데이터를 뽑을 가능성이 있으므로 조건을 만들때 괄호를 어디에 넣을 것이지 잘 생각하고 넣자
*/

-- 3장 총망라
select first_name, last_name, school, hire_date, salary
from teachers
where school like '%Roos%'
order by hire_date desc;
