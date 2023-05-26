-- select id="connTest" 완료
SELECT 1 AS CONN;
/*----------------------------------------------------------------------------------------*/ 
-- select id="sidoList" 완료
SELECT SIDO_NO AS sidoNo,
       SIDO_NAME AS sidoName,
       SIDO_NAME_ALIAS AS sidoNameAlias
FROM SIDO_CODE
ORDER BY SIDO_NO ASC;
/*----------------------------------------------------------------------------------------*/
-- select id="gugunList" 완료
SELECT GUGUN_NO as gugunNo,
       SIDO_NO as sidoNo,
       GUGUN_NAME as gugunName
FROM GUGUN_CODE 
WHERE SIDO_NO = 9
/*WHERE GUGUN_NO = #{gugun_no}  -- 9, 2*/
ORDER BY GUGUN_NAME ASC;
/*----------------------------------------------------------------------------------------*/
-- select id="dongList" 완료
SELECT DONG_NO AS dongNo,
       SIDO_NO AS sidoNo,
       GUGUN_NO AS gugunNo,
       DONG_NAME AS dongName,
       DONG_NAME_DISP AS dongNameDisp
FROM DONG_CODE
WHERE GUGUN_NO = 120 AND DONG_GBN = 'B'
/*WHERE GUGUN_NO = #{gugun_no}  -- 120, 154*/
ORDER BY DONG_NAME_DISP ASC;
/*----------------------------------------------------------------------------------------*/
-- select id="danjiList" 완료
SELECT DANJI_NO AS danjiNo,
	   DANJI_NAME AS danjiName
FROM DANJI_INFO
WHERE DONG_NO IN ( SELECT DONG_NO
                   FROM DONG_CODE X 
         	       WHERE X.JUNGBU_CODE LIKE ( SELECT CASE WHEN RIGHT(JUNGBU_CODE,2) = '00' 
         	                                                THEN CONCAT(LEFT(JUNGBU_CODE,8),'%')
	             	                                      ELSE JUNGBU_CODE
	             	                                 END 
	                                          FROM DONG_CODE A
	                                          WHERE A.DONG_NO = 4366
	                                          /*WHERE GUGUN_NO = A.DONG_NO = #{dong_no} -- 4366, 4357 */)
                 )
      AND CATE_CD = '01'
      /*CATE_CD = #{cate_cd} -- '01', '06'*/
ORDER BY DANJI_NAME ASC;
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveInterestDanji" 완료
SELECT D.DANJI_NO AS danjiNo,
	   D.DANJI_NAME AS danjiName,
	   (CASE B.ARTICLE_TYPE
	        WHEN 'A01' THEN '아파트'
	        WHEN 'A02' THEN '오피스텔'
	        WHEN 'A03' THEN '주상복합'
	        WHEN 'A04' THEN '재건축'
	        WHEN 'B01' THEN '아파트 분양권'
	        WHEN 'B02' THEN '오피스텔 분양권'
	        ELSE '주상복합 분양권'
		END) AS 'mamulType',
	   SUM(CASE WHEN TRADE_TYPE='A1' AND A.STAT = 'Y' THEN 1 ELSE 0 END) AS 'a1COUNT',
	   SUM(CASE WHEN TRADE_TYPE='B1' AND A.STAT = 'Y' THEN 1 ELSE 0 END) AS 'b1COUNT',
	   SUM(CASE WHEN TRADE_TYPE='B2' AND A.STAT = 'Y' THEN 1 ELSE 0 END) AS 'b2COUNT',
	   SUM(CASE WHEN TRADE_TYPE='B3' AND A.STAT = 'Y' THEN 1 ELSE 0 END) AS 'b3COUNT',
       IFNULL(SUM(CASE WHEN TRADE_TYPE='A1' AND A.STAT = 'Y' THEN 1 ELSE 0 END),0) + IFNULL(SUM(CASE WHEN TRADE_TYPE='B1' AND A.STAT = 'Y' THEN 1 ELSE 0 END),0) + IFNULL(SUM(CASE WHEN TRADE_TYPE='B2' AND A.STAT = 'Y' THEN 1 ELSE 0 END),0) + IFNULL(SUM(CASE WHEN TRADE_TYPE='B3' AND A.STAT = 'Y' THEN 1 ELSE 0 END),0) AS allCnt,
       D.DANJI_LNG as danjiLng,
       D.DANJI_LAT as danjiLat,
       E.URL_DRAWING as urlDrawing,
       F.SIDO_NAME as sidoName,
       G.GUGUN_NAME as gugunName,
       H.DONG_NAME as dongName,
       D.I_YEAR AS buildYear,
	   D.I_MONTH AS buildMonth,
	   D.CNT_TOT_SEDE as cntTotSede,
	   D.GEOCODE AS location
