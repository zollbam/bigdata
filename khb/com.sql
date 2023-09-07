/*
작성일: 230904
수정일:
작성자: 조건영
작성목적: com테이블들에 대한 이해 
*/

-- tb_com_author
SELECT *
  FROM sc_khb_srv.tb_com_author;

/*
1. 현재 권한은 4종류 => 1.비로그인, 2.관리 3. 중개사, 4.일반인
2. mssql_export.sql파일에 데이터 추출을 bcp방법으로 정리해두었다.
3. 
*/



-- tb_com_banner_info
SELECT *
  FROM sc_khb_srv.tb_com_banner_info;

/*
1. 기존에 사용하던 타입 코드는 메인푸터(M)와 종료모달(E)
2. 배너 구분 코드라고 우리 쪽에서 만든 코드가 존재
 => 부모pk는 1256으로 이미지(I), 텍스트(T), 외부링크(L)
*/



-- tb_com_bbs
SELECT *
  FROM sc_khb_srv.tb_com_bbs;

/*
1. 게시판 구분 코드에 B와 Q는 ??
2. reg_id의 등록자는 user_info의 일반인과 realtor_info의 공인중개사가 섞여서 나온다.
3. rgtr_nm에서 공인중개사 사무소명과 공인중개사명이 일치하지 않는다.
 => realtor_info에서 pk를 조회해보면 사무소명이 일치하는 것도 있고 아닌것도 있다.
    ex) 중개사pk 1565117인 김정아는 대박공인중개사사무소인데 OK대동공인중개사사무소라고 적혀있다.
4. 우리쪽에서 사용하는 테이블이 아니다.
*/



-- tb_com_bbs_cmnt
SELECT *
  FROM sc_khb_srv.tb_com_bbs_cmnt;ㅌ
ㅌ
/*
1. tb_com_bbs와 연결된 댓글 테이블
2. tb_com_bbs와 마찬가지로 중개사pk가 1584665인 주임식은 realtor테이블에서는 철인부동산이지만
   이 테이블에서는 지산닥터공인중개사 사무소라고 되어있다.
3. 우리쪽에서 사용하는 테이블이 아니다.
4. 
*/



-- tb_com_cnrs_info
SELECT *
  FROM sc_khb_srv.tb_com_cnrs_info;

/*
1. 왕원철 부장님이 필요하다고 해서 만든 테이블
2. 
*/



-- tb_com_code
SELECT *
  FROM sc_khb_srv.tb_com_code;

/*
1. 한방쪽에는 없는 대분류가 있어 새롭게 추가함
 => 두레가입형태, 두레게시판형태 등
2. 160번 사용자구분 => 두레 개설 상태로 변경은 어떠한가?
*/



-- tb_com_crtfc_tmpr
SELECT *
  FROM sc_khb_srv.tb_com_crtfc_tmpr;

/*
1. 인중구분코드열은 com_code의 부모pk 1237로 휴대폰/인증서/sns로 구분되어 있지만
   열명을 보면 휴대폰/이메일/sns로 나뉘어져 있다.
2. crtfc_se_code?? crtfc_se_cd?? 둘중 어느 것을??
*/



-- tb_com_ctpv_cd
SELECT *
  FROM sc_khb_srv.tb_com_ctpv_cd;

/*
1. 시도 테이블
2. 
*/



-- tb_com_device_info
SELECT *
  FROM sc_khb_srv.tb_com_device_info;
 
/*
1. 동일 사용자에 의해 여러 대의 디바이스가 존재 할 수 있다.
2. 동일 기계라도 다른 사용자로 로그인 할 수 도 있다.
 => 동일 기계에 로그인시 해당 기계에 로그인되어 있던 기존 사용자는 삭제 여부가 Y가 된다.
*/



-- tb_com_device_ntcn_mapng_info
SELECT *
  FROM sc_khb_srv.tb_com_device_ntcn_mapng_info;

/*
1. 성공/실패 수는 전송된 디바이스 수라고 생각하면 된다.
2. 
*/



-- tb_com_device_stng_info
SELECT *
  FROM sc_khb_srv.tb_com_device_stng_info;

/*
1. 푸쉬를 디바이스별 설정하는 테이블
2. 
*/



-- tb_com_emd_li_cd
SELECT *
  FROM sc_khb_srv.tb_com_emd_li_cd;

/*
1. 법정동 코드 존재
2. 
*/



-- tb_com_error_log
SELECT *
  FROM sc_khb_srv.tb_com_error_log;

/*
1. 에러 내용
2. 
*/



-- tb_com_faq
SELECT *
  FROM sc_khb_srv.tb_com_faq;

/*
1. 아무 데이터 없음
2. 
*/



-- tb_com_file
SELECT *
  FROM sc_khb_srv.tb_com_file;

/*
1. 아무 데이터 없음
2. 
*/



-- tb_com_file_mapng
SELECT *
  FROM sc_khb_srv.tb_com_file_mapng;

/*
1. 아무 데이터 없음
2. 
*/



-- tb_com_group
SELECT *
  FROM sc_khb_srv.tb_com_group;

/*
1. 권한 테이블과 마찬가지로 비로그인/관리/중개사/일반인 존재
2. 
*/



-- tb_com_group_author
SELECT *
  FROM sc_khb_srv.tb_com_group_author;

/*
1. 그룹이 가지는 권한에 대한 테이블
 => 비로그인은 비로그인만 부여
 => 관리자는 비로그인,관리,중개사,일반인에 대한 모든 권한 부여
 => 중개사는 비로그인, 중개사, 일반인 권한 부여
 => 일반인은 비로그인과 일반인 권한 부여
2. 
*/



-- tb_com_gtwy_svc
SELECT *
  FROM sc_khb_srv.tb_com_gtwy_svc;

