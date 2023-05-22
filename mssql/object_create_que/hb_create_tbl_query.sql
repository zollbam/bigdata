SELECT * FROM information_schema.columns;
/*IS_NULLABLE => NO(not null) YES(null)*/
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
       NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION
FROM information_schema.columns;


SELECT * FROM sys.columns;
SELECT * FROM information_schema.tables;
SELECT * FROM information_schema.constraint_column_usage;

SELECT * FROM sys.objects WHERE type ='pk';


SELECT c.TABLE_NAME, c.COLUMN_NAME + ' ' + CASE WHEN c.DATA_TYPE IN ('decimal') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c.NUMERIC_SCALE AS varchar) + ')'
            WHEN c.DATA_TYPE IN ('char', 'varchar') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
            ELSE c.DATA_TYPE
       END + 
       CASE WHEN c.IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
       END +
       CASE WHEN c.COLUMN_DEFAULT IS NOT NULL THEN ' defualt ' + c.COLUMN_DEFAULT
            ELSE ''
       END, 
       ccu.COLUMN_NAME "pk_col"
FROM information_schema.columns c
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c.TABLE_NAME = ccu.TABLE_NAME;

SELECT c2.TABLE_NAME, 
       'CREATE TABLE ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + ' (' +
	   stuff((SELECT ', ' + c1.COLUMN_NAME + ' ' + CASE WHEN c1.DATA_TYPE IN ('decimal') THEN c1.DATA_TYPE + '(' + CAST(c1.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c1.NUMERIC_SCALE AS varchar) + ')'
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
     CASE WHEN ccu.COLUMN_NAME != '' THEN ', primary key (' +  ccu.COLUMN_NAME + '));' end
FROM information_schema.columns c2
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c2.TABLE_NAME = ccu.TABLE_NAME
GROUP BY c2.TABLE_NAME, c2.TABLE_SCHEMA, ccu.COLUMN_NAME;





/*
mssql
날짜: 23-05-19

테이블 생성 하는 쿼리문 작성
*/

/*사용 테이블*/
SELECT * FROM information_schema.columns;
SELECT * FROM information_schema.constraint_column_usage;

/*테이블에서 사용될 열만 조회*/
SELECT TABLE_NAME,TABLE_SCHEMA, COLUMN_NAME, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
       NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION
FROM information_schema.columns;

/*테이블 정보*/
SELECT TABLE_NAME, COLUMN_NAME + ' ' + CASE WHEN DATA_TYPE IN ('decimal') THEN DATA_TYPE + '(' + CAST(NUMERIC_PRECISION AS varchar) + ', ' + CAST(NUMERIC_SCALE AS varchar) + ')'
            WHEN DATA_TYPE IN ('char', 'varchar') THEN DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
            ELSE DATA_TYPE
       END + 
       CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
       END +
       CASE WHEN COLUMN_DEFAULT IS NOT NULL THEN ' defualt ' + COLUMN_DEFAULT
            ELSE ''
       END
FROM information_schema.columns;

SELECT 'CREATE TABLE ' + TABLE_SCHEMA + '.' + TABLE_NAME + ' (' +
	   stuff((SELECT ', ' + COLUMN_NAME + ' ' + CASE WHEN DATA_TYPE IN ('decimal') THEN DATA_TYPE + '(' + CAST(NUMERIC_PRECISION AS varchar) + ', ' + CAST(NUMERIC_SCALE AS varchar) + ')'
            WHEN DATA_TYPE IN ('char', 'varchar') THEN DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
            ELSE DATA_TYPE
       END + 
       CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
       END +
       CASE WHEN COLUMN_DEFAULT IS NOT NULL THEN ' default ' + COLUMN_DEFAULT
            ELSE ''
       END
FROM information_schema.columns
                            WHERE c.TABLE_NAME = TABLE_name
                            FOR xml PATH('')), 1, 2, '') + ');'
FROM information_schema.columns c
GROUP BY TABLE_NAME, TABLE_SCHEMA;



SELECT 'CREATE TABLE ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + ' (' +
	   stuff((SELECT ', ' + c1.COLUMN_NAME + ' ' + CASE WHEN c1.DATA_TYPE IN ('decimal') THEN c1.DATA_TYPE + '(' + CAST(c1.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c1.NUMERIC_SCALE AS varchar) + ')'
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
     CASE WHEN ccu.COLUMN_NAME != '' THEN ', primary key (' +  ccu.COLUMN_NAME + '));' end
FROM information_schema.columns c2
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c2.TABLE_NAME = ccu.TABLE_NAME
GROUP BY c2.TABLE_NAME, c2.TABLE_SCHEMA, ccu.COLUMN_NAME;











