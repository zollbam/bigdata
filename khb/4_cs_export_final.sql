/*
작성일: 230906
수정일: 
작성자: 조건영
작성 목적: cs테이블 => txt
*/


--------------------------------------------------------------------insert--------------------------------------------------------------------
-- tb_hsmp_curprc_info
SELECT *
  FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY DANJI_NO, STDDE, AR_NO) row_num
             , CAST(ROW_NUMBER() OVER (ORDER BY DANJI_NO, STDDE, AR_NO) AS nvarchar(max)) + '||' + -- hsmp_curprc_info_pk
               CAST(DANJI_NO AS nvarchar(max)) + '||' + -- hsmp_info_pk
               CAST(STDDE AS nvarchar(max)) + '||' + -- crtr_day
		       CAST(AR_NO AS nvarchar(max)) + '||' + -- area_no 
		       CAST(TRDE_UPLMTPC AS nvarchar(max)) + '||' + -- trde_uplmt_amt
		       CAST(TRDE_LSLPC AS nvarchar(max)) + '||' + -- trde_lwlt_amt
		       CAST(LFSTS_UPLMTPC AS nvarchar(max)) + '||' + -- lfsts_uplmt_amt
		       CAST(LFSTS_LSLPC AS nvarchar(max)) + '||' + -- lfsts_lwlt_amt
		       CAST(GTN_GNRLPC AS nvarchar(max)) + '||' + -- gnrl_grnte_amt
		       CAST(MTHT_GNRLPC AS nvarchar(max)) + '||' + -- gnrl_mtht_amt
		       REFLCT_AT + '||' + -- rflt_yn
		       '' + '||' + -- reg_id
		       '' + '||' + -- reg_dt
		       '' + '||' + -- mdfcn_id
		       '' txt -- mdfcn_dt
		  FROM kmls.dbo.KRI_CURPRC_DANJI_TB
	   ) a
 WHERE row_num <= 500000;

SELECT *
  FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY DANJI_NO, STDDE, AR_NO) row_num
             , CAST(ROW_NUMBER() OVER (ORDER BY DANJI_NO, STDDE, AR_NO) AS nvarchar(max)) + '||' + -- hsmp_curprc_info_pk
               CAST(DANJI_NO AS nvarchar(max)) + '||' + -- hsmp_info_pk
               CAST(STDDE AS nvarchar(max)) + '||' + -- crtr_day
		       CAST(AR_NO AS nvarchar(max)) + '||' + -- area_no 
		       CAST(TRDE_UPLMTPC AS nvarchar(max)) + '||' + -- trde_uplmt_amt
		       CAST(TRDE_LSLPC AS nvarchar(max)) + '||' + -- trde_lwlt_amt
		       CAST(LFSTS_UPLMTPC AS nvarchar(max)) + '||' + -- lfsts_uplmt_amt
		       CAST(LFSTS_LSLPC AS nvarchar(max)) + '||' + -- lfsts_lwlt_amt
		       CAST(GTN_GNRLPC AS nvarchar(max)) + '||' + -- gnrl_grnte_amt
		       CAST(MTHT_GNRLPC AS nvarchar(max)) + '||' + -- gnrl_mtht_amt
		       REFLCT_AT + '||' + -- rflt_yn
		       '' + '||' + -- reg_id
		       '' + '||' + -- reg_dt
		       '' + '||' + -- mdfcn_id
		       '' txt -- mdfcn_dt
		  FROM kmls.dbo.KRI_CURPRC_DANJI_TB
	   ) a
 WHERE row_num > 5500000 AND row_num <= 00000;

SELECT *
  FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY DANJI_NO, STDDE, AR_NO) row_num
             , CAST(ROW_NUMBER() OVER (ORDER BY DANJI_NO, STDDE, AR_NO) AS nvarchar(max)) + '||' + -- hsmp_curprc_info_pk
               CAST(DANJI_NO AS nvarchar(max)) + '||' + -- hsmp_info_pk
               CAST(STDDE AS nvarchar(max)) + '||' + -- crtr_day
		       CAST(AR_NO AS nvarchar(max)) + '||' + -- area_no 
		       CAST(TRDE_UPLMTPC AS nvarchar(max)) + '||' + -- trde_uplmt_amt
		       CAST(TRDE_LSLPC AS nvarchar(max)) + '||' + -- trde_lwlt_amt
		       CAST(LFSTS_UPLMTPC AS nvarchar(max)) + '||' + -- lfsts_uplmt_amt
		       CAST(LFSTS_LSLPC AS nvarchar(max)) + '||' + -- lfsts_lwlt_amt
		       CAST(GTN_GNRLPC AS nvarchar(max)) + '||' + -- gnrl_grnte_amt
		       CAST(MTHT_GNRLPC AS nvarchar(max)) + '||' + -- gnrl_mtht_amt
		       REFLCT_AT + '||' + -- rflt_yn
		       '' + '||' + -- reg_id
		       '' + '||' + -- reg_dt
		       '' + '||' + -- mdfcn_id
		       '' txt -- mdfcn_dt
		  FROM kmls.dbo.KRI_CURPRC_DANJI_TB
	   ) a
 WHERE row_num > 3000000;

