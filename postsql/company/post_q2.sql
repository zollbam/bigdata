-- postgis 설치
CREATE EXTENSION postgis;

-- postgis 버전확인
SELECT postgis_version();

-- 지도에 점만 찍어줌
SELECT st_setsrid(st_point(dx, dy),2097)
FROM avm_bbook_pyo_count
WHERE mgmbldrgstpk='11110-100181034';
/*
지도처럼 보이지 않고 하얀 종이에 점 하나만 달랑 있다.
st_setsrid로 setsrid를 설정해준다.
srid종류는 5179, 2097 등 여러 종류가 있다.
*/

-- 멀티 폴리곤에서 중앙점의 좌표찾아서 geometry타입으로 만들기
SELECT kor_sub_nm, st_setsrid(st_point(st_x(st_centroid(geom)),st_y(st_centroid(geom))),5179) "중앙값 좌표(5179)"
FROM tl_spsb_statn;
/*
멀티폴리곤이었던 도형이 중앙점을 찾으면 점으로 나타나게 되었습니다.
지하철 역이 서울/대전/ 광주/대구/부산 모두 다 있다.
*/

-- SRID 5181/2097 => 4326으로 변환(전체)
SELECT st_transform(st_setsrid(st_makepoint(dx, dy),2097), 4326)
FROM avm_bbook_pyo_count;
/*
avm_bbook_pyo_count의 dx, dy는 tl_spsb_statn의srid와는 값이 달라서 srid를 바꾸어보았습니다.
5181 : 카카오맵
2097 : 타원체의 한국 중부원점 TM 직각좌표계
*/

SELECT st_transform(st_setsrid(st_makepoint(dx, dy),2097), 4326)
FROM avm_bbook_pyo_count;

-- 5181/2097 => 4326으로 변환(해당건물만)
SELECT st_transform(st_setsrid(st_makepoint(dx, dy),5174), 4326)
FROM avm_bbook_pyo_count
WHERE mgmbldrgstpk='11110-100181034';

-- SRID확인
SELECT st_srid(geom)
FROM tl_spsb_statn ;
/*
srid는 모두 5179로 나오고 있습니다.
이는 네이버 지도에서 사용하는 것으로 알려져있습니다. 
*/

-- tl_spsb_statn의 srid 변환
SELECT st_transform(geom, 4326)
FROM tl_spsb_statn;
/*
5179로 나오는 srid를 4326으로 변경하였습니다.
*/

-- srid를 설정
SELECT st_setsrid(geom, 5179)
FROM tl_spsb_statn;
/*
해당 좌표에 맞는 srid를 설정하여 지도에 그려준다.
srid를 잘못 입력 하면 이상한 장소에 점이 찍히게 된다.
*/

-- 멀티폴리곤 전체 데이터를 다 보여줌
SELECT st_union(geom)
FROM tl_spsb_statn;
/*
avm_bbook_pyo_count은 데이터가 많은 탓인지 멀티폴리곤이 아닌 탓인지 돌아는 가는데 마지막 지도에서 아무것도 보이지가 않는다.
 */

-- geometrycollection을 반환
SELECT st_collect(geom)
FROM tl_spsb_statn;

-- 좌표값 추출의 여러 함수들
SELECT geom "기존",  st_xmax(geom) "x 최대값 추출",  st_ymax(geom) "y 최대값 추출", st_setsrid(st_centroid(geom),5179) "중앙점"
FROM tl_spsb_statn;
/*
st_xmax: 멀티 폴리곤에서 x의 최대값을 추출
st_ymax: 멀티 폴리곤에서 y의 최대값을 추출
st_centroid: 멀티폴리곤 중앙점을 구함
st_xmin, st_ymin 등도 있다.
*/

-- 쿼리 결과(보완 필요)
WITH gis_bil AS (
    SELECT mgmbldrgstpk, st_transform(st_point(dx,dy,5174), 4326) dxy
    FROM avm_bbook_pyo_count
    WHERE mgmbldrgstpk='11110-100181034'
), gis_sub AS (
    SELECT kor_sub_nm, st_makepoint(st_xmin(st_transform(geom, 4326)), st_ymin(st_transform(geom, 4326))) sub_dxy
    FROM tl_spsb_statn
)
SELECT RANK() OVER (ORDER BY st_distancesphere(gb.dxy, gs.sub_dxy)) 순번, 
          gs.kor_sub_nm 이름, 
          round(st_distancesphere(gb.dxy, gs.sub_dxy)::NUMERIC, 2) "거리(m)"