FROM TRADE_INFO C
        LEFT OUTER JOIN PRODUCT_INFO A ON A.PRODUCT_NO = C.PRODUCT_NO	  
        LEFT OUTER JOIN ARTICLE_TYPE_AB_INFO B ON B.PRODUCT_NO = C.PRODUCT_NO
        INNER JOIN REALTOR_INFO J ON A.REALTOR_NO = J.REALTOR_NO AND J.STAT = 'Y' AND J.STATUS_CODE in ('H01', 'H70')
        RIGHT OUTER JOIN DANJI_INFO D ON B.APT_NO = D.DANJI_NO
        LEFT OUTER JOIN DANJI_DETAIL_INFO E ON D.DANJI_NO = E.DANJI_NO AND A.DANJI_DETAIL_NO = E.DANJI_DETAIL_NO
        INNER JOIN SIDO_CODE F ON D.SIDO_NO = F.SIDO_NO
   	    INNER JOIN GUGUN_CODE G ON D.GUGUN_NO = G.GUGUN_NO
        INNER JOIN DONG_CODE H ON D.DONG_NO = H.DONG_NO
        WHERE 1 = 1
        AND A.DONG_NO  IN (
            SELECT DONG_NO
            FROM DONG_CODE X 
         	WHERE X.JUNGBU_CODE LIKE (
          	SELECT CASE WHEN RIGHT(JUNGBU_CODE,2) = '00' THEN CONCAT(LEFT(JUNGBU_CODE,8),'%')
             	ELSE JUNGBU_CODE
             END 
             FROM DONG_CODE A 
             WHERE A.DONG_NO = 4366
             /*WHERE A.DONG_NO = #{dongNo} -- 4366, 4357 */
            )
       	)
		GROUP BY D.DANJI_NO
		ORDER BY DANJI_NAME ASC;
/*----------------------------------------------------------------------------------------*/
-- select id="codeList" 완료
SELECT CODE AS code,
	   CODE_NM AS codeNm,
	   CODE_DESC AS codeDesc
FROM COM_CODE
WHERE GRD_CD = '170'
/*WHERE GRD_CD = #{grp_cd} -- '170', '000'*/
ORDER BY CODE ASC;
/*----------------------------------------------------------------------------------------*/
-- select id="codeDesc" 완료
SELECT CODE_NM AS codeNm
FROM COM_CODE
WHERE GRD_CD = 170
/*WHERE GRD_CD = #{grp_cd} -- '170', '000'*/
      AND CODE_DESC IS NULL;
      /*WHERE CODE_DESC = #{code_desc} -- 'HF007', '두레_가입_형태'*/
/*----------------------------------------------------------------------------------------*/
-- select id="getMamulMapList" 완료
SELECT CLUSTER_NO as clusterNo, 
	   LEVEL as clusterLevel, 
	   '' as clusterText, 
	   CENTER_LAT as centerLat, 
	   CENTER_LNG as centerLng, 
	   COUNT_INFO as countInfo,
	   TOP_LAT as maxLat,
	   BOT_LAT as minLat,
	   LEFT_LNG as minLng,
	   RIGHT_LNG as maxLng
FROM MAP_CLUSTER_INFO
WHERE CENTER_LAT BETWEEN 33.115 AND 33.8
      /*CENTER_LAT BETWEEN #{minLat} AND #{maxLat}*/
	  AND CENTER_LNG BETWEEN 126 AND 129
	  /*CENTER_LNG BETWEEN #{minLng} AND #{maxLng}*/
   	  AND LEVEL = 5; 
