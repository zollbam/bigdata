/*
작성 일시: 230913
수정 일시: 
작 성 자 : 조건영
작성 목적: 숫자 타입에서 null과 0이 있는 열 찾기
*/


/*
※시사점
1. crdnt는 수동으로 찾기
2. 문자타입
 1) null
 2) 0
 3) 공백
3. 숫자타입
 1) null
 2) 0
4. 시간타입
 1) null
 2) 공백
*/


-- null과 0이 있는 null 찾기
SELECT c1.table_name
     , 'WITH NULL_ZERO_SPACE_TBL AS' + CHAR(10) +
       '(' +
       replace(
       stuff(
             (
              SELECT concat(
                            ' UNION', char(10)
                          , 'select distinct ''', c2.table_name, ''' table_name',char(10)
                          , SPACE(5), ', ''', c2.COLUMN_NAME, ''' column_name', char(10)
                          , '     , concat(', char(10)
                          , CASE WHEN C2.DATA_TYPE IN ('numeric', 'decimal') THEN SPACE(12) + '  case when (SELECT COUNT(*) FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' IS NULL) > 0 THEN ''NULL인 값 존재 * ''' + CHAR(10) +
                                                                                  SPACE(15) + 'END' + CHAR(10) +
                                                                                  SPACE(12) + ', case when (SELECT COUNT(*) FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' = 0) > 0 THEN ''0인 값 존재 * ''' + CHAR(10) +
                                                                                  SPACE(15) + 'END' + CHAR(10) +
                                                                                  SPACE(13) + ') null_zero_space_yn' + CHAR(10) +
                                                                                  SPACE(2) + 'FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME
                                 WHEN C2.DATA_TYPE IN ('datetime') THEN SPACE(12) + '  case when (SELECT COUNT(*) FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME + ' WHERE CAST(' + COLUMN_NAME + ' AS NVARCHAR(MAX)) IS NULL) > 0 THEN ''NULL인 값 존재 * ''' + CHAR(10) +
                                                                        SPACE(15) + 'END' + CHAR(10) +
                                                                        SPACE(13) + ', '''') null_zero_space_yn' + CHAR(10) +
                                                                        SPACE(2) + 'FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME
                                 ELSE SPACE(12) + '  case when (SELECT COUNT(*) FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' IS NULL) > 0 THEN ''NULL인 값 존재 * ''' + CHAR(10) +
                                      SPACE(15) + 'END' + CHAR(10) +
                                      SPACE(12) + ', case when (SELECT COUNT(*) FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' = ''0'') > 0 THEN ''0인 값 존재 * ''' + CHAR(10) +
                                      SPACE(15) + 'END' + CHAR(10) +
                                      SPACE(12) + ', case when (SELECT COUNT(*) FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' = '''') > 0 THEN ''공백인 값 존재 * ''' + CHAR(10) +
                                      SPACE(15) + 'END' + CHAR(10) +
                                      SPACE(13) + ') null_zero_space_yn' + CHAR(10) +
                                      SPACE(2) + 'FROM ' + C2.TABLE_SCHEMA + '.' + C2.TABLE_NAME
                                        END
                          , CASE WHEN c2.ORDINAL_POSITION = (
                                                             SELECT max(ORDINAL_POSITION) 
                                                               FROM information_schema.columns 
                                                              WHERE table_name = 'tb_com_user'
                                                            ) THEN ''
                                 ELSE char(10)
                             END
                           )
                FROM information_schema.columns c2
               WHERE c1.TABLE_NAME = c2.TABLE_NAME
                 AND DATA_TYPE != 'geometry'
                 FOR xml PATH('')
             )
           , 1, 6, ''
           )
           , '&gt;', '>') +
       CHAR(10) + ')' + CHAR(10) +
       'SELECT t.*
          FROM NULL_ZERO_SPACE_TBL t
               inner join
               information_schema.columns c
                       on t.table_name = c.table_name
                      and t.column_name = c.column_name
         order by c.ORDINAL_POSITION;'
  FROM information_schema.columns c1
 WHERE table_schema = 'sc_khb_srv'
   AND table_name = 'tb_com_user'
 GROUP BY TABLE_NAME;


SELECT ORDINAL_POSITION  FROM information_schema.columns;







