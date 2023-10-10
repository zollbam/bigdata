/*
작성일: 231007
수정일: 
작성자: 조건영
작성 목적: kmls와 한방app쪽 com_code 테이블의 sort_ord 비교
*/

-------------------------------- ↓소분류↓ --------------------------------

-- kmls vs app
SELECT cc.grp_cd
     , tcc.parnts_code
     , tcc.code
     , tcc.code_nm
     , cc.sort_ord "kmls_sort_ord"
     , tcc.sort_ordr "app_sort_ord"
  FROM KMLS.dbo.COM_CODE cc
       INNER JOIN 
       sc_khb_srv.tb_com_code tcc
               ON 'H' + cc.grp_cd = tcc.parnts_code
              AND cc.item_cd = tcc.code
              AND cc.grp_cd <> '000';





-- kmls vs app vs 기존app
SELECT cc.grp_cd
     , tcc.parnts_code
     , tcc.code
     , tcc.code_nm
     , cc.sort_ord "kmls_sort_ord"
     , tcc.sort_ordr "app_sort_ord"
     , cc2.CODE_VAL "hanbang_sort_ord"
  FROM KMLS.dbo.COM_CODE cc
       INNER JOIN 
       sc_khb_srv.tb_com_code tcc
               ON 'H' + cc.grp_cd = tcc.parnts_code
              AND cc.item_cd = tcc.code
              AND cc.grp_cd <> '000'
       INNER JOIN
       hanbang.hanbang.com_code cc2
               ON cc2.GUBUN + cc2.GRD_CD = tcc.parnts_code
              AND cc2.GRD_CD <> '000'
              AND cc2.CODE = tcc.code;

/*
 * 1. kmls vs app
 *  - 소분류만 비교 했을 때 1020개
 * 
 * 2. kmls vs app vs 기존app
 *  - 소분류만 비교 했을 때 1017개
 *  - 전대차계약서와 813코드 2개 추가
 *  - maria에는 추가된 코드가 없기 때문에 3개가 빠진 상태로 쿼리결과 추출
*/


-- sort_ord의 update
UPDATE sc_khb_srv.tb_com_code
   SET sort_ordr = cc.sort_ord
  FROM KMLS.dbo.COM_CODE cc
 WHERE cc.grp_cd <> '000'
   AND LEFT(sc_khb_srv.tb_com_code.parnts_code, 1) = 'H'
   AND sc_khb_srv.tb_com_code.code_pk <> sc_khb_srv.tb_com_code.parnts_code_pk
   AND RIGHT(sc_khb_srv.tb_com_code.parnts_code, 3) = cc.grp_cd
   AND sc_khb_srv.tb_com_code.code = cc.item_cd;




-- update 후 sort_ord 비교(kmls vs app)
SELECT cc.grp_cd
     , tcc.parnts_code
     , tcc.code
     , tcc.code_nm
     , cc.sort_ord "kmls_sort_ord"
     , tcc.sort_ordr "app_sort_ord"
  FROM KMLS.dbo.COM_CODE cc
       INNER JOIN 
       sc_khb_srv.tb_com_code tcc
               ON 'H' + cc.grp_cd = tcc.parnts_code
              AND cc.item_cd = tcc.code
              AND cc.grp_cd <> '000'
 WHERE cc.sort_ord <> tcc.sort_ordr;

/*
 * 1. 비교 결과 모두 동일하다고 나온다!!
*/


-------------------------------- ↓대분류↓ --------------------------------

-- kmls vs app
SELECT cc.grp_cd
     , tcc.parnts_code
     , tcc.code
     , tcc.code_nm
     , cc.sort_ord "kmls_sort_ord"
     , tcc.sort_ordr "app_sort_ord"
  FROM KMLS.dbo.COM_CODE cc
       INNER JOIN 
       sc_khb_srv.tb_com_code tcc
               ON 'H' + cc.item_cd = tcc.parnts_code
              AND tcc.code_pk = tcc.parnts_code_pk
              AND cc.grp_cd = '000';


-- kmls vs app vs 기존app
SELECT cc.grp_cd
     , tcc.parnts_code
     , tcc.code
     , tcc.code_nm
     , cc.sort_ord "kmls_sort_ord"
     , tcc.sort_ordr "app_sort_ord"
     , cc2.CODE_VAL "hanbang_sort_ord"
  FROM KMLS.dbo.COM_CODE cc
       INNER JOIN 
       sc_khb_srv.tb_com_code tcc
               ON 'H' + cc.item_cd = tcc.parnts_code
              AND tcc.code_pk = tcc.parnts_code_pk
              AND cc.grp_cd = '000'
       INNER JOIN
       hanbang.hanbang.com_code cc2
               ON cc2.GUBUN + cc2.code = tcc.parnts_code
              AND cc2.GRD_CD = '000';

/*
 * 1. kmls vs app
 *  - kmls의 대분류는 64개
 *  - app의 대분류는 5개 추가된 69개
 * 
 * 2. kmls vs app vs 기존app
 *  - kmls의 대분류는 64개
 *  - app의 대분류는 5개 추가된 69개
 *  - 기존app의 대분류는 kmls와 같은 64개
*/




-- sort_ord의 update
UPDATE sc_khb_srv.tb_com_code
   SET sort_ordr = cc.sort_ord
  FROM KMLS.dbo.COM_CODE cc
 WHERE cc.grp_cd = '000'
   AND sc_khb_srv.tb_com_code.code_pk = sc_khb_srv.tb_com_code.parnts_code_pk
   AND sc_khb_srv.tb_com_code.parnts_code LIKE 'H%'
   AND RIGHT(sc_khb_srv.tb_com_code.code, 3) = cc.item_cd;
   AND sc_khb_srv.tb_com_code.code = cc.item_cd;




-- update 후 sort_ord 비교(kmls vs app)
SELECT cc.grp_cd
     , tcc.parnts_code
     , tcc.code
     , tcc.code_nm
     , cc.sort_ord "kmls_sort_ord"
     , tcc.sort_ordr "app_sort_ord"
  FROM KMLS.dbo.COM_CODE cc
       INNER JOIN 
       sc_khb_srv.tb_com_code tcc
               ON 'H' + cc.item_cd = tcc.parnts_code
              AND tcc.code_pk = tcc.parnts_code_pk
              AND cc.grp_cd = '000'
 WHERE cc.sort_ord <> tcc.sort_ordr;

/*
 * 1. 비교 결과 모두 동일하다고 나온다!!
*/