/*----------------------------------------------------------------------------------------*/
-- select id="getDanjiMapMarkList" 완료
SELECT 
			DANJI_NO as danjiNo,
			DANJI_LAT as centerLat,
			DANJI_LNG as centerLng,
			CNT_TOT_SEDE as cntTotSede, 
			(6371*acos(cos(radians(33))*cos(radians(DANJI_LAT))*cos(radians(DANJI_LNG)
			-radians(126))+sin(radians(126))*sin(radians(DANJI_LAT))))
			AS distance
			/*(6371*acos(cos(radians(#{minLat}))*cos(radians(DANJI_LAT))*cos(radians(DANJI_LNG)
			-radians(#{minLng}))+sin(radians(#{minLat}))*sin(radians(DANJI_LAT))))
			AS distance*/
		FROM DANJI_INFO 
	    WHERE DANJI_LAT BETWEEN 33 AND 34
	    AND DANJI_LNG BETWEEN 126 AND 129
	    AND STAT = 'Y'
	    ORDER BY DISTANCE;
/*----------------------------------------------------------------------------------------*/
-- select id="getRealtorMapMarkList" 완료
SELECT REALTOR_NO as realtorNo,
	   REALTOR_LAT as centerLat,
	   REALTOR_LNG as centerLng,
	   (6371*acos(cos(radians(33))*cos(radians(REALTOR_LAT))*cos(radians(REALTOR_LNG)
		-radians(126))+sin(radians(126))*sin(radians(REALTOR_LAT))))
	   AS distance
	   /*(6371*acos(cos(radians(#{minLat}))*cos(radians(DANJI_LAT))*cos(radians(DANJI_LNG)
			-radians(#{minLng}))+sin(radians(#{minLat}))*sin(radians(DANJI_LAT))))
			AS distance*/
FROM REALTOR_INFO 
WHERE STAT = 'Y'
	  AND REALTOR_LAT BETWEEN 33 AND 34
	  AND REALTOR_LNG BETWEEN 126 AND 129
ORDER BY DISTANCE;
/*----------------------------------------------------------------------------------------*/
-- select id="getSubwayMapList" 완료
SELECT SUBWAY_STATION_NAME as clusterText, 
		    '' as hp, 
		    '' as homepage, 
		    JSON_EXTRACT(SUBWAY_GEOCODE, "$.lat") AS centerLat,
		    JSON_EXTRACT(SUBWAY_GEOCODE, "$.lng") AS centerLng,    
			0 as hiraNo,
			0 as schoolNo,
			SUBWAY_NO as subwayNo
FROM SUBWAY_CODE
WHERE JSON_EXTRACT(SUBWAY_GEOCODE, "$.lat") BETWEEN 36 AND 39
      AND JSON_EXTRACT(SUBWAY_GEOCODE, "$.lng") BETWEEN 126 AND 129;
