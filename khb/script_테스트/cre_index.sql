/*
작성일: 231006
수정일: 
작성자: 조건영
작성 목적: 매물목록조회 index생성을 위한 성능 비교
*/

/* selectAtlfslList - 매물목록조회 */
WITH atlfslList AS (
    SELECT	a.atlfsl_bsc_info_pk AS atlfslBscInfoPk		 	 /* 매물기본정보PK */
		 ,	a.asoc_atlfsl_no AS asocAtlfslNo				 /* 협회매물번호 */
		 ,	a.asoc_app_intrlck_no AS asocAppIntrlckNo		 /* 협회앱연동번호 */
		 ,	a.lrea_office_info_pk AS lreaOfficeInfoPk		 /* 공인중개사사무실정보PK */
		 ,	a.ctpv_cd_pk AS ctpvCdPk 						 /* 시도코드PK */
		 ,	a.sgg_cd_pk AS sggCdPk							 /* 시군구코드PK */
		 ,	a.emd_li_cd_pk AS emdLiCdPk						 /* 읍면동리스트코드PK */
		 ,	a.hsmp_info_pk AS hsmpInfoPk					 /* 단지정보PK */
		 ,	a.hsmp_dtl_info_pk AS hsmpDtlInfoPk				 /* 단지상세정보PK */
		 ,	a.atlfsl_ty_cd AS atlfslTyCd					 /* 매물타입코드 */
		 ,	a.atlfsl_knd_cd AS atlfslKndCd					 /* 매물종류코드 */
		 ,	a.stdg_innb AS stdgInnb							 /* 법정동고유번호 */
		 ,	a.dong_innb AS dongInnb							 /* 동고유번호 */
		 ,	a.mno AS mno									 /* 본번 */
		 ,	a.sno AS sno									 /* 부번 */
		 ,	a.aptcmpl_nm AS aptcmplNm						 /* 아파트동명 */
		 ,	a.ho_nm  AS hoNm								 /* 아파트호명 */
		 ,	a.atlfsl_crdnt AS atlfslCrdnt 					 /* 매물좌표 */
		 ,	a.atlfsl_lot AS atlfslLot 						 /* 매물경도 */
		 ,	a.atlfsl_lat AS atlfslLat 					 	 /* 매물위도 */
		 ,	a.bldg_aptcmpl_indct_yn AS bldgAptcmplIndctYn	 /* 건물동표시여부 */
		 ,	a.pyeong_indct_yn AS pyeongIndctYn 				 /* 평표시여부 */
		 ,	a.vr_exst_yn AS vrExstYn 						 /* VR존재여부 */
		 ,	a.img_exst_yn AS imgExstYn 						 /* 이미지존재여부 */
		 ,	a.prvuse_area AS prvuseArea 					 /* 전용면적 */
		 ,	a.sply_area AS splyArea							 /* 공급면적 */
		 ,	a.plot_area AS plotArea							 /* 대지면적 */
		 ,	a.arch_area AS archArea							 /* 건축면적 */
		 ,	a.room_cnt AS roomCnt							 /* 방수 */
		 ,	a.atlfsl_inq_cnt AS atlfslInqCnt				 /* 매물조회수 */ 
		 ,	a.flr_cnt AS flrCnt							 	 /* 현재층수 */
		 ,	ISNULL(a.top_flr_cnt, 0) AS topFlrCnt	 		 /* 최고층수 */
		 ,	ISNULL(a.flr_cnt, 0) AS grndFlrCnt			 	 /* 지상층수 */ 
		 ,	a.udgd_flr_cnt AS udgdFlrCnt					 /* 지하층수 */
		 ,  (CASE WHEN a.flr_cnt = 0 THEN ''
				 WHEN a.flr_cnt  <  CEILING(a.top_flr_cnt) * 0.33 THEN '저층'
				 WHEN a.flr_cnt  <  CEILING(a.top_flr_cnt) * 0.67 THEN '중층'
				 ELSE '고층' 
			END) AS floorCategory							 /* 층수 */
		 ,	a.drc_cd AS drcCd					 			 /* 방향코드 */
		 ,	a.rcmdtn_yn AS rcmdtnYn 						 /* 추천여부 */
		 ,	a.auc_yn AS aucYn								 /* 경매여부 */
		 ,	a.atlfsl_stts_cd AS atlfslSttsCd				 /* 매물상태코드 */
		 ,	a.atlfsl_vrfc_yn AS atlfslVrfcYn				 /* 매물검증여부 */
		 ,	a.pstn_expln_cn AS pstnExplnCn					 /* 위치설명내용 */
		 ,	CONVERT(CHAR(10), a.atlfsl_vrfc_day, 102) AS atlfslVrfcDayStr /* 검증매물등록일 */
		 ,	a.cmcn_day AS cmcnDay							 /* 준공일 */
		 ,  a.totar AS totar								 /* 연면적 */
		 ,	a.use_yn AS useYn								 /* 사용여부 */
		 ,	a.reg_dt AS regDt								 /* 등록일자 */
		 ,	b.dlng_se_cd AS dlngSeCd						 /* 거래구분코드 */
		 ,	(CASE b.dlng_se_cd
				 WHEN 'A1' THEN '매매'
				 WHEN 'B1' THEN '전세'
				 WHEN 'B2' THEN '월세'
				 WHEN 'B3' THEN '연세'
			 END)  AS dlngSeNm                     		     /* 거래구분명 */
		 ,	b.trde_amt AS trdeAmt							 /* 매매금액 */
		 ,	b.lfsts_amt AS lfstsAmt							 /* 전세금액 */
		 ,	b.mtht_amt AS mthtAmt							 /* 월세금액 */
		 ,	b.mng_amt AS mngAmt 							 /* 관리금액 */
		  ,	d.lrea_office_nm AS lreaOfficeNm				 /* 공인중개사사무소명 */
		 ,	d.lrea_office_rprsv_nm AS lreaOfficeRprsvNm 	 /* 공인중개사사무소대표자명*/
		 ,	d.lrea_office_rprs_telno AS lreaOfficeRprsTelno	 /* 공인중개사사무소대표전화번호 */
		 ,  d.lrea_telno AS lreaTelno						 /* 공인중개사전화번호 */
		 ,	d.lrea_office_addr AS lreaOfficeAddr			 /* 공인중개사사무소주소 */
		 ,	d.stts_cd AS sttsCd 							 /* 상태_코드 */
		 ,	CONVERT(CHAR(10), b.reg_dt, 102) AS regDtStr	 /* 일반매물등록일 */
		 ,	c.hsmp_nm AS hsmpNm								 /* 단지명 */
		 ,  (SELECT ctpv_nm 
		       FROM sc_khb_srv.tb_com_ctpv_cd 
		      WHERE ctpv_cd_pk = a.ctpv_cd_pk) AS ctpvNm	 /* 시도명 */
		 ,  (SELECT sgg_nm 
		       FROM sc_khb_srv.tb_com_sgg_cd 
		      WHERE sgg_cd_pk = a.sgg_cd_pk) AS sggNm		 /* 시군구명 */
		 ,  (SELECT emd_li_nm 
		       FROM sc_khb_srv.tb_com_emd_li_cd 
		      WHERE emd_li_cd_pk = a.emd_li_cd_pk) AS emdLiNm/* 읍면리명 */
		 ,	(SELECT ctrt_area 
		       FROM sc_khb_srv.tb_hsmp_dtl_info 
		      WHERE hsmp_info_pk = c.hsmp_info_pk 
		        AND hsmp_dtl_info_pk = a.hsmp_dtl_info_pk) AS ctrtArea /* 계약면적 */
		 ,	(SELECT TOP 1 img_url 
		       FROM sc_khb_srv.tb_atlfsl_img_info 
		      WHERE atlfsl_bsc_info_pk = a.atlfsl_bsc_info_pk) AS imgUrl/* 이미지URL */
		 ,	(SELECT TOP 1 img_ty_cd 
		       FROM sc_khb_srv.tb_atlfsl_img_info 
		      WHERE atlfsl_bsc_info_pk = a.atlfsl_bsc_info_pk) AS imgTyCd/* I:이미지, V:VR */
		 ,	(SELECT atlfsl_sfe_expln_cn 
		       FROM sc_khb_srv.tb_atlfsl_etc_info 
		      WHERE atlfsl_bsc_info_pk = a.atlfsl_bsc_info_pk) AS atlfslSfeExplnCn/* 매물특징 */
  FROM db_khb_srv.sc_khb_srv.tb_atlfsl_bsc_info a
	   INNER JOIN 
	   db_khb_srv.sc_khb_srv.tb_atlfsl_dlng_info b 
	           ON a.atlfsl_bsc_info_pk = b.atlfsl_bsc_info_pk
	   LEFT JOIN 
	   db_khb_srv.sc_khb_srv.tb_hsmp_info c 
	           ON a.hsmp_info_pk = c.hsmp_info_pk
	   LEFT JOIN 
	   db_khb_srv.sc_khb_srv.tb_lrea_office_info d 
	           ON a.lrea_office_info_pk = d.lrea_office_info_pk
	   LEFT JOIN 
	   db_khb_srv.sc_khb_srv.tb_atlfsl_cfr_fclt_info e
	           ON a.atlfsl_bsc_info_pk = e.atlfsl_bsc_info_pk
 WHERE 1 = 1
   AND a.use_yn = 'Y'
   AND d.stts_cd IN ('H01', 'H70')
)
SELECT	*
  FROM	atlfslList;
 WHERE	1=1
 ORDER 	BY regDt DESC