/*
1. AR_NO
 => null은 없고 0은 그대로 0으로 두자
2. TRDE_UPLMTPC, TRDE_LSLPC, LFSTS_UPLMTPC, LFSTS_LSLPC, GTN_GNRLPC, MTHT_GNRLPC
 => null은 없고 0은 그대로 0으로 두자
3. REFLCT_AT
 => N과 Y만 존재
4. WHERE row_num > 2000000 한 이유??
 => 한번에 2700000행을 다 복사붙여넣기 시 오버플로우 발생
5. 파일명 cs_hsmp_curprc_info.txt
6. 3개월 치만 받아서 파일로 만들자
*/





-- tb_lrea_mntrng_hsmp_info
select CONVERT(nvarchar(max), row_number() over (order by mber_no, danji_no)) + '||' + -- lrea_mntrng_hsmp_info_pk
       CONVERT(nvarchar(max), MBER_NO) + '||' + -- lrea_office_info_pk
       CONVERT(nvarchar(max), DANJI_NO) + '||' + -- hsmp_info_pk
       MONTR_MBER_STTUS_CD + '||' + -- mntrng_stts_cd
       ''  + '||' + -- reg_id
       ''  + '||' + -- reg_dt
       ''  + '||' + -- mdfcn_id
       '' -- mdfcn_dt
  from kmls.dbo.KRI_MONTR_MBER_TB;

/*
1. 총 14311개 행
2. 파일 명은 cs_lrea_mntrng_hsmp_info.txt

*/

SELECT count(*) FROM kmls.dbo.KRI_MONTR_MBER_TB;


