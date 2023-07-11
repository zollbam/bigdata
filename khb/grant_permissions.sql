/*
테이블, 시퀀스, 함수, 등 권한을 확인하는 작업
작성 일시: 23-06-25
수정 일시: 23-07-03
작 성 자 : 조건영
*/

-- 권한 정보 조회
SELECT 
  class_desc
, CASE WHEN class_desc = 'TYPE' THEN type_name(major_id) 
       ELSE object_name(major_id) 
  END "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'')
  FROM sys.DATABASE_permissions dp
 WHERE class_desc != 'DATABASE' AND grantee_principal_id != 0
 GROUP BY class_desc, major_id, grantee_principal_id;

-- 권한 부여 스크립트 작성 쿼리문(테이블)
SELECT 
  class_desc "클래스 설명"
, object_name(major_id) "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, 'grant ' + 
  stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'') + 
  ' on sc_khb_srv.' + 
  object_name(major_id) + 
  ' to ' + user_name(grantee_principal_id) + ';' "권한부여 쿼리"
  FROM sys.DATABASE_permissions dp
 WHERE class_desc != 'DATABASE' 
       AND 
       grantee_principal_id != 0
       AND 
       object_name(major_id) = ANY(SELECT name FROM sys.tables WHERE schema_id = 5)
 GROUP BY class_desc, major_id, grantee_principal_id
 ORDER BY 2,3;
SELECT * FROM sys.tables;
-- 권한 부여 스크립트 작성 쿼리문(사용자 타입)
SELECT 
  class_desc
, CASE WHEN class_desc = 'TYPE' THEN type_name(major_id) 
       ELSE object_name(major_id) 
  END "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'')
  FROM sys.DATABASE_permissions dp
 WHERE class_desc = 'TYPE'
 GROUP BY class_desc, major_id, grantee_principal_id
 ORDER BY 2, 3;

-- 권한 부여 스크립트 작성 쿼리문(시퀀스)
SELECT 
  class_desc
, object_name(major_id) "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, 'grant ' + 
  stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'') + 
  ' on sc_khb_srv.' + 
  object_name(major_id) + 
  ' to ' + user_name(grantee_principal_id) + ';'
  FROM sys.DATABASE_permissions dp
 WHERE class_desc != 'DATABASE' 
       AND 
       grantee_principal_id != 0
       AND 
       object_name(major_id) = ANY(SELECT name FROM sys.sequences)
 GROUP BY class_desc, major_id, grantee_principal_id
 ORDER BY 2,3;

-- 권한 부여 스크립트 작성 쿼리문(프로시저 & 함수)
SELECT 
  class_desc
, object_name(major_id) "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, 'grant ' + 
  stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'') + 
  ' on sc_khb_srv.' + 
  object_name(major_id) + 
  ' to ' + user_name(grantee_principal_id) + ';'
  FROM sys.DATABASE_permissions dp
 WHERE class_desc != 'DATABASE' 
       AND 
       grantee_principal_id != 0
       AND
       object_name(major_id) = ANY(SELECT ROUTINE_NAME FROM information_schema.routines)
 GROUP BY class_desc, major_id, grantee_principal_id
 ORDER BY 2,3;


grant INSERT, UPDATE on sc_khb_srv.tb_com_rss_info to us_khb_exif;



