-- Active: 1679909868066@@127.0.0.1@5432@postgres
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























