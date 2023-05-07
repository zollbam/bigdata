# db����
CREATE database geo;

# db���
use geo;

# point
CREATE TABLE gis_point  (g POINT);
SHOW FIELDS FROM gis_point;
INSERT INTO gis_point VALUES
    (PointFromText('POINT(10 10)')),
    (PointFromText('POINT(20 10)')),
    (PointFromText('POINT(20 20)')),
    (PointFromWKB(AsWKB(PointFromText('POINT(10 20)'))));

select * from geotest.gis_point;

# line
CREATE TABLE gis_line (g LINESTRING);
SHOW FIELDS FROM gis_line;
INSERT INTO gis_line VALUES
    (LineFromText('LINESTRING(0 0,0 10,10 0)')),
    (LineStringFromText('LINESTRING(10 10,20 10,20 20,10 20,10 10)')),
    (LineStringFromWKB(AsWKB(LineString(Point(10, 10), Point(40, 10)))));

select * from geotest.gis_line;

# polygon
CREATE TABLE gis_polygon   (g POLYGON);
SHOW FIELDS FROM gis_polygon;
INSERT INTO gis_polygon VALUES
    (PolygonFromText('POLYGON((10 10,20 10,20 20,10 20,10 10))')),
    (PolyFromText('POLYGON((0 0,50 0,50 50,0 50,0 0), (10 10,20 10,20 20,10 20,10 10))')),
    (PolyFromWKB(AsWKB(Polygon(LineString(Point(0, 0), Point(30, 0), Point(30, 30), Point(0, 0))))))	;

select * from geotest.gis_polygon;

# multipoint
CREATE TABLE gis_multi_point (g MULTIPOINT);
SHOW FIELDS FROM gis_multi_point;
INSERT INTO gis_multi_point VALUES
    (MultiPointFromText('MULTIPOINT(0 0,10 10,10 20,20 20)')),
    (MPointFromText('MULTIPOINT(1 1,11 11,11 21,21 21)')),
    (MPointFromWKB(AsWKB(MultiPoint(Point(3, 6), Point(4, 10)))));

select * from geotest.gis_multi_point;

# multilinestring
CREATE TABLE gis_multi_line (g MULTILINESTRING);
SHOW FIELDS FROM gis_multi_line;
INSERT INTO gis_multi_line VALUES
    (MultiLineStringFromText('MULTILINESTRING((10 48,10 21,10 0),(16 0,16 23,16 48))')),
    (MLineFromText('MULTILINESTRING((10 48,10 21,10 0))')),
    (MLineFromWKB(AsWKB(MultiLineString(LineString(Point(1, 2), Point(3, 5)), LineString(Point(2, 5), Point(5, 8), Point(21, 7))))));

insert into gis_multi_line values
	(MLineFromWKB(aswkb(MultiLineString(LineString(Point(1, 2), Point(3, 5)), 
                       LineString(Point(2, 5), Point(5, 8), Point(21, 7))))));

select * from geotest.gis_multi_line;
   
# mulpolygon
CREATE TABLE gis_multi_polygon (g MULTIPOLYGON);
SHOW FIELDS FROM gis_multi_polygon;
INSERT INTO gis_multi_polygon VALUES
    (MultiPolygonFromText('MULTIPOLYGON(((28 26,28 0,84 0,84 42,28 26),(52 18,66 23,73 9,48 6,52 18)),((59 18,67 18,67 13,59 13,59 18)))')),
    (MPolyFromText('MULTIPOLYGON(((28 26,28 0,84 0,84 42,28 26),(52 18,66 23,73 9,48 6,52 18)),((59 18,67 18,67 13,59 13,59 18)))')),
    (MPolyFromWKB(AsWKB(MultiPolygon(Polygon(LineString(Point(0, 3), Point(3, 3), Point(3, 0), Point(0, 3)))))));

select * from geotest.gis_multi_polygon;

# geometrycollection
CREATE TABLE gis_geometrycollection  (g GEOMETRYCOLLECTION);
SHOW FIELDS FROM gis_geometrycollection;
INSERT INTO gis_geometrycollection VALUES
    (GeomCollFromText('GEOMETRYCOLLECTION(POINT(0 0), LINESTRING(0 0,10 10))')),
    (GeometryFromWKB(AsWKB(GeometryCollection(Point(44, 6), LineString(Point(3, 6), Point(7, 9)))))),
    (GeomFromText('GeometryCollection()')),
    (GeomFromText('GeometryCollection EMPTY'));
