/*
날짜 : 2023-05-23
한방 테스트 DB인 db_khb_srv에서 테이블를 생성하는 쿼리를 만들어 주는 쿼리문 작성
 */
-- 테이블의 열 정보
SELECT c.TABLE_NAME"테이블명", c.COLUMN_NAME "컬럼명", 
       CASE WHEN c.DATA_TYPE IN ('decimal') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c.NUMERIC_SCALE AS varchar) + ')'
            WHEN c.DATA_TYPE IN ('char', 'varchar', 'nvarchar') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
            ELSE c.DATA_TYPE
       END "타입 형식",
       CASE WHEN c.IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
       END "NULL부부"
FROM information_schema.columns c
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c.TABLE_NAME = ccu.TABLE_NAME;

-- 필요 열만 추출
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
       NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION
FROM information_schema.columns;
/*IS_NULLABLE => NO(not null) YES(null)*/

-- 열정보가 텍스트로 저장
SELECT * FROM information_schema.columns;

-- 열정보가 숫자로 저장
SELECT * FROM sys.columns;

-- 테이블 PK
SELECT * FROM information_schema.constraint_column_usage;
SELECT * FROM sys.objects WHERE type ='pk';

-- 테이블 생성 스크립트 작성 준비 테이블
SELECT c.TABLE_NAME "테이블명", 
       c.COLUMN_NAME + ' ' + 
       CASE WHEN c.DATA_TYPE IN ('decimal') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c.NUMERIC_SCALE AS varchar) + ')'
            WHEN c.DATA_TYPE IN ('char', 'varchar') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
            ELSE c.DATA_TYPE
       END + 
       CASE WHEN c.IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
       END +
       CASE WHEN c.COLUMN_DEFAULT IS NOT NULL THEN ' defualt ' + c.COLUMN_DEFAULT
            ELSE ''
       END "열 정보", 
       ccu.COLUMN_NAME "pk_col"
FROM information_schema.columns c
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c.TABLE_NAME = ccu.TABLE_NAME;

-- 각 테이블별 테이블 작성 쿼리문
SELECT c2.TABLE_NAME "테이블명", 
       'CREATE TABLE ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + ' (' +
	   stuff((SELECT ', ' + c1.COLUMN_NAME + ' ' + 
		          CASE WHEN c1.DATA_TYPE IN ('decimal') THEN c1.DATA_TYPE + '(' + CAST(c1.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c1.NUMERIC_SCALE AS varchar) + ')'
	                   WHEN c1.DATA_TYPE IN ('char', 'varchar') THEN c1.DATA_TYPE + '(' + CAST(c1.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
	                   ELSE c1.DATA_TYPE
	              END + 
	              CASE WHEN c1.IS_NULLABLE = 'NO' THEN ' NOT NULL'
	                   ELSE ''
	              END +
                  CASE WHEN c1.COLUMN_DEFAULT IS NOT NULL THEN ' default ' + c1.COLUMN_DEFAULT
                       ELSE ''
                  END 
              FROM information_schema.columns c1
              WHERE c1.TABLE_NAME = c2.TABLE_name
              	FOR xml PATH('')), 1, 2, '') + 
       CASE WHEN ccu.COLUMN_NAME != '' THEN ', primary key (' +  ccu.COLUMN_NAME + '));' END "테이블별 작성 스크립트"
FROM information_schema.columns c2
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c2.TABLE_NAME = ccu.TABLE_NAME
GROUP BY c2.TABLE_NAME, c2.TABLE_SCHEMA, ccu.COLUMN_NAME;


