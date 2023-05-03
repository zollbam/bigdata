# danji_info
SELECT *
FROM(SELECT DANJI_NAME, ROAD_ADDR,
            point(
       CAST(json_extract(GEOCODE,'$.lng') AS float),
       CAST(json_extract(GEOCODE,'$.lat') AS float)) "poi"
FROM hanbang.danji_info) a;
WHERE astext(poi) = 'POINT(0 0)';

SELECT point(DANJI_LNG, DANJI_LAT)
FROM hanbang.danji_info;

# dong_code
SELECT *
FROM(SELECT dong_no, DONG_NAME, DONG_NAME_DISP,
            point(CAST(json_extract(GEOCODE,'$.lng') AS float),
                  CAST(json_extract(GEOCODE,'$.lat') AS float)) "poi"
FROM hanbang.dong_code) a;
WHERE astext(poi) = 'POINT(0 0)';

# map_bjd_polygon
SELECT REPLACE(json_extract(json_extract(POLYGON_JSON, '$.properties'), '$.EMD_CD'), '"', '') "EMD_CD",
       REPLACE(json_extract(json_extract(POLYGON_JSON, '$.properties'), '$.EMD_ENG_NM'), '"', '') "EMD_ENG_NM",
       REPLACE(json_extract(json_extract(POLYGON_JSON, '$.properties'), '$.EMD_KOR_NM'), '"', '') "EMD_KOR_NM",
       ST_GeomFromGeoJSON(json_extract(POLYGON_JSON, '$.geometry')) "EMD_geom"
FROM hanbang.map_bjd_polygon;

# map_cluster
SELECT CLUSTER_NO, CLUSTER_LEVEL, CLUSTER_TEXT,
       point(CENTER_LNG, CENTER_LAT)
FROM hanbang.map_cluster;

# # map_cluster_info
/*너무 좌표들이 많아서 무엇을 써서 어떻게 표현할지*/
SELECT point(CENTER_LNG, CENTER_LAT),
       point(RIGHT_LNG, TOP_LAT),
       point(LEFT_LNG, BOT_LAT),
       point(FIRST_CENTER_LNG, FIRST_CENTER_LAT)
FROM hanbang.map_cluster_info;

SELECT geometrycollection(point(CENTER_LNG, CENTER_LAT),
       point(RIGHT_LNG, TOP_LAT),
       point(LEFT_LNG, BOT_LAT),
       point(FIRST_CENTER_LNG, FIRST_CENTER_LAT))
FROM hanbang.map_cluster_info;

SELECT st_buffer(point(CENTER_LNG, CENTER_LAT), meter*0.00001)
FROM hanbang.map_cluster_info;

# product_info
SELECT PRODUCT_NO, 
       KAR_MM_NO,
       KAR_CONTENT_NO,
       REALTOR_NO,
       point(
       CAST(json_extract(PRODUCT_GEOCODE,'$.lng') AS float),
       CAST(json_extract(PRODUCT_GEOCODE,'$.lat') AS float)) "point",
       st_asgeojson(point(
       CAST(json_extract(PRODUCT_GEOCODE,'$.lng') AS float),
       CAST(json_extract(PRODUCT_GEOCODE,'$.lat') AS float)))
FROM hanbang.product_info;

# realtor_info
SELECT REALTOR_NO, COMPANY_NAME, COMPANY_ADDR, COMPANY_RSTV_NAME,
       point(REALTOR_LNG, REALTOR_LAT)
FROM hanbang.realtor_info;

SELECT point(CAST(json_extract(COMPANY_GEOCODE,'$.lng') AS float),
             CAST(json_extract(COMPANY_GEOCODE,'$.lat') AS float)) "point"
FROM hanbang.realtor_info;

# subway_code
SELECT SUBWAY_NO, SUBWAY_REGION_NAME, SUBWAY_REGION_NO, SUBWAY_LINE_NAME, SUBWAY_LINE_NO, SUBWAY_STATION_NAME,
       point(
       CAST(json_extract(SUBWAY_GEOCODE,'$.lng') AS float),
       CAST(json_extract(SUBWAY_GEOCODE,'$.lat') AS float)) "point"
FROM hanbang.subway_code ;

# user_mamul
SELECT concat_ws(' ', sido_no_nm, gugun_no_nm, dong_no_nm, concat_ws('-',bon_no, bu_no)), point(coor_lng,coor_lat)
FROM user_mamul

# user_mamul_agent
SELECT com_addr, com_name,point(com_long , com_lat)
FROM user_mamul_agent

# 권한 X
SELECT ST_SetSRID(ST_GeomFromText('LINESTRING(77.29 29.07,77.42 29.26,77.27 29.31,77.29 29.07)'),50);
