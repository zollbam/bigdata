/*
작성일 : 23-08-04
수정일 : 23-08-04
작성자 : 조건영
사용DB : mssql2008 한방 20번
사용목적 : cs에서 새로 업데이트 된 테이블들 txt파일 만들기 위해
*/

-- txt파일 만들기 쿼리문(기본틀)
WITH tbl_txt_ch AS (
	SELECT 
	  TABLE_NAME "table_name"
	, CASE WHEN DATA_TYPE IN ('tinyint', 'bigint', 'int', 'smallint', 'numeric', 'decimal', 'float') THEN 'cast(' + COLUMN_NAME + ' as varchar(500))'
	       WHEN DATA_TYPE IN ('binary', 'varbinary' , 'bit', 'timestamp') THEN 'convert(varchar(max), convert(varbinary(100), ' + COLUMN_NAME + '), 1)'
	       WHEN DATA_TYPE IN ('text') THEN 'convert(varchar(max), ' + COLUMN_NAME + ' )'
	       WHEN DATA_TYPE IN ('datetime', 'smalldatetime' , 'datetime2', 'date') THEN 'convert(varchar(23), ' + COLUMN_NAME + ' , 12)'
	       ELSE COLUMN_NAME
	  END "col_char_change"
	, ORDINAL_POSITION
	  FROM information_schema.columns
	 WHERE table_name = 'sido_code'
)
SELECT
	  t2.table_name
	, 'select ' + char(10) + '    ' + 
	  stuff((
	         SELECT '  ' + col_char_change +
	                CASE WHEN t1.ORDINAL_POSITION < (SELECT max(ORDINAL_POSITION) FROM tbl_txt_ch) 
	                              THEN '  + ''||'' + ' + char(10) + '  '
	                     ELSE ''
	                END
	           FROM tbl_txt_ch t1
	          WHERE t1.table_name = t2.table_name
	            FOR xml PATH('')), 1, 2, '') + char(10) +
	  '  from ' + table_name + ';'
  FROM tbl_txt_ch t2
 GROUP BY t2.table_name;
/*
with 문 where 문에 테이블명을 넣어 주어야한다!!!
쿼리 결과는 해당 테이블을 txt파일 만들 수 있게 도와주는 쿼리문을 만들어 준다.
txt파일로 저장시킬 때 열 순서나 빈값 열은 각 테이블 별로 새로 만들어 주어야 한다.
*/



-- 시도 전체 데이터 => new_SIDO_CODE.txt
SELECT
  CAST(sido_no AS varchar(10)) + '||' +
  sido + '||' +
  sido_s + '||' +
  '' + '||' +
  CONVERT(varchar(max), CONVERT(varbinary(20), time_stamp), 1)
  FROM SIDO_CODE;
/*
강원도(42) => 강원특별자치도(51)
군위군(47) => 대구광역시 군위군(27)
*/



-- 시군구 전체 데이터 => new_GUGUN_CODE.txt
SELECT
  CAST(gugun_no AS varchar(10)) + '||' +
  CAST(sido_no AS varchar(10)) + '||' +
  gugun + '||' +
  '' + '||' +
  disp_gbn + '||' +
  CONVERT(varchar(max), CONVERT(varbinary(20), time_stamp), 1)
  FROM GUGUN_CODE;



-- 읍면동 전체 데이터 => new_DONG_CODE.txt
SELECT
  CAST(dong_no AS varchar(10)) + '||' +
  CAST(sido_no AS varchar(10)) + '||' +
  CAST(gugun_no AS varchar(10)) + '||' +
  dong + '||' +
  dong_disp + '||' +
  '' + '||' +
  dong_gbn + '||' +
  jungbu_cd + '||' +
  CONVERT(varchar(max), CONVERT(varbinary(20), time_stamp) , 1) + '||' +
  CASE WHEN lng IS NULL THEN ''
       ELSE 'point(' + CAST(lng AS varchar(10)) + ' ' + CAST(lat AS varchar(10)) + ')'
  END
FROM DONG_CODE;
/*
군위와 강원도가 변경된 테이블 => new_DONG_CODE.txt
*/









































