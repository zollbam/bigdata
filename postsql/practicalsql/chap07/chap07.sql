-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- join의 이해
/*
문법은 JOIN ... ON ~~ 인데 일반적으로 ON뒤에는 같은 열을 사용하기 위해 =를 대부분 쓰지만
가끔 ON tablea.keya >= tableb.keyb같이 부등호로 join을 하는 경우도 있으니 알아두자
*/

-- 예제 테이블 생성
create table departments(
    dept_id integer,
    dept text,
    city text,
    constraint dept_key primary key (dept_id),
    constraint dept_city_unique unique (dept, city)
);
/*
unique는 하나 이상 지정이 가능하다.
여기서는 dept와 city가 동시에 유니크 이므로 텍사스에 tax부서는 1개만 있다는 것을 알 수 있다.
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
기본키는 고유한 값인 unique여야하고 결측값인 null값이 어야 한다.
외래키는 기본키와 다르게 null값도 중복값도 넣을 수 있지만 무조건 참조된 기본키 안에 해당 값이 있어야 한다.
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

-- join의 유형
/*
1. JOIN
  - 테이블들의 조인된 열에서 일치하는 값이 있는 두 테이블의 행을 반환
  - 대체로 inner join

2. left JOIN
  - 왼쪽 테이블의 모든 행을 반환
  - 오른쪽 테이블에서 일치하는 값을 가진 행을 찾으면 해당 행의 값이 결과에 포함되지만
    그렇지 않으면 오른쪽 테이블 값은 결과에 포함되지 않습니다.

3. RIGHT JOIN
  - 오른쪽 테이블의 모든 행을 반환
  - 왼쪽 테이블에서 일치하는 값을 가진 행을 찾으면 해당 행의 값이 결과에 포함되지만
    그렇지 않으면 왼쪽 테이블 값은 결과에 포함되지 않습니다.

4. FULL JOIN
  - 테이블의 모든 행을 반환하고 값이 일치하는 행은 연결
  - 왼쪽 OR 오른쪽 테이블에 일치하는 앖이 없는 행은 결과에 다른 테이블에 대한 빈값이 포함

5. CROSS JOIN
  - 두테이블에서 가능한 모든 행 조합을 반환
*/

-- 2개 테이블 join하기
select *
from employees join departments
               on employees.dept_id = departments.dept_id
order by employees.dept_id;

-- 예제를 통한 join개념
-- * 테이블 만들기
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
(inner) join은 두테이블의 id가 완전히 동일하게 있는 경우에만 값을 나오게 해주는 교집합의 형태라고 보면 됩니다.
테이블에만 있는 데이터는 쿼리 결과에 나오지 않습니다.
*/

-- ** using을 사용
select *
from district_2020 join district_2035 using(id)
order by district_2020.id;
/*
using은 비교하려는 두개의 테이블의 열이름이 같은 경우에만 사용할 수 있습니다.
on대신 using을 사용하여 중복 출력되는 열을 줄이고 쿼리문도 줄일 수 있습니다.
on에서 id가 2열 나오는 것아 하나로 줄어든 것을 확인 할 수 있습니다.
또한 2개 이상을 열을 결합하는 경우에는 쉼표로 구분해서 넣으면 된다. => 예를 들면 (id, class)로
*/

-- * left join
select *
from district_2020 left join district_2035 using(id)
order by district_2020.id;

select *
from district_2020 left join district_2035 using(id)
order by id;
/*
위의 2개의 쿼리는 모두 같은 결과가 나오게 된다.
using으로 사용된 테이블은 앞에 테이블명.을 하지 않아도 오류가 발생하지 않는다.
*/

select *
from district_2020 left join district_2035 using(id)
order by district_2035.id;
/*
district_2035테이블에는 id가 5인 데이터가 없어서 정렬 기준에 없어서 제일 밑에 있는 것을 확인 하였습니다.
*/

-- * right join
select *
from district_2020 right join district_2035 using(id)
order by id;
/*
left join이나 right join은 자신의 고유 데이터 + 교집합 데이터라고 생각하면 된다.
*/

-- * full (outer) join
select *
from district_2020 full outer join district_2035 using(id)
order by id;

