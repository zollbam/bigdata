/*
작성일 : 230821
수정일 : 
작성자 : 조건영
작성 목적 : point(경도 위도) 텍스트 파일을 바로 geometry타입으로 저장 시키기 위해
          새로운 방법인 insert into openrowset을 찾았다.
          여기에는 이관할 파일과 format 파일이 있어야 한다.

참조 사이트
 1. xsi:type => format xml 파일의 타입 정리
  - https://learn.microsoft.com/en-us/openspecs/sql_data_portability/ms-bcp/51298f0a-c9ac-463a-8e01-76d25ebaca3c
*/

-- format xml파일 내용 작성 쿼리
SELECT TABLE_NAME 
     , concat('<?xml version="1.0"?>', char(10),
              '<BCPFORMAT xmlns="http://schemas.microsoft.com/sqlserver/2004/bulkload/format" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">', char(10),
              '<RECORD>', char(10),
              replace(
                      replace(
                              stuff((
                                     SELECT '<FIELD ID="' + 
                                            CAST(ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS varchar(4000)) + 
                                            '" xsi:type="CharTerm" TERMINATOR="' +
                                            CASE WHEN ORDINAL_POSITION = (SELECT max(ORDINAL_POSITION) 
                                                                            FROM information_schema.columns
                                                                           WHERE TABLE_SCHEMA = 'sc_khb_srv'
                                                                             AND table_name = 'tb_atlfsl_bsc_info') 
                                                                                                                   THEN '\r\n'
                                                 ELSE '||'
                                            END + 
                                            '" MAX_LENGTH="' +
                                            CASE WHEN DATA_TYPE IN ('char', 'nvarchar', 'varchar') THEN 
                                                                                                        CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '4000' + '" COLLATION = "Korean_Wansung_CI_AS'
                                                                                                             ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS nvarchar(4000)) + '" COLLATION = "Korean_Wansung_CI_AS'
                                                                                                        END
                                                 WHEN DATA_TYPE IN ('decimal', 'int', 'numeric') THEN CAST(NUMERIC_PRECISION+NUMERIC_SCALE AS nvarchar(4000))
                                                 WHEN DATA_TYPE IN ('datetime', 'geometry') THEN '4000'
                                            END + '"/>' + char(10)
                                       FROM information_schema.columns c1
                                      WHERE c1.TABLE_NAME = c2.TABLE_NAME
                                        FOR xml PATH('')), 1, 0, ''),'&lt;', '<'), '&gt;', '>'),
              '</RECORD>', char(10),
              '<ROW>', char(10),
              replace(
                      replace(
                              stuff((
                                     SELECT '<COLUMN SOURCE="' + 
                                            CAST(ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS varchar(4000)) + 
                                            '" NAME="' +
                                            COLUMN_NAME + 
                                            '" xsi:type="' +
                                            CASE WHEN DATA_TYPE = 'char' THEN 'SQLCHAR'
                                                 WHEN DATA_TYPE = 'nvarchar' THEN 'SQLNVARCHAR'
                                                 WHEN DATA_TYPE = 'varchar' THEN 'SQLVARYCHAR'
                                                 WHEN DATA_TYPE = 'decimal' THEN 'SQLFLT8'
                                                 WHEN DATA_TYPE = 'int' THEN 'SQLINT'
                                                 WHEN DATA_TYPE = 'numeric' THEN 'SQLNUMERIC'
                                                 WHEN DATA_TYPE = 'datetime' THEN 'SQLDATETIME'
                                                 WHEN DATA_TYPE = 'geometry' THEN 'SQLNVARCHAR'
                                            END +'"/>' + char(10)
                                       FROM information_schema.columns c1
                                      WHERE c1.TABLE_NAME = c2.TABLE_NAME
                                        FOR xml PATH('')), 1, 0, ''),'&lt;', '<'), '&gt;', '>'), 
              '</ROW>', char(10),
              '</BCPFORMAT>')
  FROM information_schema.columns c2
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
   AND table_name = 'tb_atlfsl_bsc_info'
 GROUP BY TABLE_NAME;
/*
테이블 이름 변경시 서브쿼리에 있는 where절에도 테이블 이름을 변경 해주어야 한다. => 총 2개의 조건을 변경 시켜야 함
*/



SELECT TABLE_NAME 
     , stuff((SELECT concat('  <FIELD ID="', CAST(ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS varchar(4000)), '" xsi:type="CharTerm" TERMINATOR="'
     , CASE WHEN ORDINAL_POSITION = (SELECT max(ORDINAL_POSITION) 
                                       FROM information_schema.columns
                                      WHERE TABLE_SCHEMA = 'sc_khb_srv'
                                        AND table_name = 'tb_atlfsl_bsc_info') THEN '\r\n'
            ELSE '||'
       END, '" MAX_LENGTH="'
     , CASE WHEN DATA_TYPE IN ('char', 'nvarchar', 'varchar') THEN 
                                                                   CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'max'
                                                                        ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS nvarchar(4000))
                                                                   END
            WHEN DATA_TYPE IN ('decimal', 'int', 'numeric') THEN CAST((NUMERIC_PRECISION + NUMERIC_SCALE) AS nvarchar(4000))
            WHEN DATA_TYPE IN ('datetime', 'geometry') THEN '4000'
       END,'"/>', char(10))
       FROM information_schema.columns c1
       WHERE c1.TABLE_NAME = c2.TABLE_NAME
        FOR xml PATH('')), 1, 2, '') AS a
--     , ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION)
--     , COLUMN_NAME
--     , CASE WHEN DATA_TYPE = 'char' THEN 'SQLCHAR'
--            WHEN DATA_TYPE = 'nvarchar' THEN 'SQLNVARCHAR'
--            WHEN DATA_TYPE = 'varchar' THEN 'SQLVARYCHAR'
--            WHEN DATA_TYPE = 'decimal' THEN 'SQLDECIMAL'
--            WHEN DATA_TYPE = 'int' THEN 'SQLINT'
--            WHEN DATA_TYPE = 'numeric' THEN 'SQLNUMERIC'
--            WHEN DATA_TYPE = 'datetime' THEN 'SQLDATETIME'
--            WHEN DATA_TYPE = 'geometry' THEN 'SQLNVARCHAR'
--       END
  FROM information_schema.columns c2
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
   AND table_name = 'tb_atlfsl_bsc_info'
 GROUP BY TABLE_NAME;



SELECT *
  FROM information_schema.columns
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
   AND TABLE_NAME = 'tb_lttot_info';
   AND NUMERIC_PRECISION IS NOT NULL;



SELECT DISTINCT DATA_TYPE
  FROM information_schema.columns
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
   AND DATETIME_PRECISION IS NOT NULL;


































