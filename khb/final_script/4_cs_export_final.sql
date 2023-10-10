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
             , CAST(ROW_NUMBER() OVER (ORDER BY DANJI_NO, STDDE
             , AR_NO) AS nvarchar(max)) + '||' + -- hsmp_curprc_info_pk
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
SELECT *
  FROM (
SELECT ROW_NUMBER() OVER (ORDER BY mm_no) row_num
     , CASE WHEN isnull(mm_no, '') = '' THEN ''
            ELSE CONVERT(varchar(100), CONVERT(decimal, mm_no))
        END  + '||' +  -- asoc_atlfsl_no
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
            -- convert(nvarchar(max), confirm_date, 112)
        END + '||' + -- atlfsl_vrfc_day
       CASE WHEN isnull(toji_meter, '') = '' OR toji_meter > 10000000000  THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(19,9), toji_meter), 3)
        END + '||' + -- land_area
       CASE WHEN isnull(jibun_meter, '') = '' OR jibun_meter > 10000000000  THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(19,9), jibun_meter), 3)
        END + '||' +   -- qota_area
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
       CASE WHEN isnull([power], '') = '' OR [power] > 10000000000 THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(25,5), [power]), 3)
        END + '||' + -- power_vl
       CASE WHEN isnull(room1_cnt, '') = '' OR room1_cnt > 1000000000000000 THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(18,3), room1_cnt), 3)
        END + '||' + -- room_one_cnt
       CASE WHEN isnull(room2_cnt, '') = '' OR room2_cnt > 1000000000000000 THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(18,3), room2_cnt), 3)
        END + '||' + -- room_two_cnt
       CASE WHEN isnull(room3_cnt, '') = '' OR room3_cnt > 1000000000000000 THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(18,3), room3_cnt), 3)
        END + '||' + -- room_three_cnt
       CASE WHEN isnull(room4_cnt, '') = '' OR room4_cnt > 1000000000000000 THEN ''
            ELSE CONVERT(varchar(max), CONVERT(decimal(18,3), room4_cnt), 3)
        END + '||' + -- room_four_cnt 
       CASE WHEN isnull(expenses_item_info, '') = '' THEN ''
            ELSE expenses_item_info
        END + '||' + -- expitm_nm
       CASE WHEN isnull(elevator_yn, '') = '' THEN ''
            ELSE elevator_yn
        END + '||' + -- elvtr_yn
	   CASE WHEN isnull(direction_info, '') = '' THEN ''
	        ELSE direction_info
		END + '||' + -- drc_crtr_nm
	   CASE WHEN isnull(curr_upjong, '') = '' THEN ''
	        ELSE curr_upjong
		END + '||' + -- now_tpbiz_nm
	   CASE WHEN isnull(recommend_use1, '') = '' THEN ''
		    ELSE recommend_use1
		END + '||' + -- rcmdtn_usg_one_nm
	   CASE WHEN isnull(recommend_use2, '') = '' THEN ''
		    ELSE recommend_use2
		END + '||' + -- rcmdtn_usg_two_nm
	   CASE WHEN isnull(house_meter, '') = '' or house_meter > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), house_meter), 3)
		END + '||' + -- house_area
	   CASE WHEN isnull(house_pyung, '') = '' or house_pyung > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), house_pyung), 3)
		END + '||' + -- house_area_pyeong
	   CASE WHEN isnull(sangga_meter, '') = '' or sangga_meter > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), sangga_meter), 3)
	    END + '||' + -- sopsrt_area
	   CASE WHEN isnull(sangga_pyung, '') = '' or sangga_pyung > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), sangga_pyung), 3)
		END + '||' + -- sopsrt_area_pyeong
	   CASE WHEN isnull(office_meter, '') = '' or office_meter > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), office_meter), 3)
		END + '||' + -- ofc_area
	   CASE WHEN isnull(office_pyung, '') = '' or office_pyung > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), office_pyung), 3)
		END + '||' + -- ofc_area_pyeong
	   CASE WHEN isnull(sell_cd, '') = '' THEN ''
		    ELSE sell_cd
		END + '||' + -- sale_se_cd
	   CASE WHEN isnull(floor_high, '') = '' or floor_high > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(25, 15), floor_high), 3)
		END + '||' + -- flr_hg_vl
	   CASE WHEN isnull(road_meter, '') = '' or road_meter > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(25, 15), road_meter), 3)
		END + '||' + -- nearby_road_vl
	   CASE WHEN isnull(build_use_cd, '') = '' THEN ''
		    ELSE build_use_cd
		END + '||' + -- bdst_usg_cd
	   CASE WHEN isnull(biz_step_cd, '') = '' THEN ''
		    ELSE biz_step_cd
		END + '||' + -- biz_step_cd
	   CASE WHEN isnull(const_company, '') = '' THEN ''
		    ELSE const_company
		END + '||' + -- slctn_bldr_nm
	   CASE WHEN isnull(estimate_meter, '') = '' or estimate_meter > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), estimate_meter), 3)
		END + '||' + -- expect_sply_area
	   CASE WHEN isnull(estimate_pyung, '') = '' or estimate_pyung > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), estimate_pyung), 3)
		END + '||' + -- expect_sply_area_pyeong
	   CASE WHEN isnull(estimate_cnt, '') = '' or round(CONVERT(NUMERIC(21, 3), replace(replace(estimate_cnt,',',''),'\','')), 1) 
                                                   - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(estimate_cnt,',',''),'\','')), 1)) <> 0 
                                               THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), estimate_cnt), 3)
		END + '||' + -- expect_hh_cnt
	   CASE WHEN isnull(zone_meter, '') = '' or zone_meter > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), zone_meter), 3)
		END + '||' + -- zone_tot_area
	   CASE WHEN isnull(zone_pyung, '') = '' or zone_pyung > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), zone_pyung), 3)
		END + '||' + -- zone_tot_area_pyeong
	   CASE WHEN isnull(yongjuk_rate, '') = '' or yongjuk_rate > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), yongjuk_rate), 3)
		END + '||' + -- expect_fart
	   CASE WHEN isnull(gunpe_rate, '') = '' or gunpe_rate > 10000000000 THEN ''
		    ELSE CONVERT(nvarchar(max), CONVERT(decimal(19, 9), gunpe_rate), 3)
		END + '||' + -- btl_rt
	   CASE WHEN isnull(rentalhouse_apply_yn, '') = '' THEN ''
		    ELSE rentalhouse_apply_yn
		END + '||' + -- reg_rentbzmn_yn
	   CASE WHEN officetel_use_cd <> '' THEN officetel_use_cd -- 오피스텔용도(G140)
            WHEN building_cate_cd <> '' THEN building_cate_cd -- 건물종류(재개발)(G340)
            WHEN building_use_cd <> '' THEN building_use_cd -- 건물주용도(G520)
            WHEN store_use_cd <> '' THEN store_use_cd -- 주용도_상가점포(G550)
            WHEN office_use_cd <> '' THEN office_use_cd -- 주용도_사무실(G560)
            else '' 
		END + '||' + -- atlfsl_usg_cd
	   CASE WHEN gunrak_cd <> '' THEN gunrak_cd -- 군락형태(G320)
		    WHEN sangga_cd <> '' THEN sangga_cd -- 상가구분(G350)
		    WHEN sukbak_cate_cd <> '' THEN sukbak_cate_cd -- 숙박물건종류(G400)
            WHEN factory_type_cd <> '' THEN factory_type_cd -- 공장형태(G420)
            WHEN factory_cate <> '' THEN factory_cate -- 공장종류
            WHEN saleType <> '' THEN saleType -- 분양구분