SELECT geometrycollection(geomfromtext('point(3 5)'), geomfromtext('point(1 2)'));
select * from geotest.gis_geometrycollection;

# geometry
/*
������ε� ��� ��ǥ���� �� ���� �� �� �ִ�. => point, multipoly�̶���� 
*/
CREATE TABLE gis_geometry (g GEOMETRY);
SHOW FIELDS FROM gis_geometry;
INSERT into gis_geometry SELECT * FROM gis_point;
INSERT into gis_geometry SELECT * FROM gis_line;
INSERT into gis_geometry SELECT * FROM gis_polygon;
INSERT into gis_geometry SELECT * FROM gis_multi_point;
INSERT into gis_geometry SELECT * FROM gis_multi_line;
INSERT into gis_geometry SELECT * FROM gis_multi_polygon;
INSERT into gis_geometry SELECT * FROM gis_geometrycollection;

select * from geotest.gis_geometry;

# polygon�� multipolygon�� ����
SET @pg = 'Polygon((0 0,0 3,3 0,0 0),(1 1,1 2,2 1,1 1), (0 0, 0 10, 10 10, 10 0, 0 0))';
SET @mpg = 'multiPolygon(((0 0,0 3,3 0,0 0),(1 1,1 2,2 1,1 1)), ((0 0, 0 10, 10 10, 10 0, 0 0)))';

select geomfromtext(@pg);
select st_area(geomfromtext(@pg));
select geomfromtext(@mpg);
select st_area(geomfromtext(@mpg));
/*
������ => pg�� mpg�� ���� ���̴� ���� ���δ�.
������ ������ ������ ���� pg�� 96, mpg�� 104��
       pg�� 10*10�� ���簢������ ©�� �κ��� �ְ�
       mpg�� 10*10�� ���簢������ �߰��Ǵ� ������ �ִٴ� �ǹ� 
*/

# ���� �ٰ����� linestring����
SET @a = 'Polygon((0 0,0 5,5 0,0 0),(1 1,1 3,3 1,1 1), (0.5 0.5, 4 0.5, 0.5 4, 0.5 0.5))';

select polyfromtext(@a);

select st_interiorringn(polyfromtext(@a), 1);
/*���� ���ʿ� �ִ� �ٰ����� ��Ÿ������ ���*/
select st_interiorringn(polyfromtext(@a), 2);
/*�������� ���� 2��° �ٰ����� ��Ÿ������ ���*/
select st_interiorringn(polyfromtext(@a), 3);
/*���� �ٱ��ʿ� �ִ� ���� �̰� �;��µ� null�� ���´�.
  �ƹ����� ���� �ٱ��ʿ� �ִ� ���� ST_ExteriorRing�� ������ ������
  st_interiorringn������ ������ �ȵǴ� ������ �Ǵ�*/

select st_numinteriorrings(polyfromtext(@a));
/*���� ���� 2�� �̹Ƿ� st_interiorringn���� 2��° �μ��� 1�� 2�� �ȴ�.
  if �������� 5�̸� �ι�° �μ��� 1~5���� ����*/

# Ÿ�� ��ȯ �Լ�
-- ��ǥ�� ���� �����ͷ� ��ȯ
SELECT asbinary(geomfromtext('point(1 3)'));
SELECT asbinary(geomfromtext('linestring(1 3, 5 10)'));

-- ��ǥ�� �ؽ�Ʈ�� ��ȯ
SELECT astext(geomfromtext('linestring(1 3, 2 4, 5 10)'));

-- ��ǥ�� WKB�� ��ȯ
SELECT aswkb(geomfromtext('polygon((1 3, 2 4, 5 10, 1 3))')) "result";

-- ��ǥ�� WKT�� ��ȯ
SELECT aswkt(geomfromtext('multipolygon(((1 3, 2 4, 5 10, 1 3)), ((0 0, 1 0, 1 1, 0 1, 0 0)))')) "result";

-- �ؽ�Ʈ/������ pointŸ������
SELECT pointfromtext(aswkt(geomfromtext('point(1 0)'))) "result";
SELECT pointfromwkb(asbinary(geomfromtext('point(1 0)'))) "result";

-- �ؽ�Ʈ/������ linestringŸ������
SELECT linefromtext(aswkt(geomfromtext('linestring(1 3, 2 4, 5 10)'))) "result";
SELECT linefromwkb(asbinary(geomfromtext('linestring(1 3, 2 4, 5 10)'))) "result";

