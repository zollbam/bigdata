-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- 연산의 이해
/*
1. 두 정수는 integer로 반환
2. 연산자 옆에 numeric타입인 숫자가 하나라도 있으면 numeric을 반환
3. 부동 소수점 숫자가 있으면 부동 소수점 타입인 double precision을 반환
4. 지수, 제곱근, 팩토리얼 같은 경우에는 입력이 정수여도 numeric과 floating-point로 반환
*/

-- 기본연산
select 2+2 "더하기";
select 9-1 "빼기";
select 3*4 "곱하기";
select 20/5 "나누기";
select 20/6 "소수점 나누기";
/*
소수점으로 나올줄 알았던 값이 integer타입으로 반환되어 몫이 나오는 계산이 되었다.
*/

select (20/6)::float8 "소수점 나누기";
/*
몫으로 계산되어 나온 3을 실수형으로 고치는 것이므로 본인이 원하는 3.33333...의 값은 나오지 않는다.
*/

select (20/cast(6 as float8)) "소수점 나누기";
select 20/6::float8 "소수점 나누기";
select 20::float8/6 "소수점 나누기";
select 20.0/6 "소수점 나누기";
/*
정수로 되어 있는 아무 숫자 하나를 실수형으로 변경을 해야 자신이 원하는 소주점자리 숫자로 반환이 됩니다.
*/

-- 그외 자주 쓰는 연산
select 3^4 "n의 m승";
select |/10 "제곱근(루트)";
select sqrt(10) "제곱근(루트)";
select ||/10 "세제곱근";
select |||/81 "네제곱근";
/*
네제곱근도 있나 했지만 없어서 오류가 나온다. ㅎㅎㅎㅎ
*/

select 4 !;
select 4 ! "팩토리얼";
/*
!는 portgresql13버전이하에서만 사용 가능 하므로 그이상의 버전에서는 오류가 나온다.
*/

select factorial(5) "팩토리얼";

-- 연산 순서
/*
1. 지수와 근
2. 곱하기, 나누기, 모듈
3. 더하기, 빼기

* 먼저 계산하고 싶은게 있다면 괄호를 사용하여 만들자
*/

select 7+8*9; -- 곱하기 먼저
select (7+8)*9; -- 더하기 먼저
select 3^3-1; -- 제곱근 먼저
select 3^(3-1); -- 빼기 먼저

-- 인구조사 테이블 열을 이용해 계산하기
-- * 사용할 테이블 불러오기
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

-- 연산 연습 예제
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

-- 데이터 전체 백분율 구하기
select county_name county,
       state_name state,
       area_water::numeric / (area_land + area_water) *100 pct_water
from us_counties_pop_est_2019
order by pct_water desc;
/*
물이 전체 면적에 얼마나 차지하는지 알아보기 위해 사용
*/

-- 변화율 계산
/*
저 숫자보다 얼마나 큰지비교하거나 시간에 따른 변화를 분석할 때 주로 사용
*/

-- * 테이블 생성
create table percent_change (
    department text,
    spend_2019 numeric(10,2),
    spend_2022 numeric(10,2)
);

-- * 데이터 삽입
insert into percent_change VALUES
                ('Assessor', 178556, 179500),
                ('Building', 250000, 289000),
                ('Clerk', 451980, 650000),
                ('Library', 87777, 90001),
                ('Parks', 250000, 223000),
                ('Water', 199000, 195000);

-- * 변화율 계산
select department, spend_2019, spend_2022, round((spend_2022 - spend_2019)/spend_2019*100, 1) pct_change
from percent_change;

-- 해당 열의 평균 및 총합 집계함구 사용
SELECT sum(pop_est_2019) county_sum,
       round(avg(pop_est_2019), 0) county_average
from us_counties_pop_est_2019;

-- 중앙값 찾기
-- * 예제 테이블 생성
create table percentile_test(
    numbers integer
);

insert into percentile_test (numbers) VALUES
            (1), (2), (3), (4), (5), (6);

-- * 방법1. 백분위수 함수 사용
select percentile_cont(0.5) within group (order by numbers),
       percentile_disc(0.5) within group (order by numbers)
from percentile_test;
/*
percentile_cont는 구한 중앙값을 실수 형태로 반환
percentile_disc는 구한 중앙값을 정수 형태로 반환
*/

SELECT sum(pop_est_2019) county_sum,
       round(avg(pop_est_2019), 0) county_average,
       percentile_cont(0.5) within group (order by pop_est_2019) county_median
from us_counties_pop_est_2019;
/*
인구 데이터의 2019년 추정 인구 수로 총합, 평균, 중앙값을 찾았습니다.
*/

select percentile_cont(array[0.25, 0.5, 0.75]) within group (order by pop_est_2019) quartiles
from us_counties_pop_est_2019;
/*
백분위수 함수로는 중앙값만 찾을 수 있는 것은 아니다. 10%, 20% 등 자신이 원하는 구간을 골라 값을 반환 받을 수도 있습니다.
array로 여러개의 사분위수를 가져올 수 있습니다. 여기서는 0.25는 1사분위수, 0.75는 3사분위수라고도 한다.
array을 사용할 때는 바로 뒤에 ()이 아닌 []를 사용하자
*/

-- *
select array['1사분위수', '2사분위수', '3사분위수'];

-- 배열을 행으로 바꾸기
select unnest(array['제1사분위수', '제2사분위수', '제3사분위수']) "n사분위수",
       unnest(percentile_cont(array[0.25, 0.5, 0.75]) within group (order by pop_est_2019)) quartiles
from us_counties_pop_est_2019;
/*
unnest()함수는 배열을 행으로 바꾸어주는 험수로 바로 위 쿼리처럼 배열로 반환 되엇을 때
보기 쉽게 하기 위해 행으로 변화시켜 주고 싶을 때 사용헙니다.
*/

-- 최빈값 찾기
SELECT mode() within group (order by births_2019)
from us_counties_pop_est_2019;
/*
이 값은 모든 카운티에서 출생아 수가 동일한게 가장 많은 수가 나타난다.
최빈값은 최대값이 아니라 해당 데이터 중 같은게 가장 많이 나오는 수를 보여주는 것이다.
percentile_..의 백분위수 함수와 문법이 비슷하다.
*/

select count(*)
from us_counties_pop_est_2019
where births_2019=86;
/*
출생아 수가 86명이 태어난 카운티는 총 16개이다.
*/

-- * 만약 최반값이 2개 이면??
create table mode_tbl(
    num integer
);

select mode() within group (order by a.num)
from (select unnest(array[1,1,1,2,2,2]) num) a;
/*
내가 원하는 것은 최빈값이 2개 나와야 하는데 한개만 나왔다.
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
최반값인 여러 개의 키 데이터를 열 형태로 반환하였습니다.
*/
