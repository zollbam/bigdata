/*
작성 일자 : 230912
수정 일자 : 
작 성 자 : 조건영
작성 목적 : 20번에서 timestamp의 최대값을 얻기 위해 (mariadb에서)
*/



/*
※time stmap가 필요한 배치명과 연결된 테이블
1. sidoBatch => sido_code
2. gugunBatch => gugun_code
3. dongBatch => dong_code
4. comCodeBatch => com_code
5. danjiBatch => danji_info
6. danjiDetailBatch => danji_detail_info
*/


-- 
WITH batch_update AS 
(
 SELECT 'sido\Batch' job_nm
      , max(SYS_TIMESTAMP)
   FROM sido_code
  UNION 
 SELECT 'gugunBatch' job_nm
      , max(SYS_TIMESTAMP)
   FROM gugun_code
  UNION 
 SELECT 'dongBatch' job_nm
      , max(SYS_TIMESTAMP)
   FROM dong_code
  UNION 
 SELECT 'comCodeBatch' job_nm
      , max(SYS_TIMESTAMP)
   FROM com_code
  UNION 
 SELECT 'danjiBatch' job_nm
      , max(SYS_TIMESTAMP)
   FROM danji_info
  UNION 
 SELECT 'danjiDetailBatch' job_nm
      , max(SYS_TIMESTAMP)
   FROM danji_detail_info
)
SELECT *
  INTO OUTFILE '/var/lib/mysql/backup/batch_update.txt'
       fields TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM batch_update;









































