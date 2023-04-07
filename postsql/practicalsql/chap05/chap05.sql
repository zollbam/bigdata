-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- 들어가기 전
/*
데이터가  수백, 수천, 수백만개의 행을 불러오게 될 것인데 일일이 insert문으로 불러오고 싶지는 않을 것이다.
postgresql에서는 copy명령을 통해 대량으로 데이터를 가져올 수 있습니다.
copy명령어는 데이터를 불러오고 내보내는 기능을 모두 가지고 있습니다.
MYSQL에서는 load data infile문, microsoft sql server에는 자체 bulk insert 명령으로 대량 가져오기 방볍을 사용

파일의 멘 윗줄에 보면 행 이름이 적혀 있는 경우가 많이 있습니다. 이것을 헤더행이러고 합니다.
postgresql에서는 헤더행을 사용하지 않습니다. 그래서 copy명령에서 header옵션을 사용하여 제외시킵니다.

csv파일을 읽으면 파일자체오류도 있고 한정자 텍스트가 없어서 오류가 날 수 도 있기 때문에
파일을 불러온 후 항상 데이터를 검토하는 습관을 가지도록 하자!!
*/

-- 파일 불러오가 예제
create table supervisor (
    town varchar(15),
    supervisor varchar(10),
    salary numeric(6)
);
/*
copy 테이블명 ~~으로 쿼리를 생성하는데 DB에 해당 테이블이 있어야 함으로 없으면 오류가 나타나
그전에 테이블을 생성 해주어야 한다.
*/

copy supervisor
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header);
/*
테이블 생성으로 열이름이 주어져 있으므로 copy로 파일을 불러올 때 헤더행을 삭제하고 데이터만 삽입해야 한다.

with문의 옵션들을 모두 알면 좋다 => https://www.postgresql.org/docs/current/sql-copy.html 에서  알아보자
하지만 일반적으로 쓰는 몇개만 적어 보았습니다.
1. format
 - 형식 이름은 csv, text, binary 가 있습니다.
 - 주로 csv를 많이 쓰며, text는 \r같은 ASCII문자(캐리지 리턴)로 인식됩니다.

2. HEADER
 - 데이터를 불러올 때는 제외할 헤더형이 있다는 것을 알려줍니다.
 - 데이터를 내보낼 때는 헤더 행을 포함시켜 저장 시켜 줍니다.

3. delimiter 
 - 가져오기 도는 내보내기 파일에서 구분자로 사용할 문자를 지정
 - 문법: delimiter '|'

4. quote
 - 열값이 텍스트 한정자 역할을 하는 문자로 둘러싸여 있는 경우에 사용한다.
*/

table supervisor;

-- 미국 모든 카운티에 대한 인구 추정치 데이터
-- * 테이블 생성
create table us_counties_pop_est_2019(
    state_fips text, -- 주코드
    county_fips text, -- 카운티 코드
    region text, -- 카운티의 위치 => 북동부, 중서부, 남부, 서부
    state_name text, -- 주이름
    county_name text, -- 카운티이름
    area_land bigint, -- 카운티에 있는 토지 넓이
    area_water bigint, -- 카운티에 있는 물 넓이
    internal_point_lat numeric(10, 7), -- 내점(카운티 정중아부 가가이에 위치한 지점)의 위도
    internal_point_lon numeric(10, 7), -- 내점(카운티 정중아부 가가이에 위치한 지점)의 경도
    pop_est_2018 INTEGER, -- 2018년 7월 1일 기준 인구 추정치
    pop_est_2019 INTEGER, -- 2019년 7월 1일 기준 인구 추정치
    births_2019 INTEGER, -- 2018년 7월 1일부터 2019년 6월 30일 사이 출생아 수
    deaths_2019 INTEGER, -- 2018년 7월 1일부터 2019년 6월 30일 사이 사망자 수
    international_migr_2019 INTEGER, -- 2018년 7월 1일부터 2019년 6월 30일 사이 순 국제 이주자 수
    domestic_migr_2019 INTEGER, -- 2018년 7월 1일부터 2019년 6월 30일 사이 순 지역 이주자 수
    residual_2019 INTEGER, -- 일관성을 위해 추정치를 조정하는데 사용되는 숫자
    constraint counties_2019_key  PRIMARY key (state_fips, county_fips)
);

-- * 파일 불러오기
copy us_counties_pop_est_2019
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\us_counties_pop_est_2019.csv'
with (format csv, header);

