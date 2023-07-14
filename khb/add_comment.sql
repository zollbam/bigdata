/*
확장속성(comment)을 추가하는 파일
작성 일시: 230624
수정 일시: 230714
작 성 자 : 조건영 
작성 목적 : 테이블과 컬럼에 comment를 복사하여 쿼리문을 만들기 위해 만듬
사용 DB : mssql 2016
*/

-- 테이블 확장 속성 쿼리 작성
SELECT 
  t.TABLE_NAME "테이블명"
, 'EXEC SP_ADDEXTENDEDPROPERTY @name=N''MS_Description'', @value=N''' + CAST(ep.value AS varchar) +
  ''', @level0type=N''SCHEMA'', @level0name=N''' + t.TABLE_SCHEMA +
  ''', @level1type=N''TABLE'', @level1name=N''' + t.table_name + ''';' "확장속성 추가 쿼리"
  FROM (SELECT TABLE_SCHEMA, TABLE_NAME 
          FROM information_schema.tables) t
               LEFT join
       (SELECT object_name(major_id) "TABLE_NAME",  value
          FROM sys.extended_properties
         WHERE minor_id = 0) ep
                   ON t.TABLE_NAME = ep."TABLE_NAME"
 WHERE t.TABLE_SCHEMA = 'sc_khb_srv'
 ORDER BY 1;

-- 컬럼 확장 속성 쿼리 작성
SELECT DISTINCT 
  object_name(c.object_id) "테이블명"
, c.NAME "컬럼명"
, 'EXEC SP_ADDEXTENDEDPROPERTY @name=N''MS_Description'', @value=N''' + CAST(ep.value AS varchar) +
  ''', @level0type=N''SCHEMA'', @level0name=N''' + ccu.TABLE_SCHEMA +
  ''', @level1type=N''TABLE'', @level1name=N''' + object_name(c.object_id) +
  ''', @level2type=N''COLUMN'', @level2name=N''' + c.NAME + ''';' "컬럼 확장속성 추가 쿼리"
, c.column_id
  FROM sys.columns c
       INNER JOIN
       information_schema.constraint_column_usage ccu
           ON object_name(c.object_id) = ccu.TABLE_NAME
       LEFT JOIN
       sys.extended_properties ep
     	   ON object_name(c.object_id) = object_name(ep.major_id) AND c.column_id = ep.minor_id
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
       AND 
       object_name(c.object_id) = 'tb_atlfsl_dlng_info'
 ORDER BY 1, 4;

-- 테이블 확장 속성 삭제 쿼리 작성
SELECT DISTINCT t.name "테이블명",
	   'EXEC SP_DROPEXTENDEDPROPERTY @name=N''MS_Description'', ' +
	   ' @level0type=N''SCHEMA'', @level0name=N''' + ccu.TABLE_SCHEMA + 
	   ''', @level1type=N''TABLE'', @level1name=N''' + t.name + ''';' "확장속성 삭제 쿼리"
  FROM sys.tables t
       INNER JOIN
       information_schema.constraint_column_usage ccu
           ON t.name = ccu.TABLE_NAME
       INNER JOIN
       sys.extended_properties ep
           ON t.name = object_name(ep.major_id)
-- WHERE t.name = 'tb_com_banner_info' -- 컬럼명 조건
 ORDER BY 1;

-- 컬럼 확장 속성 삭제 쿼리 작성
SELECT DISTINCT 
  object_name(c.object_id) "테이블명"
, c.NAME "컬럼명"
, c.column_id
, 'EXEC SP_DROPEXTENDEDPROPERTY @name=N''MS_Description'', ' +
  ' @level0type=N''SCHEMA'', @level0name=N''' + ccu.TABLE_SCHEMA +
  ''', @level1type=N''TABLE'', @level1name=N''' + object_name(c.object_id) +
  ''', @level2type=N''COLUMN'', @level2name=N''' + c.NAME + ''';'
  FROM sys.columns c
       INNER JOIN
       information_schema.constraint_column_usage ccu
           ON object_name(c.object_id) = ccu.TABLE_NAME
       INNER JOIN
       sys.extended_properties ep
           ON object_name(c.object_id) = object_name(ep.major_id) AND c.column_id = ep.minor_id
 WHERE object_name(c.object_id) = 'tb_com_banner_info' -- 컬럼명 조건
 ORDER BY 1, c.column_id;

-- 테이블
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_배치_이력', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_batch_hstry';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_주변_시설_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_상업_상세_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_거래_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기타_상세_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기타_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_이미지_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_문의_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_토지_용도_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_주거_일반_상세_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_주거_집합_상세_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_배너_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info';
-- tb_com_banner_info_tmp
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게시판', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게시판_댓글', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_인증_임시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_시도_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ctpv_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_디바이스_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_디바이스_알림_매핑_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_디바이스_설정_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_읍면동_리_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_에러_LOG', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_FAQ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_파일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_파일_매핑', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_그룹', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_그룹_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게이트웨이_서비스', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게이트웨이_서비스_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_작업_일정_이력', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_hstry';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_작업_일정_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_로그인_이력', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_메뉴', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_메뉴_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_공지사항', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_알림_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_PUSH_메타_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_QNA', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_자료실', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_RSS_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_화면', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_화면_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_시군구_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_sgg_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_이력', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_매핑', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_서비스_아이피_관리', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_주제_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_유저', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_유저_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_유저_그룹', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_사용자_알림_매핑_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_상세_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'관심_매물_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무실_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'분양_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_기초_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_매물_이미지_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_매물_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_매물_선점_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info';

-- 컬럼
-----------------------------------------------------------------------------------
-- tb_atlfsl_batch_hstry
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_배치_이력_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_batch_hstry', @level2type=N'COLUMN', @level2name=N'atlfsl_batch_hstry_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'컨텐츠_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_batch_hstry', @level2type=N'COLUMN', @level2name=N'cntnts_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_batch_hstry', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이력_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_batch_hstry', @level2type=N'COLUMN', @level2name=N'hstry_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'결과_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_batch_hstry', @level2type=N'COLUMN', @level2name=N'rslt_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작업_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_batch_hstry', @level2type=N'COLUMN', @level2name=N'job_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'오류_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_batch_hstry', @level2type=N'COLUMN', @level2name=N'err_cn';
-----------------------------------------------------------------------------------
-- tb_atlfsl_bsc_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'협회_매물_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'asoc_atlfsl_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'협회_앱_연동_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'asoc_app_intrlck_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'lrea_office_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'ctpv_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'sgg_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'읍면동_리스트_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'emd_li_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'hsmp_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_상세_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'hsmp_dtl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_상세_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_dtl_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_종류_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_knd_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_동_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'stdg_dong_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'stdg_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_고유번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'stdg_innb';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동_고유번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'dong_innb';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'본번', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'mno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부번', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'sno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'aptcmpl_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'호_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'ho_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_좌표', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_crdnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_경도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_lot';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_위도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_lat';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_전송_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_trsm_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'건물_동_표시_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'bldg_aptcmpl_indct_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'평_표시_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'pyeong_indct_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'VR_존재_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'vr_exst_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_존재_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'img_exst_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주제_코드_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'thema_cd_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'담당자_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'pic_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'담당자_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'pic_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'담당자_전화번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'pic_telno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'상세_화면_열람_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'dtl_scrn_prsl_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전용_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'prvuse_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공급_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'sply_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'대지_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'plot_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'건축_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'arch_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'room_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화장실_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'toilet_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_inq_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_노출_방식_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'flr_expsr_mthd_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'현재_층_노출_방식_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'now_flr_expsr_mthd_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최고_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'top_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지상_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'grnd_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지하_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'udgd_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'계단_형태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'stairs_stle_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방향_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'drc_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'발코니_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'blcn_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'위치_설명_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'pstn_expln_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주차_가능_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'parkng_psblty_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주차_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'parkng_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'준공_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'cmcn_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'융자_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'financ_amt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'use_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'클러스터_정보_상태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'clustr_info_stts_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'PUSH_상태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'push_stts_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'추천_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'rcmdtn_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'경매_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'auc_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_상태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_bsc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_stts_cd';
-----------------------------------------------------------------------------------
-- tb_atlfsl_cfr_fclt_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_주변_시설_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'atlfsl_cfr_fclt_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기초_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'난방_방식_코드_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'heat_mthd_cd_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'난방_연료_코드_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'heat_fuel_cd_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'냉방_시설_코드_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'arclng_fclt_cd_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'생활_시설_코드_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'lvlh_fclt_cd_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'보안_시설_코드_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'scrty_fclt_cd_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'기타_시설_코드_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'etc_fclt_cd_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'냉방_방법_코드_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'arclng_mthd_cd_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cfr_fclt_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_atlfsl_cmrc_dtl_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_상업_상세_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_cmrc_dtl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'stdg_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전용_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'prvuse_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최고_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'top_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'room_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화장실_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'toilet_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'준공_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'cmcn_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방향_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'drc_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'위치_설명_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'pstn_expln_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공급_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'sply_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주차_가능_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'parkng_psblty_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'건축_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'arch_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'대지_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'plot_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지하_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'udgd_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지상_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'grnd_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_cmrc_dtl_info', @level2type=N'COLUMN', @level2name=N'use_yn';
-----------------------------------------------------------------------------------
-- tb_atlfsl_dlng_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_거래_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'atlfsl_dlng_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'거래_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'dlng_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매매_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'trde_amt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전세_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'lfsts_amt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'월세_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'mtht_amt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'융자_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'financ_amt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'현재_전세_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'now_lfsts_amt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'현재_월세_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'now_mtht_amt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'프리미엄', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'premium';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'관리_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_dlng_info', @level2type=N'COLUMN', @level2name=N'mng_amt';
-----------------------------------------------------------------------------------
-- tb_atlfsl_etc_dtl_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기타_상세_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_etc_dtl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'stdg_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전용_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'prvuse_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최고_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'top_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'room_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'준공_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'cmcn_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방향_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'drc_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'위치_설명_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'pstn_expln_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공급_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'sply_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주차_가능_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'parkng_psblty_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'건축_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'arch_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'대지_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'plot_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지하_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'udgd_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지상_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'grnd_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_dtl_info', @level2type=N'COLUMN', @level2name=N'use_yn';
-----------------------------------------------------------------------------------
-- tb_atlfsl_etc_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기타_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_etc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기초_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'입주_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'mvn_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'입주_가능_이내_개월_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'mvn_psblty_wthn_month_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'입주_가능_이후_개월_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'mvn_psblty_aftr_month_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'입주_협의_가능_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'mvn_cnsltn_psblty_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_특징_설명_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_sfe_expln_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'진입_도로_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'entry_road_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_설명_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'atlfsl_expln_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_etc_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_atlfsl_img_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_이미지_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'atlfsl_img_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기초_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_순번', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'img_sn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'img_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_파일_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'img_file_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_설명_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'img_expln_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'썸네일_이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'thumb_img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'원본_이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'orgnl_img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_정렬_순차', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'img_sort_ordr';
-----------------------------------------------------------------------------------
-- tb_atlfsl_inqry_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_문의_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'atlfsl_inqry_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'문의_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'inqry_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'del_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_inqry_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_atlfsl_land_usg_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_토지_용도_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'atlfsl_land_usg_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기초_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'용도_지역_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'usg_rgn_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'국토_이용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'trit_utztn_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'도시계획_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'ctypln_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'건축_허가_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'arch_prmsn_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'토지_거래_허가_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'land_dlng_prmsn_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_land_usg_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_atlfsl_reside_gnrl_dtl_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_주거_일반_상세_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_reside_gnrl_dtl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'stdg_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전용_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'prvuse_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최고_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'top_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'room_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화장실_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'toilet_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'준공_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'cmcn_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방향_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'drc_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'위치_설명_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'pstn_expln_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공급_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'sply_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주차_가능_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'parkng_psblty_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'건축_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'arch_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'대지_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'plot_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지하_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'udgd_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지상_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'grnd_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_노출_방식_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'flr_expsr_mthd_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'현재_층_노출_방식_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'now_flr_expsr_mthd_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'계단_형태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'stairs_stle_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_gnrl_dtl_info', @level2type=N'COLUMN', @level2name=N'use_yn';
-----------------------------------------------------------------------------------
-- tb_atlfsl_reside_set_dtl_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_주거_집합_상세_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_reside_set_dtl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'stdg_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'hsmp_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전용_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'prvuse_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최고_층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'top_flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'room_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화장실_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'toilet_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'계단_형태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'stairs_stle_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'준공_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'cmcn_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방향_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'drc_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'융자_금액', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'financ_amt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'aptcmpl_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'호_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'ho_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_노출_방식_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'flr_expsr_mthd_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'현재_층_노출_방식_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'now_flr_expsr_mthd_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'발코니_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'blcn_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_atlfsl_reside_set_dtl_info', @level2type=N'COLUMN', @level2name=N'use_yn';
-----------------------------------------------------------------------------------
-- tb_com_author
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'parnts_author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'author_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유효_기간_시작_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'valid_pd_begin_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유효_기간_종료_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'valid_pd_end_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조직_관리_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'orgnzt_manage_at';
-----------------------------------------------------------------------------------
-- tb_com_banner_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'배너_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'banner_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'배너_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'banner_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'배너_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'banner_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'썸네일_이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'thumb_img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'배너_순차', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'banner_ordr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'use_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'상세_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'dtl_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_banner_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_com_bbs
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게시판_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'bbs_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게시판_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'bbs_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'ttl_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'del_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록자_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'rgtr_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_com_bbs_cmnt
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게시판_댓글_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt', @level2type=N'COLUMN', @level2name=N'bbs_cmnt_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게시판_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt', @level2type=N'COLUMN', @level2name=N'bbs_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt', @level2type=N'COLUMN', @level2name=N'cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt', @level2type=N'COLUMN', @level2name=N'del_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록자_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt', @level2type=N'COLUMN', @level2name=N'rgtr_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_bbs_cmnt', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_com_code
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'parnts_code_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'코드_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'정렬_순서', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'sort_ordr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'parent_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동기화_시점_값', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'synchrn_pnttm_vl';
-----------------------------------------------------------------------------------
-- tb_com_crtfc_tmpr
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'인증_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'crtfc_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'인증_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'crtfc_se_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'소셜_로그인_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'soc_lgn_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_인증_일련번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_sn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_인증_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일_인증_일련번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email_crtfc_sn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일_인증_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email_crtfc_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'SNS_인증_일련번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'sns_crtfc_sn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'SNS_인증_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'sns_crtfc_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_ctpv_cd
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ctpv_cd', @level2type=N'COLUMN', @level2name=N'ctpv_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ctpv_cd', @level2type=N'COLUMN', @level2name=N'ctpv_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_축약_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ctpv_cd', @level2type=N'COLUMN', @level2name=N'ctpv_abbrev_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_좌표', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ctpv_cd', @level2type=N'COLUMN', @level2name=N'ctpv_crdnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동기화_시점_값', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ctpv_cd', @level2type=N'COLUMN', @level2name=N'synchrn_pnttm_vl';
-----------------------------------------------------------------------------------
-- tb_com_device_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'디바이스_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'device_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'PUSH_토큰_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'push_tkn_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'디바이스_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'device_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'플랫폼_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'pltfom_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'del_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'로그인_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'lgn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'리프레시_토큰_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'refresh_tkn_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_com_device_ntcn_mapng_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'디바이스_알림_매핑_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'device_ntcn_mapng_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'디바이스_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'device_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'알림_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'ntcn_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전송_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'trsm_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전송_결과_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'trsm_rslt_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_com_device_stng_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'디바이스_설정_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'device_stng_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'디바이스_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'device_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'PUSH_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'push_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방해_금지_시작_분초', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'dstrbnc_prhibt_bgng_hm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방해_금지_종료_분초', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'dstrbnc_prhibt_end_hm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'PUSH_메타_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_device_stng_info', @level2type=N'COLUMN', @level2name=N'push_meta_info_pk';
-----------------------------------------------------------------------------------
-- tb_com_emd_li_cd
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'읍면동_리_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'emd_li_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'ctpv_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'sgg_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'읍면동_리_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'emd_li_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전부_읍면동_리_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'all_emd_li_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'읍면동_리_좌표', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'emd_li_crdnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_행정동_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'stdg_dong_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_행정동_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'stdg_dong_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동기화_시점_값', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_emd_li_cd', @level2type=N'COLUMN', @level2name=N'synchrn_pnttm_vl';
-----------------------------------------------------------------------------------
-- tb_com_error_log
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_LOG_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'error_log_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'user_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방식_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'mthd_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파라미터_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'paramtr_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'error_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'요청_IP_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'requst_ip_adres';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_faq
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'FAQ_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'faq_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'질문_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'qestn_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'답변_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'answer_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'카테고리_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'ctgry_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'svc_se_code';
-----------------------------------------------------------------------------------
-- tb_com_file
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'file_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'본래_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'orignl_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'경로', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'cours';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_사이즈', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'file_size';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'다운로드_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'dwld_co';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'확장자_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'extsn_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'delete_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'delete_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file', @level2type=N'COLUMN', @level2name=N'delete_id';
-----------------------------------------------------------------------------------
-- tb_com_file_mapng
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'file_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'자료실_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'recsroom_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이벤트_번호_pk', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'event_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공개_자료_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'othbc_dta_no_pk';
-----------------------------------------------------------------------------------
-- tb_com_group
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'그룹_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'group_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_그룹_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'parnts_group_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'그룹_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'group_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유효_기간_시작_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'valid_pd_begin_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유효_기간_종료_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'valid_pd_end_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_group_author
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_그룹_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'com_group_author_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'그룹_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'group_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_gtwy_svc
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게이트웨이_서비스_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_svc_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게이트웨이_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게이트웨이_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게이트웨이_메소드_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_method_nm';
-----------------------------------------------------------------------------------
-- tb_com_gtwy_svc_author
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게이트웨이_서비스_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'com_gtwy_svc_author_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게이트웨이_서비스_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'gtwy_svc_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_job_schdl_hstry
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작업_일정_이력_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_hstry', @level2type=N'COLUMN', @level2name=N'job_schdl_hstry_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작업_일정_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_hstry', @level2type=N'COLUMN', @level2name=N'job_schdl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'LINK_테이블_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_hstry', @level2type=N'COLUMN', @level2name=N'link_tbl_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'진행_결과_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_hstry', @level2type=N'COLUMN', @level2name=N'prgrs_rslt_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'오류_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_hstry', @level2type=N'COLUMN', @level2name=N'err_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'실행_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_hstry', @level2type=N'COLUMN', @level2name=N'excn_dt';
-----------------------------------------------------------------------------------
-- tb_com_job_schdl_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작업_일정_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_info', @level2type=N'COLUMN', @level2name=N'job_schdl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작업_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_info', @level2type=N'COLUMN', @level2name=N'job_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작업_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_info', @level2type=N'COLUMN', @level2name=N'job_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작업_주기', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_info', @level2type=N'COLUMN', @level2name=N'job_cycle';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'마지막_실행_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_job_schdl_info', @level2type=N'COLUMN', @level2name=N'last_excn_dt';
-----------------------------------------------------------------------------------
-- tb_com_login_hist
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'로그인_이력_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'login_hist_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'user_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'로그인_IP_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'login_ip_adres';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_menu
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'메뉴_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'menu_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_메뉴_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'parnts_menu_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'메뉴_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'menu_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'정렬_순서', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'sort_ordr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'scrin_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조직_관리_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'orgnzt_manage_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'어플리케이션_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'aplctn_code';
-----------------------------------------------------------------------------------
-- tb_com_menu_author
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_메뉴_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'com_menu_author_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'메뉴_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'menu_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_notice
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공지사항_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'sj_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'inqire_co';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공지_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공지_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_se_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'svc_se_code';
-----------------------------------------------------------------------------------
-- tb_com_ntcn_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'알림_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'ntcn_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'PUSH_메타_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'push_meta_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'ttl_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파라미터_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'paramtr_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_ntcn_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
--tb_com_push_meta_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'PUSH_메타_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'push_meta_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'PUSH_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'push_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전송_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'trsm_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'토픽_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'tpc_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'user_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'재전송_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'retransm_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'재전송_주기', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'retransm_cycle';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'use_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방해_금지_설정_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'dstrbnc_prhibt_stng_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'PUSH_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_push_meta_info', @level2type=N'COLUMN', @level2name=N'push_yn';
-----------------------------------------------------------------------------------
-- tb_com_qna
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'질의응답_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'qna_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_질의응답_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'parnts_qna_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'sj_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비밀_번호_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'secret_no_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비밀_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'secret_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'inqire_co';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'답변_깊이_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'answer_dp_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_recsroom
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'자료실_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'recsroom_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'sj_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'inqire_co';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'file_use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'updt_id';
-----------------------------------------------------------------------------------
-- tb_com_rss_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'RSS_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'rss_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'RSS_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'rss_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'ttl_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'누리집_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'hmpg_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'썸네일_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'thumb_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'해시태그_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'hashtag_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게시_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'pstg_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'inq_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작성자_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_rss_info', @level2type=N'COLUMN', @level2name=N'wrtr_nm';
-----------------------------------------------------------------------------------
-- tb_com_scrin
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'rm_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'생성_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'creat_author_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'inqire_author_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_author_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'delete_author_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'엑셀_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'excel_author_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_scrin_author
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_화면_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'com_scrin_author_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'scrin_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_sgg_cd
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_sgg_cd', @level2type=N'COLUMN', @level2name=N'sgg_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_sgg_cd', @level2type=N'COLUMN', @level2name=N'ctpv_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_sgg_cd', @level2type=N'COLUMN', @level2name=N'sgg_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_좌표', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_sgg_cd', @level2type=N'COLUMN', @level2name=N'sgg_crdnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_행정동_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_sgg_cd', @level2type=N'COLUMN', @level2name=N'stdg_dong_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동기화_시점_값', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_sgg_cd', @level2type=N'COLUMN', @level2name=N'synchrn_pnttm_vl';
-----------------------------------------------------------------------------------
-- tb_com_stplat_hist
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_이력_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'com_stplat_hist_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_se_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'필수_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'essntl_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_경로_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'file_cours_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_시작_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_begin_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_종료_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_end_dt';
-----------------------------------------------------------------------------------
-- tb_com_stplat_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'svc_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'stplat_se_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'필수_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'essntl_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_경로_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'file_cours_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록자_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'register_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정자_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'updusr_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'채널_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'chnnl_id';
-----------------------------------------------------------------------------------
-- tb_com_stplat_mapng
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_매핑_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'com_stplat_mapng_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_동의_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'stplat_agre_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_거부_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'stplat_reject_dt';
-----------------------------------------------------------------------------------
-- tb_com_svc_ip_manage
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'아이피_관리_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_manage_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'아이피_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_adres';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'아이피_사용_기관_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_use_instt_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_thema_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주제_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'thema_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주제_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'thema_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주제_코드_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'thema_cd_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'주제_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'thema_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_정렬_순차', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'img_sort_ordr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'use_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'대표_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'rprs_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_등록_사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_thema_info', @level2type=N'COLUMN', @level2name=N'atlfsl_reg_use_yn';
-----------------------------------------------------------------------------------
-- tb_com_user
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'parnts_user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비밀번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'password';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'moblphon_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_se_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'가입_일자', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'sbscrb_de';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'암호_변경_일자', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'password_change_de';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최종_로그인_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'last_login_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최종_로그인_아이피', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'last_login_ip';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'오류_횟수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'error_co';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'오류_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'error_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'use_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'updt_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'리프레시_토큰_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'refresh_tkn_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'소셜_로그인_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'soc_lgn_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'lrea_office_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'lrea_office_info_pk';
-----------------------------------------------------------------------------------
-- tb_com_user_author
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'user_author_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_user_group
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_유저_그룹_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'com_user_group_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'그룹_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'group_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_com_user_ntcn_mapng_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_알림_매핑_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'user_ntcn_mapng_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'알림_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'ntcn_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'알림_확인_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'ntcn_idnty_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_ntcn_mapng_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_hsmp_dtl_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_상세_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'hsmp_dtl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'hsmp_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공급_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'sply_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공급_면적_평', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'sply_area_pyeong';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'평_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'pyeong_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전용_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'prvuse_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전용_면적_평', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'prvuse_area_pyeong';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'계약_면적', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'ctrt_area';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'계약_면적_평', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'ctrt_area_pyeong';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'상세_지번', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'dtl_lotno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'room_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'욕실_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'btr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'평_세대_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'pyeong_hh_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방향_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'drc_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'베이_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'bay_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'계단_형태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'stairs_stle_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'도면_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'flrpln_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'확장_도면_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'estn_flrpln_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'use_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동기화_시점_값', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_dtl_info', @level2type=N'COLUMN', @level2name=N'synchrn_pnttm_vl';
-----------------------------------------------------------------------------------
-- tb_hsmp_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'hsmp_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'hsmp_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'ctpv_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'sgg_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'읍면동_리_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'emd_li_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지번', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'lotno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'도로명_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'rn_addr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'집계_세대_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'tot_hh_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'집계_동_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'tot_aptcmpl_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'층_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'flr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'집계_주차_대수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'tot_parkng_cntom';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'세대_주차_대수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'hh_parkng_cntom';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시공자_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'bldr_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'준공_연도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'cmcn_year';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'준공_월', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'cmcn_mt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'완공_연도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'compet_year';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'완공_월', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'compet_mt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'난방_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'heat_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'연료_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'fuel_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'카탈로그_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'ctlg_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'관리_사무소_전화번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'mng_office_telno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'버스_노선_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'bus_rte_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'지하철_노선_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'subway_rte_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'학교_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'schl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'편의시설_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'cvntl_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_좌표', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'hsmp_crdnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_경도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'hsmp_lot';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_위도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'hsmp_lat';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'use_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동기화_시점_값', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_hsmp_info', @level2type=N'COLUMN', @level2name=N'synchrn_pnttm_vl';
-----------------------------------------------------------------------------------
-- tb_itrst_atlfsl_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'관심_매물_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'itrst_atlfsl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'lrea_office_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_기본_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_bsc_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'단지_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'hsmp_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'읍면동_리스트_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'emd_li_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'use_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_itrst_atlfsl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_lrea_office_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lrea_office_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사업자_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'bzmn_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lrea_office_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_대표자_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lrea_office_rprsv_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전화_유형_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'tlphon_type_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'안심_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'safety_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_대표_전화번', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lrea_office_rprs_telno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_전화번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lrea_telno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lrea_office_addr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'ctpv_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'sgg_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'법정동_고유번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'stdg_innb';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'행정동_고유번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'dong_innb';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_레벨_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'user_level_no';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'대표_이미지_1_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'rprs_img_1_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'대표_이미지_2_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'rprs_img_2_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'대표_이미지_3_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'rprs_img_3_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'위도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lat';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'경도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lot';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'user_ty_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'상태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'stts_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'use_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_좌표', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'lrea_office_crdnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동기화_시점_값', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'synchrn_pnttm_vl';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'홈페이지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name=N'hmpg_url';
-----------------------------------------------------------------------------------
-- tb_lttot_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'분양_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'lttot_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'분양_정보_제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'lttot_info_ttl_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'분양_정보_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'lttot_info_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'ctpv_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'ctpv_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'sgg_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'sgg_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'읍면동_리_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'emd_li_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전부_읍면동_리_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'all_emd_li_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'상세_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'dtl_addr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공급_규모_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'sply_scale_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공급_주택_면적_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'sply_house_area_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'분양_가격_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'lttot_pc_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'모집_공고_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'rcrit_pbanc_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'청약_접수_일_목록', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'subscrpt_rcpt_day_list';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'당첨자_발표_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'przwner_prsntn_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'입주_예정_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'mvn_prnmnt_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'계약_기간', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'ctrt_pd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시공자_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'bldr_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'모델하우스_개관_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'mdlhs_opnng_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'분양_문의_정보_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'lttot_inqry_info_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'편의시설_정보_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'cvntl_info_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'교통_환경_정보_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'trnsport_envrn_info_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'교육_환경_정보_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'edu_envrn_info_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록자_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'rgtr_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'reg_day';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동기화_시점_값', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lttot_info', @level2type=N'COLUMN', @level2name=N'synchrn_pnttm_vl';
-----------------------------------------------------------------------------------
-- tb_svc_bass_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'svc_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'API_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'api_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'svc_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_분류_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'svc_cl_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_타입_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'svc_ty_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'svc_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'svc_cn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_데이터_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'file_data_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공개_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'othbc_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'delete_at';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'inqire_co';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_제공_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'use_provd_co';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_svc_bass_info', @level2type=N'COLUMN', @level2name=N'updt_dt';
-----------------------------------------------------------------------------------
-- tb_user_atlfsl_img_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_매물_이미지_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'user_atlfsl_img_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_매물_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'user_atlfsl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'정렬_순차', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'sort_ordr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_파일_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'img_file_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'썸네일_이미지_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'thumb_img_url';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서버_이미지_파일_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'srvr_img_file_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'로컬_이미지_파일_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'local_img_file_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'썸네일_이미지_파일_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'thumb_img_file_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_img_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_user_atlfsl_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_매물_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'user_atlfsl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'user_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'선점_공인중개사_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'preocupy_lrea_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_종류_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_knd_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'거래_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'dlng_se_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매물_상태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'atlfsl_stts_cd';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'ctpv_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시도_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'ctpv_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'sgg_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'시군구_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'sgg_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'읍면동_리스트_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'emd_li_cd_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전부_읍면동_리스트_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'all_emd_li_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'본번', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'mno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부번', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'sno';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'동_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'aptcmpl_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'호_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'ho_nm';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'위도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'lat';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'경도', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'lot';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'매매_가격', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'trde_pc';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'전세_가격', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'lfsts_pc';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'월세_년세_가격', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'mtht_yyt_pc';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'room_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'욕실_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'btr_cnt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_자동_선택_여', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'lrea_office_atmc_chc_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
-- tb_user_atlfsl_preocupy_info
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_매핑_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info', @level2type=N'COLUMN', @level2name=N'user_mapng_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용자_매물_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info', @level2type=N'COLUMN', @level2name=N'user_atlfsl_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공인중개사_사무소_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info', @level2type=N'COLUMN', @level2name=N'lrea_office_info_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'선점_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info', @level2type=N'COLUMN', @level2name=N'preocupy_yn';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info', @level2type=N'COLUMN', @level2name=N'reg_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info', @level2type=N'COLUMN', @level2name=N'reg_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info', @level2type=N'COLUMN', @level2name=N'mdfcn_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_user_atlfsl_preocupy_info', @level2type=N'COLUMN', @level2name=N'mdfcn_dt';
-----------------------------------------------------------------------------------
--