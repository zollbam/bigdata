/*
작성 일자 : 230911
수정 일자 : 
작 성 자 : 조건영
작성 목적 : 161번의 테이블과 txt파일로 이관된 테이블의 비교
*/



-- 비교 쿼리 작성
SELECT table_name
     , concat(
              'SELECT *', char(10),
              '  from db_khb_srv_230908.sc_khb_srv.', table_name, ' c1', char(10),
              '       left join', char(10),
              '       db_khb_srv.sc_khb_srv.', table_name, ' c2', char(10),
              '              on ', stuff(
                                         (
                                          select CASE WHEN ORDINAL_POSITION = 1 THEN '    c1.' + COLUMN_NAME 
                                                      WHEN ORDINAL_POSITION = 2 THEN 'where(' + char(10) + SPACE(7) +
                                                                                     'case when cast(c1.' + column_name + ' as nvarchar(max)) in (null, '''') then ''''' + char(10) + SPACE(12) + 
                                                                                     'else c1.' + COLUMN_NAME + char(10) + SPACE(8) + 
                                                                                     'end'
                                                      ELSE '   or case when cast(c1.' + column_name + ' as nvarchar(max)) in (null, '''') then ''''' + char(10) + SPACE(14) + 
                                                           'else c1.' + COLUMN_NAME + char(10) + SPACE(8) + 
                                                           'end'
                                                  END + 
                                                 CASE WHEN a2.ORDINAL_POSITION = 1 THEN ' = c2.' + COLUMN_NAME 
                                                      ELSE ' !=' + char(10) + SPACE(7) + 
                                                           'case when cast(c2.' + column_name + ' as nvarchar(max)) in (null, '''') then ''''' + char(10) + SPACE(12) + 
                                                           'else c2.' + COLUMN_NAME + char(10) + SPACE(8) + 
                                                           'end'
                                                  END + 
                                                 CASE WHEN ORDINAL_POSITION = (
                                                                               SELECT max(ORDINAL_POSITION)
                                                                                 FROM information_schema.columns
                                                                                WHERE table_name = 'tb_user_atlfsl_preocupy_info'
                                                                              ) THEN ')'
                                                      ELSE char(10) + ' '
                                                  END
                                             from information_schema.columns a2
                                            WHERE a1.TABLE_NAME = a2.table_name
                                              AND DATA_TYPE != 'geometry'
                                              AND table_name = 'tb_user_atlfsl_preocupy_info'
                                            ORDER BY a2.ORDINAL_POSITION
                                              fOR xml PATH('')
                                         ), 1, 4,''
                                        ),
             ';') 
  FROM information_schema.columns a1
 WHERE TABLE_CATALOG = 'db_khb_srv'
   AND TABLE_NAME = 'tb_user_atlfsl_preocupy_info'
 GROUP BY table_name
 ORDER BY table_name;
/*
1. 161번에 있는 현재 테스트 서버의 데이터와
   이제껏 만들어온 txt파일로 이관한 테이블에
   값이 잘 들어갔는지 확인하기 위한 쿼리
2. TABLE_NAME 변수가 3개나 있어 모든 쿼리값에북어여다.
3.  
*/



