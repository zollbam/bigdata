/*
작성일: 231006
수정일: 231010
작성자: 조건영
작성 목적: 새로 추가된 매물_??_코드들 구분지를 공통 코드 필요!!
*/




SELECT *
 FROM (
SELECT mm_no
     , CASE WHEN officetel_use_cd <> '' THEN officetel_use_cd -- 오피스텔용도(G140)
            WHEN building_cate_cd <> '' THEN building_cate_cd -- 건물종류(재개발)(G340)
            WHEN building_use_cd <> '' THEN building_use_cd -- 건물주용도(G520)
            WHEN store_use_cd <> '' THEN store_use_cd -- 주용도_상가점포(G550)
            WHEN office_use_cd <> '' THEN office_use_cd -- 주용도_사무실(G560)
            else '' 
		END atlfsl_usg_cd
	 , CASE WHEN gunrak_cd <> '' THEN gunrak_cd -- 군락형태(G320)
		    WHEN sangga_cd <> '' THEN sangga_cd -- 상가구분(G350)
		    WHEN sukbak_cate_cd <> '' THEN sukbak_cate_cd -- 숙박물건종류(G400)
            WHEN factory_type_cd <> '' THEN factory_type_cd -- 공장형태(G420)
            WHEN factory_cate <> '' THEN factory_cate -- 공장종류
            WHEN saleType <> '' THEN saleType -- 분양구분
            ELSE ''
        END atlfsl_se_cd
     , CASE WHEN sukbak_ipji_cd <> '' THEN sukbak_ipji_cd -- 숙박입지(G410)
            WHEN factory_ipji_cd <> '' THEN factory_ipji_cd -- 공장입지(G440)
            WHEN office_ipji_cd <> '' THEN office_ipji_cd -- 사무실입지(G570)
            WHEN sangga_ipji_cd <> '' THEN sangga_ipji_cd -- 상가입지(G580)
            ELSE ''
        END atlfsl_lct_cd
     , CASE WHEN room_cd <> '' THEN room_cd -- 방구조(G250)
	        WHEN const_struc_cd <> '' THEN const_struc_cd -- 건축구조(공장)(G450)
            ELSE ''
        END atlfsl_strct_cd
     , CASE WHEN concat(officetel_use_cd, building_cate_cd, building_use_cd, store_use_cd, office_use_cd) <> '' 
                 THEN CASE WHEN officetel_use_cd <> '' THEN 'G140, ' 
			               WHEN building_cate_cd <> '' THEN 'G340, '
			               WHEN building_use_cd <> '' THEN 'G520, '
			               WHEN store_use_cd <> '' THEN 'G550, '
			               WHEN office_use_cd <> '' THEN 'G560, '
			               ELSE ''
					   END
		    ELSE ''
        END +
       CASE WHEN concat(gunrak_cd, sangga_cd, sukbak_cate_cd, factory_type_cd, factory_cate, saleType) <> ''
                 THEN CASE WHEN gunrak_cd <> '' THEN 'G320, '
					       WHEN sangga_cd <> '' THEN 'G350, '
					       WHEN sukbak_cate_cd <> '' THEN 'G400, '
			               WHEN factory_type_cd <> '' THEN 'G420, '
			               WHEN factory_cate <> '' THEN ''
			               WHEN saleType <> '' THEN ''
			               ELSE ''
			           END 
			ELSE ''
		END +
       CASE WHEN concat(sukbak_ipji_cd, factory_ipji_cd, office_ipji_cd, sangga_ipji_cd) <> ''
			     THEN CASE WHEN sukbak_ipji_cd <> '' THEN 'G410, '
			               WHEN factory_ipji_cd <> '' THEN 'G440, '
			               WHEN office_ipji_cd <> '' THEN 'G570, '
			               WHEN sangga_ipji_cd <> '' THEN 'G580, '
			               ELSE ''
			           END 
			ELSE ''
		END +
	   CASE WHEN concat(room_cd, const_struc_cd) <> ''
			     THEN CASE WHEN room_cd <> '' THEN 'G250, '
	        			   WHEN const_struc_cd <> '' THEN 'G450, '
	        			   ELSE ''
                       END 
			ELSE ''
		END parents_code
  FROM KMLS.dbo.MAMUL m
 )a;