-- tb_lrea_schdl_ntcn_info
/*UNION + with*/
WITH tb_lrea_schdl_ntcn_info_tmp AS
(
SELECT '1' + '||' + -- schdl_se_cd
       B.TAG + '||' +  -- schdl_type_cd
       A.MEMBERID + '||' +  -- lrea_office_info_pk
       CAST(A.[NO] AS nvarchar(max)) + '||' +  -- schdl_se_pk
       CONVERT(VARCHAR(8), CONVERT(DATE, B.SDATE), 112) + '||' +  -- schdl_ntcn_day
	   C.user_id + '||' +  -- reg_id
       CAST(GETDATE() AS nvarchar(max)) + '||' + -- reg_dt
	   C.user_id + '||' + -- mdfcn_id
       CAST(GETDATE() AS nvarchar(max)) txt  -- mdfcn_dt
  FROM kmls.dbo.TB_BARGAIN A
       INNER JOIN  
       kmls.dbo.TB_SCHEDULE B
               ON A.MEMBERID = B.MEMBERID
              AND A.CONTACTCODE = B.CONTACTCODE
       INNER JOIN
       kmls.dbo.USER_MST C 
               ON A.MemberId = C.mem_no
 WHERE A.OPTION7 <> 'T'
   AND C.master_yn = 'Y'
   AND ISDATE(B.SDATE) = 1
   AND B.TAG IN ('M','M1','L','E','S','S1') -- S, S1은 합쳐서 신고마감으로 봅니다!!
   AND EXISTS(
              SELECT 'Y'
                FROM TB_BARGAIN_HIS_NEW.TB_BARGAIN_HIS_NEW  H
               WHERE H.CONTACTCODE = A.CONTACTCODE
                 AND H.REGDATE > CONVERT(DATE, GETDATE()-2)
             )
UNION
SELECT '2' + '||' +  -- schdl_se_cd 
       'T' + '||' +  -- schdl_type_cd
       CAST(a.mem_no AS nvarchar(max)) + '||' +  -- lrea_office_info_pk
       CAST(a.mm_no AS nvarchar(max)) + '||' + -- schdl_se_pk
       CONVERT(VARCHAR(8), CONVERT(DATE, a.expire_date), 112) + '||' +  -- schdl_ntcn_day
	   um.user_id + '||' + -- reg_id
       CAST(GETDATE() AS nvarchar(max)) + '||' + -- reg_dt
	   um.user_id + '||' +  -- mdfcn_id
       CAST(GETDATE() AS nvarchar(max)) txt -- mdfcn_dt
  FROM kmls.dbo.MAMUL a
       INNER JOIN
       kmls.dbo.USER_MST um
               ON a.mem_no = um.mem_no
 WHERE ISDATE(a.expire_date) = 1
   AND um.master_yn = 'Y'
   AND a.edit_date > CONVERT(DATE, GETDATE()-2)
UNION
SELECT '3' + '||' +  -- schdl_se_cd
       'C' + '||' +  -- schdl_type_cd
       CAST(a.mem_no AS nvarchar(max)) + '||' +  -- lrea_office_info_pk
       CAST(a.cust_no AS nvarchar(max)) + '||' + -- schdl_se_pk
       CONVERT(VARCHAR(8), CONVERT(DATE, a.rsrvdate), 112) + '||' +  -- schdl_ntcn_day
	   um.user_id + '||' + -- reg_id
       CAST(GETDATE() AS nvarchar(max)) + '||' + -- reg_dt
	   um.user_id + '||' +  -- mdfcn_id
       CAST(GETDATE() AS nvarchar(max)) txt -- mdfcn_dt
  FROM kmls.dbo.custom a
       INNER JOIN
       kmls.dbo.USER_MST um
               ON a.mem_no = um.mem_no
 WHERE ISDATE(a.rsrvdate) = 1
   AND a.UPDATE_DATE > CONVERT(VARCHAR, CONVERT(DATE,  GETDATE()-2), 112)
UNION
SELECT '4' + '||' +  -- schdl_se_cd
       'G' + '||' +  -- schdl_type_cd
       CAST(a.mem_no AS nvarchar(max)) + '||' +  -- lrea_office_info_pk
       CAST(a.ino AS nvarchar(max)) + '||' + -- schdl_se_pk
       CONVERT(VARCHAR(8), CONVERT(DATE, a.vdate), 112) + '||' +  -- schdl_ntcn_day
	   um.user_id + '||' + -- reg_id
       CAST(GETDATE() AS nvarchar(max)) + '||' + -- reg_dt
	   um.user_id + '||' +  -- mdfcn_id
       CAST(GETDATE() AS nvarchar(max)) txt -- mdfcn_dt
  FROM kmls.dbo.IlBan a
       INNER JOIN
       kmls.dbo.USER_MST um
               ON a.mem_no = um.mem_no
 WHERE ISDATE(a.vdate) = 1
   AND a.REGDATE > CONVERT(VARCHAR, CONVERT(DATE,  GETDATE()-2), 112)
)
SELECT CONVERT(nvarchar(max), ROW_NUMBER() OVER (ORDER BY txt)) + '||' +
       txt
  FROM tb_lrea_schdl_ntcn_info_tmp;
 
/*
1. 파일명은 cs_lrea_schdl_ntcn_info.txt
*/



