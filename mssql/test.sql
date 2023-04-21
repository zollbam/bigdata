-- 테이블 생성 스크립트 만들기
-- 링크: https://scalability.tistory.com/38
-- * 스크립트 만들 테이블명 변수 설정
DECLARE @TABLE_NAME SYSNAME -- 
SELECT @TABLE_NAME = '[dbo].[autoadmin_managed_databases]' 

-- *  
DECLARE 
      @OBJECT_NAME SYSNAME
    , @OBJECT_ID INT
SELECT 
      @OBJECT_NAME = '[' + S.NAME + '].[' + O.NAME + ']'
    , @OBJECT_ID = O.[OBJECT_ID]
FROM SYS.OBJECTS O WITH (NOWAIT)
JOIN SYS.SCHEMAS S WITH (NOWAIT) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
WHERE S.NAME + '.' + O.NAME = @TABLE_NAME
    AND O.[TYPE] = 'U'
    AND O.IS_MS_SHIPPED = 0


DECLARE @SQL NVARCHAR(MAX) = '';
 
WITH INDEX_COLUMN AS 
(
    SELECT 
          IC.[OBJECT_ID]
        , IC.INDEX_ID
        , IC.IS_DESCENDING_KEY
        , IC.IS_INCLUDED_COLUMN
        , C.NAME
    FROM SYS.INDEX_COLUMNS IC WITH (NOWAIT)
    JOIN SYS.COLUMNS C WITH (NOWAIT) ON IC.[OBJECT_ID] = C.[OBJECT_ID] AND IC.COLUMN_ID = C.COLUMN_ID
    WHERE IC.[OBJECT_ID] = @OBJECT_ID
),
FK_COLUMNS AS 
(
     SELECT 
          K.CONSTRAINT_OBJECT_ID
        , CNAME = C.NAME
        , RCNAME = RC.NAME
    FROM SYS.FOREIGN_KEY_COLUMNS K WITH (NOWAIT)
    JOIN SYS.COLUMNS RC WITH (NOWAIT) ON RC.[OBJECT_ID] = K.REFERENCED_OBJECT_ID AND RC.COLUMN_ID = K.REFERENCED_COLUMN_ID 
    JOIN SYS.COLUMNS C WITH (NOWAIT) ON C.[OBJECT_ID] = K.PARENT_OBJECT_ID AND C.COLUMN_ID = K.PARENT_COLUMN_ID
    WHERE K.PARENT_OBJECT_ID = @OBJECT_ID
)
SELECT @SQL = 'CREATE TABLE ' + @OBJECT_NAME + CHAR(13) + '(' + CHAR(13) + STUFF((
    SELECT CHAR(9) + ', [' + C.NAME + '] ' + 
        CASE WHEN C.IS_COMPUTED = 1
            THEN 'AS ' + CC.[DEFINITION] 
            ELSE UPPER(TP.NAME) + 
                CASE WHEN TP.NAME IN ('VARCHAR', 'CHAR', 'VARBINARY', 'BINARY', 'TEXT')
                       THEN '(' + CASE WHEN C.MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(C.MAX_LENGTH AS VARCHAR(5)) END + ')'
                     WHEN TP.NAME IN ('NVARCHAR', 'NCHAR', 'NTEXT')
                       THEN '(' + CASE WHEN C.MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(C.MAX_LENGTH / 2 AS VARCHAR(5)) END + ')'
                     WHEN TP.NAME IN ('DATETIME2', 'TIME2', 'DATETIMEOFFSET') 
                       THEN '(' + CAST(C.SCALE AS VARCHAR(5)) + ')'
                     WHEN TP.NAME = 'DECIMAL' 
                       THEN '(' + CAST(C.[PRECISION] AS VARCHAR(5)) + ',' + CAST(C.SCALE AS VARCHAR(5)) + ')'
                    ELSE ''
                END +
                CASE WHEN C.COLLATION_NAME IS NOT NULL THEN ' COLLATE ' + C.COLLATION_NAME ELSE '' END +
                CASE WHEN C.IS_NULLABLE = 1 THEN ' NULL' ELSE ' NOT NULL' END +
                CASE WHEN DC.[DEFINITION] IS NOT NULL THEN ' DEFAULT' + DC.[DEFINITION] ELSE '' END + 
                CASE WHEN IC.IS_IDENTITY = 1 THEN ' IDENTITY(' + CAST(ISNULL(IC.SEED_value, '0') AS CHAR(1)) + ',' + CAST(ISNULL(IC.INCREMENT_value, '1') AS CHAR(1)) + ')' ELSE '' END 
        END + CHAR(13)
    FROM SYS.COLUMNS C WITH (NOWAIT)
    JOIN SYS.TYPES TP WITH (NOWAIT) ON C.USER_TYPE_ID = TP.USER_TYPE_ID
    LEFT JOIN SYS.COMPUTED_COLUMNS CC WITH (NOWAIT) ON C.[OBJECT_ID] = CC.[OBJECT_ID] AND C.COLUMN_ID = CC.COLUMN_ID
    LEFT JOIN SYS.DEFAULT_CONSTRAINTS DC WITH (NOWAIT) ON C.DEFAULT_OBJECT_ID != 0 AND C.[OBJECT_ID] = DC.PARENT_OBJECT_ID AND C.COLUMN_ID = DC.PARENT_COLUMN_ID
    LEFT JOIN SYS.IDENTITY_COLUMNS IC WITH (NOWAIT) ON C.IS_IDENTITY = 1 AND C.[OBJECT_ID] = IC.[OBJECT_ID] AND C.COLUMN_ID = IC.COLUMN_ID
    WHERE C.[OBJECT_ID] = @OBJECT_ID
    ORDER BY C.COLUMN_ID
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, CHAR(9) + ' ')
    + ISNULL((SELECT CHAR(9) + ', CONSTRAINT [' + K.NAME + '] PRIMARY KEY (' + 
                    (SELECT STUFF((
                         SELECT ', [' + C.NAME + '] ' + CASE WHEN IC.IS_DESCENDING_KEY = 1 THEN 'DESC' ELSE 'ASC' END
                         FROM SYS.INDEX_COLUMNS IC WITH (NOWAIT)
                         JOIN SYS.COLUMNS C WITH (NOWAIT) ON C.[OBJECT_ID] = IC.[OBJECT_ID] AND C.COLUMN_ID = IC.COLUMN_ID
                         WHERE IC.IS_INCLUDED_COLUMN = 0
                             AND IC.[OBJECT_ID] = K.PARENT_OBJECT_ID 
                             AND IC.INDEX_ID = K.UNIQUE_INDEX_ID     
                         FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, ''))
            + ')' + CHAR(13)
            FROM SYS.KEY_CONSTRAINTS K WITH (NOWAIT)
            WHERE K.PARENT_OBJECT_ID = @OBJECT_ID 
                AND K.[TYPE] = 'PK'), '') + ')'  + CHAR(13)
    + ISNULL((SELECT (
        SELECT CHAR(13) +
             'ALTER TABLE ' + @OBJECT_NAME + ' WITH' 
            + CASE WHEN FK.IS_NOT_TRUSTED = 1 
                THEN ' NOCHECK' 
                ELSE ' CHECK' 
              END + 
              ' ADD CONSTRAINT [' + FK.NAME  + '] FOREIGN KEY(' 
              + STUFF((
                SELECT ', [' + K.CNAME + ']'
                FROM FK_COLUMNS K
                WHERE K.CONSTRAINT_OBJECT_ID = FK.[OBJECT_ID]
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
               + ')' +
              ' REFERENCES [' + SCHEMA_NAME(RO.[SCHEMA_ID]) + '].[' + RO.NAME + '] ('
              + STUFF((
                SELECT ', [' + K.RCNAME + ']'
                FROM FK_COLUMNS K
                WHERE K.CONSTRAINT_OBJECT_ID = FK.[OBJECT_ID]
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
               + ')'
            + CASE 
                WHEN FK.DELETE_REFERENTIAL_ACTION = 1 THEN ' ON DELETE CASCADE' 
                WHEN FK.DELETE_REFERENTIAL_ACTION = 2 THEN ' ON DELETE SET NULL'
                WHEN FK.DELETE_REFERENTIAL_ACTION = 3 THEN ' ON DELETE SET DEFAULT' 
                ELSE '' 
              END
            + CASE 
                WHEN FK.UPDATE_REFERENTIAL_ACTION = 1 THEN ' ON UPDATE CASCADE'
                WHEN FK.UPDATE_REFERENTIAL_ACTION = 2 THEN ' ON UPDATE SET NULL'
                WHEN FK.UPDATE_REFERENTIAL_ACTION = 3 THEN ' ON UPDATE SET DEFAULT'  
                ELSE '' 
              END 
            + CHAR(13) + 'ALTER TABLE ' + @OBJECT_NAME + ' CHECK CONSTRAINT [' + FK.NAME  + ']' + CHAR(13)
        FROM SYS.FOREIGN_KEYS FK WITH (NOWAIT)
        JOIN SYS.OBJECTS RO WITH (NOWAIT) ON RO.[OBJECT_ID] = FK.REFERENCED_OBJECT_ID
        WHERE FK.PARENT_OBJECT_ID = @OBJECT_ID
        FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)')), '')
    + ISNULL(((SELECT
         CHAR(13) + 'CREATE' + CASE WHEN I.IS_UNIQUE = 1 THEN ' UNIQUE' ELSE '' END 
                + ' NONCLUSTERED INDEX [' + I.NAME + '] ON ' + @OBJECT_NAME + ' (' +
                STUFF((
                SELECT ', [' + C.NAME + ']' + CASE WHEN C.IS_DESCENDING_KEY = 1 THEN ' DESC' ELSE ' ASC' END
                FROM INDEX_COLUMN C
                WHERE C.IS_INCLUDED_COLUMN = 0
                    AND C.INDEX_ID = I.INDEX_ID
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')'  
                + ISNULL(CHAR(13) + 'INCLUDE (' + 
                    STUFF((
                    SELECT ', [' + C.NAME + ']'
                    FROM INDEX_COLUMN C
                    WHERE C.IS_INCLUDED_COLUMN = 1
                        AND C.INDEX_ID = I.INDEX_ID
                    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')', '')  + CHAR(13)
        FROM SYS.INDEXES I WITH (NOWAIT)
        WHERE I.[OBJECT_ID] = @OBJECT_ID
            AND I.IS_PRIMARY_KEY = 0
            AND I.[TYPE] = 2
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')
    ), '')
 
PRINT @SQL


-- fk키 테스트 테이블
create table pk_2_tbl (
	a int,
	b int,
	constraint ab_pk primary key(a,b)
)

create table fk_2_tbl (
	c int,
	d int,
	constraint cd_fk foreign key (c,d) references pk_2_tbl(a,b)
)