/*
1. 게이트워이에 정보 테이블
2. 
*/



-- tb_com_gtwy_svc_author
SELECT *
  FROM sc_khb_srv.tb_com_gtwy_svc_author;

/*
1. 게이트워이 권한 정보 테이블
2. 
*/



-- tb_com_job_schdl_hstry
SELECT *
  FROM sc_khb_srv.tb_com_job_schdl_hstry;

/*
1. 배치에 대한 이력 테이블
2. 
*/



-- tb_com_job_schdl_info
SELECT *
  FROM sc_khb_srv.tb_com_job_schdl_info;

/*
1. 여러 배치에 관한 정보 테이블
2. 각 배치의 동기화 시점값은 마지막 작업을 하고 최대값을 삽입하는 방법을 채택
3. 
*/



-- tb_com_login_hist
SELECT *
  FROM sc_khb_srv.tb_com_login_hist;

/*
1. 로그인 이력
2. 
*/



-- tb_com_menu
SELECT *
  FROM sc_khb_srv.tb_com_menu;

/*
1. 관심매물, 테마 매물, 내 집 찾기, 쪽지 관리, 구합니다, 있습니다 등 메뉴에 대한 정보
2. 
*/



-- tb_com_menu_author
SELECT *
  FROM sc_khb_srv.tb_com_menu_author;

/*
1. 메뉴에 대한 권한 테이블
2. 
*/



-- tb_com_notice
SELECT *
  FROM sc_khb_srv.tb_com_notice;

/*
1. 공지 테이블
2. 
*/



-- tb_com_ntcn_info
SELECT *
  FROM sc_khb_srv.tb_com_ntcn_info;

/*
1. 공지 테이블
2. 
*/



-- tb_com_push_meta_info
SELECT *
  FROM sc_khb_srv.tb_com_push_meta_info;

/*
1. 전송 구분 코드 열의 01은 토큰, 02는 토픽으로 구분하여 전송
2. 방해 금지를 제외한다는 Y는 
3. 
*/



-- tb_com_qna
SELECT *
  FROM sc_khb_srv.tb_com_qna;

/*
1. 데이터 없습니다.
2. 
*/



-- tb_com_recsroom
SELECT *
  FROM sc_khb_srv.tb_com_recsroom;

/*
1. 데이터 없습니다.
2. 
*/



-- tb_com_rss_info
SELECT *
  FROM sc_khb_srv.tb_com_rss_info;

/*아이디값??*/
SELECT count(*)
  FROM sc_khb_srv.tb_com_rss_info; -- 4470  

SELECT count(DISTINCT id_vl)
  FROM sc_khb_srv.tb_com_rss_info; -- 4470
 
/*
1. rss(really simple, syndication)
2. rss 구분 코드는 블로그(01), 유투브(02), 부동산뉴스(03S1N1), 협회소식(03S1N2), 지부소식(03S1N4), live뉴스(04)
3. 아이디 값도 중복 데이터가 없다
 => 아이디 값이란?
*/



-- tb_com_scrin
SELECT *
  FROM sc_khb_srv.tb_com_scrin;

/*
1. 화면 테이블
2. 
*/



-- tb_com_scrin_author
SELECT *
  FROM sc_khb_srv.tb_com_scrin_author;

/*
1. 화면 권한 테이블
2. 
*/



-- tb_com_sgg_cd
SELECT *
  FROM sc_khb_srv.tb_com_sgg_cd;

/*
1. 시군구 테이블
2. 
*/



-- tb_com_stplat_hist
SELECT *
  FROM sc_khb_srv.tb_com_stplat_hist;

/*
1. 약관 이력 테이블
2. 
*/



-- tb_com_stplat_info
SELECT *
  FROM sc_khb_srv.tb_com_stplat_info;

/*
1. 약관 정보 테이블 => 데이터 없음
2. 
*/



-- tb_com_stplat_mapng
SELECT *
  FROM sc_khb_srv.tb_com_stplat_mapng;

/*
1. 약관 매핑 테이블 => 데이터 없음
2. 
*/



-- tb_com_svc_ip_manage
SELECT *
  FROM sc_khb_srv.tb_com_svc_ip_manage;

/*
1. 서비스 ip 관리=> 데이터 없음
2. 
*/



-- tb_com_thema_info
SELECT *
  FROM sc_khb_srv.tb_com_thema_info;

/*
1. thema_cd, thema_cd_nm은 com_code에 있는데 굳이 또 테이블까지 만들었을까?
 => 75~79는 com_code에도 없다.
2. 
*/



-- tb_com_user
SELECT *
  FROM sc_khb_srv.tb_com_user;

/*pk와 부모사용자pk 비교*/
SELECT *
  FROM sc_khb_srv.tb_com_user
 WHERE user_no_pk != parnts_user_no_pk;
 
/*
1. 사용자에는 관리자(01), 공인중개사(02), 일반인(03) 3개의 그룹이 존재 => 다른 테이블들과 번호가 다르다
2. user_no_pk와 parnts_user_no_pk가 완전히 동일하다. 
 => 다른 행은 0개로 존재하지 않는다.
*/



-- tb_com_user_author
SELECT *
  FROM sc_khb_srv.tb_com_user_author;

/*
1. 데이터 없음
2. 
*/



-- tb_com_user_group
SELECT *
  FROM sc_khb_srv.tb_com_user_group;

/*
1. 그룹번호 pk => 02: 관리자, 03: 공인중개사, 04: 일반인
2. 
*/



-- tb_com_user_ntcn_mapng_info
SELECT *
  FROM sc_khb_srv.tb_com_user_ntcn_mapng_info;

/*
1. 유저 알림 매핑
2. 
*/













 
 
 