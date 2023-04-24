-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- 연습문제
-- * 1번
/*
과일과 야채를 지역 식료품점에 배달하는 회사가 있습니다.
매일 운전자들이 운전하는 마일리지의 10분의 1킬로미터를 추적해야 합니다.
어떤 운전자도 하루에 999킬로마터 이상을 주행하지 않는다고 가정할 때 테이블의 마일리지 열에 적합한 데이터 타입은 무엇이며 그 이유는?

numeric(6,3)가 적당해 보입니다. 그 이유는 10분의 1만큼 이므로 정수값은 10의 자리가 넘지 않을 것이며
킬로미터를 미터로 바꾸었을 때 소수점3째 자리까지있으면 1000을 곱했을 때 정수형태로 나와 보기 편할것으로 예상되 numeric(6,3)타입으로 골랐다.
*/

-- * 2번
/*
운전자를 나열한 테이블에서 운전자의 성과 이름에 적합한 데이터 타입은 무엇인가요??
또, 성과 이름을 하나의 열로 하는 것보다 두개의 열로 구분하는 이유는??

성이나 이름은 길어보았자 20자이상이 넘어 갈거 처럼 보이지 않기 때문에 varchar(20)으로 정의할 것 입니다.
또 성과 아름을 하나의 열로 하지 않는 이유는 데이터 길이가 너무 길어지는 이유도 있겠지만 성과 이름사이의 공백의
이유로 그 공백하나의 자리도 낭비하지 않기 위해서 두개의 열을 나눈다고 생각합니다.
*/

-- * 3번
/*
날짜 형식의 문자열을 포함하는 텍스트 열이 있다고 가정해 보자
문자열 하나는 '4//2011'로 표기 되어 있습니다.
해당 문자열을 timestamp데이터 타입으로 변환하려고 하면 어떻게 되나요?
*/
CREATE table chap04_ex3 (time_text text);

insert into chap04_ex3 VALUES ('4//2021');

SELECT time_text::timestamp
from chap04_ex3;
/*
잘못된 데이터 입력 형식이라고 데이터가 변환되지 않고 오류가 발생합니다.
*/