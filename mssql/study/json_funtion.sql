/*
mssql 쿼리문
날짜 23-05-19
json형태로 된 파일을 geometry으로 바꾸기 위해 작성
*/

-- 테이블 삭제
DROP TABLE json_data_tbl;

-- 테이블 생성
CREATE TABLE json_data_tbl(
	json_lng_lat NVARCHAR(MAX)
);
/*NVARCHAR으로 만들어야 json_value함수를 사용할 수 있음
  json_value의 첫번째 인수는 text타입을 인식하지 못 함*/

-- json형태로 레코드 생성
INSERT INTO json_data_tbl VALUES (N'{"lng":127.64545, "lat":37.41153}');

-- 데이터 삽입 확인
SELECT * FROM json_data_tbl;

-- json값 추출
SELECT json_value(json_lng_lat,'$.lng'), json_value(json_lng_lat,'$.lat')
FROM json_data_tbl;
/*mariadb의 json_extract 함수와 같은 기능*/

-- geometry타입 값 만들기
SELECT geometry::Point(json_value(json_lng_lat,'$.lng'), json_value(json_lng_lat,'$.lat'),4326)
FROM json_data_tbl;

-- 
SELECT * FROM information_schema.constraint_table_usage;
SELECT * FROM information_schema.constraint_table_usage;