----------------------------------update----------------------------------
-- tb_atlfsl_bsc_info => bsc_update.txt
SELECT CASE WHEN isnull(mm_no, '') = '' THEN ''
            ELSE CONVERT(varchar(100), CONVERT(decimal, mm_no))
        END + '||' +  -- asoc_atlfsl_no
       CASE WHEN isnull(chu_yn, '') = '' THEN '' 
            ELSE chu_yn
        END + '||' + -- rcmdtn_yn
       CASE WHEN isnull(kyungmae_yn, '') = '' THEN '' 
            ELSE kyungmae_yn
        END + '||' + -- auc_yn
       CASE WHEN isnull(state_cd, '') = '' THEN '' 
            ELSE state_cd
        END + '||' + -- atlfsl_stts_cd
       CASE WHEN isnull(confirm_yn, '') = '' THEN '' 
            ELSE confirm_yn
        END + '||' + -- atlfsl_vrfc_yn
       CASE WHEN isnull(confirm_date, '') = '' THEN '' 
            ELSE CAST(confirm_date AS nvarchar(max))
        END + '||' + -- atlfsl_vrfc_day
       CASE WHEN isnull(toji_meter, '') = '' or toji_meter = 0 THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(19,9), toji_meter), 3)
        END + '||' + -- land_area
       CASE WHEN isnull(jibun_meter, '') = '' or jibun_meter = 0 THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(19,9), jibun_meter), 3)
        END + '||' + -- qota_area
       CASE WHEN isnull(use_confirm_day, '') = '' THEN ''
            ELSE use_confirm_day 
        END + '||' + -- use_inspct_day
       CASE WHEN isnull(building_use_cd, '') = '' THEN ''
            ELSE building_use_cd
        END + '||' + -- bldg_usg_cd
       CASE WHEN isnull(setak_cd, '') = '' THEN ''
            ELSE setak_cd
        END + '||' + -- lndr_se_cd
       CASE WHEN isnull(jubang_cd, '') = '' THEN ''
            ELSE jubang_cd
        END + '||' + -- ktchn_se_cd
       CASE WHEN isnull(yoksil_cd, '') = '' THEN ''
            ELSE yoksil_cd
        END + '||' + -- btr_se_cd
       CASE WHEN isnull(balcony_ext_yn, '') = '' THEN ''
            ELSE balcony_ext_yn
        END + '||' + -- blcn_estn_yn
       CASE WHEN isnull([power], '') = '' OR [power] = 0 THEN ''
            ELSE CAST([power] AS nvarchar(max))
        END + '||' + -- power_vl
       CASE WHEN isnull(room1_cnt, '') = '' or room1_cnt = 0 THEN ''
            ELSE CAST(room1_cnt AS nvarchar(max))
        END + '||' + -- room_one_cnt
       CASE WHEN isnull(room2_cnt, '') = '' or  room1_cnt = 0 THEN ''
            ELSE CAST(room2_cnt AS nvarchar(max))
        END + '||' + -- room_two_cnt
       CASE WHEN isnull(room3_cnt, '') = '' or room1_cnt = 0 THEN ''
            ELSE CAST(room3_cnt AS nvarchar(max))
        END + '||' + -- room_three_cnt
       CASE WHEN isnull(room4_cnt, '') = '' or room1_cnt = 0 THEN ''
            ELSE CAST(room4_cnt AS nvarchar(max))
        END -- room_four_cnt 
  FROM KMLS.dbo.mamul
 WHERE mm_no != 0;

/*
1. 총 개수는 6716378 행 => 245599 행
2. 파일명은 bsc_update.txt
3. 
*/





-- tb_atlfsl_dlng_info
SELECT CONVERT(nvarchar(max), mm_no) + '||' + -- atlfsl_dlng_info_pk
       CASE WHEN CONVERT(NUMERIC(18), replace(managefee_info,',','')) = 0 THEN ''
            ELSE CONVERT(nvarchar(max), CONVERT(NUMERIC(18), replace(managefee_info,',','')))
        END "asoc_atlfsl_no||mng_amt" -- mng_amt
  FROM KMLS.dbo.MAMUL
 WHERE isnumeric(managefee_info) = 1;

/*
1. 행 개수: 109180행 => 210?????
2. 파일 이름: dlng_update.txt
*/





-- tb_com_user(02, 공인중개사) => user_update.txt
SELECT CAST(mem_no AS nvarchar(max)) + '||' +  -- user_no_pk
       user_id txt -- user_id
  FROM KMLS.dbo.USER_MST 
 WHERE master_yn = 'Y' 
   AND user_no != 179951
 ORDER BY 1;

/*
1. 총 203580

*/


-- tb_lrea_office_info => lrea_update.txt
SELECT CAST(m.mem_no AS nvarchar(max)) + '||' + -- lrea_office_info_pk
       CASE WHEN m.email IS NULL THEN ''
            ELSE m.email
        END  + '||' + -- eml
       CASE WHEN m.jumin_no IS NULL THEN ''
            ELSE m.jumin_no 
        END  + '||' + -- lrea_grd_cd
       CASE WHEN m.comp_reg_no IS NULL THEN ''
            ELSE m.comp_reg_no 
        END -- estbl_reg_no
  FROM KMLS.dbo.[MEMBER] m
       LEFT JOIN 
       KMLS.dbo.KRI_MONTR_MBER_TB kmmt
               ON m.mem_no = kmmt.MBER_NO
 WHERE mem_no != 1540192;  -- jumin_no가 진짜 주민 번호로 되어 있다.

/*
1. 총 209741행
2. 폴더 생성후 "문자 삭제 해주어야함 
*/