OFFSET	(1-1) * 10 ROWS FETCH NEXT 10 ROWS ONLY;

/*
 1. 인덱스 설정 전 => 13~14초대
 2. 인덱스 설정 후 => 11~12초대
 3. 하지만 where ~ offset부분이 없으면 35초가 1초대로 성능 개선!!
*/

DBCC FREEPROCCACHE;


-- 인덱스 설정
/*
신청 테이블
 - 매물 주변 시설 정보 테이블(tb_atlfsl_cfr_fclt_info)
 - 매물 거래 정보 테이블(tb_atlfsl_dlng_info)
 - 매물 기타 정보 테이블(tb_atlfsl_etc_info)
 - 매물 이미지 정보 테이블(tb_atlfsl_img_info)
*/

CREATE NONCLUSTERED INDEX ni_tb_atlfsl_cfr_fclt_info_01 ON sc_khb_srv.tb_atlfsl_cfr_fclt_info(atlfsl_bsc_info_pk);
CREATE NONCLUSTERED INDEX ni_tb_atlfsl_dlng_info_01 ON sc_khb_srv.tb_atlfsl_dlng_info(atlfsl_bsc_info_pk);
CREATE NONCLUSTERED INDEX ni_tb_atlfsl_etc_info_01 ON sc_khb_srv.tb_atlfsl_etc_info(atlfsl_bsc_info_pk);
CREATE NONCLUSTERED INDEX ni_tb_atlfsl_img_info_01 ON sc_khb_srv.tb_atlfsl_img_info(atlfsl_bsc_info_pk);


-- 인덱스 삭제
DROP INDEX ni_tb_atlfsl_cfr_fclt_info_01 ON sc_khb_srv.tb_atlfsl_cfr_fclt_info;
DROP INDEX ni_tb_atlfsl_dlng_info_01 ON sc_khb_srv.tb_atlfsl_dlng_info;
DROP INDEX ni_tb_atlfsl_etc_info_01 ON sc_khb_srv.tb_atlfsl_etc_info;
DROP INDEX ni_tb_atlfsl_img_info_01 ON sc_khb_srv.tb_atlfsl_img_info;






