/*----------------------------------------------------------------------------------------*/
-- select id="getMamulMapCount" 완료
/*코드 조사 필요*/
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveMapCenter" 완료
/*코드 조사 필요*/
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveMapMamulList" 
/*코드 조사 필요*/
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveDanjiDetailMamulList" 
/*코드 조사 필요*/
SELECT R.*,
			(
				CASE R.direction
					WHEN 'EE' THEN '동향'
					WHEN 'EN' THEN '북동향'
					WHEN 'ES' THEN '남동향'
					WHEN 'NN' THEN '북향'
					WHEN 'SS' THEN '남향'
					WHEN 'WN' THEN '북서향'
					WHEN 'WS' THEN '남서향'
					WHEN 'WW' THEN '서향'
				ELSE '없음'
				END
			) AS directionName
		FROM (
		SELECT 
				 A.*,
			    D.DEAL_PRICE as dealPrice,
				 D.DEPOSIT_PRICE as depositPrice,
				 D.RENTAL_PRICE as rentalPrice,
				 (SELECT IMG_URL_TH AS imgUrlTh FROM PRODUCT_IMG_INFO WHERE PRODUCT_NO = A.productNo LIMIT 1) AS imgUrlTh,
				 (SELECT IMG_TYPE AS imgUrlTh FROM PRODUCT_IMG_INFO WHERE PRODUCT_NO = A.productNo LIMIT 1) AS imgType,
				 (SELECT CODE_NM FROM COM_CODE WHERE GRD_CD = '100' AND CODE = A.productCateCd) as mamulType,
				 IF(E.DANJI_NAME != '', E.DANJI_NAME, CONCAT(F.SIDO_NAME, ' ', G.GUGUN_NAME, ' ',H.DONG_NAME_DISP)) as danjiName,
				 I.REALTOR_PIC1 as realtorPic1,
				 J.FEATURE AS feature,
				 B.FAV_SEQ_NO as favTradeNo,						
				 (
				 CASE TRADE_TYPE 
				    WHEN 'A1' THEN D.DEAL_PRICE
				    ELSE CONCAT(D.DEPOSIT_PRICE,'/',D.RENTAL_PRICE)
  				 END
				 ) AS dealPriceNm,
				 (
				 CASE WHEN D.TRADE_TYPE = 'A1' THEN '매매'
			    	  WHEN D.TRADE_TYPE = 'B1' THEN '전세'
			    	  WHEN D.TRADE_TYPE = 'B2' THEN '월세'
			    	  WHEN D.TRADE_TYPE = 'B3' THEN '연세'
			     END
			    ) AS articleTypeNm
				 FROM
			    (
				 SELECT
			    	   A_P.PRODUCT_NO AS productNo,
					   A_P.KAR_MM_NO AS karMmNo,
					   A_P.KAR_CONTENT_NO AS karContentNo,
					   A_P.REALTOR_NO AS realtorNo,
					   A_P.PRODUCT_GEOCODE AS productGeocode,
					   A_P.PRODUCT_CATE_CD AS productCateCd,
					   A_P.ARTICLE_INFO_TYPE AS articleInfoType,
					   A_P.ADDR_CODE AS addrCode,
					   A_P.SIDO_NO AS sidoNo,
					   A_P.GUGUN_NO AS gugunNo,
					   A_P.DONG_NO AS dongNo,
					   A_P.DANJI_NO AS danjiNo,
					   A_P.THEME_CDS AS themeCds,
					   A_P.REG_DT AS regDt,
					   A_P.UPDT_DT AS updtDt,
					   A_P.STAT AS stat,
					   A_P.PRODUCT_LAT AS centerLat, 
					   A_P.PRODUCT_LNG AS centerLng,
					   A_P.PRODUCT_NO AS clusterNo,
					   A_P.EXCLS_SPC AS exclsSpc,
					   A_P.ROOM AS room,
					   A_P.OPEN_APT_DONG_YN AS openAptDongYn,
					   A_P.OPEN_APT_TYPE_YN AS openAptTypeYn,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN A_AB.ARTICLE_AB_NO
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN A_C.ARTICLE_C_NO
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN A_D.ARTICLE_D_NO
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN A_EF.ARTICLE_EF_NO
				END 
				) AS articleAbNo,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN A_AB.ARTICLE_TYPE
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN A_C.ARTICLE_TYPE
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN A_D.ARTICLE_TYPE
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN A_EF.ARTICLE_TYPE
				END 
				) AS articleType,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN (
				         SELECT IFNULL(DB2.GONG_METER, '')
				         FROM ARTICLE_TYPE_AB_INFO DB
				            LEFT JOIN DANJI_INFO DB1 ON DB1.DANJI_NO = DB.APT_NO
				            LEFT JOIN DANJI_DETAIL_INFO DB2 ON DB2.DANJI_NO = DB.APT_NO
				         WHERE DB.PRODUCT_NO = A_P.PRODUCT_NO 
				         AND DB.STAT = 'Y' 
				         AND DB2.DANJI_DETAIL_NO = A_P.DANJI_DETAIL_NO   
				      )
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN IFNULL(A_C.SPLY_SPC, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN IFNULL(A_D.SPLY_SPC, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN IFNULL(A_EF.SPLY_SPC, '')
				END 
				) AS splySpc,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN IF(A_AB.APT_DONG !='', CONCAT(A_AB.APT_DONG, '동'), '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN IF(A_C.PLACE !='', A_C.PLACE, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN IF(A_D.PLACE !='', A_D.PLACE, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN IF(A_EF.PLACE !='', A_EF.PLACE, '')
				END 
				) AS place,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN IF(A_AB.HO != '', CONCAT(A_AB.HO, '호'), '')
				   ELSE ''
				END
				) AS placeDetail,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN  IFNULL(A_AB.FLOOR, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN IFNULL(A_C.FLOOR, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN IFNULL(A_D.FLOOR, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN IFNULL(A_EF.FLOOR, '')
				END 
				) AS floor,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN  IFNULL(A_AB.TOTAL_FLOOR, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN IFNULL(A_C.TOTAL_FLOOR, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN IFNULL(A_D.TOTAL_FLOOR, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN IFNULL(A_EF.TOTAL_FLOOR, '')
				END 
				) AS totalFloor,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN  IFNULL(A_AB.RESTROOM, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN IFNULL(A_C.RESTROOM, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN IFNULL(A_D.RESTROOM, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN ''
				END 
				) AS restRoom,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN  IFNULL(A_AB.DIRECTION, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN IFNULL(A_C.DIRECTION, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN IFNULL(A_D.DIRECTION, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN IFNULL(A_EF.DIRECTION, '')
				END 
				) AS direction,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN  IFNULL(A_AB.STAIR_CD, '')
				   ELSE ''
				END 
				) AS stiarCd,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN  IFNULL(A_AB.BALCONY_CD, '')
				   ELSE ''
				END 
				) AS balconyCd,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN(
				         SELECT D1.CNT_SEDE_PARK
				         FROM DANJI_INFO D1
				           LEFT JOIN DANJI_DETAIL_INFO D2 ON D2.DANJI_NO = D1.DANJI_NO
				         WHERE D1.DANJI_NO = A_AB.APT_NO 
				         AND D2.DANJI_DETAIL_NO = A_P.DANJI_DETAIL_NO
				      )
				   ELSE 0
				END 
				) AS cntSedePark,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN(
				         SELECT IF(D1.CNT_TOT_PARK > 0 ,'Y','N')
				         FROM DANJI_INFO D1
				           LEFT JOIN DANJI_DETAIL_INFO D2 ON D2.DANJI_NO = D1.DANJI_NO
				         WHERE D1.DANJI_NO = A_AB.APT_NO 
				         AND D2.DANJI_DETAIL_NO = A_P.DANJI_DETAIL_NO
				      )
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C'
				      THEN IFNULL(A_C.PARKING_PSBL, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D'
				      THEN IFNULL(A_D.PARKING_PSBL, '')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR A_P.ARTICLE_INFO_TYPE = 'F'
				      THEN IFNULL(A_EF.PARKING_PSBL, '')
				END 
				) AS parkingPsbl,
				A_P.THEME_CDS,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B'
				      THEN(
				         SELECT D2.URL_DRAWING
				         FROM DANJI_INFO D1
				           LEFT JOIN DANJI_DETAIL_INFO D2 ON D2.DANJI_NO = D1.DANJI_NO
				         WHERE D1.DANJI_NO = A_AB.APT_NO 
				         AND D2.DANJI_DETAIL_NO = A_P.DANJI_DETAIL_NO
				      )
				   ELSE ''
				END 
				) AS urlDrawing,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C' THEN A_C.BUILD_SPC
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D' THEN A_D.BUILD_SPC
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR  A_P.ARTICLE_INFO_TYPE = 'F' THEN A_EF.BUILD_SPC
				   ELSE 0
				END 
				) AS buildSpc,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C' THEN A_C.GRND_SPC
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D' THEN A_D.GRND_SPC
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR  A_P.ARTICLE_INFO_TYPE = 'F' THEN A_EF.GRND_SPC
				   ELSE 0
				END 
				) AS grndSpc,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B' THEN A_AB.FLR_EXPS_TYPE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C' THEN A_C.FLR_EXPS_TYPE
				   ELSE 10
				END 
				) AS flrExpsType,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'A' OR A_P.ARTICLE_INFO_TYPE = 'B' OR A_P.ARTICLE_INFO_TYPE = 'C'  THEN A_C.FCOR_FLR_EXPS_TYPE
				   ELSE 0
				END 
				) AS fcorFlrExpsType,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C' THEN IFNULL(A_C.DNFLR_CNT, '0')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D' THEN IFNULL(A_D.DNFLR_CNT, '0')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR  A_P.ARTICLE_INFO_TYPE = 'F' THEN IFNULL(A_EF.DNFLR_CNT, '0')
				   ELSE '0'
				END 
				) AS dnflrCnt,
				(
				CASE 
				   WHEN A_P.ARTICLE_INFO_TYPE = 'C' THEN IFNULL(A_C.UPFLR_CNT, '0')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'D' THEN IFNULL(A_D.UPFLR_CNT, '0')
				   WHEN A_P.ARTICLE_INFO_TYPE = 'E' OR  A_P.ARTICLE_INFO_TYPE = 'F' THEN IFNULL(A_EF.UPFLR_CNT, '0')
				   ELSE '0'
				END 
				) AS upflrCnt
			FROM PRODUCT_INFO A_P
			LEFT JOIN article_type_ab_info AS A_AB ON A_P.PRODUCT_NO = A_AB.PRODUCT_NO AND A_AB.STAT = 'Y'
			LEFT JOIN article_type_c_info AS A_C ON A_P.PRODUCT_NO = A_C.PRODUCT_NO AND A_C.STAT = 'Y'
			LEFT JOIN article_type_d_info AS A_D ON A_P.PRODUCT_NO = A_D.PRODUCT_NO AND A_D.STAT = 'Y'
			LEFT JOIN article_type_ef_info AS A_EF ON A_P.PRODUCT_NO = A_EF.PRODUCT_NO AND A_EF.STAT = 'Y' ) A
			LEFT JOIN FAV_INFO B ON A.productNo = B.FAV_SEQ_NO AND B.MEM_NO = 1500031 AND B.FAV_CATE_CD = 'P'
			/*B(FAV_INFO).MEM_NO = #{memNo}*/	
			INNER JOIN TRADE_INFO D ON A.productNo = D.PRODUCT_NO
			LEFT JOIN DANJI_INFO E ON A.danjiNo = E.DANJI_NO
			INNER JOIN SIDO_CODE F ON A.sidoNo = F.SIDO_NO
			INNER JOIN GUGUN_CODE G ON A.gugunNo = G.GUGUN_NO
			INNER JOIN DONG_CODE H ON A.dongNo = H.DONG_NO
			LEFT JOIN REALTOR_INFO I ON A.realtorNo = I.REALTOR_NO
			LEFT JOIN ETC_INFO J ON A.productNo = J.PRODUCT_NO
			LEFT JOIN FACILITIES_INFO L ON A.productNo = L.PRODUCT_NO
			AND E.DANJI_NO = 45
			/*E(DANJI_INFO).DANJI_NO = #{danjiNo}*/
		) AS R
		ORDER BY RAND();