--            WHEN warehouse_type_cd <> '' THEN warehouse_type_cd
--            WHEN building_type_cd <> '' THEN building_type_cd
            ELSE ''
        END + '||' + -- atlfsl_se_cd
       CASE WHEN sukbak_ipji_cd <> '' THEN sukbak_ipji_cd -- 숙박입지(G410)
            WHEN factory_ipji_cd <> '' THEN factory_ipji_cd -- 공장입지(G440)
            WHEN office_ipji_cd <> '' THEN office_ipji_cd -- 사무실입지(G570)
            WHEN sangga_ipji_cd <> '' THEN sangga_ipji_cd -- 상가입지(G580)
            ELSE ''
        END + '||' + -- atlfsl_lct_cd
       CASE WHEN room_cd <> '' THEN room_cd -- 방구조(G250)
	        WHEN const_struc_cd <> '' THEN const_struc_cd -- 건축구조(공장)(G450)
            ELSE ''
        END txt -- atlfsl_strct_cd
  FROM KMLS.dbo.mamul
 WHERE mm_no !=0
       ) a
 WHERE row_num <= 1000000; --AND row_num > 6000000;





-- tb_atlfsl_dlng_info => 
SELECT *
  FROM (
SELECT ROW_NUMBER() OVER (ORDER BY mm_no) row_num
     , CASE WHEN mm_no IS NULL THEN ''
            ELSE CONVERT(nvarchar(max), mm_no) 
        END + '||' + -- asoc_atlfsl_no
       CASE WHEN isnumeric(managefee_info) = 1 
             AND round(CONVERT(NUMERIC(21, 3), replace(replace(managefee_info,',',''),'\','')), 1) 
                  - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(managefee_info,',',''),'\','')), 1)) = 0 
                 THEN CONVERT(nvarchar(max), CONVERT(NUMERIC(18), replace(replace(managefee_info,',',''),'\','')))
            ELSE ''
        END + '||' + -- mng_amt
       CASE WHEN amt_sisul IS NULL THEN ''
            ELSE CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_sisul, 3)) 
        END + '||' + -- fclt_amt
       CASE WHEN amt_pay IS NULL THEN ''
            ELSE CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_pay, 3)) 
        END + '||' + -- pay_amt
       CASE WHEN mid_gbn IS NULL THEN ''
            ELSE mid_gbn 
        END + '||' + -- mdstrm_amt_int_se_cd
       CASE WHEN amt_real_invest IS NULL THEN ''
            ELSE CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_real_invest, 3)) 
        END + '||' + -- rl_invt_amt
       CASE WHEN amt_move_free IS NULL THEN ''
            ELSE CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_move_free, 3)) 
        END + '||' + -- nintr_moving_amt
       CASE WHEN amt_move_nofree IS NULL THEN ''
            ELSE CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_move_nofree, 3)) 
        END "update_dlng" -- int_moving_amt
  FROM KMLS.dbo.MAMUL
       ) a
 WHERE row_num > 6000000 AND row_num <= 7000000;

