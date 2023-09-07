/*
작성일: 230904
수정일:
작성자: 조건영
작성목적: link테이블들에 대한 이해 
*/



-- tb_link_apt_lttot_cmpet_rt_info
SELECT *
  FROM sc_khb_srv.tb_link_apt_lttot_cmpet_rt_info;

/*
1. 아파트 분양 경쟁률 테이블
2. 주택 관리 번호, 공고 번호, 모델 번호, 주택 타입 명
3. 공급 세대 수, 접수 수, 순위
4. 거주 코드, 거주 코드 명
5. 경쟁률 내용, 최저 당첨 점수 내용, 최고 당첨 점수 내용, 평균 당첨 점수 내용
6. 
*/



-- tb_link_apt_lttot_house_ty_dtl_info
SELECT *
  FROM sc_khb_srv.tb_link_apt_lttot_house_ty_dtl_info;

/*
1. 아파트 분양 주택 타입 상세 테이블
2. 주택 관리 번호, 공고 번호, 모델 번호, 주택 타입 명
3. 일반 공급 세대 수, 특별 공급 세대 수, 특별 공급 다자녀가구 세대_수, 특별 공급 결혼 부부 세대 수, 특별 공급 생애 최초 세대 수 , 특별 공급 노인 부모 부양 세대_수,
   특별 공급 기관 추천 세대 수, 특별 공급 기타 세대 수, 특별 공급 이전 기관 세대 수, 공급 분양 최고 금액
4. 공급면적도 확인 할 수 있다.
5. 
*/



-- tb_link_apt_lttot_info
SELECT *
  FROM sc_khb_srv.tb_link_apt_lttot_info;

/*
1. 아파트 분양 테이블
2. 주택구분과 주택 상세, 분양 구분, 공급 지역, 공급 위치 등의 코드와 한글명이 같이 존재
3. 청약일/접수일/모집공고일/1~2순위 접수일/당첨자발표일/계약일/입주예정 년월 등 날짜
4. 홈페이지 주소, url, 시공자, 시행자
5. 투기과열지구/조정대상지역/분양가격상한/정비사업/공공주택지구/대규모택지개발지구/수도권민영공공주택지구 여부
6. 지역정보 
 => 법정동 코드나 지역 pk번호
 => 업데이트 문은 노션과 cre_tbl.sql에 정리되어 있다.
7. 좌표 열들은 삭제될 가능성 높다.
8. 
*/



-- tb_link_apt_nthg_rank_remndr_hh_lttot_info
SELECT *
  FROM sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info;

/*
1. 아파트 무순위 잔여 세대 분양 테이블
2. 아파트 분양 테이블과 비슷한 열들 존재
 => 청약일/접수일/모집공고일/1~2순위 접수일/당첨자발표일/계약일/입주예정 년월 등 날짜
 => 홈페이지 주소, url, 시공자, 시행자
3. 지역정보 
 => 법정동 코드나 지역 pk번호
 => 업데이트 문은 노션과 cre_tbl.sql에 정리되어 있다.
4. 좌표 열들은 삭제될 가능성 높다.
5. 
*/



-- tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info
SELECT *
  FROM sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info;

/*
1. 아파트 무순위 잔여 세대 분양 타입 상세 테이블
2. 공급면적, 일반/특별 공급 세대수 정보
3. 분양 최대 금액
4. 모델 타입 명에 있는 숫자는 해당 물량의 면적이라고 할 수 있다.
 => 084.9559D는 28평 정도의 D타입
 => 039.9368는 13평 정도
*/



-- tb_link_hsmp_area_info
SELECT *
  FROM sc_khb_srv.tb_link_hsmp_area_info;

/*
1. 단지 면적 테이블
2. 연면적, 관리비 부과 면적, 주거 전용 면적, 전용 면적, 건축물 대장 연면적
3. 동수, 세대수
4. 자두에서는 단지코드와 명이 5와 6번째 행인데 우리 쪽에서는 1과 2 행에 단지 코드와 명이 있다.
5. 
*/



-- tb_link_hsmp_bsc_info
SELECT *
  FROM sc_khb_srv.tb_link_hsmp_bsc_info;

/*
1. 단지 기초 테이블
2. 단지코드 및 단지명
3. 지역 명 => 시도/시군구/읍면/동
4. 법정동과 도로명 주소
5. 분양형태. 동수, 세대수, 복도 유형, 승강기수, 총 주차 대수
6. 관리방식, 난방방식, 일반 관리 방식, 일반 관리 인원수, 경비, 청소, 음식물 처리, 소독, 세대 전기 등 관리 방법에 대한 여러 열들 존재
7. 시공자명, 시행자명
8. 좌표데이터는 update문으로 삽입
9. 
*/



-- tb_link_hsmp_managect_info
SELECT *
  FROM sc_khb_srv.tb_link_hsmp_managect_info;

/*
1. 단지 관리비 테이블
2. 지역 명
 => 시도/시군구/읍면/동리 등
3. 인건_비용, 사무_비용, 제세공과금, 피복_비용, 교육_훈련_비용, 차량_유지_비용, 
   부대_비용, 청소_비용, 경비_비용소독_비용.승강기_유지_비용.지능형네트워크_유지_비용, 수선_비용,
   시설_유지_비용, 안전_점검_비용, 재해_예방_비용, 위탁_관리_수수료, 개별_사용료,
   공용_난방_비용, 전용_난방_비용, 공용_급탕_비용, 전용_급탕_비용,
   공용_가스_사용료, 전용_가스_사용료, 공용_전기_사용료, 전용_전기_사용료,
   공용_수도_사용료, 전용_수도_사용료, 정화조_오물_수수료, 생활_폐기물_수수료,
   장기_수선_충당금_월_부과액, 장기_수선_충당금_월_사용액, 장기_수선_충당금_총_금액, 장기_수선_충당금_적립율
4. 
*/



-- tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info
SELECT *
  FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info;

/*
1. 오피스텔 도시 민간 임대 분양 경쟁률 테이블
2. 주택 관리 번호, 공고 번호, 모델 번호, 주택 타입 명
3. 공급 세대 수, 공급 구분 명, 거주자 우선 여부, 접수 수
4. 경쟁률 내용
 => 기본적으로는 접수_수/공급_세대_수
    -> 나누기에서도 이상한 값이 발견 된다. 주택 관리 번호가 2021950020인 행 95/13=47.5?????
 => 접수_수보다 공급_세대_수가 크면 (공급_세대_수-접수_수)
 => 접수_수보다 공급_세대_수가 크면 (공급_세대_수-접수_수)방법으로 안 되는 것도 있는데 이건 아직 잘 모르겠다.
    ex) 주택 관리 번호가 2020950005인 행 238-0=47???
5. 
*/



-- tb_link_ofctl_cty_prvate_rent_lttot_info
SELECT *
  FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info;

/*
1. 오피스텔 도시 민간 임대 분양 테이블
2. 주택 관리 번호, 공고 번호, 모델 번호, 주택 타입 명
3. 지역정보 
 => 법정동 코드나 지역 pk번호
 => 업데이트 문은 노션과 cre_tbl.sql에 정리되어 있다.
4. 모집_공고_일자 ,청약_접수_시작_일자, 청약_접수_종료_일자, 당첨자_발표_일자, 계약_시작_일자, 계약_종료_일자, 입주_예정_월
5. 홈페이지_URL, 사업_주체_시행사_명, 문의_처_전화번호, 분양_정보_URL
6. 주택 구분 코드, 주택 구분 코드 명, 주택 상세 구분 코드, 주택 상세 구분 코드 명, 주택 구분 명
 => 주택 구분 명은 주택 구분 코드와 주택 상세 구분 코드를 합친 문자열입니다.
7. 공급_위치_우편번호, 공급_위치_명, 공급_규모
8. 
*/



-- tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info
SELECT *
  FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info;

/*
1. 오피스텔 도시 민간 임대 분양 타입 상세 테이블
2. 주택 관리 번호, 공고 번호, 모델 번호, 주택 타입 명
3. 공급_세대_수, 배정_세대_수, 접수_수
4. 공급_유형_코드, 공급_유형_코드_명
5. 경쟁_률_내용
6. 
*/



-- tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info
SELECT *
  FROM sc_khb_srv.tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info;

/*
1. 오피스텔 지원 민간 임대 분양 경쟁률 테이블
2. 주택 관리 번호, 공고 번호, 모델 번호, 주택 타입 명
3. 공급_세대_수, 배정_세대_수, 접수_수
4. 공급_유형_코드, 공급_유형_코드_명 => 신혼부부, 일반공급, 고령자, 쳥년 등
5. 경쟁_률_내용
6. 
*/



-- tb_link_remndr_hh_lttot_cmpet_rt_info
SELECT *
  FROM sc_khb_srv.tb_link_remndr_hh_lttot_cmpet_rt_info;

/**/
SELECT DISTINCT beffat_aftfat_se_cd
  FROM sc_khb_srv.tb_link_remndr_hh_lttot_cmpet_rt_info;

/*
1. 잔여 세대 분양 경쟁률 테이블
2. 주택 관리 번호, 공고 번호, 사전 사후 구분 코드, 주택 타입 명
3. 공급 세대 수, 접수 수
4. 경쟁률 내용
*/



-- tb_link_rtrcn_re_sply_lttot_cmpet_rt_info
SELECT *
  FROM sc_khb_srv.tb_link_rtrcn_re_sply_lttot_cmpet_rt_info;

/*
1. 취소 재공급 분양 경쟁률 테이블
2. 자두에서 tb_apply_cancl_re_suply_lttot_info_cmpetrt	테이블 suply_hshld_co(공급 세대)열을 이관 X
3. 주택 관리 번호, 공고 번호, 모델 번호, 주택 타입 명
4. 일반_공급_배정_세대_수, 다자녀_가구_배정_세대_수, 결혼_부부_배정_세대_수, 생애_최초_배정_세대_수, 노인_부모_부양_배정_세대_수, 기관_추천_배정_세대_수
5. 일반_공급_접수_수, 다자녀_가구_접수_수, 결혼_부부_접수_수, 생애_최초_접수_수, 노인_부모_부양_접수_수, 기관_추천_접수_수
6. 일반_공급_경쟁_률_내용, 다자녀_가구_경쟁_률_내용, 결혼_부부_경쟁_률_내용, 생애_최초_경쟁_률_내용, 노인_부모_부양_경쟁_률_내용, 기관_추천_경쟁_률_내용
7. 
*/




-- tb_link_subway_statn_info
SELECT *
  FROM sc_khb_srv.tb_link_subway_statn_info;

/*
1. 지하철 역 테이블
2. rte_nm노선명 축약 하기 위해 update문
3. 좌표 삽입을 위한 update문
4. 법정동 코드는 tb_legal_zone_info_lio테이블의 li_code, emd_code 코드를 사용하여 데이터를 삽입
 => left join방법으로 
5. 
*/








