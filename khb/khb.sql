/*
작성일: 230904
수정일:
작성자: 조건영
작성목적: khb테이블들에 대한 이해 
*/



-- tb_atlfsl_batch_hstry
SELECT *
  FROM sc_khb_srv.tb_atlfsl_batch_hstry;

/*이력 구분 코드*/
SELECT DISTINCT hstry_se_cd
  FROM sc_khb_srv.tb_atlfsl_batch_hstry;


/*결과코드*/
SELECT DISTINCT rslt_cd
  FROM sc_khb_srv.tb_atlfsl_batch_hstry;
 
/*
1. 컨텐츠 번호와 매물 기본 정보의 다른점은?
2. 이력 구분 코드는 C와 U뿐
3. 
*/

, , , atlfsl_vrfc_yn, atlfsl_vrfc_day

-- tb_atlfsl_bsc_info
SELECT *
  FROM sc_khb_srv.tb_atlfsl_bsc_info;

/*push 상태코드 0개 X*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_bsc_info
 WHERE push_stts_cd IS NOT NULL;

/*추천여부 0개*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_bsc_info
 WHERE rcmdtn_yn IS NOT NULL;

/*경매여부 0개*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_bsc_info
 WHERE auc_yn IS NOT NULL;

/*매물 상태코드 0개*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_bsc_info
 WHERE atlfsl_stts_cd IS NOT NULL;

/*매물 검증 여부 0개*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_bsc_info
 WHERE atlfsl_vrfc_yn IS NOT NULL;

/*매물 검증 일 0개*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_bsc_info
 WHERE atlfsl_vrfc_day IS NOT NULL;

/*lrea_office_info_pk*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_bsc_info
 WHERE lrea_office_info_pk = 0;

/*
1. 매물 기초 정보 테이블
2. 추천여부, 경매여부, 경매여부, 매물상태코드, 매물검증여부, 매물검증일 => 0개
 => 20번 DB에서 찾아서 데이터를 삽입해야 한다.
3. lrea_office_info_pk가 0인 데이터 존재 => 삭제 해야 pkfk 선 연결 가능
 => 19240046, 19251046, 19251054, 22489121, 26964088, 26996111
*/



-- tb_atlfsl_cfr_fclt_info
SELECT *
  FROM sc_khb_srv.tb_atlfsl_cfr_fclt_info;

/*
1. 냉방_방식 열만 숫자로 되어 있고 나머지 코드 목록은 영어+숫자로 데이터가 구성
2. 
*/



-- tb_atlfsl_dlng_info
SELECT *
  FROM sc_khb_srv.tb_atlfsl_dlng_info;

/*관리금액 0개*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_dlng_info
 WHERE mng_amt IS NOT NULL;

/*20번에서 161번으로 가져오는 방법*/
--SELECT contentNo
--     , mkr.mm_no
--     , tradeType
--     , dealPrice
--     , regAlDepositPrice
--     , regAlRentalPrice
--     , loanPrice
--     , alDepositPrice
--     , alRentalPrice
--     , premPrice
--     , m.reg_date
--     , m.edit_date
--     , m.managefee_info
--  FROM MAMUL_KRENAPP_REAl mkr
--       INNER JOIN
--       mamul m
--               ON mkr.mm_no = m.mm_no
-- ORDER BY mm_no;

/*
1. 냉방_방식 열만 숫자로 되어 있고 나머지 코드 목록은 영어+숫자로 데이터가 구성
2. 관리 금액이 null => 모든 행
 => 관리 금액은 mamul테이블의 managefee_info열에 데이터가 존재
3. 
*/



-- tb_atlfsl_etc_info
SELECT *
  FROM sc_khb_srv.tb_atlfsl_etc_info;

/*입주 가능 이내 개월 수 315개*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_etc_info
 WHERE mvn_psblty_wthn_month_cnt IS NOT NULL;

/*입주 가능 이후 개월 수 1개*/
SELECT *
  FROM sc_khb_srv.tb_atlfsl_etc_info
 WHERE mvn_psblty_aftr_month_cnt IS NOT NULL;

/*
1. 매물 기타 정보 테이블
2. 입주 가능 이후 개월 수에 있는 하나의 값은 202209개월이다.
*/



-- tb_atlfsl_img_info
SELECT *
  FROM sc_khb_srv.tb_atlfsl_img_info;
 
/*이미지 타입*/
SELECT DISTINCT img_ty_cd
  FROM sc_khb_srv.tb_atlfsl_img_info;

/*
1. 매물 이미지 테이블
2. 이미지 타입은 I(일반), V(VR)로 구분
*/



-- tb_atlfsl_inqry_info
SELECT *
  FROM sc_khb_srv.tb_atlfsl_inqry_info;

/*
1. 매물 문의 정보 => 데이터 없음
2. 
*/



-- tb_atlfsl_land_usg_info
SELECT *
  FROM sc_khb_srv.tb_atlfsl_land_usg_info;

/*
1. 매물 문의 정보 => 데이터 없음
2. 국토이용여부, 도시계획여부, 건축허가여부, 토지거래허가여부 는 이관 시부터 거의 null값이거나 공백이라 null로 데이터가 이관
3. 
*/



-- tb_atlfsl_thema_info
SELECT *
  FROM sc_khb_srv.tb_atlfsl_thema_info;