/*----------------------------------------------------------------------------------------*/
-- select id="retrieveMapRealtor" 
SELECT  
			 D.REALTOR_NO AS realtorNo,
			 D.BIZ_NO AS bizNo,
			 D.COMPANY_NAME AS companyName,
			 D.COMPANY_RSTV_NAME AS companyRstvName,
			 D.EXPS_TEL_TYPE AS expsTelType,
			 D.COMPANY_RSTN_PHONE AS companyRstnPhone,
			 CASE WHEN LENGTH(D.COMPANY_SAFETY_PHONE) = 12 THEN 
			 CONCAT(substring(D.COMPANY_SAFETY_PHONE, 1, 4), '-', substring(D.COMPANY_SAFETY_PHONE, 5, 4), '-', substring(D.COMPANY_SAFETY_PHONE, 9, 4))
			 ELSE NULL
			 END AS companySafetyPhone,
			 D.REALTOR_PHONE AS realtorPhone,
			 D.COMPANY_ADDR AS companyAddr,
			 D.SIDO_NO AS sidoNo,
			 D.GUGUN_NO AS gugunNo,
			 D.DONG_NO AS dongNo,
			 D.HDONG_NO AS hdongNo,
			 D.USER_LEVEL AS userLevel,
			 D.REALTOR_PIC1 AS realtorPic1,
			 D.REALTOR_PIC2 AS realtorPic2,
			 D.REALTOR_PIC3 AS realtorPic3,
			 D.REALTOR_LNG AS realtorLng,
    		 D.REALTOR_LAT AS realtorLat,
			 D.REG_DT AS regDt,
			 D.UPT_DT AS uptDt,
			 D.STAT AS stat,
			 SUM(CASE WHEN TRADE_TYPE='A1' AND A.STAT = 'Y' THEN 1 ELSE 0 END) AS 'a1Count', 
             SUM(CASE WHEN TRADE_TYPE='B1' AND A.STAT = 'Y' THEN 1 ELSE 0 END) AS 'b1Count',
	         SUM(CASE WHEN TRADE_TYPE='B2' AND A.STAT = 'Y' THEN 1 ELSE 0 END) AS 'b2Count',
	         SUM(CASE WHEN TRADE_TYPE='B3' AND A.STAT = 'Y' THEN 1 ELSE 0 END) AS 'b3Count',
	         IFNULL(SUM(CASE WHEN TRADE_TYPE='A1' AND A.STAT = 'Y' THEN 1 ELSE 0 END),0) + IFNULL(SUM(CASE WHEN TRADE_TYPE='B1' AND A.STAT = 'Y' THEN 1 ELSE 0 END),0) + IFNULL(SUM(CASE WHEN TRADE_TYPE='B2' AND A.STAT = 'Y' THEN 1 ELSE 0 END),0) + IFNULL(SUM(CASE WHEN TRADE_TYPE='B3' AND A.STAT = 'Y' THEN 1 ELSE 0 END),0) AS allCnt
		FROM REALTOR_INFO D
		LEFT JOIN PRODUCT_INFO A ON  D.REALTOR_NO = A.REALTOR_NO
		LEFT JOIN TRADE_INFO C ON A.PRODUCT_NO = C.PRODUCT_NO
		WHERE D.REALTOR_NO = 66
		/*D.REALTOR_NO = #{realtorNo}*/
		GROUP BY D.REALTOR_NO;