-- �ؽ�Ʈ/������ polygonŸ������
SELECT polyfromtext(aswkt(geomfromtext('polygon((-2 -3, -2 -4, -3 -4, -3 -3, -2 -3))'))) "result";
SELECT polygonfromwkb(asbinary(geomfromtext('polygon((1 3, 2 4, 5 10, 1 3))'))) "result";

-- �ؽ�Ʈ/������ multipointŸ������
SELECT mpointfromtext(astext(geomfromtext('multipoint(1 0, 2 4)'))) "result";
SELECT multipointfromwkb(aswkb(geomfromtext('multipoint(-1 -1, 3 5, 1.5 1.5)'))) "result";

-- �ؽ�Ʈ/������ multilinestringŸ������
SELECT MLineFromText(aswkt(geomfromtext('multilinestring((1 3, 2 4, 5 10), (0 0, 1 1))'))) "result";
SELECT MLineFromwkb(aswkb(geomfromtext('multilinestring((1 1, 2 2, 2 1, 1 2), (1 3, 3 5))'))) "result";

-- �ؽ�Ʈ/������ multipolygonŸ������
SELECT MLineFromText(aswkt(geomfromtext('multipolygon(((-2 -3, -2 -4, -3 -4, -3 -3, -2 -3)), 
                                                      ((1 1, 2 1, 2 2, 1 2, 1 1)))'))) "result";
SELECT MLineFromwkb(aswkb(geomfromtext('multipolygon(((-2 -3, -2 -4, -3 -4, -3 -3, -2.5 0,-2 -3)), 
                                                      ((1 1, 2 1, 2 2, 1 1)))'))) "result";

-- �ؽ�Ʈ/������ geometrycollectionŸ������
SELECT geomcollFromText(aswkt(geomfromtext('geometrycollection(multipoint(-2 -3, -2 -4, -3 -4, -3 -3, -2 -3), 
                                                            polygon((1 1, 2 1, 2 2, 1 2, 1 1)))'))) "result";
SELECT MLineFromwkb(aswkb(geomfromtext('geometrycollection(linestring(-2 -3, -2 -4, -3 -4), 
                                                           polygon((1 1, 2 1, 2 2, 1 1)))'))) "result";

-- �ؽ�Ʈ/������ geometrycollectionŸ������
SELECT geomfromtext(aswkt(geomfromtext('point(5 5)'))) "result";
SELECT geomfromwkb(aswkb(geomfromtext('geometrycollection(linestring(-2 -3, -2 -4, -3 -4), 
                                                           polygon((1 1, 2 1, 2 2, 1 1)))'))) "result";


-- �ؽ�Ʈ/������ geometrycollectionŸ������
SELECT ST_geomfromtext(st_aswkt(st_geomfromtext('polygon((1 1, 2 1, 2 2, 1 1))'))) "result";

# ���� �� �Լ�
-- st_intersects
SET @a = 'point(1 1)';
SET @b = 'point(1 2)';
SELECT st_union(geomfromtext(@a), geomfromtext(@b));
SELECT st_intersects(geomfromtext(@a), geomfromtext(@b));

SET @a = 'point(1 0)';
SET @b = 'linestring(0 0, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_intersects(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 1, -2 0)';
SET @b = 'linestring(0 0, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_intersects(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'polygon((0 0, 0 -1, -1 -1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_intersects(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'point(0.1 0.3)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_intersects(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'linestring(0 2, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_intersects(geomfromtext(@a), geomfromtext(@b));

SET @a = 'geometrycollection(multipoint(2 2), polygon((0 0, 1 0, 1 1, 0 0)))';
SET @b = 'geometrycollection(multipoint(-1 -3, -1 -5), polygon((0 0, 0.5 0, 0 0.5, 0 0)))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_intersects(geomfromtext(@a), geomfromtext(@b));

-- ST_CROSSES
SET @a = 'point(1 1)';
SET @b = 'point(1 2)';
SELECT st_union(geomfromtext(@a), geomfromtext(@b));
SELECT st_crosses(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 0, 1 1, 0 1)';
SET @b = 'linestring(0 0, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_crosses(geomfromtext(@a), geomfromtext(@b));

SET @a = 'point(1 1)';
SET @b = 'linestring(0 0, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_crosses(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, -1 0, -1 1, 0 0))';
SET @b = 'polygon((0 0, 1 1, 0 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_crosses(geomfromtext(@a), geomfromtext(@b));

-- ST_EQUALS
SET @a = 'point(1 1)';
SET @b = 'point(1 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_EQUALS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 1, 2 0)';
SET @b = 'linestring(0 0, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_EQUALS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'polygon((0 0, 0.5 0, 0.5 0.5, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_EQUALS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'multipolygon(((0 0, 1 0, 1 1, 0 0)), ((0 0, -1 -1, 0 -1, 0 0)))';
SET @b = 'polygon((0 0, 1 0, 1 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_EQUALS(geomfromtext(@a), geomfromtext(@b));

-- ST_WITHIN
SET @a = 'point(1 1)';
SET @b = 'point(1 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_WITHIN(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 0, 1 1)';
SET @b = 'linestring(0 0, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_WITHIN(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0.5 0.3, 0.9 0.3, 0.9 0.4, 0.5 0.3))';
SET @b = 'polygon((0 0, 1 0, 1 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_WITHIN(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 0, 1 1)';
SET @b = 'polygon((0 0, 1 0, 1 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_WITHIN(geomfromtext(@a), geomfromtext(@b));

SET @a = 'point(0.3 0.2)';
SET @b = 'polygon((0 0, 1 0, 1 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_WITHIN(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0.3 0.2, 0.9 0.2)';
SET @b = 'polygon((0 0, 1 0, 1 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_WITHIN(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'multipolygon(((0 0, 1 0, 1 1, 0 0)), ((0 0, -1 -1, 0 -1, 0 0)))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_WITHIN(geomfromtext(@a), geomfromtext(@b));

-- ST_CONTAINS
/* 
ST_WITHIN�� ����� ���� ������ �μ� ������ �ٸ���.
���� �����ϸ� 1�� ���� �����ϸ� 0�� ��ȯ
*/
SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'polygon((0 0, 0.5 0, 0.5 0.5, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_CONTAINS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 0.5 0, 0.5 0.5, 0 0))';
SET @b = 'polygon((0 0, 1 0, 1 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_CONTAINS(geomfromtext(@a), geomfromtext(@b));

-- ST_OVERLAPS
SET @a = 'point(1 1)';
SET @b = 'point(1 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_OVERLAPS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 0, 1 1, 1 0, 0 1)';
SET @b = 'linestring(0.7 0.1, 0.7 0.9)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_OVERLAPS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 0, 1 1)';
SET @b = 'linestring(-1 1, 0 0)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_OVERLAPS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'polygon((0 0, 0.5 0, 0.5 0.5, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_OVERLAPS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'polygon((0 0, 0.5 0, 0.5 0.6, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_OVERLAPS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, -1 0, -1 1, 0 0))';
SET @b = 'polygon((0 0, 1 1, 0 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_OVERLAPS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'point(1 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_OVERLAPS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 0, 1 1)';
SET @b = 'point(1 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_OVERLAPS(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'multipolygon(((0 0, 1 0, 1 1, 0 0)), ((0 0, -1 -1, 0 -1, 0 0)))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_WITHIN(geomfromtext(@a), geomfromtext(@b));

-- ST_DISJOINT
SET @a = 'point(1 1)';
SET @b = 'point(1 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

SET @a = 'point(0 0)';
SET @b = 'linestring(0 0, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 0, 1 1)';
SET @b = 'linestring(1 0, 0 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'polygon((0 0, 1 1, 0 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'polygon((0 0, 0 -1, -1 -1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));     
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'point(0.1 0.3)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'linestring(0 0.5, 1.5 0.5)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'linestring(0 1.5, 1.5 1.5)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

SET @a = 'geometrycollection(multipoint(2 2), polygon((0 0, 1 0, 1 1, 0 0)))';
SET @b = 'geometrycollection(multipoint(-1 -3, -1 -5), polygon((0 0, 0.5 0, 0 0.5, 0 0)))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

-- ST_TOUCHES
SET @a = 'point(1 1)';
SET @b = 'point(1 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_TOUCHES(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 0, 1 1, 0 1)';
SET @b = 'linestring(0 0, 2 2)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_TOUCHES(geomfromtext(@a), geomfromtext(@b));

SET @a = 'linestring(0 1, 0.5 0.5)';
SET @b = 'linestring(0 0, 1 1)';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_TOUCHES(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
SET @b = 'polygon((0 0, 1 1, 0 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_TOUCHES(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, -1 0, -1 1, 0 0))';
SET @b = 'polygon((0 0, 1 1, 0 1, 0 0))';
SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT ST_TOUCHES(geomfromtext(@a), geomfromtext(@b));

SET @a = 'polygon((0 0, 1 0, 1 1, 0 0))';
   SET @b = 'polygon((0 0, 0 2, 2 0, 0 0))';
   SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));     
   SELECT ST_DISJOINT(geomfromtext(@a), geomfromtext(@b));

# ���� ���� �Լ�




