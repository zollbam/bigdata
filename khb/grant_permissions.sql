/*
테이블, 시퀀스, 함수, 등 권한을 확인하는 작업
작성 일시: 23-06-25
수정 일시: 23-07-12
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

-- 권한 부여 정보 확인(테이블) => long
SELECT
  class_desc "클래스 설명"
, object_name(major_id) "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, permission_name "권한명"
  FROM sys.DATABASE_permissions
 WHERE class_desc != 'DATABASE' 
       AND 
       grantee_principal_id != 0
       AND 
       object_name(major_id) = ANY(SELECT name FROM sys.tables WHERE schema_id = 5)
 ORDER BY 2, 3;
GRANT SELECT ,INSERT, UPDATE, DELETE ON sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info TO us_khb_exif;
-- 권한 부여 정보 확인(테이블) => wide
SELECT *
  FROM (SELECT
--  class_desc "클래스 설명"
  dense_RANK() OVER (ORDER BY object_name(major_id), user_name(grantee_principal_id)) "no"
, object_name(major_id) "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, permission_name "권한명"
, 'O' "res"
  FROM sys.DATABASE_permissions 
  WHERE class_desc != 'DATABASE' 
       AND 
       grantee_principal_id != 0
       AND 
       object_name(major_id) = ANY(SELECT name FROM sys.tables WHERE schema_id = 5)
 ) AS a
 PIVOT (
        count(a.res) FOR "권한명" IN ([INSERT], [SELECT], [UPDATE], [DELETE])
       ) AS pivot_res;

-- 권한 부여 정보 확인(테이블) => wide + O/X
SELECT 
  b."클래스 설명"
, b."객체명"
, b."권한 받은 유저"
, CASE WHEN b."INSERT" = 0 THEN 'X' ELSE 'O' END "INSERT(C)"
, CASE WHEN b."SELECT" = 0 THEN 'X' ELSE 'O' END "SELECT(R)"
, CASE WHEN b."UPDATE" = 0 THEN 'X' ELSE 'O' END "UPDATE(U)"
, CASE WHEN b."DELETE" = 0 THEN 'X' ELSE 'O' END "DELETE(D)"
  FROM (
        SELECT *
          FROM (SELECT
                  class_desc "클래스 설명"
                , object_name(major_id) "객체명"
                , user_name(grantee_principal_id) "권한 받은 유저"
                , permission_name "권한명"
                , 'O' "res"
                  FROM sys.DATABASE_permissions 
                 WHERE class_desc != 'DATABASE' 
                       AND 
                       grantee_principal_id != 0
                       AND 
                       object_name(major_id) = ANY(SELECT name 
                                                     FROM sys.tables 
                                                    WHERE schema_id = 5)
               ) AS a
                    PIVOT (
                           count(a.res) FOR "권한명" IN ([INSERT], [SELECT], [UPDATE], [DELETE])
                          ) AS pivot_res
      ) b;
 WHERE b."객체명" = 'tb_user_atlfsl_preocupy_info';

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
, 'revoke ' + 
  stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'') + 
  ' on sc_khb_srv.' + 
  object_name(major_id) + 
  ' from ' + user_name(grantee_principal_id) + ';' "권한삭제 쿼리"
  FROM sys.DATABASE_permissions dp
 WHERE class_desc != 'DATABASE' 
       AND 
       grantee_principal_id != 0
       AND 
       object_name(major_id) = ANY(SELECT name FROM sys.tables WHERE schema_id = 5)
 GROUP BY class_desc, major_id, grantee_principal_id
 ORDER BY 2, 3;

-- 권한 부여 스크립트 작성 쿼리문(사용자 타입)
SELECT 
  class_desc
, CASE WHEN class_desc = 'TYPE' THEN type_name(major_id) 
       ELSE object_name(major_id) 
  END "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, 'grant ' + 
  stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'') +
  ' on type::sc_khb_srv.' + type_name(major_id) + ' to ' + user_name(grantee_principal_id) + ';' "권한 부여 쿼리"
, 'revoke ' + 
  stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'') +
  ' on type::sc_khb_srv.' + type_name(major_id) + ' from ' + user_name(grantee_principal_id) + ';' "권한 삭제 쿼리"
  FROM sys.DATABASE_permissions dp
 WHERE class_desc = 'TYPE'
--       AND 
--       user_name(grantee_principal_id) = 'us_khb_adm'
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
  ' to ' + user_name(grantee_principal_id) + ';' "시퀀스 권한 부여 쿼리"
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

SELECT * FROM sc_khb_srv.tb_hsmp_info thi ;
































