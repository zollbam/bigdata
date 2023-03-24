-- postgis ��ġ
CREATE EXTENSION postgis;

-- postgis ����Ȯ��
SELECT postgis_version();

-- ������ ���� �����
SELECT st_setsrid(st_point(dx, dy),2097)
FROM avm_bbook_pyo_count
WHERE mgmbldrgstpk='11110-100181034';
/*
����ó�� ������ �ʰ� �Ͼ� ���̿� �� �ϳ��� �޶� �ִ�.
st_setsrid�� setsrid�� �������ش�.
srid������ 5179, 2097 �� ���� ������ �ִ�.
*/

-- ��Ƽ �����￡�� �߾����� ��ǥã�Ƽ� geometryŸ������ �����
SELECT kor_sub_nm, st_setsrid(st_point(st_x(st_centroid(geom)),st_y(st_centroid(geom))),5179) "�߾Ӱ� ��ǥ(5179)"
FROM tl_spsb_statn;
/*
��Ƽ�������̾��� ������ �߾����� ã���� ������ ��Ÿ���� �Ǿ����ϴ�.
����ö ���� ����/����/ ����/�뱸/�λ� ��� �� �ִ�.
*/

-- SRID 5181/2097 => 4326���� ��ȯ(��ü)
SELECT st_transform(st_setsrid(st_makepoint(dx, dy),2097), 4326)
FROM avm_bbook_pyo_count;
/*
avm_bbook_pyo_count�� dx, dy�� tl_spsb_statn��srid�ʹ� ���� �޶� srid�� �ٲپ�ҽ��ϴ�.
5181 : īī����
2097 : Ÿ��ü�� �ѱ� �ߺο��� TM ������ǥ��
*/

SELECT st_transform(st_setsrid(st_makepoint(dx, dy),2097), 4326)
FROM avm_bbook_pyo_count;

-- 5181/2097 => 4326���� ��ȯ(�ش�ǹ���)
SELECT st_transform(st_setsrid(st_makepoint(dx, dy),5174), 4326)
FROM avm_bbook_pyo_count
WHERE mgmbldrgstpk='11110-100181034';

-- SRIDȮ��
SELECT st_srid(geom)
FROM tl_spsb_statn ;
/*
srid�� ��� 5179�� ������ �ֽ��ϴ�.
�̴� ���̹� �������� ����ϴ� ������ �˷����ֽ��ϴ�. 
*/

-- tl_spsb_statn�� srid ��ȯ
SELECT st_transform(geom, 4326)
FROM tl_spsb_statn;
/*
5179�� ������ srid�� 4326���� �����Ͽ����ϴ�.
*/

-- srid�� ����
SELECT st_setsrid(geom, 5179)
FROM tl_spsb_statn;
/*
�ش� ��ǥ�� �´� srid�� �����Ͽ� ������ �׷��ش�.
srid�� �߸� �Է� �ϸ� �̻��� ��ҿ� ���� ������ �ȴ�.
*/

-- ��Ƽ������ ��ü �����͸� �� ������
SELECT st_union(geom)
FROM tl_spsb_statn;
/*
avm_bbook_pyo_count�� �����Ͱ� ���� ſ���� ��Ƽ�������� �ƴ� ſ���� ���ƴ� ���µ� ������ �������� �ƹ��͵� �������� �ʴ´�.
 */

-- geometrycollection�� ��ȯ
SELECT st_collect(geom)
FROM tl_spsb_statn;

-- ��ǥ�� ������ ���� �Լ���
SELECT geom "����",  st_xmax(geom) "x �ִ밪 ����",  st_ymax(geom) "y �ִ밪 ����", st_setsrid(st_centroid(geom),5179) "�߾���"
FROM tl_spsb_statn;
/*
st_xmax: ��Ƽ �����￡�� x�� �ִ밪�� ����
st_ymax: ��Ƽ �����￡�� y�� �ִ밪�� ����
st_centroid: ��Ƽ������ �߾����� ����
st_xmin, st_ymin � �ִ�.
*/

-- ���� ���(���� �ʿ�)
WITH gis_bil AS (
    SELECT mgmbldrgstpk, st_transform(st_point(dx,dy,5174), 4326) dxy
    FROM avm_bbook_pyo_count
    WHERE mgmbldrgstpk='11110-100181034'
), gis_sub AS (
    SELECT kor_sub_nm, st_makepoint(st_xmin(st_transform(geom, 4326)), st_ymin(st_transform(geom, 4326))) sub_dxy
    FROM tl_spsb_statn
)
SELECT RANK() OVER (ORDER BY st_distancesphere(gb.dxy, gs.sub_dxy)) ����, 
          gs.kor_sub_nm �̸�, 
          round(st_distancesphere(gb.dxy, gs.sub_dxy)::NUMERIC, 2) "�Ÿ�(m)"
FROM gis_bil gb, gis_sub gs
ORDER BY 3
LIMIT 3;
/*
�ش� �������� �Ÿ�(m)���� �������� �ƴ� �������̴�.
�Ÿ����� ������ �־� ���δ�.
2000m�̳���� ���ǵ� ���� min�̳� max�� �����ϱ� ���ٴ� �߾Ӱ��� ��������!!1
 */

-- ���� ���(����)
-- * st_distancesphere �Ÿ� ������
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
SELECT RANK() OVER (ORDER BY st_distancesphere(gb.dxy, gs.sub_dxy)) ����, 
               gs.kor_sub_nm �̸�, 
               to_char(st_distancesphere(st_geomfromtext(st_astext(gb.dxy)), st_geomfromtext(st_astext(gs.sub_dxy)))::NUMERIC,'FM999999.99') "�Ÿ�(m)"
FROM gis_bil gb, gis_sub gs
WHERE ST_DWithin(st_geogfromtext(st_astext(gb.dxy)), st_geogfromtext(st_astext(gs.sub_dxy)),2000)= TRUE
LIMIT 3;

-- * st_distance �Ÿ� ������
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
SELECT RANK() OVER (ORDER BY fis.dist) ����, 
               fis.sub_name �̸�,
               to_char(dist::NUMERIC,'999999.00') "�Ÿ�(m)"
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
SELECT RANK() OVER (ORDER BY fis.dist) ����, fis.sub_name �̸�, to_char(dist::NUMERIC,'9999.00') "�Ÿ�(m)"
FROM FIN_sub fis
WHERE "in 2000m"= TRUE
LIMIT 3;



























































