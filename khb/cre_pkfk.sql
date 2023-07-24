/*
pk와 fk를 작성하는 쿼리문을 추출하는 파일
작성 일시: 230623
수정 일시: 230714
작 성 자 : 조건영
*/

-- 테이블에서 pk제약조건 삭제
SELECT 
  TABLE_NAME
, 'alter table ' + TABLE_SCHEMA + '.' + TABLE_NAME + ' drop constraint ' + CONSTRAINT_NAME + ';'
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
 WHERE CONSTRAINT_NAME LIKE '%pk_%'
       AND 
       CONSTRAINT_SCHEMA = 'sc_khb_srv'
 ORDER BY 1;

-- 테이블에 primary key 제약조건 만들기
SELECT object_name(c.object_id) "테이블명",
  'alter table sc_khb_srv.' + object_name(c.object_id) + ' add constraint pk_' + object_name(c.object_id) + ' primary key(' + name +');' "pk제약조건 쿼리문"
  FROM sys.columns c
       INNER JOIN
	   (SELECT object_name(object_id) "table_name", min(column_id) "column_id"
		  FROM sys.columns
		 WHERE object_name(object_id) IN (SELECT table_name 
		                                    FROM information_schema.columns 
		                                   WHERE TABLE_SCHEMA = 'sc_khb_srv')
		 GROUP BY object_name(object_id)
	   ) cc
			ON object_name(c.object_id) = cc.table_name 
		       AND 
		       c.column_id = cc.column_id
 ORDER BY 1;
/*
이 쿼리문은 테이블과 열 만 생성하고 pk가 하나일 때 유용 => 다른 DB의 pk를 복제 하는 것은 아니다!! 
*/

-- pk제약조건 조회
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME
  FROM information_schema.constraint_column_usage
 ORDER BY 1;

-- 
SELECT ccu.TABLE_NAME,
       CASE WHEN ccu.COLUMN_NAME != '' THEN 'alter table ' + ccu.TABLE_SCHEMA + '.' + ccu.TABLE_NAME + 
                                            ' add constraint ' + ccu.CONSTRAINT_NAME + ' primary key (' + stuff((SELECT ', ' + COLUMN_NAME
                                                                         FROM information_schema.constraint_column_usage ccu1
                                                                        WHERE CONSTRAINT_NAME LIKE 'PK_%' AND ccu.TABLE_NAME = ccu1.TABLE_NAME
                                                                          FOR xml PATH('')),1,2,'') + ');' 
       END "테이블별 작성 스크립트"
  FROM information_schema.constraint_column_usage ccu
 WHERE ccu.CONSTRAINT_NAME LIKE 'pk%'
 GROUP BY ccu.TABLE_SCHEMA, ccu.TABLE_NAME, ccu.COLUMN_NAME, ccu.CONSTRAINT_NAME
 ORDER BY 1;

-- pk를 조회 할 수 있는 뷰들
SELECT *
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
 WHERE CONSTRAINT_NAME LIKE '%pk_%';


-- fk를 조회 할 수 있는 뷰들
SELECT *
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
 WHERE CONSTRAINT_NAME LIKE '%fk_%';

SELECT *
  FROM sys.foreign_keys;

SELECT *
  FROM sys.foreign_key_columns;

-- fk를 만들기 위한 정보(161)
SELECT 
  object_name(constraint_object_id) "FK 제약조건명"
, object_name(parent_object_id) "기준 테이블명"
, c.COLUMN_NAME "기준 컬럼명"
, object_name(referenced_object_id) "참조 테이블명"
, c.COLUMN_NAME "참조 컬럼명"
  FROM sys.foreign_key_columns fkc
       INNER join
       information_schema.columns c
           ON object_name(fkc.parent_object_id) = c.TABLE_NAME
              AND
              fkc.referenced_column_id = c.ORDINAL_POSITION
 ORDER BY 4, 2;

SELECT 
  a.constraint_name