/*----------------------------------------------------------------------------------------*/
-- select id="getRealtorClustMapList" 
/*코드 조사 필요*/

/*----------------------------------------------------------------------------------------*/
-- select id="retrieveMamulList" 
/*코드 조사 필요*/
     
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveMamulCount" 
/*코드 조사 필요*/
     
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveMamulListCount" 
/*코드 조사 필요*/
     
/*----------------------------------------------------------------------------------------*/
-- select id="getDanjiList" 
/*코드 조사 필요*/
     
/*----------------------------------------------------------------------------------------*/
-- select id="danjiListCount" 
/*코드 조사 필요*/
     
/*----------------------------------------------------------------------------------------*/
-- select id="getDanjiMamulCount" 
/*코드 조사 필요*/
     
/*----------------------------------------------------------------------------------------*/
-- select id="getDanjiClustMapList" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="getDanjiDetail" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveMamulDetail" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveMamulDetailImg" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="realtorList" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveRealtorMapList" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveRealtorListCount" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="realtorSearchList" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveRealtorInfo" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveRealtorInfoToSj" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="getDanjiDetailList" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveBoardList" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveBoardList" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveNewsInfo" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="getDanjiDrawing" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="getDanjiDrawingChoice" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="getPubInfo" 
/*코드 조사 필요*/
	
/*----------------------------------------------------------------------------------------*/
-- select id="retrieveRecentMamulList" 
/*코드 조사 필요*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
SELECT trade_type FROM hanbang.realtor_info;


