FROM gis_bil gb, gis_sub gs
ORDER BY 3
LIMIT 3;
/*
해당 쿼리문은 거리(m)열이 문자형이 아닌 숫자형이다.
거리값도 오차가 있어 보인다.
2000m이내라는 조건도 없고 min이나 max를 추출하기 보다는 중앙값을 추출하자!!1
 */

-- 쿼리 결과(최종)
-- * st_distancesphere 거리 측정법
WITH gis_bil AS (
				SELECT mgmbldrgstpk, st_transform(st_setsrid(st_makepoint(dx,dy),5174),4326) dxy
				FROM avm_bbook_pyo_count
				WHERE mgmbldrgstpk='11110-100181034'
), gis_sub_tin AS (
                SELECT DISTINCT kor_sub_nm, geom
				FROM tl_spsb_statn
), gis_sub AS (
				SELECT kor_sub_nm, st_transform(st_setsrid(st_centroid(geom),5179), 4326)  sub_dxy
				FROM gis_sub_tin
)
SELECT RANK() OVER (ORDER BY st_distancesphere(gb.dxy, gs.sub_dxy)) 순번, 
               gs.kor_sub_nm 이름, 
               to_char(st_distancesphere(st_geomfromtext(st_astext(gb.dxy)), st_geomfromtext(st_astext(gs.sub_dxy)))::NUMERIC,'FM999999.99') "거리(m)"
FROM gis_bil gb, gis_sub gs
WHERE ST_DWithin(st_geogfromtext(st_astext(gb.dxy)), st_geogfromtext(st_astext(gs.sub_dxy)),2000)= TRUE
LIMIT 3;

-- * st_distance 거리 측정법
WITH gis_bil AS (
				SELECT mgmbldrgstpk, st_transform(st_setsrid(st_makepoint(dx,dy),5174),4326) dxy
				FROM avm_bbook_pyo_count
				WHERE mgmbldrgstpk='11110-100181034'
), gis_sub_tin AS (
                SELECT DISTINCT kor_sub_nm, geom
				FROM tl_spsb_statn
), gis_sub AS (
				SELECT kor_sub_nm, st_transform(st_setsrid(st_centroid(geom),5179), 4326)  sub_dxy
				FROM gis_sub_tin
), FIN_sub AS (
                SELECT 
                gs.kor_sub_nm sub_name,
                st_distance(st_geogfromtext(st_astext(gb.dxy)), st_geogfromtext(st_astext(gs.sub_dxy))) dist, 
                ST_DWithin(st_geogfromtext(st_astext(gb.dxy)), st_geogfromtext(st_astext(gs.sub_dxy)),2000) "in 2000m"
                FROM  gis_bil gb, gis_sub gs
)
SELECT RANK() OVER (ORDER BY fis.dist) 순번, 
               fis.sub_name 이름,
               to_char(dist::NUMERIC,'999999.00') "거리(m)"
FROM FIN_sub fis;
WHERE "in 2000m"= TRUE
LIMIT 3;

WITH gis_bil AS (
	SELECT mgmbldrgstpk, st_transform(st_setsrid(st_makepoint(dx,dy),5174),4326) dxy
	FROM avm_bbook_pyo_count
	WHERE mgmbldrgstpk='${mbrgspk}'
), gis_sub_tin AS (
	SELECT DISTINCT kor_sub_nm, geom
	FROM tl_spsb_statn
), gis_sub AS (
	SELECT kor_sub_nm, st_transform(st_setsrid(st_centroid(geom),5179), 4326) sub_dxy
	FROM gis_sub_tin
), FIN_sub AS (
	SELECT gs.kor_sub_nm sub_name,
	st_distance(st_geogfromtext(st_astext(gb.dxy)), st_geogfromtext(st_astext(gs.sub_dxy))) dist, 
	ST_DWithin(st_geogfromtext(st_astext(gb.dxy)), st_geogfromtext(st_astext(gs.sub_dxy)),2000) "in 2000m"
	FROM gis_bil gb, gis_sub gs
)
SELECT RANK() OVER (ORDER BY fis.dist) 순번, fis.sub_name 이름, to_char(dist::NUMERIC,'9999.00') "거리(m)"
FROM FIN_sub fis
WHERE "in 2000m"= TRUE
LIMIT 3;



























