, a.kid_table_name
, a.kid_column_name
, b.parent_table_name
, b.parent_column_name
  FROM (SELECT 
          object_name(fkc.constraint_object_id) "constraint_name"
        , object_name(fkc.parent_object_id) "kid_table_name"
        , c.name "kid_column_name"
          FROM sys.foreign_key_columns fkc
               INNER JOIN
               sys.columns c
                   ON fkc.parent_object_id = c.object_id 
                      AND 
                      fkc.parent_column_id = c.column_id
       ) a
       INNER JOIN
       (SELECT 
          object_name(fkc.constraint_object_id) "constraint_name"
        , object_name(fkc.referenced_object_id) "parent_table_name"
        , c.name "parent_column_name"
          FROM sys.foreign_key_columns fkc
               INNER JOIN
               sys.columns c
               ON fkc.referenced_object_id  = c.object_id 
                  AND 
                  fkc.referenced_column_id  = c.column_id
       ) b
           ON a.constraint_name = b.constraint_name
 ORDER BY 2, 4;

-- fk 쿼리문 만들기(161)
/*
ALTER TABLE sc_khb_srv.tb_atlfsl_cfr_fclt_info
ADD CONSTRAINT fk_tb_atlfsl_cfr_fclt_info_tb_atlfsl_bsc_info_t
FOREIGN KEY (atlfsl_bsc_info_pk)
REFERENCES sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);
*/

SELECT 
  a.kid_table_name "테이블명"
, a.constraint_name "fk제약조건명"
, 'alter table sc_khb_srv.' + a.kid_table_name + char(13) +
  'add constraint ' + a.constraint_name + char(13) + 
  'foreign key (' + a.kid_column_name + ')' + char(13) +
  'references sc_khb_srv.' + b.parent_table_name + '(' + b.parent_column_name + ');' "fk생성 쿼리문"
, 'alter table sc_khb_srv.' + a.kid_table_name + char(13) +
  'drop constraint ' + a.constraint_name + ';' "fk삭제 쿼리문"
  FROM (SELECT 
          object_name(fkc.constraint_object_id) "constraint_name"
        , object_name(fkc.parent_object_id) "kid_table_name"
        , c.name "kid_column_name"
          FROM sys.foreign_key_columns fkc
               INNER JOIN
               sys.columns c
                   ON fkc.parent_object_id = c.object_id 
                      AND 
                      fkc.parent_column_id = c.column_id
       ) a
       INNER JOIN
       (SELECT 
          object_name(fkc.constraint_object_id) "constraint_name"
        , object_name(fkc.referenced_object_id) "parent_table_name"
        , c.name "parent_column_name"
          FROM sys.foreign_key_columns fkc
               INNER JOIN
               sys.columns c
               ON fkc.referenced_object_id  = c.object_id 
                  AND 
                  fkc.referenced_column_id  = c.column_id
       ) b
           ON a.constraint_name = b.constraint_name
 ORDER BY 1, 2;





-- fk생성 및 생성 안되는 이유
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_batch_hstry_tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_atlfsl_batch_hstry 
add constraint fk_tb_atlfsl_batch_hstry_tb_atlfsl_bsc_info 
foreign key (atlfsl_bsc_info_pk) 
	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

SELECT 
  PRODUCT_NO
, PRODUCT_CATE_CD
  FROM hanbang.hanbang.product_info pi2
 WHERE PRODUCT_NO = ANY(SELECT atlfsl_bsc_info_pk
                          FROM sc_khb_srv.tb_atlfsl_batch_hstry
                        EXCEPT
                        SELECT atlfsl_bsc_info_pk
                          from sc_khb_srv.tb_atlfsl_bsc_info
                         WHERE atlfsl_knd_cd NOT in ('03', '04'));
