/*
작성일: 231006
수정일: 
작성자: 조건영
작성 목적: kmls와 한방app쪽 매칭 열 비교
*/

-- kmls과 app 매칭 테이블 비교

/*tb_atlfsl_bsc_info*/

/* 1.mno
 *  - 569개의 데이터가 다르다!!!
*/
SELECT m.old_bon_no "kmls", tabi.mno "app"
  FROM KMLS.dbo.MAMUL m
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE m.old_bon_no <> tabi.mno;


/* 2.pic_no
 *  - 180개의 데이터가 다르다!!!
*/
SELECT m.user_no "kmls", tabi.pic_no "app"
  FROM KMLS.dbo.mamul m 
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE m.user_no <> tabi.pic_no;



SELECT mkr.contentNo "kmls", tabi.asoc_app_intrlck_no "app"
  FROM KMLS.dbo.MAMUL_KRENAPP_REAL mkr 
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON mkr.mm_no = tabi.asoc_atlfsl_no
 WHERE mkr.contentNo <> tabi.asoc_app_intrlck_no;


SELECT m.old_bu_no "kmls", tabi.sno "app"
  FROM KMLS.dbo.MAMUL m
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE m.old_bu_no <> tabi.sno;



























