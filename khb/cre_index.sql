/*
인덱스 생성 쿼리문 파일
작성 일시: 230620
수정 일시: 230629
작 성 자 : 조건영
*/

-- 인덱스 쿼리를 만들기 위한 정보(161)
SELECT 
  i.name "index_name"
, ic.index_id 
, ic.index_column_id
, schema_name(o.schema_id) "schema_name" 
, object_name(i.object_id) "table_name"
, c.name "column_name"
, i.type_desc "cluster_se"
, i.is_unique "unique_yn"
  FROM sys.indexes i
       INNER JOIN
       sys.index_columns ic
           ON i.object_id = ic.object_id 
              AND 
              i.index_id = ic.index_id
       INNER JOIN
       sys.columns c
           ON c.object_id = i.object_id
              AND 
              c.column_id = ic.column_id
       INNER JOIN 
       sys.objects o 
           ON o.object_id = c.object_id 
 WHERE object_name(i.object_id) IN (SELECT TABLE_name 
                                      FROM information_schema.tables
                                     WHERE table_schema = 'sc_khb_srv')
   AND (i.name LIKE 'si%' 
    OR i.name LIKE 'ix%')
 ORDER BY 4, 5;


-- 인덱스 쿼리 스크립트 만들기
WITH index_info AS (
SELECT 
  i.name "index_name"
, ic.index_id 
, ic.index_column_id
, schema_name(o.schema_id) "schema_name" 
, object_name(i.object_id) "table_name"
, c.name "column_name"
, i.type_desc "cluster_se"
, i.is_unique "unique_yn"
  FROM sys.indexes i
       INNER JOIN
       sys.index_columns ic
           ON i.object_id = ic.object_id 
              AND 
              i.index_id = ic.index_id
       INNER JOIN
       sys.columns c
           ON c.object_id = i.object_id
              AND 
              c.column_id = ic.column_id
       INNER JOIN 
       sys.objects o 
           ON o.object_id = c.object_id 
 WHERE object_name(i.object_id) IN (SELECT TABLE_name 
                                      FROM information_schema.tables
                                     WHERE table_schema = 'sc_khb_srv')
--       AND
--       name COLLATE korean_wansung_cs_as LIKE '%pk_%'
)
SELECT table_name "테이블명",
  CASE WHEN unique_yn = 1 THEN 
                               CASE WHEN cluster_se = 'CLUSTERED' THEN 'create unique CLUSTERED index '
                                    ELSE 'create unique index '
                               END
       ELSE 
            CASE WHEN cluster_se = 'CLUSTERED' THEN 'create CLUSTERED index '
                 ELSE 'create index '
            END
  END + 
  ii1.index_name + ' on ' +
  schema_name + '.' + 
  table_name + '(' +
  stuff((SELECT ', ' + column_name 
           FROM index_info
          WHERE index_name = ii1.index_name 
                AND
                index_id = ii1.index_id
--                     AND 
--                     table_name = ii1.table_name
            FOR xml PATH('')), 1, 2, '') + ');' "인덱스 생성 스크립트"
  FROM index_info ii1
 GROUP BY index_name, index_id, schema_name, table_name, cluster_se, unique_yn
ORDER BY 1;



-- 인덱스 생성 (162)

 





 














