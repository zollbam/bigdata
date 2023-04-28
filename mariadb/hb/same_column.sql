-- 테이블 정보 확인
SELECT COLUMN_NAME "컬럼명", COLUMN_COMMENT "컬럼명", COLUMN_KEY, COLUMN_TYPE, IS_NULLABLE
FROM information_schema.columns 
WHERE TABLE_NAME=LOWER('user_info_hp')
/*
WHERE절에서 보고자 하는 테이블명을 변경하면 확인 가능
*/

-- hbtest의 총 테이블에 대한 열의 개수는 792개
SELECT * FROM information_schema.`COLUMNS` WHERE TABLE_schema='hanbang'


-- 중복되는 열의 이름을 제거하면 495개
-- 같은 이름으로 삭제된 데이터가 297개가 있다는 의미
SELECT distinct COLUMN_NAME FROM information_schema.`COLUMNS` WHERE TABLE_schema='hanbang' 

-- 중복되는 열의 이름 개수는 132개
SELECT COLUMN_NAME, COUNT(COLUMN_NAME)
FROM information_schema.`COLUMNS`
WHERE TABLE_schema='hanbang' 
GROUP BY COLUMN_NAME
HAVING COUNT(COLUMN_NAME)>1
ORDER BY 2 DESC 

-- 중복되는 열의 이름의 총 개수는 429
SELECT SUM(a.ref)
from(SELECT COUNT(COLUMN_NAME) ref
     FROM information_schema.`COLUMNS`
     WHERE TABLE_schema='hanbang'
     GROUP BY COLUMN_NAME
     HAVING COUNT(COLUMN_NAME)>1) a

-- 열의 이름이 하나만 있는 경우는 363
-- 429(두개이상) + 363(하나) = 792(총 열의 개수)
SELECT COLUMN_NAME, COUNT(COLUMN_NAME)
FROM information_schema.`COLUMNS`
WHERE TABLE_schema='hanbang'
GROUP BY COLUMN_NAME
HAVING COUNT(COLUMN_NAME)=1
ORDER BY 2 DESC 

-- 중복된 테이블 정보만 추출
SELECT TABLE_NAME, COLUMN_NAME, DATA_type, column_key, column_comment
FROM information_schema.`COLUMNS` 
WHERE COLUMN_NAME IN (SELECT COLUMN_NAME
                      FROM information_schema.`COLUMNS`
                      WHERE TABLE_schema='hanbang'
                      GROUP BY COLUMN_NAME
                      HAVING COUNT(COLUMN_NAME)>1) 
		AND 
		TABLE_schema='hanbang'
ORDER BY COLUMN_NAME