/*
배치 이력에 매물 타입이 03과 04 인 매물 번호가 들어가 있어서 충돌 발생
*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_batch_hstry_tb_atlfsl_info_app
alter table sc_khb_srv.tb_atlfsl_batch_hstry 
add constraint fk_tb_atlfsl_batch_hstry_tb_atlfsl_info_app 
foreign key (cntnts_no) 
	references sc_khb_srv.tb_atlfsl_info_app(cntnts_no);

/*아직 sc_khb_srv.tb_atlfsl_info_app 라는 테이블 없음*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_bsc_info_tb_lrea_office_info
alter table sc_khb_srv.tb_atlfsl_bsc_info 
add constraint fk_tb_atlfsl_bsc_info_tb_lrea_office_info 
foreign key (lrea_office_info_pk) 
	references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

SELECT lrea_office_info_pk 
  FROM sc_khb_srv.tb_atlfsl_bsc_info
EXCEPT 
SELECT lrea_office_info_pk 
  FROM sc_khb_srv.tb_lrea_office_info;
/*
매물기초 정보에는 공인중개사 번호가 0이 포함 되어 있으므로
0인 데이터를 삭제 시켜야 fk가 생성
*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_cfr_fclt_info_tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_atlfsl_cfr_fclt_info 
add constraint fk_tb_atlfsl_cfr_fclt_info_tb_atlfsl_bsc_info 
foreign key (atlfsl_bsc_info_pk) 
	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_cmrc_dtl_info_tb_atlfsl_bsc_info => tb_atlfsl_cmrc_dtl_info 테이블 삭제
--alter table sc_khb_srv.tb_atlfsl_cmrc_dtl_info 
--add constraint fk_tb_atlfsl_cmrc_dtl_info_tb_atlfsl_bsc_info 
--foreign key (atlfsl_bsc_info_pk) 
--references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_dlng_info_tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_atlfsl_dlng_info 
add constraint fk_tb_atlfsl_dlng_info_tb_atlfsl_bsc_info 
foreign key (atlfsl_bsc_info_pk)
	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_etc_dtl_info_tb_atlfsl_bsc_info => tb_atlfsl_etc_dtl_info 테이블 삭제
--alter table sc_khb_srv.tb_atlfsl_etc_dtl_info 
--add constraint fk_tb_atlfsl_etc_dtl_info_tb_atlfsl_bsc_info 
--foreign key (atlfsl_bsc_info_pk) 
--	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_etc_info_tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_atlfsl_etc_info 
add constraint fk_tb_atlfsl_etc_info_tb_atlfsl_bsc_info 
foreign key (atlfsl_bsc_info_pk) 
	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_img_info_tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_atlfsl_img_info 
add constraint fk_tb_atlfsl_img_info_tb_atlfsl_bsc_info 
foreign key (atlfsl_bsc_info_pk) 
	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_inqry_info_tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_atlfsl_inqry_info 
add constraint fk_tb_atlfsl_inqry_info_tb_atlfsl_bsc_info 
foreign key (atlfsl_bsc_info_pk) 
references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);


/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_inqry_info_tb_com_user
alter table sc_khb_srv.tb_atlfsl_inqry_info 
add constraint fk_tb_atlfsl_inqry_info_tb_com_user 
foreign key (user_no_pk) 
references sc_khb_srv.tb_com_user(user_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_land_usg_info_tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_atlfsl_land_usg_info 
add constraint fk_tb_atlfsl_land_usg_info_tb_atlfsl_bsc_info 
foreign key (atlfsl_bsc_info_pk) 
	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_reside_gnrl_dtl_info_tb_atlfsl_bsc_info => tb_atlfsl_reside_gnrl_dtl_info 테이블 삭제
--alter table sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info 
--add constraint fk_tb_atlfsl_reside_gnrl_dtl_info_tb_atlfsl_bsc_info 
--foreign key (atlfsl_bsc_info_pk) 
--	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_atlfsl_reside_set_dtl_info_tb_atlfsl_bsc_info => tb_atlfsl_reside_set_dtl_info 테이블 삭제
--alter table sc_khb_srv.tb_atlfsl_reside_set_dtl_info 
--add constraint fk_tb_atlfsl_reside_set_dtl_info_tb_atlfsl_bsc_info 
--foreign key (atlfsl_bsc_info_pk) 
--	references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_bbs_cmnt_tb_com_bbs
alter table sc_khb_srv.tb_com_bbs_cmnt 
add constraint fk_tb_com_bbs_cmnt_tb_com_bbs 
foreign key (bbs_pk) 
	references sc_khb_srv.tb_com_bbs(bbs_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_device_info_tb_com_user
alter table sc_khb_srv.tb_com_device_info 
add constraint fk_tb_com_device_info_tb_com_user 
foreign key (user_no_pk) 
references sc_khb_srv.tb_com_user(user_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_device_ntcn_mapng_info_tb_com_device_info
alter table sc_khb_srv.tb_com_device_ntcn_mapng_info 
add constraint fk_tb_com_device_ntcn_mapng_info_tb_com_device_info 
foreign key (device_info_pk) 
references sc_khb_srv.tb_com_device_info(device_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_device_ntcn_mapng_info_tb_com_ntcn_info
alter table sc_khb_srv.tb_com_device_ntcn_mapng_info 
add constraint fk_tb_com_device_ntcn_mapng_info_tb_com_ntcn_info 
foreign key (ntcn_info_pk) 
references sc_khb_srv.tb_com_ntcn_info(ntcn_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_device_stng_info_tb_com_device_info
alter table sc_khb_srv.tb_com_device_stng_info 
add constraint fk_tb_com_device_stng_info_tb_com_device_info 
foreign key (device_info_pk) 
references sc_khb_srv.tb_com_device_info(device_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_emd_li_cd_tb_com_ctpv_cd
alter table sc_khb_srv.tb_com_emd_li_cd 
add constraint fk_tb_com_emd_li_cd_tb_com_ctpv_cd 
foreign key (ctpv_cd_pk) 
	references sc_khb_srv.tb_com_ctpv_cd(ctpv_cd_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_emd_li_cd_tb_com_sgg_cd
alter table sc_khb_srv.tb_com_emd_li_cd 
add constraint fk_tb_com_emd_li_cd_tb_com_sgg_cd
foreign key (sgg_cd_pk) 
	references sc_khb_srv.tb_com_sgg_cd(sgg_cd_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_file_tb_com_file_mapng
alter table sc_khb_srv.tb_com_file 
add constraint fk_tb_com_file_tb_com_file_mapng 
foreign key (file_no_pk) 
references sc_khb_srv.tb_com_file_mapng(file_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_file_mapng_tb_com_recsroom
alter table sc_khb_srv.tb_com_file_mapng 
add constraint fk_tb_com_file_mapng_tb_com_recsroom 
foreign key (recsroom_no_pk) 
references sc_khb_srv.tb_com_recsroom(recsroom_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_file_mapng_tb_com_user
alter table sc_khb_srv.tb_com_file_mapng 
add constraint fk_tb_com_file_mapng_tb_com_user 
foreign key (user_no_pk) 
references sc_khb_srv.tb_com_user(user_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_group_author_tb_com_author
alter table sc_khb_srv.tb_com_group_author 
add constraint fk_tb_com_group_author_tb_com_author 
foreign key (author_no_pk) 
references sc_khb_srv.tb_com_author(author_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_group_author_tb_com_group
alter table sc_khb_srv.tb_com_group_author 
add constraint fk_tb_com_group_author_tb_com_group 
foreign key (group_no_pk) 
references sc_khb_srv.tb_com_group(group_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_gtwy_svc_author_tb_com_author
alter table sc_khb_srv.tb_com_gtwy_svc_author 
add constraint fk_tb_com_gtwy_svc_author_tb_com_author 
foreign key (author_no_pk) 
references sc_khb_srv.tb_com_author(author_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_gtwy_svc_author_tb_com_gtwy_svc
alter table sc_khb_srv.tb_com_gtwy_svc_author 
add constraint fk_tb_com_gtwy_svc_author_tb_com_gtwy_svc 
foreign key (gtwy_svc_pk) 
references sc_khb_srv.tb_com_gtwy_svc(gtwy_svc_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_job_schdl_hstry_tb_com_job_schdl_info
alter table sc_khb_srv.tb_com_job_schdl_hstry 
add constraint fk_tb_com_job_schdl_hstry_tb_com_job_schdl_info 
foreign key (job_schdl_info_pk) 
references sc_khb_srv.tb_com_job_schdl_info(job_schdl_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_menu_tb_com_scrin
alter table sc_khb_srv.tb_com_menu 
add constraint fk_tb_com_menu_tb_com_scrin 
foreign key (scrin_no_pk) 
references sc_khb_srv.tb_com_scrin(scrin_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_menu_author_tb_com_author
alter table sc_khb_srv.tb_com_menu_author 
add constraint fk_tb_com_menu_author_tb_com_author 
foreign key (author_no_pk) 
references sc_khb_srv.tb_com_author(author_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_menu_author_tb_com_menu
alter table sc_khb_srv.tb_com_menu_author 
add constraint fk_tb_com_menu_author_tb_com_menu 
foreign key (menu_no_pk) 
references sc_khb_srv.tb_com_menu(menu_no_pk);

SELECT *
  FROM sc_khb_srv.tb_com_menu_author;

SELECT *
  FROM sc_khb_srv.tb_com_menu;
/*com_menu에 없던 18번을 삭제하고 관계선을 맺음!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_scrin_author_tb_com_author
alter table sc_khb_srv.tb_com_scrin_author 
add constraint fk_tb_com_scrin_author_tb_com_author 
foreign key (author_no_pk) 
references sc_khb_srv.tb_com_author(author_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_scrin_author_tb_com_scrin
alter table sc_khb_srv.tb_com_scrin_author 
add constraint fk_tb_com_scrin_author_tb_com_scrin 
foreign key (scrin_no_pk) 
references sc_khb_srv.tb_com_scrin(scrin_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_sgg_cd_tb_com_ctpv_cd
alter table sc_khb_srv.tb_com_sgg_cd 
add constraint fk_tb_com_sgg_cd_tb_com_ctpv_cd 
foreign key (ctpv_cd_pk) 
references sc_khb_srv.tb_com_ctpv_cd(ctpv_cd_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_stplat_hist_tb_com_stplat_info
alter table sc_khb_srv.tb_com_stplat_hist 
add constraint fk_tb_com_stplat_hist_tb_com_stplat_info 
foreign key (com_stplat_info_pk) 
references sc_khb_srv.tb_com_stplat_info(com_stplat_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_stplat_mapng_tb_com_stplat_info
alter table sc_khb_srv.tb_com_stplat_mapng 
add constraint fk_tb_com_stplat_mapng_tb_com_stplat_info 
foreign key (com_stplat_info_pk) 
references sc_khb_srv.tb_com_stplat_info(com_stplat_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_stplat_mapng_tb_com_user
alter table sc_khb_srv.tb_com_stplat_mapng 
add constraint fk_tb_com_stplat_mapng_tb_com_user 
foreign key (user_no_pk)
references sc_khb_srv.tb_com_user(user_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_svc_ip_manage_tb_com_author
alter table sc_khb_srv.tb_com_svc_ip_manage 
add constraint fk_tb_com_svc_ip_manage_tb_com_author 
foreign key (author_no_pk) 
references sc_khb_srv.tb_com_author(author_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_svc_ip_manage_tb_com_author
alter table sc_khb_srv.tb_com_svc_ip_manage 
add constraint fk_tb_com_svc_ip_manage_tb_com_author 
foreign key (author_no_pk) 
references sc_khb_srv.tb_com_author(author_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_user_author_tb_com_author
alter table sc_khb_srv.tb_com_user_author 
add constraint fk_tb_com_user_author_tb_com_author 
foreign key (author_no_pk) 
references sc_khb_srv.tb_com_author(author_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_user_author_tb_com_user
alter table sc_khb_srv.tb_com_user_author 
add constraint fk_tb_com_user_author_tb_com_user 
foreign key (user_no_pk) 
references sc_khb_srv.tb_com_user(user_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_user_group_tb_com_group
alter table sc_khb_srv.tb_com_user_group 
add constraint fk_tb_com_user_group_tb_com_group 
foreign key (group_no_pk) 
references sc_khb_srv.tb_com_group(group_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_user_group_tb_com_user
alter table sc_khb_srv.tb_com_user_group 
add constraint fk_tb_com_user_group_tb_com_user
foreign key (user_no_pk)
references sc_khb_srv.tb_com_user(user_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_user_ntcn_mapng_info_tb_com_ntcn_info
alter table sc_khb_srv.tb_com_user_ntcn_mapng_info 
add constraint fk_tb_com_user_ntcn_mapng_info_tb_com_ntcn_info 
foreign key (ntcn_info_pk) 
references sc_khb_srv.tb_com_ntcn_info(ntcn_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_com_user_ntcn_mapng_info_tb_com_user
alter table sc_khb_srv.tb_com_user_ntcn_mapng_info 
add constraint fk_tb_com_user_ntcn_mapng_info_tb_com_user 
foreign key (user_no_pk)
references sc_khb_srv.tb_com_user(user_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_hsmp_dtl_info_tb_hsmp_info
alter table sc_khb_srv.tb_hsmp_dtl_info 
add constraint fk_tb_hsmp_dtl_info_tb_hsmp_info 
foreign key (hsmp_info_pk) 
references sc_khb_srv.tb_hsmp_info(hsmp_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_itrst_atlfsl_info_tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_itrst_atlfsl_info 
add constraint fk_tb_itrst_atlfsl_info_tb_atlfsl_bsc_info 
foreign key (atlfsl_bsc_info_pk) 
references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_itrst_atlfsl_info_tb_com_user
alter table sc_khb_srv.tb_itrst_atlfsl_info 
add constraint fk_tb_itrst_atlfsl_info_tb_com_user 
foreign key (user_no_pk) 
	references sc_khb_srv.tb_com_user(user_no_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_itrst_atlfsl_info_tb_hsmp_info
alter table sc_khb_srv.tb_itrst_atlfsl_info 
add constraint fk_tb_itrst_atlfsl_info_tb_hsmp_info 
foreign key (hsmp_info_pk) 
	references sc_khb_srv.tb_hsmp_info(hsmp_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_itrst_atlfsl_info_tb_lrea_office_info
alter table sc_khb_srv.tb_itrst_atlfsl_info 
add constraint fk_tb_itrst_atlfsl_info_tb_lrea_office_info 
foreign key (lrea_office_info_pk) 
	references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_user_atlfsl_img_info_tb_user_atlfsl_info
alter table sc_khb_srv.tb_user_atlfsl_img_info 
add constraint fk_tb_user_atlfsl_img_info_tb_user_atlfsl_info 
foreign key (user_atlfsl_info_pk) 
	references sc_khb_srv.tb_user_atlfsl_info(user_atlfsl_info_pk);
 
/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_user_atlfsl_info_tb_com_user
alter table sc_khb_srv.tb_user_atlfsl_info 
add constraint fk_tb_user_atlfsl_info_tb_com_user 
foreign key (user_no_pk) 
	references sc_khb_srv.tb_com_user(user_no_pk);
 
/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_user_atlfsl_preocupy_info_tb_lrea_office_info
alter table sc_khb_srv.tb_user_atlfsl_preocupy_info 
add constraint fk_tb_user_atlfsl_preocupy_info_tb_lrea_office_info 
foreign key (lrea_office_info_pk) 
references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------
-- fk_tb_user_atlfsl_preocupy_info_tb_user_atlfsl_info
alter table sc_khb_srv.tb_user_atlfsl_preocupy_info 
add constraint fk_tb_user_atlfsl_preocupy_info_tb_user_atlfsl_info 
foreign key (user_atlfsl_info_pk) 
	references sc_khb_srv.tb_user_atlfsl_info(user_atlfsl_info_pk);
 
/*성공!!*/
-----------------------------------------------------------------------------------------------------------------------------------









