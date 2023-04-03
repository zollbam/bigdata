-- Active: 1679746005886@@127.0.0.1@5432@gydb
-- 데이터 타입
-- * 1. char(n)
/*
- 입력한 n에 따라 길이가 고정된 열이 정의
- 입력된 n이상의 길이의 문자는 보관이 불가
- n이하로 글자가 입력 되면 나머지 공간은 공백으로 채움
- 더 긴 이름으로 표준 SQL인 character(n)으로 정의도 가능
*/

-- * 2. varchar(n)
/*
- 최대 길이가 n으로 정의되는 가변 길이 데이터 타입
- 최대치보다 적은 수의 글자가 입력 되었을 경우 공백을 넣지 않음 => DB의 공간을 절약
- 더 긴 이름으로 표준 SQL인 character varying(n)으로 정의도 가능
*/

-- * 3. text
/*
- 길이 제한이 없는 가변 길이 데이터 타입을 담은 열
- 가장 길게 담을 수 있는 문자열의 크기는 1 GB
- 표준SQL에는 포함되지 않음
- 최대 길이를 지정할 필요 없음
*/

-- 테이블 만들기
create table char_data_types (
    char_column char(10),
    varchar_column varchar(10),
    text_column text
);

-- 행삽입
insert into char_data_types 
    values ('avc', 'abc', 'abc'),
           ('defghi', 'defghi', 'defghi');

-- 테이블을 txt파일로 저장
-- COPY char_data_types to 'C:\\Users\\typetext.txt' WITH (FORMAT CSV, HEADER, DELIMITER ',');
/*
- char_data_types테이블을 해당 폴더에 typetext.txt로 저장시킨다.
- delimiter는 구분자로 열마다 '|'로 구분한 형식으로 변경한 것
*/

-- * 4. smallint
/*
- 표준 SQL
- 2바이트, -32768 ~ +32767
*/

-- * 5. integer
/*
- 표준 SQL
- 4바이트, -2147483648 ~ +2147483647
*/

-- * 6. bigint
/*
- 표준 SQL
- 8바이트, -9223372036854775808 ~ +9223372036854775807
*/

-- * 7. smallserial
/*
- 자동 증가 정수 타입
- 2바이트, 1~32767
*/

-- * 8. serial
/*
- 자동 증가 정수 타입
- 4바이트, 1~2147483647
*/

-- * 9. bigseial
/*
- 자동 증가 정수 타입
- 8바이트, 1~9223372036854775807
*/

-- 테이블 생성
create table people (
    id serial,
    person_name varchar(100)
);

-- identity를 사용한 자동 증가
/*
- 이 방법은 작성법은 길지만 serial방법보다 선호된다.
- 오라클 같은 다른 DB시스템과 상호 호환되며 사용자가 실수로 해당 열에 값을 삽입하지 않도록 방지하기 때문
 * 수동을 재정의하지 않는 이상 id열에 값을 삽입할 수 없습니다.
- generated always as identity
- generated by default as identity
*/
create table people (
    id integer generated always as identity,
    person_name varchar(100)
);

-- * 10. timestamp
/*
- 8바이트, 날짜와 시간
- timestamptz로 timestamp with time zone타입과 동일한 데이터 타입을 지정
*/

-- * 11. date
/*
- 4바이트, 날짜
*/

-- * 12. time
/*
- 8바이트, 시간
*/

-- * 13. interval
/*
- 16바이트, 시간차이
- 기간의 시작 또는 끝은 기록하지 않고 길이만 기록
*/

-- 테이블 생성
create table date_time_types(
    timestamp_column timestamp with time zone,
    interval_column interval
);

-- 데이터 삽입
insert into date_time_types values 
    ('2022-12-31 01:00 EST', '2 days'), -- EST는 미국 동부 표준시의 약어
    ('2022-12-31 01:00 -8', '1 month'), -- UTC의 시간 차이 또는 오프셋 수를 나타냄 = > -8: 미국과 캐나다의 태평양 표준 시간
    ('2022-12-31 01:00 Australia/Melbourne', '1 century'), -- century은 100년
    (now(), '1 week');

-- 테이블 확인
table date_time_types;

-- 날짜 시간 계산
SELECT timestamp_column,
       interval_column,
       timestamp_column - interval_column as new_date
from date_time_types;

-- * 14. json
/*
- JSON 텍스트 그대로 저장
*/ 

-- * 15. jsonb
/*
- JSON 텍스트를 바이너리 형식으로 변환해서 저장
- 인덱싱을 지원하므로 처리속도가 빠름
*/ 

-- * 16. boolean
/*
- true 또는 false 값을 저장하는 논리 타입
*/ 

-- * 17. geometric
/*
- 점, 선, 원 및 기타 2차원 개체를 포함하는 기하 타입
*/ 

-- * 18. text search
/*
- postgresql 전문 검색 엔진용 텍스트 검색 타입
*/ 

-- * 19. network address
/*
- IP 또는 MAC 주소와 같은 네트워크 주소 타입
*/ 

-- * 20. Universally Unique Idenetifier
/*
- 경우에 따라 테이블의 고유키로 사용될 수 있는 UUID타입
*/ 

-- * 21. range
/*
- 정수 또는 타임스탬프 같은 값의 범위를 지정하는 범위 타입
*/ 

-- * 22. 그 외
/*
- 바이너리 데이터를 저장하는 타입
- 구조화된 형식으로 정보를 저장하는 XML 및 JSON타입
*/ 

