select *
from district_2020 full join district_2035 using(id)
order by id;
/*
full outer join으로 해도 되고 outer을 생략한 full join으로 해도 된다.
두테이블에 있는 모든 데이터가 포함되는 합집합 형태로 나오게 됩니다.
*/

-- * cross join = cartesian product(데카르트 곱)
select *
from district_2020 cross join district_2035
order by district_2020.id;
/*
데카르트곱은 가능한 모든 행 조합을 나타냅니다. 그래서 on이 필요가 없습니다.
그러니 using써도 오류가 나오게 된다.
district_2020테이블 4행과 district_2035테이블 5행 모든 조합은 4*5 = 20행이 나오게 된다.
*/

-- * null이 있는 데이터 찾기
select *
from district_2020 left join district_2035 using(id)
where school_2035 is null
order by id;
/*
쿼리의 결과는 id가 동일하면서 왼쪽테이블에는 있는데 오른쪽 테이블에는 없는 데이터를 추출하게 된다.
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
위의 2개 쿼리의 결과는 왼쪽 테이블과 일치하지 않는 오른쪽 테이블의 행을 보기 위해서 출력한 형태
*/

-- 열이름의 애매모호
select district_2020.id
from district_2020 left join district_2035
                   on district_2020.id = district_2035.id
order by district_2035.id;
/*
id라는 열이름은 district_2020와 district_2035테이블 모두에 id라는 열이 있으믄로
어떤 테이블의 id를 써야하는지 판단을 못해 오류가 발생합니다.
*/

select district_2020.id, district_2020.school_2020, district_2035.school_2035
from district_2020 left join district_2035
                   on district_2020.id = district_2035.id;
/*
이렇게 특정 테이블의 열이름을 지정해주어야 오류없이 쿼리를 반환합니다.
*/

-- 테이블 별칭으로 조인 구문 단순화시키기
select d20.id, d20.school_2020, d35.school_2035
from district_2020 d20 right join district_2035 d35
                       on d20.id = d35.id;
/*
테이블에 별칭을 지정하면서 쿼리도 단순해지고 다른 사람들의 가독성도 좋어지게 되어
복잡성을 줄여 주는 효과를 볼 수 있습니다.
*/

-- 여러 테이블 join하기 => 3개 이상도 가능
-- * 예제 테이블 생성
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

-- * 3개 테이블 join
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
id를 내림차순으로 정렬하였고 using을 사용하여 쿼리를 줄여 보았습니다.
*/

-- 집합연산자로 쿼리 결과 결합하기
/*
1. union(합집합)
  - 두번째 쿼리 행을 첫번째 쿼리의 행에 추가하고 중복을 제거
  - union all로 하면 중복은 포함한 채로 결과를 보여준다.
  - 행결합으로 할 때 쓰자!!!
  - school_2020와 school_2035로 행이름이 달라도 상관없다.
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
각 행이 어떤 테이블에서 왔는지도 확인 가능하다.
*/

/*
2. intersect(교집합)
  - 두 쿼리에 모두 존재하는 행만 반환하고 중복은 제거
*/
select * from district_2020
INTERSECT
select * from district_2035
order by id;

select '2020' "year", school_2020 school from district_2020
INTERSECT
select '2035' "year", school_2035 school from district_2035;
/*
year열 때문에 2개의 테이블에 중복되는 열이 없으므로 결과에 아무것도 안 나온다.
*/

/*
3. except(차집합)
  - 첫번째 쿼리에는 있지만 두번째 쿼리에는 없는 행을 반환
*/
select * from district_2020
except
select * from district_2035
order by id;

-- 조인된 테이블로 수학 계산하기
-- * 예제 데이터 생성
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

-- * join 테이블 수학 계산
select c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019,
       c2010.estimates_base_2010 pop_2010,
       c2019.pop_est_2019 - c2010.estimates_base_2010 row_change,
       round((c2019.pop_est_2019::numeric - c2010.estimates_base_2010) / c2010.estimates_base_2010 * 100, 1) pct_change
from us_counties_pop_est_2019 c2019 join us_counties_pop_est_2010 c2010 using(state_fips, county_fips)
order by pct_change desc;
/*
pct_change가 100이 넘는 데이터들은 10년도에 비해 19년도에 2배 이상 인구가 증가 했다고 본다.
*/