/*
1. 매물의 테마를 매칭
 => 테마에는 산근접, 전철역 도보10분이내 등 여러 종류의 테마가 있다.
2. 
*/



-- tb_hsmp_dtl_info
SELECT *
  FROM sc_khb_srv.tb_hsmp_dtl_info;

/*
1. 테이블들 중 유일하게 2개의 열로 pk를 만든 테이블이다.
2. 
*/



-- tb_hsmp_info
SELECT *
  FROM sc_khb_srv.tb_hsmp_info;

/*
1. 시도/시군구/읍면동 코드로 단지를 찾을 수 있다.
2. 시공사, 준공, 관리사무소 전화번호 등 정보도 알 수 있다.
3. 버스나 지하철 노선, 학교와 편의시설 정보도 알 수 있다.
4.
*/



-- tb_itrst_atlfsl_info
SELECT *
  FROM sc_khb_srv.tb_itrst_atlfsl_info;

/*
1. 사용자 번호와 공인중개사 정보 pk가 각각 하나의 열을 가지고 있다.
 => 하나의 열에 둘시 누가 일반 사용자인지 공인중개사 인지 알기 어렵다.
2. 매물/단지/지역 을 각각 나누어서 관심 등록 
3. 
*/



-- tb_lrea_office_info
SELECT *
  FROM sc_khb_srv.tb_lrea_office_info;

/*전화 유형*/
SELECT DISTINCT tlphon_type_cd
  FROM sc_khb_srv.tb_lrea_office_info;

/*사용자 타입 코드*/
SELECT DISTINCT user_ty_cd
  FROM sc_khb_srv.tb_lrea_office_info;

/*상태 코드*/
SELECT DISTINCT stts_cd
  FROM sc_khb_srv.tb_lrea_office_info;

/*
1. 공인중개사 사무소에 대한 정보
2. 전화 유형은 A뿐
3. 사용자 타입 코드 => 01,70,80,90,99
4. 상태코드 => H + 01,10,14,15,20,30,40,41,45,50,60,70,80,92,97,98,99
5. 소개 내용??? => 이번에 추가되는 기능??
*/
SELECT *
  FROM sc_khb_srv.tb_lrea_office_info
 WHERE lrea_office_intrcn_cn IS NOT NULL;



-- tb_lrea_schdl_ntcn_info
SELECT *
  FROM sc_khb_srv.tb_lrea_schdl_ntcn_info;

/*
1. 일정 구분 코드 => 1(계약), 2(매물), 3(고객), 4(일반) 
2. 일정 유형 코드 => M(중도금1차), M1(중도금2차), L(잔금), E(계약만기), S(신고마감), S1(신고완료), T(매물), C(고객), G(일반)
3. schdl_se_pk????
*/



-- tb_lrea_sns_url_info
SELECT *
  FROM sc_khb_srv.tb_lrea_sns_url_info;

/*
1. sns_cd => 1(facebook), 2(youtube), 3(blog), 4(Instagram)
2. 
*/



-- tb_lrea_spclty_fld_info
SELECT *
  FROM sc_khb_srv.tb_lrea_spclty_fld_info;

/*
1. spclty_fld_cd => 01(아파트), 02(원룸/빌라), 03(오피스텔), 04(상가), 05(사무실), 06(공장/창고), 07(토지), 08(건물), 09(분양권), 10(재개발/재건축), 11(경매/투자), 12(외국인렌트)
2. 
*/



-- tb_lrea_spclty_fld_info
SELECT *
  FROM sc_khb_srv.tb_lrea_spclty_fld_info;

/*
1. spclty_fld_cd => 01(아파트), 02(원룸/빌라), 03(오피스텔), 04(상가), 05(사무실), 06(공장/창고), 07(토지), 08(건물), 09(분양권), 10(재개발/재건축), 11(경매/투자), 12(외국인렌트)
2. 
*/



-- tb_lttot_info
SELECT *
  FROM sc_khb_srv.tb_lttot_info;

/*
1. 분양 정보 테이블
2. 분양문의, 편의시설, 교통환경, 교육환경 정보 내용을 확인
3. 지역 코드 존재
4. 
*/



-- tb_svc_bass_info
SELECT *
  FROM sc_khb_srv.tb_svc_bass_info;

/*
1. 
2. 
*/



-- tb_user_atlfsl_img_info
SELECT *
  FROM sc_khb_srv.tb_user_atlfsl_img_info;

/*
1. 사용자 매물의 이미지 정보 테이블
2. 
*/



-- tb_user_atlfsl_info
SELECT *
  FROM sc_khb_srv.tb_user_atlfsl_info;

/*
1. atlfsl_knd_cd => 104(매물종류), H100
2. dlng_se_cd => 105(거래구분), H110
3. 지역 정보 존재
4. 상세주소 
5. 사용자 번호 pk가 3(일반사용자), 1(관리자) 만 존재
 => 2(공인중개사)에게 권한을 부여???
 6. 
*/



-- tb_user_atlfsl_preocupy_info
SELECT *
  FROM sc_khb_srv.tb_user_atlfsl_preocupy_info;

/*
1. 사용자 매물 선점 테이블
2. 
*/



-- tb_user_atlfsl_thema_info
SELECT *
  FROM sc_khb_srv.tb_user_atlfsl_thema_info;

/*
1. 사용자 매물 테마 테이블
2. 
*/