-- * 테이블 확인
table us_counties_pop_est_2019;
/*
3142행 16열을 가진 테이블이다.
이 데이터는 2020년 에 조사한 데이터로 미국에 사는 모든 사람의 나이와 성별, 인종, 민족성을 정리한 이 데이터는 
435명의 미국하원에 각 주의 의원을 몇 명씩 배치할지 결정하는데 사용하기 위해 파일을 불러왔습니다.

주코드를 int가 아닌 text로 지정하는 이유는 만약 정수로 지정하여 02라고 값을 삽입하면 0은 사라지고 2만 남기때문에 나중에 조건문에서 02=2에서 오류가 나올 수 있다.
*/

-- * 데이터 검사하기
SELECT county_name, state_name, area_land
from us_counties_pop_est_2019
order by area_land DESC
limit 3;
/*
주이름, 카운티 이름, 토지넓이를 불러와서 토지 넓이를 기준으로 내림차순을 하고 위에서 3개의 행만 추출한다.
즉, 이 말은 토지넓이가 큰 3개의 주이름과 카운티 이름을 출력해주는 쿼리입니다.
*/

SELECT county_name, state_name, internal_point_lat, internal_point_lon
from us_counties_pop_est_2019
order by internal_point_lon DESC
limit 5;
/*
경도를 기준으로 큰 값부터 내림차순으로 상위 5개의 행만 추출하는 쿼리입니다.
*/

-- 테이블에 몇몇 열에 대한 데이터가 존재하지 않아도 데이터에 있는 열을 지정하여 가져오는 방법
-- * 테이블 생성
create table supervisor_salaries(
    id integer generated always as identity primary key,
    town text,
    county text,
    supervisor text,
    start_date date,
    salary numeric(10,2),
    benefits NUMERIC(10,2)
);

-- * 파일 가져오기
copy supervisor_salaries
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header);
/*
불러올 csv파일과 테이블이 같은 모양이 달라서 오류가 생깁니다.
*/

copy supervisor_salaries(town, supervisor, salary)
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header);
/*
(town, supervisor, salary)으로 파일 데이터가 들어갈 열을 지정해 줍니다.
값이 들어가지 않은 열들은 null로 대체 됩니다.
*/

-- * 테이블 확인
table supervisor_salaries;

-- 파일에서 필요 행만 가져와서 테이블에 삽입하기
-- * 테이블 안 데이터 삭제
DELETE from supervisor_salaries;
/*
테이블은 그대로 남아 있고 데이터만 삭제가 된다.
*/

-- * 해당 행의 데이터만 테이블에 삽입
copy supervisor_salaries(town, supervisor, salary)
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header)
where town = 'New Brillig';
/*
town값이 New Brillig인 행만 테이블에 추가 된다.
*/

-- * 테이블 확인
table supervisor_salaries;

-- * 다른 조건으로 데이터를 삽입
DELETE from supervisor_salaries;

copy supervisor_salaries(town, supervisor, salary)
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header)
where town <> 'New Brillig';
/*
town이 New Brillig만 아니면 다 삽입
*/

table supervisor_salaries;

-- 파일 가져올시 새로운 열을 추가하기
/*
파일 불러올 시 새로운 열을 추가하기 위해서는 임시 테이블에 파일을 저장하고
임시테이블에 새로운 열을 추가하고 메인 테이블에 저장하는 방법만이 유일한 방법입니다.
*/
-- * 테이블 내 데이터 삭제
delete from supervisor_salaries;

-- * 임시테이블 생성
create TEMPORARY table supervisor_salaries_temp
    (like supervisor_salaries including all);
/*
supervisor_salaries_temp라는 임시 테이블을 생성하여 supervisor_salaries의 정보를 복사해와서
열이름이나 타입 등을 가져왔습니다.

including all은 테이블 행과 열뿐만이 아니라 인덱스 및 identity 설정과 같은 구성 요소도 복사
*/

-- * 파일 불러오기
copy supervisor_salaries_temp(town, supervisor, salary)
from 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_05\supervisor_salaries.csv'
with (format csv, header);

-- * 새로운 열 추가
insert into supervisor_salaries(town, county, supervisor, salary)
select town, 'Mills', supervisor, salary
from supervisor_salaries_temp;

-- 임시테이블 삭제
drop table supervisor_salaries_temp;

-- 테이블 확인
table supervisor_salaries;

-- 모든 데이터 내보내기 
copy supervisor_salaries
TO 'D:\test\postgresql\practicalsql\supervisor_salaries_export.txt'
with (format csv, header, delimiter '|');
