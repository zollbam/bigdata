-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- 연습문제
-- * 1번
-- ** 테이블 생성
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

-- ** 파일 불러오기
/*
책에서 제공한 방식으로는 오류가 나와서 나름대로 변경 하였습니다.
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
movie열 값에 #가 양쪽에 들어가게 됩니다.
*/

table actors1;
table actors2;

-- * 2번
-- ** 쿼리 결과
SELECT county_name, state_name, births_2019
from us_counties_pop_est_2019
order by births_2019 DESC
limit 20;

-- ** 파일 내보내기
copy (SELECT county_name, state_name, births_2019
      from us_counties_pop_est_2019
      order by births_2019 DESC
      limit 20)
to 'D:\test\postgresql\practicalsql\result1.txt'
with (format csv, header);

-- * 3번
/*
chap5_ex3.txt파일에
17519.668
20084.461
18976.355
가 저장되어있다는 가정하에 문제가 진행
*/

-- ** 테이블 생성
create table chap05_ex03 (
    flo numeric(3,8)
);
/*
우선 전체가 3자리인데, 소수점을 8개 까지 한다는 것은 말이 되지 않습니다.
그래서 오류가 나오는 상황입니다.
*/

create table chap05_ex03 (
    flo numeric(8,3)
);
/*
우선 전체가 8자리에 소수점아래 3개만 사용하므로 오류없이 테이블 생성
*/

-- ** 파일불러오기
copy chap05_ex03
from 'D:\test\postgresql\practicalsql\chap5_ex3.txt'
with (format csv);
/*
txt파일에 저장된 값 그대로 테이블로 삽입이 된다.
*/

-- ** 테이블 확인
table chap05_ex03;