/*
1. 행 개수: 6716378 행 => 3170194행
 => 109180행 개수는 20번의 MAMUL에서 isnumeric(managefee_info) = 1일 때 개수
2. 파일 이름: dlng_update.txt
3. managefee_info를 isnumeric(managefee_info)하면 원기호(\)가 있어서 convert오류 발생
4. where 절에는 managefee_info에 소수로 되어 있는 문자열을 찾기 위한 조건
 => NUMERIC(21, 3)하는 이유는 소수점이 있는 실수로 만들기 위해!!
    NUMERIC(18)로 하면 정수가 되기 때문에 실수를 찾을 수 없다.
 => "= 0" 대신에 "<> 0"을 하면 소수자리 23개 존재
*/





-- tb_atlfsl_land_usg_info => land_usg_update.txt, land_usg_update_2.txt
SELECT *
  FROM (
SELECT ROW_NUMBER() OVER (ORDER BY mm_no) row_num
     , CASE WHEN mm_no IS NULL THEN ''
            ELSE CONVERT(nvarchar(max), mm_no) 
        END + '||' + -- asoc_atlfsl_no
       CASE WHEN jimok_cd IS NULL THEN ''
            ELSE jimok_cd
        END + '||' + -- ldcg_cd
       CASE WHEN jimok_gusung IS NULL THEN ''
            ELSE jimok_gusung 
        END + '||' + -- ldcg_nm
       CASE WHEN yong_jiyuk1_cd IS NULL THEN ''
            ELSE yong_jiyuk1_cd 
        END + '||' + -- usg_rgn_one_cd
       CASE WHEN yong_jiyuk2_cd IS NULL THEN ''
            ELSE yong_jiyuk2_cd 
        END + '||' + -- usg_rgn_two_cd
       CASE WHEN curr_use IS NULL THEN ''
            ELSE curr_use 
        END "update_land_usg" -- now_usg_rgn_nm
  FROM KMLS.dbo.MAMUL
       ) a 
 WHERE row_num > 5000000 AND row_num <= 7000000;

/*
1. 행 개수: 6716378 행 
2. mm_no를 제외한 나머지 열은 문자열이라 변환 필요성 X
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
