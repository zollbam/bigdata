/*
날짜 : 2023-05-19
한방 테스트 DB인 db_khb_srv에서 인덱스를 생성하는 쿼리를 만들어 주는 쿼리문 작성
 */

-- db_khb_srv의 전체 인덱스 정보
SELECT i.name "인덱스명", i.is_unique "유니크 여부", t.schema_id, s.name "스키마명", ic.object_id, t.name "테이블명", ic.index_column_id, ic.column_id, c.name "컬럼명"
FROM sys.index_columns ic 
     	INNER JOIN 
     sys.tables t 
     		ON ic.object_id = t.object_id 
     	INNER JOIN 
     sys.schemas s 
     		ON s.schema_id = t.schema_id
     	INNER JOIN
     sys.columns c 
     		ON c.object_id = ic.object_id AND c.column_id = ic.column_id
     	INNER JOIN
     sys.indexes i 
     		ON i.object_id = ic.object_id AND i.index_id = ic.index_id 
WHERE i.[type] = 2;

-- db_khb_srv의 인덱스 생성 쿼리문
SELECT 'CREATE ' + 
        CASE WHEN "유니크 여부" = 0 THEN 'INDEX ' 
             ELSE 'UNIQUE INDEX ' END +
        "인덱스명" + ' ON ' +
        "스키마명" + '.' +
        "테이블명" + ' (' + "컬럼명" + ');'
FROM (
	SELECT i.name "인덱스명", i.is_unique "유니크 여부", t.schema_id, s.name "스키마명", ic.object_id, t.name "테이블명", ic.index_column_id, ic.column_id, c.name "컬럼명"
	FROM sys.index_columns ic /*객체 번호, 인덱스 컬럼 id, 컬럼 id*/
	     	INNER JOIN 
	     sys.tables t /*스키마 id, 테이블명*/
	     		ON ic.object_id = t.object_id 
	     	INNER JOIN 
	     sys.schemas s /*스키마명*/
	     		ON s.schema_id = t.schema_id
	     	INNER JOIN
	     sys.columns c /*컬럼명*/
	     		ON c.object_id = ic.object_id AND c.column_id = ic.column_id
	     	INNER JOIN
	     sys.indexes i /*인덱스명, 유니크여부*/
	     		ON i.object_id = ic.object_id AND i.index_id = ic.index_id 
	WHERE i.[type] = 2
) ii ;

/*
sys.indexes의 type
 - 0 = 힙
 - 1 = 클러스터형 rowstore(B-tree)
 - 2 = 비클러스터형 rowstore(B-tree)
 - 3 = XML
 - 4 = 공간
 - 5 = 클러스터형 columnstore 인덱스입니다. 적용 대상: SQL Server 2014(12.x) 이상
 - 6 = 비클러스터형 columnstore 인덱스입니다. 적용 대상: SQL Server 2012(11.x) 이상
 - 7 = 비클러스터형 해시 인덱스입니다. 적용 대상: SQL Server 2014(12.x) 이상
*/