-- 1. tb_atlfsl_bsc_info
SELECT count(*), count(DISTINCT c1.atlfsl_bsc_info_pk)
  from db_khb_srv_230908.sc_khb_srv.tb_atlfsl_bsc_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_atlfsl_bsc_info c2
              on c1.atlfsl_bsc_info_pk = c2.atlfsl_bsc_info_pk
 where(
       case when cast(c1.asoc_atlfsl_no as nvarchar(max)) in (null, '') then ''
            else c1.asoc_atlfsl_no
        end !=
       case when cast(c2.asoc_atlfsl_no as nvarchar(max)) in (null, '') then ''
            else c2.asoc_atlfsl_no
        end
    or case when cast(c1.asoc_app_intrlck_no as nvarchar(max)) in (null, '') then ''
              else c1.asoc_app_intrlck_no
        end !=
       case when cast(c2.asoc_app_intrlck_no as nvarchar(max)) in (null, '') then ''
            else c2.asoc_app_intrlck_no
        end
    or case when cast(c1.lrea_office_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_info_pk
        end !=
       case when cast(c2.lrea_office_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_info_pk
        end
    or case when cast(c1.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.ctpv_cd_pk
        end !=
       case when cast(c2.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_cd_pk
        end
    or case when cast(c1.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.sgg_cd_pk
        end !=
       case when cast(c2.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.sgg_cd_pk
        end
    or case when cast(c1.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.emd_li_cd_pk
        end !=
       case when cast(c2.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.emd_li_cd_pk
        end
    or case when cast(c1.hsmp_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.hsmp_info_pk
        end !=
       case when cast(c2.hsmp_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.hsmp_info_pk
        end
    or case when cast(c1.hsmp_dtl_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.hsmp_dtl_info_pk
        end !=
       case when cast(c2.hsmp_dtl_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.hsmp_dtl_info_pk
        end
    or case when cast(c1.atlfsl_ty_cd as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_ty_cd
        end !=
       case when cast(c2.atlfsl_ty_cd as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_ty_cd
        end
    or case when cast(c1.atlfsl_dtl_ty_cd as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_dtl_ty_cd
        end !=
       case when cast(c2.atlfsl_dtl_ty_cd as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_dtl_ty_cd
        end
    or case when cast(c1.atlfsl_knd_cd as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_knd_cd
        end !=
       case when cast(c2.atlfsl_knd_cd as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_knd_cd
        end
    or case when cast(c1.stdg_dong_cd as nvarchar(max)) in (null, '') then ''
              else c1.stdg_dong_cd
        end !=
       case when cast(c2.stdg_dong_cd as nvarchar(max)) in (null, '') then ''
            else c2.stdg_dong_cd
        end
    or case when cast(c1.stdg_cd as nvarchar(max)) in (null, '') then ''
              else c1.stdg_cd
        end !=
       case when cast(c2.stdg_cd as nvarchar(max)) in (null, '') then ''
            else c2.stdg_cd
        end
    or case when cast(c1.stdg_innb as nvarchar(max)) in (null, '') then ''
              else c1.stdg_innb
        end !=
       case when cast(c2.stdg_innb as nvarchar(max)) in (null, '') then ''
            else c2.stdg_innb
        end
    or case when cast(c1.dong_innb as nvarchar(max)) in (null, '') then ''
              else c1.dong_innb
        end !=
       case when cast(c2.dong_innb as nvarchar(max)) in (null, '') then ''
            else c2.dong_innb
        end
    or case when cast(c1.mno as nvarchar(max)) in (null, '') then ''
              else c1.mno
        end !=
       case when cast(c2.mno as nvarchar(max)) in (null, '') then ''
            else c2.mno
        end
    or case when cast(c1.sno as nvarchar(max)) in (null, '') then ''
              else c1.sno
        end !=
       case when cast(c2.sno as nvarchar(max)) in (null, '') then ''
            else c2.sno
        end
    or case when cast(c1.aptcmpl_nm as nvarchar(max)) in (null, '') then ''
              else c1.aptcmpl_nm
        end !=
       case when cast(c2.aptcmpl_nm as nvarchar(max)) in (null, '') then ''
            else c2.aptcmpl_nm
        end
    or case when cast(c1.ho_nm as nvarchar(max)) in (null, '') then ''
              else c1.ho_nm
        end !=
       case when cast(c2.ho_nm as nvarchar(max)) in (null, '') then ''
            else c2.ho_nm
        end
    or case when cast(c1.atlfsl_lot as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_lot
        end !=
       case when cast(c2.atlfsl_lot as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_lot
        end
    or case when cast(c1.atlfsl_lat as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_lat
        end !=
       case when cast(c2.atlfsl_lat as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_lat
        end
    or case when cast(c1.atlfsl_trsm_dt as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_trsm_dt
        end !=
       case when cast(c2.atlfsl_trsm_dt as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_trsm_dt
        end
    or case when cast(c1.bldg_aptcmpl_indct_yn as nvarchar(max)) in (null, '') then ''
              else c1.bldg_aptcmpl_indct_yn
        end !=
       case when cast(c2.bldg_aptcmpl_indct_yn as nvarchar(max)) in (null, '') then ''
            else c2.bldg_aptcmpl_indct_yn
        end
    or case when cast(c1.pyeong_indct_yn as nvarchar(max)) in (null, '') then ''
              else c1.pyeong_indct_yn
        end !=
       case when cast(c2.pyeong_indct_yn as nvarchar(max)) in (null, '') then ''
            else c2.pyeong_indct_yn
        end
    or case when cast(c1.vr_exst_yn as nvarchar(max)) in (null, '') then ''
              else c1.vr_exst_yn
        end !=
       case when cast(c2.vr_exst_yn as nvarchar(max)) in (null, '') then ''
            else c2.vr_exst_yn
        end
    or case when cast(c1.img_exst_yn as nvarchar(max)) in (null, '') then ''
              else c1.img_exst_yn
        end !=
       case when cast(c2.img_exst_yn as nvarchar(max)) in (null, '') then ''
            else c2.img_exst_yn
        end
    or case when cast(c1.pic_no as nvarchar(max)) in (null, '') then ''
              else c1.pic_no
        end !=
       case when cast(c2.pic_no as nvarchar(max)) in (null, '') then ''
            else c2.pic_no
        end
    or case when cast(c1.pic_nm as nvarchar(max)) in (null, '') then ''
              else c1.pic_nm
        end !=
       case when cast(c2.pic_nm as nvarchar(max)) in (null, '') then ''
            else c2.pic_nm
        end
    or case when cast(c1.pic_telno as nvarchar(max)) in (null, '') then ''
              else c1.pic_telno
        end !=
       case when cast(c2.pic_telno as nvarchar(max)) in (null, '') then ''
            else c2.pic_telno
        end
    or case when cast(c1.dtl_scrn_prsl_cnt as nvarchar(max)) in (null, '') then ''
              else c1.dtl_scrn_prsl_cnt
        end !=
       case when cast(c2.dtl_scrn_prsl_cnt as nvarchar(max)) in (null, '') then ''
            else c2.dtl_scrn_prsl_cnt
        end
    or case when cast(c1.prvuse_area as nvarchar(max)) in (null, '') then ''
              else c1.prvuse_area
        end !=
       case when cast(c2.prvuse_area as nvarchar(max)) in (null, '') then ''
            else c2.prvuse_area
        end
    or case when cast(c1.sply_area as nvarchar(max)) in (null, '') then ''
              else c1.sply_area
        end !=
       case when cast(c2.sply_area as nvarchar(max)) in (null, '') then ''
            else c2.sply_area
        end
    or case when cast(c1.plot_area as nvarchar(max)) in (null, '') then ''
              else c1.plot_area
        end !=
       case when cast(c2.plot_area as nvarchar(max)) in (null, '') then ''
            else c2.plot_area
        end
    or case when cast(c1.arch_area as nvarchar(max)) in (null, '') then ''
              else c1.arch_area
        end !=
       case when cast(c2.arch_area as nvarchar(max)) in (null, '') then ''
            else c2.arch_area
        end
    or case when cast(c1.room_cnt as nvarchar(max)) in (null, '') then ''
              else c1.room_cnt
        end !=
       case when cast(c2.room_cnt as nvarchar(max)) in (null, '') then ''
            else c2.room_cnt
        end
    or case when cast(c1.toilet_cnt as nvarchar(max)) in (null, '') then ''
              else c1.toilet_cnt
        end !=
       case when cast(c2.toilet_cnt as nvarchar(max)) in (null, '') then ''
            else c2.toilet_cnt
        end
    or case when cast(c1.atlfsl_inq_cnt as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_inq_cnt
        end !=
       case when cast(c2.atlfsl_inq_cnt as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_inq_cnt
        end
    or case when cast(c1.flr_expsr_mthd_cd as nvarchar(max)) in (null, '') then ''
              else c1.flr_expsr_mthd_cd
        end !=
       case when cast(c2.flr_expsr_mthd_cd as nvarchar(max)) in (null, '') then ''
            else c2.flr_expsr_mthd_cd
        end
    or case when cast(c1.now_flr_expsr_mthd_cd as nvarchar(max)) in (null, '') then ''
              else c1.now_flr_expsr_mthd_cd
        end !=
       case when cast(c2.now_flr_expsr_mthd_cd as nvarchar(max)) in (null, '') then ''
            else c2.now_flr_expsr_mthd_cd
        end
    or case when cast(c1.flr_cnt as nvarchar(max)) in (null, '') then ''
              else c1.flr_cnt
        end !=
       case when cast(c2.flr_cnt as nvarchar(max)) in (null, '') then ''
            else c2.flr_cnt
        end
    or case when cast(c1.top_flr_cnt as nvarchar(max)) in (null, '') then ''
              else c1.top_flr_cnt
        end !=
       case when cast(c2.top_flr_cnt as nvarchar(max)) in (null, '') then ''
            else c2.top_flr_cnt
        end
    or case when cast(c1.grnd_flr_cnt as nvarchar(max)) in (null, '') then ''
              else c1.grnd_flr_cnt
        end !=
       case when cast(c2.grnd_flr_cnt as nvarchar(max)) in (null, '') then ''
            else c2.grnd_flr_cnt
        end
    or case when cast(c1.udgd_flr_cnt as nvarchar(max)) in (null, '') then ''
              else c1.udgd_flr_cnt
        end !=
       case when cast(c2.udgd_flr_cnt as nvarchar(max)) in (null, '') then ''
            else c2.udgd_flr_cnt
        end
    or case when cast(c1.stairs_stle_cd as nvarchar(max)) in (null, '') then ''
              else c1.stairs_stle_cd
        end !=
       case when cast(c2.stairs_stle_cd as nvarchar(max)) in (null, '') then ''
            else c2.stairs_stle_cd
        end
    or case when cast(c1.drc_cd as nvarchar(max)) in (null, '') then ''
              else c1.drc_cd
        end !=
       case when cast(c2.drc_cd as nvarchar(max)) in (null, '') then ''
            else c2.drc_cd
        end
    or case when cast(c1.blcn_cd as nvarchar(max)) in (null, '') then ''
              else c1.blcn_cd
        end !=
       case when cast(c2.blcn_cd as nvarchar(max)) in (null, '') then ''
            else c2.blcn_cd
        end
    or case when cast(c1.pstn_expln_cn as nvarchar(max)) in (null, '') then ''
              else c1.pstn_expln_cn
        end !=
       case when cast(c2.pstn_expln_cn as nvarchar(max)) in (null, '') then ''
            else c2.pstn_expln_cn
        end
    or case when cast(c1.parkng_psblty_yn as nvarchar(max)) in (null, '') then ''
              else c1.parkng_psblty_yn
        end !=
       case when cast(c2.parkng_psblty_yn as nvarchar(max)) in (null, '') then ''
            else c2.parkng_psblty_yn
        end
    or case when cast(c1.parkng_cnt as nvarchar(max)) in (null, '') then ''
              else c1.parkng_cnt
        end !=
       case when cast(c2.parkng_cnt as nvarchar(max)) in (null, '') then ''
            else c2.parkng_cnt
        end
    or case when cast(c1.cmcn_day as nvarchar(max)) in (null, '') then ''
              else c1.cmcn_day
        end !=
       case when cast(c2.cmcn_day as nvarchar(max)) in (null, '') then ''
            else c2.cmcn_day
        end
    or case when cast(c1.financ_amt as nvarchar(max)) in (null, '') then ''
              else c1.financ_amt
        end !=
       case when cast(c2.financ_amt as nvarchar(max)) in (null, '') then ''
            else c2.financ_amt
        end
    or case when cast(c1.use_yn as nvarchar(max)) in (null, '') then ''
              else c1.use_yn
        end !=
       case when cast(c2.use_yn as nvarchar(max)) in (null, '') then ''
            else c2.use_yn
        end
    or case when cast(c1.clustr_info_stts_cd as nvarchar(max)) in (null, '') then ''
              else c1.clustr_info_stts_cd
        end !=
       case when cast(c2.clustr_info_stts_cd as nvarchar(max)) in (null, '') then ''
            else c2.clustr_info_stts_cd
        end
    or case when cast(c1.push_stts_cd as nvarchar(max)) in (null, '') then ''
              else c1.push_stts_cd
        end !=
       case when cast(c2.push_stts_cd as nvarchar(max)) in (null, '') then ''
            else c2.push_stts_cd
        end
    or case when cast(c1.rcmdtn_yn as nvarchar(max)) in (null, '') then ''
              else c1.rcmdtn_yn
        end !=
       case when cast(c2.rcmdtn_yn as nvarchar(max)) in (null, '') then ''
            else c2.rcmdtn_yn
        end
    or case when cast(c1.auc_yn as nvarchar(max)) in (null, '') then ''
              else c1.auc_yn
        end !=
       case when cast(c2.auc_yn as nvarchar(max)) in (null, '') then ''
            else c2.auc_yn
        end
    or case when cast(c1.atlfsl_stts_cd as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_stts_cd
        end !=
       case when cast(c2.atlfsl_stts_cd as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_stts_cd
        end
    or case when cast(c1.totar as nvarchar(max)) in (null, '') then ''
              else c1.totar
        end !=
       case when cast(c2.totar as nvarchar(max)) in (null, '') then ''
            else c2.totar
        end
    or case when cast(c1.atlfsl_vrfc_yn as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_vrfc_yn
        end !=
       case when cast(c2.atlfsl_vrfc_yn as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_vrfc_yn
        end
    or case when cast(c1.atlfsl_vrfc_day as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_vrfc_day
        end !=
       case when cast(c2.atlfsl_vrfc_day as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_vrfc_day
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);



SELECT c1.atlfsl_bsc_info_pk, c1.dtl_scrn_prsl_cnt, c2.dtl_scrn_prsl_cnt
  FROM db_khb_srv_230908.sc_khb_srv.tb_atlfsl_bsc_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_atlfsl_bsc_info c2
              ON c1.atlfsl_bsc_info_pk= c2.atlfsl_bsc_info_pk
 WHERE CAST(c1.dtl_scrn_prsl_cnt AS nvarchar(max)) 
       != 
       CAST(c2.dtl_scrn_prsl_cnt AS nvarchar(max));


/*
1. ho_nm 9개
 => article_a에도 있지만 product 에서만 가지고 온다.
2. dtl_scrn_prsl_cnt 1개
 => atlfsl_bsc_info_pk의 19861172가 열람수가 1에서 2로??
3. room 21개
 => article에도 있지만 product 에서만 가지고 온다.
4. atlfsl_inq_cnt 3개
 => 매물 조회 수도 변경 된 경우가 존재
5. totar 15개 
 => 기존에는 c에 없으면 d에서 d에 없으면 ef에서 값을 찾았지만
 => 지금은 ef에 없으면 d에서 d에 없으면 c에서 값을 찾는 방식
 => 0인 데이터를 최소한 하기 위해 txt파일을 변경해서 결과로 나오는 개수가 15개가 아닐수도 있다.
6. reg_dt 57개
 => product에서만 가지고 온다.
7. mdfcn_dt 11개
 => 
8. hsmp_info_pk 7개
 => product_info테이블에서 가져온다.
*/



SELECT *
  FROM db_khb_srv_230908.sc_khb_srv.tb_atlfsl_bsc_info;


-- tb_atlfsl_cfr_fclt_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_atlfsl_cfr_fclt_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_atlfsl_cfr_fclt_info c2
              on c1.atlfsl_cfr_fclt_info_pk = c2.atlfsl_cfr_fclt_info_pk
 where(
       case when cast(c1.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.atlfsl_bsc_info_pk
        end !=
       case when cast(c2.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_bsc_info_pk
        end
    or case when cast(c1.heat_mthd_cd_list as nvarchar(max)) in (null, '') then ''
              else c1.heat_mthd_cd_list
        end !=
       case when cast(c2.heat_mthd_cd_list as nvarchar(max)) in (null, '') then ''
            else c2.heat_mthd_cd_list
        end
    or case when cast(c1.heat_fuel_cd_list as nvarchar(max)) in (null, '') then ''
              else c1.heat_fuel_cd_list
        end !=
       case when cast(c2.heat_fuel_cd_list as nvarchar(max)) in (null, '') then ''
            else c2.heat_fuel_cd_list
        end
    or case when cast(c1.arclng_fclt_cd_list as nvarchar(max)) in (null, '') then ''
              else c1.arclng_fclt_cd_list
        end !=
       case when cast(c2.arclng_fclt_cd_list as nvarchar(max)) in (null, '') then ''
            else c2.arclng_fclt_cd_list
        end
    or case when cast(c1.lvlh_fclt_cd_list as nvarchar(max)) in (null, '') then ''
              else c1.lvlh_fclt_cd_list
        end !=
       case when cast(c2.lvlh_fclt_cd_list as nvarchar(max)) in (null, '') then ''
            else c2.lvlh_fclt_cd_list
        end
    or case when cast(c1.scrty_fclt_cd_list as nvarchar(max)) in (null, '') then ''
              else c1.scrty_fclt_cd_list
        end !=
       case when cast(c2.scrty_fclt_cd_list as nvarchar(max)) in (null, '') then ''
            else c2.scrty_fclt_cd_list
        end
    or case when cast(c1.etc_fclt_cd_list as nvarchar(max)) in (null, '') then ''
              else c1.etc_fclt_cd_list
        end !=
       case when cast(c2.etc_fclt_cd_list as nvarchar(max)) in (null, '') then ''
            else c2.etc_fclt_cd_list
        end
    or case when cast(c1.arclng_mthd_cd_list as nvarchar(max)) in (null, '') then ''
              else c1.arclng_mthd_cd_list
        end !=
       case when cast(c2.arclng_mthd_cd_list as nvarchar(max)) in (null, '') then ''
            else c2.arclng_mthd_cd_list
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);

/*완전 동일*/



-- tb_atlfsl_dlng_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_atlfsl_dlng_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_atlfsl_dlng_info c2
              on c1.atlfsl_dlng_info_pk = c2.atlfsl_dlng_info_pk
 where(
       case when cast(c1.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.atlfsl_bsc_info_pk
        end !=
       case when cast(c2.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_bsc_info_pk
        end
    or case when cast(c1.dlng_se_cd as nvarchar(max)) in (null, '') then ''
              else c1.dlng_se_cd
        end !=
       case when cast(c2.dlng_se_cd as nvarchar(max)) in (null, '') then ''
            else c2.dlng_se_cd
        end
    or case when cast(c1.trde_amt as nvarchar(max)) in (null, '') then ''
              else c1.trde_amt
        end !=
       case when cast(c2.trde_amt as nvarchar(max)) in (null, '') then ''
            else c2.trde_amt
        end
    or case when cast(c1.lfsts_amt as nvarchar(max)) in (null, '') then ''
              else c1.lfsts_amt
        end !=
       case when cast(c2.lfsts_amt as nvarchar(max)) in (null, '') then ''
            else c2.lfsts_amt
        end
    or case when cast(c1.mtht_amt as nvarchar(max)) in (null, '') then ''
              else c1.mtht_amt
        end !=
       case when cast(c2.mtht_amt as nvarchar(max)) in (null, '') then ''
            else c2.mtht_amt
        end
    or case when cast(c1.financ_amt as nvarchar(max)) in (null, '') then ''
              else c1.financ_amt
        end !=
       case when cast(c2.financ_amt as nvarchar(max)) in (null, '') then ''
            else c2.financ_amt
        end
    or case when cast(c1.now_lfsts_amt as nvarchar(max)) in (null, '') then ''
              else c1.now_lfsts_amt
        end !=
       case when cast(c2.now_lfsts_amt as nvarchar(max)) in (null, '') then ''
            else c2.now_lfsts_amt
        end
    or case when cast(c1.now_mtht_amt as nvarchar(max)) in (null, '') then ''
              else c1.now_mtht_amt
        end !=
       case when cast(c2.now_mtht_amt as nvarchar(max)) in (null, '') then ''
            else c2.now_mtht_amt
        end
    or case when cast(c1.premium as nvarchar(max)) in (null, '') then ''
              else c1.premium
        end !=
       case when cast(c2.premium as nvarchar(max)) in (null, '') then ''
            else c2.premium
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end
    or case when cast(c1.mng_amt as nvarchar(max)) in (null, '') then ''
              else c1.mng_amt
        end !=
       case when cast(c2.mng_amt as nvarchar(max)) in (null, '') then ''
            else c2.mng_amt
        end);

/*완전 동일*/



-- tb_atlfsl_etc_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_atlfsl_etc_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_atlfsl_etc_info c2
              on c1.atlfsl_etc_info_pk = c2.atlfsl_etc_info_pk
 where(
       case when cast(c1.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.atlfsl_bsc_info_pk
        end !=
       case when cast(c2.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_bsc_info_pk
        end
    or case when cast(c1.mvn_se_cd as nvarchar(max)) in (null, '') then ''
              else c1.mvn_se_cd
        end !=
       case when cast(c2.mvn_se_cd as nvarchar(max)) in (null, '') then ''
            else c2.mvn_se_cd
        end
    or case when cast(c1.mvn_psblty_wthn_month_cnt as nvarchar(max)) in (null, '') then ''
              else c1.mvn_psblty_wthn_month_cnt
        end !=
       case when cast(c2.mvn_psblty_wthn_month_cnt as nvarchar(max)) in (null, '') then ''
            else c2.mvn_psblty_wthn_month_cnt
        end
    or case when cast(c1.mvn_psblty_aftr_ym as nvarchar(max)) in (null, '') then ''
              else c1.mvn_psblty_aftr_ym
        end !=
       case when cast(c2.mvn_psblty_aftr_ym as nvarchar(max)) in (null, '') then ''
            else c2.mvn_psblty_aftr_ym
        end
    or case when cast(c1.mvn_cnsltn_psblty_yn as nvarchar(max)) in (null, '') then ''
              else c1.mvn_cnsltn_psblty_yn
        end !=
       case when cast(c2.mvn_cnsltn_psblty_yn as nvarchar(max)) in (null, '') then ''
            else c2.mvn_cnsltn_psblty_yn
        end
    or case when cast(c1.atlfsl_sfe_expln_cn as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_sfe_expln_cn
        end !=
       case when cast(c2.atlfsl_sfe_expln_cn as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_sfe_expln_cn
        end
    or case when cast(c1.entry_road_yn as nvarchar(max)) in (null, '') then ''
              else c1.entry_road_yn
        end !=
       case when cast(c2.entry_road_yn as nvarchar(max)) in (null, '') then ''
            else c2.entry_road_yn
        end
    or case when cast(c1.atlfsl_expln_cn as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_expln_cn
        end !=
       case when cast(c2.atlfsl_expln_cn as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_expln_cn
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);


SELECT c1.atlfsl_etc_info_pk, c1.atlfsl_expln_cn, c2.atlfsl_expln_cn
  FROM db_khb_srv_230908.sc_khb_srv.tb_atlfsl_etc_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_atlfsl_etc_info c2
              ON c1.atlfsl_etc_info_pk= c2.atlfsl_etc_info_pk
 WHERE CAST(c1.mdfcn_dt AS nvarchar(max)) 
       != 
       CAST(c2.mdfcn_dt AS nvarchar(max));

/*
1. atlfsl_sfe_expln_cn, atlfsl_expln_cn
 => 값은 제대로 들어가있지만 유니코드 문제인지 띄어쓰기 문제인지 동일하지 않다고 나온다.
*/



-- tb_atlfsl_img_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_atlfsl_img_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_atlfsl_img_info c2
              on c1.atlfsl_img_info_pk = c2.atlfsl_img_info_pk
 where(
       case when cast(c1.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.atlfsl_bsc_info_pk
        end !=
       case when cast(c2.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_bsc_info_pk
        end
    or case when cast(c1.img_sn as nvarchar(max)) in (null, '') then ''
              else c1.img_sn
        end !=
       case when cast(c2.img_sn as nvarchar(max)) in (null, '') then ''
            else c2.img_sn
        end
    or case when cast(c1.img_ty_cd as nvarchar(max)) in (null, '') then ''
              else c1.img_ty_cd
        end !=
       case when cast(c2.img_ty_cd as nvarchar(max)) in (null, '') then ''
            else c2.img_ty_cd
        end
    or case when cast(c1.img_file_nm as nvarchar(max)) in (null, '') then ''
              else c1.img_file_nm
        end !=
       case when cast(c2.img_file_nm as nvarchar(max)) in (null, '') then ''
            else c2.img_file_nm
        end
    or case when cast(c1.img_expln_cn as nvarchar(max)) in (null, '') then ''
              else c1.img_expln_cn
        end !=
       case when cast(c2.img_expln_cn as nvarchar(max)) in (null, '') then ''
            else c2.img_expln_cn
        end
    or case when cast(c1.img_url as nvarchar(max)) in (null, '') then ''
              else c1.img_url
        end !=
       case when cast(c2.img_url as nvarchar(max)) in (null, '') then ''
            else c2.img_url
        end
    or case when cast(c1.thumb_img_url as nvarchar(max)) in (null, '') then ''
              else c1.thumb_img_url
        end !=
       case when cast(c2.thumb_img_url as nvarchar(max)) in (null, '') then ''
            else c2.thumb_img_url
        end
    or case when cast(c1.orgnl_img_url as nvarchar(max)) in (null, '') then ''
              else c1.orgnl_img_url
        end !=
       case when cast(c2.orgnl_img_url as nvarchar(max)) in (null, '') then ''
            else c2.orgnl_img_url
        end
    or case when cast(c1.img_sort_ordr as nvarchar(max)) in (null, '') then ''
              else c1.img_sort_ordr
        end !=
       case when cast(c2.img_sort_ordr as nvarchar(max)) in (null, '') then ''
            else c2.img_sort_ordr
        end);


SELECT c1.atlfsl_img_info_pk, c1.atlfsl_bsc_info_pk, c1.orgnl_img_url, c2.orgnl_img_url
  FROM db_khb_srv_230908.sc_khb_srv.tb_atlfsl_img_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_atlfsl_img_info c2
              ON c1.atlfsl_img_info_pk= c2.atlfsl_img_info_pk
 WHERE CAST(c1.orgnl_img_url AS nvarchar(max)) 
       != 
       CAST(c2.orgnl_img_url AS nvarchar(max));

/*
1. img_expln_cn, orgnl_img_url
 => \(역슬러시) 오류
2. 
 => 
*/

SELECT *
  FROM db_khb_srv.sc_khb_srv.tb_atlfsl_img_info
 WHERE img_expln_cn LIKE '%전종환%';

-- tb_atlfsl_inqry_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_atlfsl_inqry_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_atlfsl_inqry_info c2
              on c1.atlfsl_inqry_info_pk = c2.atlfsl_inqry_info_pk
 where(
       case when cast(c1.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.atlfsl_bsc_info_pk
        end !=
       case when cast(c2.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_bsc_info_pk
        end
    or case when cast(c1.user_no_pk as nvarchar(max)) in (null, '') then ''
              else c1.user_no_pk
        end !=
       case when cast(c2.user_no_pk as nvarchar(max)) in (null, '') then ''
            else c2.user_no_pk
        end
    or case when cast(c1.inqry_cn as nvarchar(max)) in (null, '') then ''
              else c1.inqry_cn
        end !=
       case when cast(c2.inqry_cn as nvarchar(max)) in (null, '') then ''
            else c2.inqry_cn
        end
    or case when cast(c1.del_yn as nvarchar(max)) in (null, '') then ''
              else c1.del_yn
        end !=
       case when cast(c2.del_yn as nvarchar(max)) in (null, '') then ''
            else c2.del_yn
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end
    or case when cast(c1.prsl_yn as nvarchar(max)) in (null, '') then ''
              else c1.prsl_yn
        end !=
       case when cast(c2.prsl_yn as nvarchar(max)) in (null, '') then ''
            else c2.prsl_yn
        end);

/*완전 동일*/



-- tb_atlfsl_land_usg_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_atlfsl_land_usg_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_atlfsl_land_usg_info c2
              on c1.atlfsl_land_usg_info_pk = c2.atlfsl_land_usg_info_pk
 where(
       case when cast(c1.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.atlfsl_bsc_info_pk
        end !=
       case when cast(c2.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_bsc_info_pk
        end
    or case when cast(c1.usg_rgn_se_cd as nvarchar(max)) in (null, '') then ''
              else c1.usg_rgn_se_cd
        end !=
       case when cast(c2.usg_rgn_se_cd as nvarchar(max)) in (null, '') then ''
            else c2.usg_rgn_se_cd
        end
    or case when cast(c1.trit_utztn_yn as nvarchar(max)) in (null, '') then ''
              else c1.trit_utztn_yn
        end !=
       case when cast(c2.trit_utztn_yn as nvarchar(max)) in (null, '') then ''
            else c2.trit_utztn_yn
        end
    or case when cast(c1.ctypln_yn as nvarchar(max)) in (null, '') then ''
              else c1.ctypln_yn
        end !=
       case when cast(c2.ctypln_yn as nvarchar(max)) in (null, '') then ''
            else c2.ctypln_yn
        end
    or case when cast(c1.arch_prmsn_yn as nvarchar(max)) in (null, '') then ''
              else c1.arch_prmsn_yn
        end !=
       case when cast(c2.arch_prmsn_yn as nvarchar(max)) in (null, '') then ''
            else c2.arch_prmsn_yn
        end
    or case when cast(c1.land_dlng_prmsn_yn as nvarchar(max)) in (null, '') then ''
              else c1.land_dlng_prmsn_yn
        end !=
       case when cast(c2.land_dlng_prmsn_yn as nvarchar(max)) in (null, '') then ''
            else c2.land_dlng_prmsn_yn
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);

/*완전 동일*/



-- tb_atlfsl_thema_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_atlfsl_thema_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_atlfsl_thema_info c2
              on c1.atlfsl_thema_info_pk = c2.atlfsl_thema_info_pk
 where(
       case when cast(c1.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.atlfsl_bsc_info_pk
        end !=
       case when cast(c2.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_bsc_info_pk
        end
    or case when cast(c1.thema_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.thema_info_pk
        end !=
       case when cast(c2.thema_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.thema_info_pk
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);


SELECT c1.atlfsl_thema_info_pk, c1.thema_info_pk, c2.thema_info_pk
  FROM db_khb_srv_230908.sc_khb_srv.tb_atlfsl_thema_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_atlfsl_thema_info c2
              ON c1.atlfsl_thema_info_pk= c2.atlfsl_thema_info_pk
 WHERE CAST(c1.thema_info_pk AS nvarchar(max)) 
       != 
       CAST(c2.thema_info_pk AS nvarchar(max));

/*
1. thema_info_pk
 => 순서대로 값이 들어가 있는 것이 아니라 발생한 개수
2. 
 => 
*/



-- tb_com_author
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_author c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_author c2
              on c1.author_no_pk = c2.author_no_pk
 where(
       case when cast(c1.parnts_author_no_pk as nvarchar(max)) in (null, '') then ''
            else c1.parnts_author_no_pk
        end !=
       case when cast(c2.parnts_author_no_pk as nvarchar(max)) in (null, '') then ''
            else c2.parnts_author_no_pk
        end
    or case when cast(c1.author_nm as nvarchar(max)) in (null, '') then ''
              else c1.author_nm
        end !=
       case when cast(c2.author_nm as nvarchar(max)) in (null, '') then ''
            else c2.author_nm
        end
    or case when cast(c1.rm_cn as nvarchar(max)) in (null, '') then ''
              else c1.rm_cn
        end !=
       case when cast(c2.rm_cn as nvarchar(max)) in (null, '') then ''
            else c2.rm_cn
        end
    or case when cast(c1.use_at as nvarchar(max)) in (null, '') then ''
              else c1.use_at
        end !=
       case when cast(c2.use_at as nvarchar(max)) in (null, '') then ''
            else c2.use_at
        end
    or case when cast(c1.valid_pd_begin_dt as nvarchar(max)) in (null, '') then ''
              else c1.valid_pd_begin_dt
        end !=
       case when cast(c2.valid_pd_begin_dt as nvarchar(max)) in (null, '') then ''
            else c2.valid_pd_begin_dt
        end
    or case when cast(c1.valid_pd_end_dt as nvarchar(max)) in (null, '') then ''
              else c1.valid_pd_end_dt
        end !=
       case when cast(c2.valid_pd_end_dt as nvarchar(max)) in (null, '') then ''
            else c2.valid_pd_end_dt
        end
    or case when cast(c1.regist_id as nvarchar(max)) in (null, '') then ''
              else c1.regist_id
        end !=
       case when cast(c2.regist_id as nvarchar(max)) in (null, '') then ''
            else c2.regist_id
        end
    or case when cast(c1.regist_dt as nvarchar(max)) in (null, '') then ''
              else c1.regist_dt
        end !=
       case when cast(c2.regist_dt as nvarchar(max)) in (null, '') then ''
            else c2.regist_dt
        end
    or case when cast(c1.updt_id as nvarchar(max)) in (null, '') then ''
              else c1.updt_id
        end !=
       case when cast(c2.updt_id as nvarchar(max)) in (null, '') then ''
            else c2.updt_id
        end
    or case when cast(c1.updt_dt as nvarchar(max)) in (null, '') then ''
              else c1.updt_dt
        end !=
       case when cast(c2.updt_dt as nvarchar(max)) in (null, '') then ''
            else c2.updt_dt
        end
    or case when cast(c1.orgnzt_manage_at as nvarchar(max)) in (null, '') then ''
              else c1.orgnzt_manage_at
        end !=
       case when cast(c2.orgnzt_manage_at as nvarchar(max)) in (null, '') then ''
            else c2.orgnzt_manage_at
        end);

/*완전동일*/



-- tb_com_banner_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_banner_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_banner_info c2
              on c1.banner_info_pk = c2.banner_info_pk
 where(
       case when cast(c1.banner_ty_cd as nvarchar(max)) in (null, '') then ''
            else c1.banner_ty_cd
        end !=
       case when cast(c2.banner_ty_cd as nvarchar(max)) in (null, '') then ''
            else c2.banner_ty_cd
        end
    or case when cast(c1.banner_se_cd as nvarchar(max)) in (null, '') then ''
              else c1.banner_se_cd
        end !=
       case when cast(c2.banner_se_cd as nvarchar(max)) in (null, '') then ''
            else c2.banner_se_cd
        end
    or case when cast(c1.thumb_img_url as nvarchar(max)) in (null, '') then ''
              else c1.thumb_img_url
        end !=
       case when cast(c2.thumb_img_url as nvarchar(max)) in (null, '') then ''
            else c2.thumb_img_url
        end
    or case when cast(c1.banner_ordr as nvarchar(max)) in (null, '') then ''
              else c1.banner_ordr
        end !=
       case when cast(c2.banner_ordr as nvarchar(max)) in (null, '') then ''
            else c2.banner_ordr
        end
    or case when cast(c1.use_yn as nvarchar(max)) in (null, '') then ''
              else c1.use_yn
        end !=
       case when cast(c2.use_yn as nvarchar(max)) in (null, '') then ''
            else c2.use_yn
        end
    or case when cast(c1.url as nvarchar(max)) in (null, '') then ''
              else c1.url
        end !=
       case when cast(c2.url as nvarchar(max)) in (null, '') then ''
            else c2.url
        end
    or case when cast(c1.img_url as nvarchar(max)) in (null, '') then ''
              else c1.img_url
        end !=
       case when cast(c2.img_url as nvarchar(max)) in (null, '') then ''
            else c2.img_url
        end
    or case when cast(c1.dtl_cn as nvarchar(max)) in (null, '') then ''
              else c1.dtl_cn
        end !=
       case when cast(c2.dtl_cn as nvarchar(max)) in (null, '') then ''
            else c2.dtl_cn
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);


SELECT c1.banner_info_pk, c1.banner_ty_cd, c2.banner_ty_cd
  FROM db_khb_srv_230908.sc_khb_srv.tb_com_banner_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_com_banner_info c2
              ON c1.banner_info_pk= c2.banner_info_pk
 WHERE CAST(c1.banner_ty_cd AS nvarchar(max)) 
       != 
       CAST(c2.banner_ty_cd AS nvarchar(max));

/*
1. thema_info_pk
 => 순서대로 값이 들어가 있는 것이 아니라 발생한 개수
2. 
 => 
*/



-- tb_com_cnrs_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_cnrs_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_cnrs_info c2
              on c1.cnrs_info_pk = c2.cnrs_info_pk
 where(
       case when cast(c1.cnrs_ttl_nm as nvarchar(max)) in (null, '') then ''
            else c1.cnrs_ttl_nm
        end !=
       case when cast(c2.cnrs_ttl_nm as nvarchar(max)) in (null, '') then ''
            else c2.cnrs_ttl_nm
        end
    or case when cast(c1.cnrs_cn as nvarchar(max)) in (null, '') then ''
              else c1.cnrs_cn
        end !=
       case when cast(c2.cnrs_cn as nvarchar(max)) in (null, '') then ''
            else c2.cnrs_cn
        end
    or case when cast(c1.img_url as nvarchar(max)) in (null, '') then ''
              else c1.img_url
        end !=
       case when cast(c2.img_url as nvarchar(max)) in (null, '') then ''
            else c2.img_url
        end
    or case when cast(c1.url_paramtr_cn as nvarchar(max)) in (null, '') then ''
              else c1.url_paramtr_cn
        end !=
       case when cast(c2.url_paramtr_cn as nvarchar(max)) in (null, '') then ''
            else c2.url_paramtr_cn
        end
    or case when cast(c1.aplctn_cd as nvarchar(max)) in (null, '') then ''
              else c1.aplctn_cd
        end !=
       case when cast(c2.aplctn_cd as nvarchar(max)) in (null, '') then ''
            else c2.aplctn_cd
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);

/*완전동일*/



-- tb_com_code
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_code c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_code c2
              on c1.code_pk = c2.code_pk
 where(
       case when cast(c1.parnts_code_pk as nvarchar(max)) in (null, '') then ''
            else c1.parnts_code_pk
        end !=
       case when cast(c2.parnts_code_pk as nvarchar(max)) in (null, '') then ''
            else c2.parnts_code_pk
        end
    or case when cast(c1.code as nvarchar(max)) in (null, '') then ''
              else c1.code
        end !=
       case when cast(c2.code as nvarchar(max)) in (null, '') then ''
            else c2.code
        end
    or case when cast(c1.code_nm as nvarchar(max)) in (null, '') then ''
              else c1.code_nm
        end !=
       case when cast(c2.code_nm as nvarchar(max)) in (null, '') then ''
            else c2.code_nm
        end
    or case when cast(c1.sort_ordr as nvarchar(max)) in (null, '') then ''
              else c1.sort_ordr
        end !=
       case when cast(c2.sort_ordr as nvarchar(max)) in (null, '') then ''
            else c2.sort_ordr
        end
    or case when cast(c1.use_at as nvarchar(max)) in (null, '') then ''
              else c1.use_at
        end !=
       case when cast(c2.use_at as nvarchar(max)) in (null, '') then ''
            else c2.use_at
        end
    or case when cast(c1.regist_id as nvarchar(max)) in (null, '') then ''
              else c1.regist_id
        end !=
       case when cast(c2.regist_id as nvarchar(max)) in (null, '') then ''
            else c2.regist_id
        end
    or case when cast(c1.regist_dt as nvarchar(max)) in (null, '') then ''
              else c1.regist_dt
        end !=
       case when cast(c2.regist_dt as nvarchar(max)) in (null, '') then ''
            else c2.regist_dt
        end
    or case when cast(c1.updt_id as nvarchar(max)) in (null, '') then ''
              else c1.updt_id
        end !=
       case when cast(c2.updt_id as nvarchar(max)) in (null, '') then ''
            else c2.updt_id
        end
    or case when cast(c1.updt_dt as nvarchar(max)) in (null, '') then ''
              else c1.updt_dt
        end !=
       case when cast(c2.updt_dt as nvarchar(max)) in (null, '') then ''
            else c2.updt_dt
        end
    or case when cast(c1.rm_cn as nvarchar(max)) in (null, '') then ''
              else c1.rm_cn
        end !=
       case when cast(c2.rm_cn as nvarchar(max)) in (null, '') then ''
            else c2.rm_cn
        end
    or case when cast(c1.parnts_code as nvarchar(max)) in (null, '') then ''
              else c1.parnts_code
        end !=
       case when cast(c2.parnts_code as nvarchar(max)) in (null, '') then ''
            else c2.parnts_code
        end);


SELECT c1.code_pk, c1.parnts_code_pk, c2.parnts_code_pk
  FROM db_khb_srv_230908.sc_khb_srv.tb_com_code c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_com_code c2
              ON c1.code_pk= c2.code_pk
 WHERE CAST(c1.parnts_code_pk AS nvarchar(max)) 
       != 
       CAST(c2.parnts_code_pk AS nvarchar(max));

/*
1. 데이터 삽입 순서로 인한 오류
*/



-- tb_com_crtfc_tmpr
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_crtfc_tmpr c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr c2
              on c1.crtfc_pk = c2.crtfc_pk
 where(
       case when cast(c1.crtfc_se_code as nvarchar(max)) in (null, '') then ''
            else c1.crtfc_se_code
        end !=
       case when cast(c2.crtfc_se_code as nvarchar(max)) in (null, '') then ''
            else c2.crtfc_se_code
        end
    or case when cast(c1.soc_lgn_ty_cd as nvarchar(max)) in (null, '') then ''
              else c1.soc_lgn_ty_cd
        end !=
       case when cast(c2.soc_lgn_ty_cd as nvarchar(max)) in (null, '') then ''
            else c2.soc_lgn_ty_cd
        end
    or case when cast(c1.moblphon_no as nvarchar(max)) in (null, '') then ''
              else c1.moblphon_no
        end !=
       case when cast(c2.moblphon_no as nvarchar(max)) in (null, '') then ''
            else c2.moblphon_no
        end
    or case when cast(c1.moblphon_crtfc_sn as nvarchar(max)) in (null, '') then ''
              else c1.moblphon_crtfc_sn
        end !=
       case when cast(c2.moblphon_crtfc_sn as nvarchar(max)) in (null, '') then ''
            else c2.moblphon_crtfc_sn
        end
    or case when cast(c1.moblphon_crtfc_at as nvarchar(max)) in (null, '') then ''
              else c1.moblphon_crtfc_at
        end !=
       case when cast(c2.moblphon_crtfc_at as nvarchar(max)) in (null, '') then ''
            else c2.moblphon_crtfc_at
        end
    or case when cast(c1.email as nvarchar(max)) in (null, '') then ''
              else c1.email
        end !=
       case when cast(c2.email as nvarchar(max)) in (null, '') then ''
            else c2.email
        end
    or case when cast(c1.email_crtfc_sn as nvarchar(max)) in (null, '') then ''
              else c1.email_crtfc_sn
        end !=
       case when cast(c2.email_crtfc_sn as nvarchar(max)) in (null, '') then ''
            else c2.email_crtfc_sn
        end
    or case when cast(c1.email_crtfc_at as nvarchar(max)) in (null, '') then ''
              else c1.email_crtfc_at
        end !=
       case when cast(c2.email_crtfc_at as nvarchar(max)) in (null, '') then ''
            else c2.email_crtfc_at
        end
    or case when cast(c1.sns_crtfc_sn as nvarchar(max)) in (null, '') then ''
              else c1.sns_crtfc_sn
        end !=
       case when cast(c2.sns_crtfc_sn as nvarchar(max)) in (null, '') then ''
            else c2.sns_crtfc_sn
        end
    or case when cast(c1.sns_crtfc_at as nvarchar(max)) in (null, '') then ''
              else c1.sns_crtfc_at
        end !=
       case when cast(c2.sns_crtfc_at as nvarchar(max)) in (null, '') then ''
            else c2.sns_crtfc_at
        end
    or case when cast(c1.regist_id as nvarchar(max)) in (null, '') then ''
              else c1.regist_id
        end !=
       case when cast(c2.regist_id as nvarchar(max)) in (null, '') then ''
            else c2.regist_id
        end
    or case when cast(c1.regist_dt as nvarchar(max)) in (null, '') then ''
              else c1.regist_dt
        end !=
       case when cast(c2.regist_dt as nvarchar(max)) in (null, '') then ''
            else c2.regist_dt
        end
    or case when cast(c1.updt_id as nvarchar(max)) in (null, '') then ''
              else c1.updt_id
        end !=
       case when cast(c2.updt_id as nvarchar(max)) in (null, '') then ''
            else c2.updt_id
        end
    or case when cast(c1.updt_dt as nvarchar(max)) in (null, '') then ''
              else c1.updt_dt
        end !=
       case when cast(c2.updt_dt as nvarchar(max)) in (null, '') then ''
            else c2.updt_dt
        end);

/*완전동일*/



-- tb_com_ctpv_cd
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_ctpv_cd c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_ctpv_cd c2
              on c1.ctpv_cd_pk = c2.ctpv_cd_pk
 where(
       case when cast(c1.ctpv_nm as nvarchar(max)) in (null, '') then ''
            else c1.ctpv_nm
        end !=
       case when cast(c2.ctpv_nm as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_nm
        end
    or case when cast(c1.ctpv_abbrev_nm as nvarchar(max)) in (null, '') then ''
              else c1.ctpv_abbrev_nm
        end !=
       case when cast(c2.ctpv_abbrev_nm as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_abbrev_nm
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);


SELECT c1.ctpv_cd_pk, c1.ctpv_nm, c2.ctpv_nm
  FROM db_khb_srv_230908.sc_khb_srv.tb_com_ctpv_cd c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_com_ctpv_cd c2
              ON c1.ctpv_cd_pk= c2.ctpv_cd_pk
 WHERE CAST(c1.mdfcn_id AS nvarchar(max)) 
       != 
       CAST(c2.mdfcn_id AS nvarchar(max));

/*
1. ctpv_nm
 => 강원특별자치도 VS 강원도
2. 
*/



-- tb_com_device_info



-- tb_com_device_ntcn_mapng_info



-- tb_com_device_stng_info



-- tb_com_emd_li_cd
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_emd_li_cd c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_emd_li_cd c2
              on c1.emd_li_cd_pk = c2.emd_li_cd_pk
 where(
       case when cast(c1.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c1.ctpv_cd_pk
        end !=
       case when cast(c2.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_cd_pk
        end
    or case when cast(c1.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.sgg_cd_pk
        end !=
       case when cast(c2.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.sgg_cd_pk
        end
    or case when cast(c1.emd_li_nm as nvarchar(max)) in (null, '') then ''
              else c1.emd_li_nm
        end !=
       case when cast(c2.emd_li_nm as nvarchar(max)) in (null, '') then ''
            else c2.emd_li_nm
        end
    or case when cast(c1.all_emd_li_nm as nvarchar(max)) in (null, '') then ''
              else c1.all_emd_li_nm
        end !=
       case when cast(c2.all_emd_li_nm as nvarchar(max)) in (null, '') then ''
            else c2.all_emd_li_nm
        end
    or case when cast(c1.stdg_dong_se_cd as nvarchar(max)) in (null, '') then ''
              else c1.stdg_dong_se_cd
        end !=
       case when cast(c2.stdg_dong_se_cd as nvarchar(max)) in (null, '') then ''
            else c2.stdg_dong_se_cd
        end
    or case when cast(c1.stdg_dong_cd as nvarchar(max)) in (null, '') then ''
              else c1.stdg_dong_cd
        end !=
       case when cast(c2.stdg_dong_cd as nvarchar(max)) in (null, '') then ''
            else c2.stdg_dong_cd
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);



SELECT c1.emd_li_cd_pk, c1.stdg_dong_cd, c2.stdg_dong_cd
  FROM db_khb_srv_230908.sc_khb_srv.tb_com_emd_li_cd c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_com_emd_li_cd c2
              ON c1.emd_li_cd_pk= c2.emd_li_cd_pk
 WHERE CAST(c1.mdfcn_dt AS nvarchar(max)) 
       != 
       CAST(c2.mdfcn_dt AS nvarchar(max));

/*
1. ctpv_cd_pk 2개
 => 경상북도 군위군 VS 대구 군위군
2. stdg_dong_cd
 => 행정동 코드 변경
*/



-- tb_com_error_log



-- tb_com_faq



-- tb_com_file



-- tb_com_file_mapng



-- tb_com_group



-- tb_com_group_author



-- tb_com_gtwy_svc



-- tb_com_job_schdl_hstry



-- tb_com_job_schdl_info



-- tb_com_login_hist



-- tb_com_menu



-- tb_com_menu_author



-- tb_com_notice



-- tb_com_ntcn_info



-- tb_com_push_meta_info



-- tb_com_qna



-- tb_com_recsroom



-- tb_com_rss_info



-- tb_com_scrin



-- tb_com_scrin_author



-- tb_com_sgg_cd
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_sgg_cd c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_sgg_cd c2
              on c1.sgg_cd_pk = c2.sgg_cd_pk
 where(
       case when cast(c1.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c1.ctpv_cd_pk
        end !=
       case when cast(c2.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_cd_pk
        end
    or case when cast(c1.sgg_nm as nvarchar(max)) in (null, '') then ''
              else c1.sgg_nm
        end !=
       case when cast(c2.sgg_nm as nvarchar(max)) in (null, '') then ''
            else c2.sgg_nm
        end
    or case when cast(c1.stdg_dong_se_cd as nvarchar(max)) in (null, '') then ''
              else c1.stdg_dong_se_cd
        end !=
       case when cast(c2.stdg_dong_se_cd as nvarchar(max)) in (null, '') then ''
            else c2.stdg_dong_se_cd
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);

SELECT c1.sgg_cd_pk, c1.ctpv_cd_pk, c2.ctpv_cd_pk
  FROM db_khb_srv_230908.sc_khb_srv.tb_com_sgg_cd c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_com_sgg_cd c2
              ON c1.sgg_cd_pk= c2.sgg_cd_pk
 WHERE CAST(c1.mdfcn_dt AS nvarchar(max)) 
       != 
       CAST(c2.mdfcn_dt AS nvarchar(max));

/*
1. ctpv_cd_pk 2개
 => 경상북도 군위군 VS 대구 군위군

*/



-- tb_com_stplat_hist



-- tb_com_stplat_mapng



-- tb_com_svc_ip_manage



-- tb_com_thema_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_thema_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_thema_info c2
              on c1.thema_info_pk = c2.thema_info_pk
 where(
       case when cast(c1.thema_cd as nvarchar(max)) in (null, '') then ''
            else c1.thema_cd
        end !=
       case when cast(c2.thema_cd as nvarchar(max)) in (null, '') then ''
            else c2.thema_cd
        end
    or case when cast(c1.thema_cd_nm as nvarchar(max)) in (null, '') then ''
              else c1.thema_cd_nm
        end !=
       case when cast(c2.thema_cd_nm as nvarchar(max)) in (null, '') then ''
            else c2.thema_cd_nm
        end
    or case when cast(c1.thema_cn as nvarchar(max)) in (null, '') then ''
              else c1.thema_cn
        end !=
       case when cast(c2.thema_cn as nvarchar(max)) in (null, '') then ''
            else c2.thema_cn
        end
    or case when cast(c1.img_url as nvarchar(max)) in (null, '') then ''
              else c1.img_url
        end !=
       case when cast(c2.img_url as nvarchar(max)) in (null, '') then ''
            else c2.img_url
        end
    or case when cast(c1.img_sort_ordr as nvarchar(max)) in (null, '') then ''
              else c1.img_sort_ordr
        end !=
       case when cast(c2.img_sort_ordr as nvarchar(max)) in (null, '') then ''
            else c2.img_sort_ordr
        end
    or case when cast(c1.use_yn as nvarchar(max)) in (null, '') then ''
              else c1.use_yn
        end !=
       case when cast(c2.use_yn as nvarchar(max)) in (null, '') then ''
            else c2.use_yn
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end
    or case when cast(c1.rprs_yn as nvarchar(max)) in (null, '') then ''
              else c1.rprs_yn
        end !=
       case when cast(c2.rprs_yn as nvarchar(max)) in (null, '') then ''
            else c2.rprs_yn
        end
    or case when cast(c1.atlfsl_reg_use_yn as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_reg_use_yn
        end !=
       case when cast(c2.atlfsl_reg_use_yn as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_reg_use_yn
        end);

SELECT c1.thema_info_pk, c1.mdfcn_id, c2.mdfcn_id
  FROM db_khb_srv_230908.sc_khb_srv.tb_com_thema_info c1
       INNER JOIN
       db_khb_srv.sc_khb_srv.tb_com_thema_info c2
              ON c1.thema_info_pk= c2.thema_info_pk
 WHERE CAST(isnull(CAST(c1.mdfcn_dt AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.mdfcn_dt AS nvarchar(max)), '') AS nvarchar(max));

/*
1. img_url
 => 경로 변경: /2023/07/04/76/76.png	/static/images/thema_076.png
 => 변경된 내용
2. img_sort_ordr
 => 0과 null 차이
3. use_yn
 => Y VS N 는 74 75
4. mdfcn_id
 => 우리쪽에서 수정하여 수정아이디가 변경
*/



-- tb_com_user
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_user c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_user c2
              on c1.user_no_pk = c2.user_no_pk
 where(
       case when cast(c1.parnts_user_no_pk as nvarchar(max)) in (null, '') then ''
            else c1.parnts_user_no_pk
        end !=
       case when cast(c2.parnts_user_no_pk as nvarchar(max)) in (null, '') then ''
            else c2.parnts_user_no_pk
        end
    or case when cast(c1.user_id as nvarchar(max)) in (null, '') then ''
              else c1.user_id
        end !=
       case when cast(c2.user_id as nvarchar(max)) in (null, '') then ''
            else c2.user_id
        end
    or case when cast(c1.user_nm as nvarchar(max)) in (null, '') then ''
              else c1.user_nm
        end !=
       case when cast(c2.user_nm as nvarchar(max)) in (null, '') then ''
            else c2.user_nm
        end
    or case when cast(c1.password as nvarchar(max)) in (null, '') then ''
              else c1.password
        end !=
       case when cast(c2.password as nvarchar(max)) in (null, '') then ''
            else c2.password
        end
    or case when cast(c1.moblphon_no as nvarchar(max)) in (null, '') then ''
              else c1.moblphon_no
        end !=
       case when cast(c2.moblphon_no as nvarchar(max)) in (null, '') then ''
            else c2.moblphon_no
        end
    or case when cast(c1.email as nvarchar(max)) in (null, '') then ''
              else c1.email
        end !=
       case when cast(c2.email as nvarchar(max)) in (null, '') then ''
            else c2.email
        end
    or case when cast(c1.user_se_code as nvarchar(max)) in (null, '') then ''
              else c1.user_se_code
        end !=
       case when cast(c2.user_se_code as nvarchar(max)) in (null, '') then ''
            else c2.user_se_code
        end
    or case when cast(c1.sbscrb_de as nvarchar(max)) in (null, '') then ''
              else c1.sbscrb_de
        end !=
       case when cast(c2.sbscrb_de as nvarchar(max)) in (null, '') then ''
            else c2.sbscrb_de
        end
    or case when cast(c1.password_change_de as nvarchar(max)) in (null, '') then ''
              else c1.password_change_de
        end !=
       case when cast(c2.password_change_de as nvarchar(max)) in (null, '') then ''
            else c2.password_change_de
        end
    or case when cast(c1.last_login_dt as nvarchar(max)) in (null, '') then ''
              else c1.last_login_dt
        end !=
       case when cast(c2.last_login_dt as nvarchar(max)) in (null, '') then ''
            else c2.last_login_dt
        end
    or case when cast(c1.last_login_ip as nvarchar(max)) in (null, '') then ''
              else c1.last_login_ip
        end !=
       case when cast(c2.last_login_ip as nvarchar(max)) in (null, '') then ''
            else c2.last_login_ip
        end
    or case when cast(c1.error_co as nvarchar(max)) in (null, '') then ''
              else c1.error_co
        end !=
       case when cast(c2.error_co as nvarchar(max)) in (null, '') then ''
            else c2.error_co
        end
    or case when cast(c1.error_dt as nvarchar(max)) in (null, '') then ''
              else c1.error_dt
        end !=
       case when cast(c2.error_dt as nvarchar(max)) in (null, '') then ''
            else c2.error_dt
        end
    or case when cast(c1.use_at as nvarchar(max)) in (null, '') then ''
              else c1.use_at
        end !=
       case when cast(c2.use_at as nvarchar(max)) in (null, '') then ''
            else c2.use_at
        end
    or case when cast(c1.regist_id as nvarchar(max)) in (null, '') then ''
              else c1.regist_id
        end !=
       case when cast(c2.regist_id as nvarchar(max)) in (null, '') then ''
            else c2.regist_id
        end
    or case when cast(c1.regist_dt as nvarchar(max)) in (null, '') then ''
              else c1.regist_dt
        end !=
       case when cast(c2.regist_dt as nvarchar(max)) in (null, '') then ''
            else c2.regist_dt
        end
    or case when cast(c1.updt_id as nvarchar(max)) in (null, '') then ''
              else c1.updt_id
        end !=
       case when cast(c2.updt_id as nvarchar(max)) in (null, '') then ''
            else c2.updt_id
        end
    or case when cast(c1.updt_dt as nvarchar(max)) in (null, '') then ''
              else c1.updt_dt
        end !=
       case when cast(c2.updt_dt as nvarchar(max)) in (null, '') then ''
            else c2.updt_dt
        end
    or case when cast(c1.refresh_tkn_cn as nvarchar(max)) in (null, '') then ''
              else c1.refresh_tkn_cn
        end !=
       case when cast(c2.refresh_tkn_cn as nvarchar(max)) in (null, '') then ''
            else c2.refresh_tkn_cn
        end
    or case when cast(c1.soc_lgn_ty_cd as nvarchar(max)) in (null, '') then ''
              else c1.soc_lgn_ty_cd
        end !=
       case when cast(c2.soc_lgn_ty_cd as nvarchar(max)) in (null, '') then ''
            else c2.soc_lgn_ty_cd
        end
    or case when cast(c1.user_img_url as nvarchar(max)) in (null, '') then ''
              else c1.user_img_url
        end !=
       case when cast(c2.user_img_url as nvarchar(max)) in (null, '') then ''
            else c2.user_img_url
        end
    or case when cast(c1.lrea_office_nm as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_nm
        end !=
       case when cast(c2.lrea_office_nm as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_nm
        end
    or case when cast(c1.lrea_office_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_info_pk
        end !=
       case when cast(c2.lrea_office_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_info_pk
        end
    or case when cast(c1.lrea_brffc_cd as nvarchar(max)) in (null, '') then ''
              else c1.lrea_brffc_cd
        end !=
       case when cast(c2.lrea_brffc_cd as nvarchar(max)) in (null, '') then ''
            else c2.lrea_brffc_cd
        end);


SELECT c1.user_no_pk, c1.user_nm, c2.user_nm
  FROM db_khb_srv_230908.sc_khb_srv.tb_com_user c1
       INNER JOIN
       db_khb_srv.sc_khb_srv.tb_com_user c2
              ON c1.user_no_pk= c2.user_no_pk
 WHERE CAST(isnull(CAST(c1.user_nm AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.user_nm AS nvarchar(max)), '') AS nvarchar(max));

/*
순서가 싹 바뀌어서 오류 발생
*/

-- tb_com_user_author



-- tb_com_user_group
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_com_user_group c1
       left join
       db_khb_srv.sc_khb_srv.tb_com_user_group c2
              on c1.com_user_group_pk = c2.com_user_group_pk
 where(
       case when cast(c1.group_no_pk as nvarchar(max)) in (null, '') then ''
            else c1.group_no_pk
        end !=
       case when cast(c2.group_no_pk as nvarchar(max)) in (null, '') then ''
            else c2.group_no_pk
        end
    or case when cast(c1.user_no_pk as nvarchar(max)) in (null, '') then ''
              else c1.user_no_pk
        end !=
       case when cast(c2.user_no_pk as nvarchar(max)) in (null, '') then ''
            else c2.user_no_pk
        end
    or case when cast(c1.regist_id as nvarchar(max)) in (null, '') then ''
              else c1.regist_id
        end !=
       case when cast(c2.regist_id as nvarchar(max)) in (null, '') then ''
            else c2.regist_id
        end
    or case when cast(c1.regist_dt as nvarchar(max)) in (null, '') then ''
              else c1.regist_dt
        end !=
       case when cast(c2.regist_dt as nvarchar(max)) in (null, '') then ''
            else c2.regist_dt
        end
    or case when cast(c1.updt_id as nvarchar(max)) in (null, '') then ''
              else c1.updt_id
        end !=
       case when cast(c2.updt_id as nvarchar(max)) in (null, '') then ''
            else c2.updt_id
        end
    or case when cast(c1.updt_dt as nvarchar(max)) in (null, '') then ''
              else c1.updt_dt
        end !=
       case when cast(c2.updt_dt as nvarchar(max)) in (null, '') then ''
            else c2.updt_dt
        end);


SELECT c1.com_user_group_pk, c1.user_no_pk, c2.user_no_pk
  FROM db_khb_srv_230908.sc_khb_srv.tb_com_user_group c1
       INNER JOIN
       db_khb_srv.sc_khb_srv.tb_com_user_group c2
              ON c1.com_user_group_pk= c2.com_user_group_pk
 WHERE CAST(isnull(CAST(c1.user_no_pk AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.user_no_pk AS nvarchar(max)), '') AS nvarchar(max));

/*
순서가 싹 바뀌어서 오류 발생
*/



-- tb_hsmp_dtl_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_hsmp_dtl_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_hsmp_dtl_info c2
              on c1.hsmp_dtl_info_pk = c2.hsmp_dtl_info_pk
 where(
       case when cast(c1.hsmp_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.hsmp_info_pk
        end !=
       case when cast(c2.hsmp_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.hsmp_info_pk
        end
    or case when cast(c1.sply_area as nvarchar(max)) in (null, '') then ''
              else c1.sply_area
        end !=
       case when cast(c2.sply_area as nvarchar(max)) in (null, '') then ''
            else c2.sply_area
        end
    or case when cast(c1.sply_area_pyeong as nvarchar(max)) in (null, '') then ''
              else c1.sply_area_pyeong
        end !=
       case when cast(c2.sply_area_pyeong as nvarchar(max)) in (null, '') then ''
            else c2.sply_area_pyeong
        end
    or case when cast(c1.pyeong_info as nvarchar(max)) in (null, '') then ''
              else c1.pyeong_info
        end !=
       case when cast(c2.pyeong_info as nvarchar(max)) in (null, '') then ''
            else c2.pyeong_info
        end
    or case when cast(c1.prvuse_area as nvarchar(max)) in (null, '') then ''
              else c1.prvuse_area
        end !=
       case when cast(c2.prvuse_area as nvarchar(max)) in (null, '') then ''
            else c2.prvuse_area
        end
    or case when cast(c1.prvuse_area_pyeong as nvarchar(max)) in (null, '') then ''
              else c1.prvuse_area_pyeong
        end !=
       case when cast(c2.prvuse_area_pyeong as nvarchar(max)) in (null, '') then ''
            else c2.prvuse_area_pyeong
        end
    or case when cast(c1.ctrt_area as nvarchar(max)) in (null, '') then ''
              else c1.ctrt_area
        end !=
       case when cast(c2.ctrt_area as nvarchar(max)) in (null, '') then ''
            else c2.ctrt_area
        end
    or case when cast(c1.ctrt_area_pyeong as nvarchar(max)) in (null, '') then ''
              else c1.ctrt_area_pyeong
        end !=
       case when cast(c2.ctrt_area_pyeong as nvarchar(max)) in (null, '') then ''
            else c2.ctrt_area_pyeong
        end
    or case when cast(c1.dtl_lotno as nvarchar(max)) in (null, '') then ''
              else c1.dtl_lotno
        end !=
       case when cast(c2.dtl_lotno as nvarchar(max)) in (null, '') then ''
            else c2.dtl_lotno
        end
    or case when cast(c1.room_cnt as nvarchar(max)) in (null, '') then ''
              else c1.room_cnt
        end !=
       case when cast(c2.room_cnt as nvarchar(max)) in (null, '') then ''
            else c2.room_cnt
        end
    or case when cast(c1.btr_cnt as nvarchar(max)) in (null, '') then ''
              else c1.btr_cnt
        end !=
       case when cast(c2.btr_cnt as nvarchar(max)) in (null, '') then ''
            else c2.btr_cnt
        end
    or case when cast(c1.pyeong_hh_cnt as nvarchar(max)) in (null, '') then ''
              else c1.pyeong_hh_cnt
        end !=
       case when cast(c2.pyeong_hh_cnt as nvarchar(max)) in (null, '') then ''
            else c2.pyeong_hh_cnt
        end
    or case when cast(c1.drc_cd as nvarchar(max)) in (null, '') then ''
              else c1.drc_cd
        end !=
       case when cast(c2.drc_cd as nvarchar(max)) in (null, '') then ''
            else c2.drc_cd
        end
    or case when cast(c1.bay_cd as nvarchar(max)) in (null, '') then ''
              else c1.bay_cd
        end !=
       case when cast(c2.bay_cd as nvarchar(max)) in (null, '') then ''
            else c2.bay_cd
        end
    or case when cast(c1.stairs_stle_cd as nvarchar(max)) in (null, '') then ''
              else c1.stairs_stle_cd
        end !=
       case when cast(c2.stairs_stle_cd as nvarchar(max)) in (null, '') then ''
            else c2.stairs_stle_cd
        end
    or case when cast(c1.flrpln_url as nvarchar(max)) in (null, '') then ''
              else c1.flrpln_url
        end !=
       case when cast(c2.flrpln_url as nvarchar(max)) in (null, '') then ''
            else c2.flrpln_url
        end
    or case when cast(c1.estn_flrpln_url as nvarchar(max)) in (null, '') then ''
              else c1.estn_flrpln_url
        end !=
       case when cast(c2.estn_flrpln_url as nvarchar(max)) in (null, '') then ''
            else c2.estn_flrpln_url
        end
    or case when cast(c1.use_yn as nvarchar(max)) in (null, '') then ''
              else c1.use_yn
        end !=
       case when cast(c2.use_yn as nvarchar(max)) in (null, '') then ''
            else c2.use_yn
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);


SELECT c1.hsmp_dtl_info_pk, c1.sply_area , c2.sply_area
  FROM db_khb_srv_230908.sc_khb_srv.tb_hsmp_dtl_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_hsmp_dtl_info c2
              ON c1.hsmp_dtl_info_pk= c2.hsmp_dtl_info_pk
             AND c1.hsmp_info_pk=c2.hsmp_info_pk
 WHERE CAST(isnull(CAST(c1.sply_area AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.sply_area AS nvarchar(max)), '') AS nvarchar(max));

/*
1. sply_area, prvuse_area, ctrt_area
 => 소수점으로 나옴
2. sply_area_pyeong
 => 평이랑 미터랑 일치가 안됨
3. room_cnt
4. 
 => 방 개수 이상

cs에서 보면 여러 열들이 기존에는 값이 없었지만 현재는 많이 채워졌다.
*/



-- tb_hsmp_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_hsmp_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_hsmp_info c2
              on c1.hsmp_info_pk = c2.hsmp_info_pk
 where(
       case when cast(c1.hsmp_nm as nvarchar(max)) in (null, '') then ''
            else c1.hsmp_nm
        end !=
       case when cast(c2.hsmp_nm as nvarchar(max)) in (null, '') then ''
            else c2.hsmp_nm
        end
    or case when cast(c1.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.ctpv_cd_pk
        end !=
       case when cast(c2.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_cd_pk
        end
    or case when cast(c1.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.sgg_cd_pk
        end !=
       case when cast(c2.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.sgg_cd_pk
        end
    or case when cast(c1.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.emd_li_cd_pk
        end !=
       case when cast(c2.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.emd_li_cd_pk
        end
    or case when cast(c1.lotno as nvarchar(max)) in (null, '') then ''
              else c1.lotno
        end !=
       case when cast(c2.lotno as nvarchar(max)) in (null, '') then ''
            else c2.lotno
        end
    or case when cast(c1.rn_addr as nvarchar(max)) in (null, '') then ''
              else c1.rn_addr
        end !=
       case when cast(c2.rn_addr as nvarchar(max)) in (null, '') then ''
            else c2.rn_addr
        end
    or case when cast(c1.tot_hh_cnt as nvarchar(max)) in (null, '') then ''
              else c1.tot_hh_cnt
        end !=
       case when cast(c2.tot_hh_cnt as nvarchar(max)) in (null, '') then ''
            else c2.tot_hh_cnt
        end
    or case when cast(c1.tot_aptcmpl_cnt as nvarchar(max)) in (null, '') then ''
              else c1.tot_aptcmpl_cnt
        end !=
       case when cast(c2.tot_aptcmpl_cnt as nvarchar(max)) in (null, '') then ''
            else c2.tot_aptcmpl_cnt
        end
    or case when cast(c1.flr_cnt as nvarchar(max)) in (null, '') then ''
              else c1.flr_cnt
        end !=
       case when cast(c2.flr_cnt as nvarchar(max)) in (null, '') then ''
            else c2.flr_cnt
        end
    or case when cast(c1.tot_parkng_cntom as nvarchar(max)) in (null, '') then ''
              else c1.tot_parkng_cntom
        end !=
       case when cast(c2.tot_parkng_cntom as nvarchar(max)) in (null, '') then ''
            else c2.tot_parkng_cntom
        end
    or case when cast(c1.hh_parkng_cntom as nvarchar(max)) in (null, '') then ''
              else c1.hh_parkng_cntom
        end !=
       case when cast(c2.hh_parkng_cntom as nvarchar(max)) in (null, '') then ''
            else c2.hh_parkng_cntom
        end
    or case when cast(c1.bldr_nm as nvarchar(max)) in (null, '') then ''
              else c1.bldr_nm
        end !=
       case when cast(c2.bldr_nm as nvarchar(max)) in (null, '') then ''
            else c2.bldr_nm
        end
    or case when cast(c1.cmcn_year as nvarchar(max)) in (null, '') then ''
              else c1.cmcn_year
        end !=
       case when cast(c2.cmcn_year as nvarchar(max)) in (null, '') then ''
            else c2.cmcn_year
        end
    or case when cast(c1.cmcn_mt as nvarchar(max)) in (null, '') then ''
              else c1.cmcn_mt
        end !=
       case when cast(c2.cmcn_mt as nvarchar(max)) in (null, '') then ''
            else c2.cmcn_mt
        end
    or case when cast(c1.compet_year as nvarchar(max)) in (null, '') then ''
              else c1.compet_year
        end !=
       case when cast(c2.compet_year as nvarchar(max)) in (null, '') then ''
            else c2.compet_year
        end
    or case when cast(c1.compet_mt as nvarchar(max)) in (null, '') then ''
              else c1.compet_mt
        end !=
       case when cast(c2.compet_mt as nvarchar(max)) in (null, '') then ''
            else c2.compet_mt
        end
    or case when cast(c1.heat_cd as nvarchar(max)) in (null, '') then ''
              else c1.heat_cd
        end !=
       case when cast(c2.heat_cd as nvarchar(max)) in (null, '') then ''
            else c2.heat_cd
        end
    or case when cast(c1.fuel_cd as nvarchar(max)) in (null, '') then ''
              else c1.fuel_cd
        end !=
       case when cast(c2.fuel_cd as nvarchar(max)) in (null, '') then ''
            else c2.fuel_cd
        end
    or case when cast(c1.ctgry_cd as nvarchar(max)) in (null, '') then ''
              else c1.ctgry_cd
        end !=
       case when cast(c2.ctgry_cd as nvarchar(max)) in (null, '') then ''
            else c2.ctgry_cd
        end
    or case when cast(c1.mng_office_telno as nvarchar(max)) in (null, '') then ''
              else c1.mng_office_telno
        end !=
       case when cast(c2.mng_office_telno as nvarchar(max)) in (null, '') then ''
            else c2.mng_office_telno
        end
    or case when cast(c1.bus_rte_info as nvarchar(max)) in (null, '') then ''
              else c1.bus_rte_info
        end !=
       case when cast(c2.bus_rte_info as nvarchar(max)) in (null, '') then ''
            else c2.bus_rte_info
        end
    or case when cast(c1.subway_rte_info as nvarchar(max)) in (null, '') then ''
              else c1.subway_rte_info
        end !=
       case when cast(c2.subway_rte_info as nvarchar(max)) in (null, '') then ''
            else c2.subway_rte_info
        end
    or case when cast(c1.schl_info as nvarchar(max)) in (null, '') then ''
              else c1.schl_info
        end !=
       case when cast(c2.schl_info as nvarchar(max)) in (null, '') then ''
            else c2.schl_info
        end
    or case when cast(c1.cvntl_info as nvarchar(max)) in (null, '') then ''
              else c1.cvntl_info
        end !=
       case when cast(c2.cvntl_info as nvarchar(max)) in (null, '') then ''
            else c2.cvntl_info
        end
    or case when cast(c1.hsmp_lot as nvarchar(max)) in (null, '') then ''
              else c1.hsmp_lot
        end !=
       case when cast(c2.hsmp_lot as nvarchar(max)) in (null, '') then ''
            else c2.hsmp_lot
        end
    or case when cast(c1.hsmp_lat as nvarchar(max)) in (null, '') then ''
              else c1.hsmp_lat
        end !=
       case when cast(c2.hsmp_lat as nvarchar(max)) in (null, '') then ''
            else c2.hsmp_lat
        end
    or case when cast(c1.use_yn as nvarchar(max)) in (null, '') then ''
              else c1.use_yn
        end !=
       case when cast(c2.use_yn as nvarchar(max)) in (null, '') then ''
            else c2.use_yn
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);

SELECT c1.hsmp_info_pk, c1.reg_dt, c2.reg_dt
  FROM db_khb_srv_230908.sc_khb_srv.tb_hsmp_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_hsmp_info c2
              ON c1.hsmp_info_pk= c2.hsmp_info_pk
 WHERE CAST(isnull(CAST(c1.reg_dt AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.reg_dt AS nvarchar(max)), '') AS nvarchar(max));

/*
1. ctpv_cd_pk
 => 군위군
2. mdfcn_id, mdfcn_dt
 => 수정된 값 존재
*/



-- tb_itrst_atlfsl_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_itrst_atlfsl_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_itrst_atlfsl_info c2
              on c1.itrst_atlfsl_info_pk = c2.itrst_atlfsl_info_pk
 where(
       case when cast(c1.user_no_pk as nvarchar(max)) in (null, '') then ''
            else c1.user_no_pk
        end !=
       case when cast(c2.user_no_pk as nvarchar(max)) in (null, '') then ''
            else c2.user_no_pk
        end
    or case when cast(c1.lrea_office_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_info_pk
        end !=
       case when cast(c2.lrea_office_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_info_pk
        end
    or case when cast(c1.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_bsc_info_pk
        end !=
       case when cast(c2.atlfsl_bsc_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_bsc_info_pk
        end
    or case when cast(c1.hsmp_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.hsmp_info_pk
        end !=
       case when cast(c2.hsmp_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.hsmp_info_pk
        end
    or case when cast(c1.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.emd_li_cd_pk
        end !=
       case when cast(c2.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.emd_li_cd_pk
        end
    or case when cast(c1.use_yn as nvarchar(max)) in (null, '') then ''
              else c1.use_yn
        end !=
       case when cast(c2.use_yn as nvarchar(max)) in (null, '') then ''
            else c2.use_yn
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end
    or case when cast(c1.rprs_yn as nvarchar(max)) in (null, '') then ''
              else c1.rprs_yn
        end !=
       case when cast(c2.rprs_yn as nvarchar(max)) in (null, '') then ''
            else c2.rprs_yn
        end
    or case when cast(c1.lttot_tbl_se_cd as nvarchar(max)) in (null, '') then ''
              else c1.lttot_tbl_se_cd
        end !=
       case when cast(c2.lttot_tbl_se_cd as nvarchar(max)) in (null, '') then ''
            else c2.lttot_tbl_se_cd
        end
    or case when cast(c1.house_mng_no as nvarchar(max)) in (null, '') then ''
              else c1.house_mng_no
        end !=
       case when cast(c2.house_mng_no as nvarchar(max)) in (null, '') then ''
            else c2.house_mng_no
        end);


SELECT c1.itrst_atlfsl_info_pk, c1.house_mng_no, c2.house_mng_no
  FROM db_khb_srv_230908.sc_khb_srv.tb_itrst_atlfsl_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_itrst_atlfsl_info c2
              ON c1.itrst_atlfsl_info_pk= c2.itrst_atlfsl_info_pk
 WHERE CAST(isnull(CAST(c1.house_mng_no AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.house_mng_no AS nvarchar(max)), '') AS nvarchar(max));

/*
1. pk순서 변경으로 인한 오류발생
2. rprs_yn, lttot_tbl_se_cd, house_mng_no
 => 어느 테이블에서 가져오는 것인가?
*/



-- tb_link_apt_lttot_cmpet_rt_info



-- tb_link_apt_lttot_house_ty_dtl_info



-- tb_link_apt_lttot_info



-- tb_link_apt_nthg_rank_remndr_hh_lttot_info



-- tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info



-- tb_link_hsmp_area_info



-- tb_link_hsmp_bsc_info



-- tb_link_hsmp_managect_info



-- tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info



-- tb_link_ofctl_cty_prvate_rent_lttot_info



-- tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info



-- tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info



-- tb_link_remndr_hh_lttot_cmpet_rt_info



-- tb_link_rtrcn_re_sply_lttot_cmpet_rt_info



-- tb_link_subway_statn_info



-- tb_lrea_office_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_lrea_office_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_lrea_office_info c2
              on c1.lrea_office_info_pk = c2.lrea_office_info_pk
 where(
       case when cast(c1.bzmn_no as nvarchar(max)) in (null, '') then ''
            else c1.bzmn_no
        end !=
       case when cast(c2.bzmn_no as nvarchar(max)) in (null, '') then ''
            else c2.bzmn_no
        end
    or case when cast(c1.lrea_office_nm as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_nm
        end !=
       case when cast(c2.lrea_office_nm as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_nm
        end
    or case when cast(c1.lrea_office_rprsv_nm as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_rprsv_nm
        end !=
       case when cast(c2.lrea_office_rprsv_nm as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_rprsv_nm
        end
    or case when cast(c1.tlphon_type_cd as nvarchar(max)) in (null, '') then ''
              else c1.tlphon_type_cd
        end !=
       case when cast(c2.tlphon_type_cd as nvarchar(max)) in (null, '') then ''
            else c2.tlphon_type_cd
        end
    or case when cast(c1.safety_no as nvarchar(max)) in (null, '') then ''
              else c1.safety_no
        end !=
       case when cast(c2.safety_no as nvarchar(max)) in (null, '') then ''
            else c2.safety_no
        end
    or case when cast(c1.lrea_office_rprs_telno as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_rprs_telno
        end !=
       case when cast(c2.lrea_office_rprs_telno as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_rprs_telno
        end
    or case when cast(c1.lrea_telno as nvarchar(max)) in (null, '') then ''
              else c1.lrea_telno
        end !=
       case when cast(c2.lrea_telno as nvarchar(max)) in (null, '') then ''
            else c2.lrea_telno
        end
    or case when cast(c1.lrea_office_addr as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_addr
        end !=
       case when cast(c2.lrea_office_addr as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_addr
        end
    or case when cast(c1.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.ctpv_cd_pk
        end !=
       case when cast(c2.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_cd_pk
        end
    or case when cast(c1.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.sgg_cd_pk
        end !=
       case when cast(c2.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.sgg_cd_pk
        end
    or case when cast(c1.stdg_innb as nvarchar(max)) in (null, '') then ''
              else c1.stdg_innb
        end !=
       case when cast(c2.stdg_innb as nvarchar(max)) in (null, '') then ''
            else c2.stdg_innb
        end
    or case when cast(c1.dong_innb as nvarchar(max)) in (null, '') then ''
              else c1.dong_innb
        end !=
       case when cast(c2.dong_innb as nvarchar(max)) in (null, '') then ''
            else c2.dong_innb
        end
    or case when cast(c1.user_level_no as nvarchar(max)) in (null, '') then ''
              else c1.user_level_no
        end !=
       case when cast(c2.user_level_no as nvarchar(max)) in (null, '') then ''
            else c2.user_level_no
        end
    or case when cast(c1.rprs_img_one_url as nvarchar(max)) in (null, '') then ''
              else c1.rprs_img_one_url
        end !=
       case when cast(c2.rprs_img_one_url as nvarchar(max)) in (null, '') then ''
            else c2.rprs_img_one_url
        end
    or case when cast(c1.rprs_img_two_url as nvarchar(max)) in (null, '') then ''
              else c1.rprs_img_two_url
        end !=
       case when cast(c2.rprs_img_two_url as nvarchar(max)) in (null, '') then ''
            else c2.rprs_img_two_url
        end
    or case when cast(c1.rprs_img_three_url as nvarchar(max)) in (null, '') then ''
              else c1.rprs_img_three_url
        end !=
       case when cast(c2.rprs_img_three_url as nvarchar(max)) in (null, '') then ''
            else c2.rprs_img_three_url
        end
    or case when cast(c1.lat as nvarchar(max)) in (null, '') then ''
              else c1.lat
        end !=
       case when cast(c2.lat as nvarchar(max)) in (null, '') then ''
            else c2.lat
        end
    or case when cast(c1.lot as nvarchar(max)) in (null, '') then ''
              else c1.lot
        end !=
       case when cast(c2.lot as nvarchar(max)) in (null, '') then ''
            else c2.lot
        end
    or case when cast(c1.user_ty_cd as nvarchar(max)) in (null, '') then ''
              else c1.user_ty_cd
        end !=
       case when cast(c2.user_ty_cd as nvarchar(max)) in (null, '') then ''
            else c2.user_ty_cd
        end
    or case when cast(c1.stts_cd as nvarchar(max)) in (null, '') then ''
              else c1.stts_cd
        end !=
       case when cast(c2.stts_cd as nvarchar(max)) in (null, '') then ''
            else c2.stts_cd
        end
    or case when cast(c1.use_yn as nvarchar(max)) in (null, '') then ''
              else c1.use_yn
        end !=
       case when cast(c2.use_yn as nvarchar(max)) in (null, '') then ''
            else c2.use_yn
        end
    or case when cast(c1.hmpg_url as nvarchar(max)) in (null, '') then ''
              else c1.hmpg_url
        end !=
       case when cast(c2.hmpg_url as nvarchar(max)) in (null, '') then ''
            else c2.hmpg_url
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end
    or case when cast(c1.lrea_office_intrcn_cn as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_intrcn_cn
        end !=
       case when cast(c2.lrea_office_intrcn_cn as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_intrcn_cn
        end
    or case when cast(c1.eml as nvarchar(max)) in (null, '') then ''
              else c1.eml
        end !=
       case when cast(c2.eml as nvarchar(max)) in (null, '') then ''
            else c2.eml
        end);

SELECT c1.lrea_office_info_pk, c1.lrea_telno, c2.lrea_telno
  FROM db_khb_srv_230908.sc_khb_srv.tb_lrea_office_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_lrea_office_info c2
              ON c1.lrea_office_info_pk= c2.lrea_office_info_pk
 WHERE CAST(isnull(CAST(c1.lrea_telno AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.lrea_telno AS nvarchar(max)), '') AS nvarchar(max));

/*
1. lrea_telno
 => \한개가 없다.
2. lat, lot, lrea_office_crdnt
 => 0과 null
3. hmpg_url
 => \\개수 차이
4. lrea_office_intrcn_cn
 => '테스트' vs null
*/



-- tb_lttot_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_lttot_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_lttot_info c2
              on c1.lttot_info_pk = c2.lttot_info_pk
 where(
       case when cast(c1.lttot_info_ttl_nm as nvarchar(max)) in (null, '') then ''
            else c1.lttot_info_ttl_nm
        end !=
       case when cast(c2.lttot_info_ttl_nm as nvarchar(max)) in (null, '') then ''
            else c2.lttot_info_ttl_nm
        end
    or case when cast(c1.lttot_info_cn as nvarchar(max)) in (null, '') then ''
              else c1.lttot_info_cn
        end !=
       case when cast(c2.lttot_info_cn as nvarchar(max)) in (null, '') then ''
            else c2.lttot_info_cn
        end
    or case when cast(c1.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.ctpv_cd_pk
        end !=
       case when cast(c2.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_cd_pk
        end
    or case when cast(c1.ctpv_nm as nvarchar(max)) in (null, '') then ''
              else c1.ctpv_nm
        end !=
       case when cast(c2.ctpv_nm as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_nm
        end
    or case when cast(c1.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.sgg_cd_pk
        end !=
       case when cast(c2.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.sgg_cd_pk
        end
    or case when cast(c1.sgg_nm as nvarchar(max)) in (null, '') then ''
              else c1.sgg_nm
        end !=
       case when cast(c2.sgg_nm as nvarchar(max)) in (null, '') then ''
            else c2.sgg_nm
        end
    or case when cast(c1.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.emd_li_cd_pk
        end !=
       case when cast(c2.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.emd_li_cd_pk
        end
    or case when cast(c1.all_emd_li_nm as nvarchar(max)) in (null, '') then ''
              else c1.all_emd_li_nm
        end !=
       case when cast(c2.all_emd_li_nm as nvarchar(max)) in (null, '') then ''
            else c2.all_emd_li_nm
        end
    or case when cast(c1.dtl_addr as nvarchar(max)) in (null, '') then ''
              else c1.dtl_addr
        end !=
       case when cast(c2.dtl_addr as nvarchar(max)) in (null, '') then ''
            else c2.dtl_addr
        end
    or case when cast(c1.sply_scale_cn as nvarchar(max)) in (null, '') then ''
              else c1.sply_scale_cn
        end !=
       case when cast(c2.sply_scale_cn as nvarchar(max)) in (null, '') then ''
            else c2.sply_scale_cn
        end
    or case when cast(c1.sply_house_area_cn as nvarchar(max)) in (null, '') then ''
              else c1.sply_house_area_cn
        end !=
       case when cast(c2.sply_house_area_cn as nvarchar(max)) in (null, '') then ''
            else c2.sply_house_area_cn
        end
    or case when cast(c1.lttot_pc_cn as nvarchar(max)) in (null, '') then ''
              else c1.lttot_pc_cn
        end !=
       case when cast(c2.lttot_pc_cn as nvarchar(max)) in (null, '') then ''
            else c2.lttot_pc_cn
        end
    or case when cast(c1.rcrit_pbanc_day as nvarchar(max)) in (null, '') then ''
              else c1.rcrit_pbanc_day
        end !=
       case when cast(c2.rcrit_pbanc_day as nvarchar(max)) in (null, '') then ''
            else c2.rcrit_pbanc_day
        end
    or case when cast(c1.subscrpt_rcpt_day_list as nvarchar(max)) in (null, '') then ''
              else c1.subscrpt_rcpt_day_list
        end !=
       case when cast(c2.subscrpt_rcpt_day_list as nvarchar(max)) in (null, '') then ''
            else c2.subscrpt_rcpt_day_list
        end
    or case when cast(c1.przwner_prsntn_day as nvarchar(max)) in (null, '') then ''
              else c1.przwner_prsntn_day
        end !=
       case when cast(c2.przwner_prsntn_day as nvarchar(max)) in (null, '') then ''
            else c2.przwner_prsntn_day
        end
    or case when cast(c1.mvn_prnmnt_day as nvarchar(max)) in (null, '') then ''
              else c1.mvn_prnmnt_day
        end !=
       case when cast(c2.mvn_prnmnt_day as nvarchar(max)) in (null, '') then ''
            else c2.mvn_prnmnt_day
        end
    or case when cast(c1.ctrt_pd as nvarchar(max)) in (null, '') then ''
              else c1.ctrt_pd
        end !=
       case when cast(c2.ctrt_pd as nvarchar(max)) in (null, '') then ''
            else c2.ctrt_pd
        end
    or case when cast(c1.bldr_nm as nvarchar(max)) in (null, '') then ''
              else c1.bldr_nm
        end !=
       case when cast(c2.bldr_nm as nvarchar(max)) in (null, '') then ''
            else c2.bldr_nm
        end
    or case when cast(c1.mdlhs_opnng_day as nvarchar(max)) in (null, '') then ''
              else c1.mdlhs_opnng_day
        end !=
       case when cast(c2.mdlhs_opnng_day as nvarchar(max)) in (null, '') then ''
            else c2.mdlhs_opnng_day
        end
    or case when cast(c1.lttot_inqry_info_cn as nvarchar(max)) in (null, '') then ''
              else c1.lttot_inqry_info_cn
        end !=
       case when cast(c2.lttot_inqry_info_cn as nvarchar(max)) in (null, '') then ''
            else c2.lttot_inqry_info_cn
        end
    or case when cast(c1.cvntl_info_cn as nvarchar(max)) in (null, '') then ''
              else c1.cvntl_info_cn
        end !=
       case when cast(c2.cvntl_info_cn as nvarchar(max)) in (null, '') then ''
            else c2.cvntl_info_cn
        end
    or case when cast(c1.trnsport_envrn_info_cn as nvarchar(max)) in (null, '') then ''
              else c1.trnsport_envrn_info_cn
        end !=
       case when cast(c2.trnsport_envrn_info_cn as nvarchar(max)) in (null, '') then ''
            else c2.trnsport_envrn_info_cn
        end
    or case when cast(c1.edu_envrn_info_cn as nvarchar(max)) in (null, '') then ''
              else c1.edu_envrn_info_cn
        end !=
       case when cast(c2.edu_envrn_info_cn as nvarchar(max)) in (null, '') then ''
            else c2.edu_envrn_info_cn
        end
    or case when cast(c1.img_url as nvarchar(max)) in (null, '') then ''
              else c1.img_url
        end !=
       case when cast(c2.img_url as nvarchar(max)) in (null, '') then ''
            else c2.img_url
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);


SELECT c1.lttot_info_pk, c1.edu_envrn_info_cn, c2.edu_envrn_info_cn
  FROM db_khb_srv_230908.sc_khb_srv.tb_lttot_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_lttot_info c2
              ON c1.lttot_info_pk= c2.lttot_info_pk
 WHERE CAST(isnull(CAST(c1.edu_envrn_info_cn AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.edu_envrn_info_cn AS nvarchar(max)), '') AS nvarchar(max));

/*
1. lttot_info_ttl_nm
 => 유니코드 오류??
2. sply_house_area_cn
 => \오류
3. lttot_pc_cn, trnsport_envrn_info_cn, edu_envrn_info_cn
 => 유니코드 오류
4.
*/



-- tb_user_atlfsl_img_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_user_atlfsl_img_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_user_atlfsl_img_info c2
              on c1.user_atlfsl_img_info_pk = c2.user_atlfsl_img_info_pk
 where(
       case when cast(c1.user_atlfsl_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.user_atlfsl_info_pk
        end !=
       case when cast(c2.user_atlfsl_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.user_atlfsl_info_pk
        end
    or case when cast(c1.sort_ordr as nvarchar(max)) in (null, '') then ''
              else c1.sort_ordr
        end !=
       case when cast(c2.sort_ordr as nvarchar(max)) in (null, '') then ''
            else c2.sort_ordr
        end
    or case when cast(c1.img_file_nm as nvarchar(max)) in (null, '') then ''
              else c1.img_file_nm
        end !=
       case when cast(c2.img_file_nm as nvarchar(max)) in (null, '') then ''
            else c2.img_file_nm
        end
    or case when cast(c1.img_url as nvarchar(max)) in (null, '') then ''
              else c1.img_url
        end !=
       case when cast(c2.img_url as nvarchar(max)) in (null, '') then ''
            else c2.img_url
        end
    or case when cast(c1.thumb_img_url as nvarchar(max)) in (null, '') then ''
              else c1.thumb_img_url
        end !=
       case when cast(c2.thumb_img_url as nvarchar(max)) in (null, '') then ''
            else c2.thumb_img_url
        end
    or case when cast(c1.srvr_img_file_nm as nvarchar(max)) in (null, '') then ''
              else c1.srvr_img_file_nm
        end !=
       case when cast(c2.srvr_img_file_nm as nvarchar(max)) in (null, '') then ''
            else c2.srvr_img_file_nm
        end
    or case when cast(c1.local_img_file_nm as nvarchar(max)) in (null, '') then ''
              else c1.local_img_file_nm
        end !=
       case when cast(c2.local_img_file_nm as nvarchar(max)) in (null, '') then ''
            else c2.local_img_file_nm
        end
    or case when cast(c1.thumb_img_file_nm as nvarchar(max)) in (null, '') then ''
              else c1.thumb_img_file_nm
        end !=
       case when cast(c2.thumb_img_file_nm as nvarchar(max)) in (null, '') then ''
            else c2.thumb_img_file_nm
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);


SELECT c1.user_atlfsl_img_info_pk, c1.mdfcn_dt, c2.mdfcn_dt
  FROM db_khb_srv_230908.sc_khb_srv.tb_user_atlfsl_img_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_user_atlfsl_img_info c2
              ON c1.user_atlfsl_img_info_pk= c2.user_atlfsl_img_info_pk
 WHERE CAST(isnull(CAST(c1.mdfcn_dt AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.mdfcn_dt AS nvarchar(max)), '') AS nvarchar(max));

/*
1. 순서 오류
2. 
*/



-- tb_user_atlfsl_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_user_atlfsl_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_user_atlfsl_info c2
              on c1.user_atlfsl_info_pk = c2.user_atlfsl_info_pk
 where(
       case when cast(c1.user_no_pk as nvarchar(max)) in (null, '') then ''
            else c1.user_no_pk
        end !=
       case when cast(c2.user_no_pk as nvarchar(max)) in (null, '') then ''
            else c2.user_no_pk
        end
    or case when cast(c1.preocupy_lrea_cnt as nvarchar(max)) in (null, '') then ''
              else c1.preocupy_lrea_cnt
        end !=
       case when cast(c2.preocupy_lrea_cnt as nvarchar(max)) in (null, '') then ''
            else c2.preocupy_lrea_cnt
        end
    or case when cast(c1.atlfsl_knd_cd as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_knd_cd
        end !=
       case when cast(c2.atlfsl_knd_cd as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_knd_cd
        end
    or case when cast(c1.dlng_se_cd as nvarchar(max)) in (null, '') then ''
              else c1.dlng_se_cd
        end !=
       case when cast(c2.dlng_se_cd as nvarchar(max)) in (null, '') then ''
            else c2.dlng_se_cd
        end
    or case when cast(c1.atlfsl_stts_cd as nvarchar(max)) in (null, '') then ''
              else c1.atlfsl_stts_cd
        end !=
       case when cast(c2.atlfsl_stts_cd as nvarchar(max)) in (null, '') then ''
            else c2.atlfsl_stts_cd
        end
    or case when cast(c1.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.ctpv_cd_pk
        end !=
       case when cast(c2.ctpv_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_cd_pk
        end
    or case when cast(c1.ctpv_nm as nvarchar(max)) in (null, '') then ''
              else c1.ctpv_nm
        end !=
       case when cast(c2.ctpv_nm as nvarchar(max)) in (null, '') then ''
            else c2.ctpv_nm
        end
    or case when cast(c1.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.sgg_cd_pk
        end !=
       case when cast(c2.sgg_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.sgg_cd_pk
        end
    or case when cast(c1.sgg_nm as nvarchar(max)) in (null, '') then ''
              else c1.sgg_nm
        end !=
       case when cast(c2.sgg_nm as nvarchar(max)) in (null, '') then ''
            else c2.sgg_nm
        end
    or case when cast(c1.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
              else c1.emd_li_cd_pk
        end !=
       case when cast(c2.emd_li_cd_pk as nvarchar(max)) in (null, '') then ''
            else c2.emd_li_cd_pk
        end
    or case when cast(c1.all_emd_li_nm as nvarchar(max)) in (null, '') then ''
              else c1.all_emd_li_nm
        end !=
       case when cast(c2.all_emd_li_nm as nvarchar(max)) in (null, '') then ''
            else c2.all_emd_li_nm
        end
    or case when cast(c1.mno as nvarchar(max)) in (null, '') then ''
              else c1.mno
        end !=
       case when cast(c2.mno as nvarchar(max)) in (null, '') then ''
            else c2.mno
        end
    or case when cast(c1.sno as nvarchar(max)) in (null, '') then ''
              else c1.sno
        end !=
       case when cast(c2.sno as nvarchar(max)) in (null, '') then ''
            else c2.sno
        end
    or case when cast(c1.lat as nvarchar(max)) in (null, '') then ''
              else c1.lat
        end !=
       case when cast(c2.lat as nvarchar(max)) in (null, '') then ''
            else c2.lat
        end
    or case when cast(c1.lot as nvarchar(max)) in (null, '') then ''
              else c1.lot
        end !=
       case when cast(c2.lot as nvarchar(max)) in (null, '') then ''
            else c2.lot
        end
    or case when cast(c1.trde_pc as nvarchar(max)) in (null, '') then ''
              else c1.trde_pc
        end !=
       case when cast(c2.trde_pc as nvarchar(max)) in (null, '') then ''
            else c2.trde_pc
        end
    or case when cast(c1.lfsts_pc as nvarchar(max)) in (null, '') then ''
              else c1.lfsts_pc
        end !=
       case when cast(c2.lfsts_pc as nvarchar(max)) in (null, '') then ''
            else c2.lfsts_pc
        end
    or case when cast(c1.mtht_yyt_pc as nvarchar(max)) in (null, '') then ''
              else c1.mtht_yyt_pc
        end !=
       case when cast(c2.mtht_yyt_pc as nvarchar(max)) in (null, '') then ''
            else c2.mtht_yyt_pc
        end
    or case when cast(c1.room_cnt as nvarchar(max)) in (null, '') then ''
              else c1.room_cnt
        end !=
       case when cast(c2.room_cnt as nvarchar(max)) in (null, '') then ''
            else c2.room_cnt
        end
    or case when cast(c1.btr_cnt as nvarchar(max)) in (null, '') then ''
              else c1.btr_cnt
        end !=
       case when cast(c2.btr_cnt as nvarchar(max)) in (null, '') then ''
            else c2.btr_cnt
        end
    or case when cast(c1.lrea_office_atmc_chc_yn as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_atmc_chc_yn
        end !=
       case when cast(c2.lrea_office_atmc_chc_yn as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_atmc_chc_yn
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end
    or case when cast(c1.dtl_addr as nvarchar(max)) in (null, '') then ''
              else c1.dtl_addr
        end !=
       case when cast(c2.dtl_addr as nvarchar(max)) in (null, '') then ''
            else c2.dtl_addr
        end);


SELECT c1.user_atlfsl_info_pk, c1.dtl_addr, c2.dtl_addr
  FROM db_khb_srv_230908.sc_khb_srv.tb_user_atlfsl_info c1
       LEFT JOIN
       db_khb_srv.sc_khb_srv.tb_user_atlfsl_info c2
              ON c1.user_atlfsl_info_pk= c2.user_atlfsl_info_pk
 WHERE CAST(isnull(CAST(c1.dtl_addr AS nvarchar(max)), '') AS nvarchar(max)) 
       !=
       CAST(isnull(CAST(c2.dtl_addr AS nvarchar(max)), '') AS nvarchar(max));

/*
1. 순서 오류
2. trde_pc
 => 어느 테이블??
*/



-- tb_user_atlfsl_preocupy_info
SELECT *
  from db_khb_srv_230908.sc_khb_srv.tb_user_atlfsl_preocupy_info c1
       left join
       db_khb_srv.sc_khb_srv.tb_user_atlfsl_preocupy_info c2
              on c1.user_atlfsl_preocupy_info_pk = c2.user_atlfsl_preocupy_info_pk
 where(
       case when cast(c1.user_atlfsl_info_pk as nvarchar(max)) in (null, '') then ''
            else c1.user_atlfsl_info_pk
        end !=
       case when cast(c2.user_atlfsl_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.user_atlfsl_info_pk
        end
    or case when cast(c1.lrea_office_info_pk as nvarchar(max)) in (null, '') then ''
              else c1.lrea_office_info_pk
        end !=
       case when cast(c2.lrea_office_info_pk as nvarchar(max)) in (null, '') then ''
            else c2.lrea_office_info_pk
        end
    or case when cast(c1.preocupy_yn as nvarchar(max)) in (null, '') then ''
              else c1.preocupy_yn
        end !=
       case when cast(c2.preocupy_yn as nvarchar(max)) in (null, '') then ''
            else c2.preocupy_yn
        end
    or case when cast(c1.reg_id as nvarchar(max)) in (null, '') then ''
              else c1.reg_id
        end !=
       case when cast(c2.reg_id as nvarchar(max)) in (null, '') then ''
            else c2.reg_id
        end
    or case when cast(c1.reg_dt as nvarchar(max)) in (null, '') then ''
              else c1.reg_dt
        end !=
       case when cast(c2.reg_dt as nvarchar(max)) in (null, '') then ''
            else c2.reg_dt
        end
    or case when cast(c1.mdfcn_id as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_id
        end !=
       case when cast(c2.mdfcn_id as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_id
        end
    or case when cast(c1.mdfcn_dt as nvarchar(max)) in (null, '') then ''
              else c1.mdfcn_dt
        end !=
       case when cast(c2.mdfcn_dt as nvarchar(max)) in (null, '') then ''
            else c2.mdfcn_dt
        end);

/*완전 일치*/





