# db생성
CREATE database geo;

# db사용
use geo;

# geotable 만들기
-- 테이블 삭제
drop table geo_tbl;

-- 테이블 생성
create table geo_tbl (
	geo_type_fir varchar(20) check (geo_type_fir in ('point', 'linestring', 'polygon', 'geometrycollection',
	                               'multipoint', 'multilinestring', 'multipolygon', 'null', 'empty')),
	lng_lat_fir geometry,
	geo_type_sec varchar(20) check (geo_type_sec in ('point', 'linestring', 'polygon', 'geometrycollection',
	                               'multipoint', 'multilinestring', 'multipolygon', 'null', 'empty')),
	lng_lat_sec geometry
);

-- 레코드 삽입
insert into geo_tbl values ('point', geomfromtext('point(0 1)'), 'point', geomfromtext('point(0 0)'));

DELETE FROM geo_tbl;
SET @a = 'multilinestring((1 2, 1 3, 2 5, 1 2), (-1 -2, -1 -3, -2 -5, -1 -2))';
SET @b = 'multilinestring(-1 -2, -1 -3, -2 -5)';
insert into geo_tbl values ('multilinestring', geomfromtext(@a), 'point', geomfromtext(@b));

-- 데이터 확인
select * from geo_tbl;
select lng_lat_fir, lng_lat_sec, st_equals(lng_lat_fir, lng_lat_sec) from geo_tbl;

SELECT lng_lat_fir, st_isclosed(lng_lat_fir) FROM geo_tbl;

# geometry 타입
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
평면으로된 모든 좌표들을 다 저장 할 수 있다. => point, multipoly이라던지 
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



# 타입 변환 함수
-- 좌표를 이진 데이터로 변환
SELECT asbinary(geomfromtext('point(1 3)'));
SELECT asbinary(geomfromtext('linestring(1 3, 5 10)'));

-- 좌표를 텍스트로 변환
SELECT astext(geomfromtext('linestring(1 3, 2 4, 5 10)'));

-- 좌표를 WKB로 변환
SELECT aswkb(geomfromtext('polygon((1 3, 2 4, 5 10, 1 3))')) "result";

-- 좌표를 WKT로 변환
SELECT aswkt(geomfromtext('multipolygon(((1 3, 2 4, 5 10, 1 3)), ((0 0, 1 0, 1 1, 0 1, 0 0)))')) "result";

-- 텍스트/이진을 point타입으로
SELECT pointfromtext(aswkt(geomfromtext('point(1 0)'))) "result";
SELECT pointfromwkb(asbinary(geomfromtext('point(1 0)'))) "result";

-- 텍스트/이진를 linestring타입으로
SELECT linefromtext(aswkt(geomfromtext('linestring(1 3, 2 4, 5 10)'))) "result";
SELECT linefromwkb(asbinary(geomfromtext('linestring(1 3, 2 4, 5 10)'))) "result";

-- 텍스트/이진를 polygon타입으로
SELECT polyfromtext(aswkt(geomfromtext('polygon((-2 -3, -2 -4, -3 -4, -3 -3, -2 -3))'))) "result";
SELECT polygonfromwkb(asbinary(geomfromtext('polygon((1 3, 2 4, 5 10, 1 3))'))) "result";

-- 텍스트/이진를 multipoint타입으로
SELECT mpointfromtext(astext(geomfromtext('multipoint(1 0, 2 4)'))) "result";
SELECT multipointfromwkb(aswkb(geomfromtext('multipoint(-1 -1, 3 5, 1.5 1.5)'))) "result";

-- 텍스트/이진를 multilinestring타입으로
SELECT MLineFromText(aswkt(geomfromtext('multilinestring((1 3, 2 4, 5 10), (0 0, 1 1))'))) "result";
SELECT MLineFromwkb(aswkb(geomfromtext('multilinestring((1 1, 2 2, 2 1, 1 2), (1 3, 3 5))'))) "result";

-- 텍스트/이진를 multipolygon타입으로
SELECT MLineFromText(aswkt(geomfromtext('multipolygon(((-2 -3, -2 -4, -3 -4, -3 -3, -2 -3)), 
                                                      ((1 1, 2 1, 2 2, 1 2, 1 1)))'))) "result";
SELECT MLineFromwkb(aswkb(geomfromtext('multipolygon(((-2 -3, -2 -4, -3 -4, -3 -3, -2.5 0,-2 -3)), 
                                                      ((1 1, 2 1, 2 2, 1 1)))'))) "result";

-- 텍스트/이진를 geometrycollection타입으로
SELECT geomcollFromText(aswkt(geomfromtext('geometrycollection(multipoint(-2 -3, -2 -4, -3 -4, -3 -3, -2 -3), 
                                                            polygon((1 1, 2 1, 2 2, 1 2, 1 1)))'))) "result";
SELECT MLineFromwkb(aswkb(geomfromtext('geometrycollection(linestring(-2 -3, -2 -4, -3 -4), 
                                                           polygon((1 1, 2 1, 2 2, 1 1)))'))) "result";

-- 텍스트/이진를 geometrycollection타입으로
SELECT geomfromtext(aswkt(geomfromtext('point(5 5)'))) "result";
SELECT geomfromwkb(aswkb(geomfromtext('geometrycollection(linestring(-2 -3, -2 -4, -3 -4), 
                                                           polygon((1 1, 2 1, 2 2, 1 1)))'))) "result";

-- 텍스트/이진를 geometrycollection타입으로
SELECT ST_geomfromtext(st_aswkt(st_geomfromtext('polygon((1 1, 2 1, 2 2, 1 1))'))) "result";

-- geom타입을 json형태로
SELECT lng_lat_fir, st_asgeojson(lng_lat_fir) "st_asgeojson" FROM geo_tbl;

-- json형태를 geom타입으로
SELECT st_geomfromgeojson('{"type": "Point", "coordinates": [1, 1]}');



# 공간 논리 함수
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
SELECT geometryc                   ollection(geomfromtext(@a), geomfromtext(@b));
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
SELECT * FROM geo_tbl;
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
ST_WITHIN과 기능은 동일 하지만 인수 순서가 다르다.
위를 실행하면 1이 밑을 실행하면 0이 반환
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

-- st_isclosed
set @a = 'linestring(0 1, 3 5, 4 1, 0 1)';

select geomfromtext(@a);
select st_isclosed(geomfromtext(@a));

set @a = 'linestring(0 1, 3 5, 4 1)';

select geomfromtext(@a);
select st_isclosed(geomfromtext(@a));

set @a = 'point(0 1)';

select geomfromtext(@a);
select st_isclosed(geomfromtext(@a));

set @a = 'polygon((0 1, 3 5, 4 1, 0 1))';

select geomfromtext(@a);
select st_isclosed(geomfromtext(@a));

-- st_isempty
/*마리아db는 empty를 지원 하지 않는다???
  empty여도 1이 아닌 0 으로 반환*/

set @a = 'geometrycollection empty';

select geomfromtext(@a);
select st_isempty(geomfromtext(@a));

set @a = 'point(0 0)';

select geomfromtext(@a);
select st_isempty(geomfromtext(@a));

# st_issimple
set @a = 'point(0 0)';

select geomfromtext(@a);
select st_issimple(geomfromtext(@a));

set @a = 'multipoint(0 0, 0 0, 1 1)';

select geomfromtext(@a);
select st_issimple(geomfromtext(@a));
/*동일 점이 있으면 비정상적인 걸로 인식하여 0으로 반환*/

set @a = 'multipoint(0 0, 1 0)';

select geomfromtext(@a);
select st_issimple(geomfromtext(@a));

set @a = 'multipoint(0 0, 1 0, 2 3)';

select geomfromtext(@a);
select st_issimple(geomfromtext(@a));

set @a = 'linestring(0 0, 1 0, 2 3, 1 -1)';

select geomfromtext(@a);
select st_issimple(geomfromtext(@a));

set @a = 'linestring(0 0, 1 0, 2 3, 0 -1)';

select geomfromtext(@a);
select st_issimple(geomfromtext(@a));

-- st_isring
set @a = 'linestring(0 0, 1 0, 2 3, 1 -1)';

select geomfromtext(@a);
select st_isring(geomfromtext(@a));

set @a = 'linestring(0 0, 1 0, 2 3, 0 0)';

select geomfromtext(@a);
select st_isring(geomfromtext(@a));

set @a = 'linestring(0 0, 1 0, 2 3, 3 3, 1 0)';

select geomfromtext(@a);
select st_isring(geomfromtext(@a));

set @a = 'linestring(0 0, 1 0, 2 3, 3 3, 0 0)';

select geomfromtext(@a);
select st_isring(geomfromtext(@a));

set @a = 'polygon((0 0, 1 0, 2 3, 3 3, 0 0))';

select geomfromtext(@a);
select st_isring(geomfromtext(@a));



# 공간 연산 함수
-- st_union
set @a = 'point(3 5)';
set @b = 'point(1 2)';

select geomfromtext(@a);
select geomfromtext(@b);
select st_union(geomfromtext(@a), geomfromtext(@b));

set @a = 'linestring(0 1, 3 5, 4 1)';
set @b = 'linestring(1 2, 2 4)';

select geomfromtext(@a);
select geomfromtext(@b);
select st_union(geomfromtext(@a), geomfromtext(@b));

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((1 0, 2 0, 2 1, 1 1, 1 0))';

select geomfromtext(@a);
select geomfromtext(@b);
select st_union(geomfromtext(@a), geomfromtext(@b));

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((0.5 0.5, 1.5 0.5, 1.5 1.5, 0.5 1.5, 0.5 0.5))';

select geomfromtext(@a);
select geomfromtext(@b);
select st_union(geomfromtext(@a), geomfromtext(@b));

set @a = 'GEOMETRYCOLLECTION(POLYGON((0 0, 0.5 0, 0.5 0.5, 0 0.5, 0 0)), linestring(1 0, 2 0, 2 1, 1 1))';
set @b = 'point(1.8 1.8)';

select geometrycollectionfromtext(@a);
select geomfromtext(@b);
select st_union(geomfromtext(@a), geomfromtext(@b));

set @a = 'POLYGON((0 0, 0.5 0, 0.5 0.5, 0 0.5, 0 0))';
set @b = 'point(1.8 1.8)';

select geomfromtext(@a);
select geomfromtext(@b);
select st_union(geomfromtext(@a), geomfromtext(@b));

-- st_intersection
set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((1 0, 2 0, 2 1, 1 1, 1 0))';

select geomfromtext(@a);
select geomfromtext(@b);
select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_intersection(geomfromtext(@a), geomfromtext(@b));

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((0.5 0, 1.5 0, 1.5 1.1, 0.5 1.1, 0.5 0))';

select geomfromtext(@a);
select geomfromtext(@b);
select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_intersection(geomfromtext(@a), geomfromtext(@b));

set @a = 'geometrycollection(polygon((0 0, 1 0, 1 1, 0 1, 0 0)), point(1 3))';
set @b = 'geometrycollection(linestring(-0.5 0.5, 1.5 1.5), linestring(0.9 2.7, 1.1 3.3))';

select geometrycollectionfromtext(@a);
select geomfromtext(@b); -- 지오메트릭 컬렉션 가능
select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_intersection(geomfromtext(@a), geomfromtext(@b));

-- st_symdifference
set @a = 'point(1 1)';
set @b = 'point(1 1)';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_symdifference(geomfromtext(@a), geomfromtext(@b));

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((1 0, 2 0, 2 1, 1 1, 1 0))';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_symdifference(geomfromtext(@a), geomfromtext(@b));

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((0.5 0, 1.5 0, 1.5 1.1, 0.5 1.1, 0.5 0))';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_symdifference(geomfromtext(@a), geomfromtext(@b));

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((0.2 0.2, 0.3 0.2, 0.8 0.8, 0.7 0.8, 0.2 0.2))';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_symdifference(geomfromtext(@a), geomfromtext(@b));

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'point(0.5 0.5)';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_symdifference(geomfromtext(@a), geomfromtext(@b));

set @a = 'linestring(0 0, 2 2)';
set @b = 'linestring(0 0, 1 1, 0 1)';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_symdifference(geomfromtext(@a), geomfromtext(@b));

-- st_difference
set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((0.5 0, 1.5 0, 1.5 1.1, 0.5 1.1, 0.5 0))';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_difference(geomfromtext(@a), geomfromtext(@b));

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
set @b = 'polygon((1.2 0.7, 1.2 0.8, 0.8 0.8, 0.8 0.1, 1.2 0.1, 1.2 0.2, 0.9 0.2, 0.9 0.7, 1.2 0.7))';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_difference(geomfromtext(@a), geomfromtext(@b));

-- st_buffer
set @a = 'point(0 0)';

select geomfromtext(@a);
select st_buffer(geomfromtext(@a), 1);

set @a = 'linestring(0 0, 1 1)';

select geomfromtext(@a);
select st_buffer(geomfromtext(@a), 1);

set @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';

select geomfromtext(@a);
select st_buffer(geomfromtext(@a), 1);

set @a = 'geometrycollection(polygon((0 0, 1 0, 1 1, 0 1, 0 0)), linestring(-2 0, -3 -1))';

select geomfromtext(@a);
select st_buffer(geomfromtext(@a), 1);

-- st_convexhull
SET @a = 'MultiPoint(0 0, 1 2)'; 

select geomfromtext(@a);
SELECT ST_CONVEXHULL(geomfromtext(@a)); 

SET @a = 'MultiPoint(0 0, 1 2, 2 3)'; 

select geomfromtext(@a);
SELECT ST_CONVEXHULL(geomfromtext(@a)); -- 폴리곤

set @a = 'multilinestring((0 0, 1 1), (0 1, 1 0))'; 

select geomfromtext(@a);
select st_convexhull(geomfromtext(@a));

set @a = 'multilinestring((0 0, 1 1), (1 1, 1 0))'; 

select geomfromtext(@a);
select st_convexhull(geomfromtext(@a));

set @a = 'geometrycollection(linestring(0 0, 1 1), linestring(0 1, 1 0))';

select geometrycollection(geomfromtext(@a));
select st_convexhull(geomfromtext(@a));

set @a = 'geometrycollection(point(0 0), linestring(1 1, 0 1))';

select geometrycollection(geomfromtext(@a));
select st_convexhull(geomfromtext(@a));

-- st_envelope
SET @a = 'MultiPoint(0 0, 1 0)'; 

select geomfromtext(@a);
SELECT st_envelope(geomfromtext(@a)); 
-- 선 같아 보이지만 폴리곤

SET @a = 'MultiPoint(0 0, 1 2)'; 

select geomfromtext(@a);
SELECT st_envelope(geomfromtext(@a)); 

SET @a = 'MultiPolygon(((0 0, 2 0, 1 1, 0 0)), ((1 2, 2 1, 2 3, 1 2)))'; 

select geomfromtext(@a);
SELECT st_envelope(geomfromtext(@a)); 

SET @a = 'geometrycollection(polygon((0 1, 1 0, 1 2, 0 1)), linestring(2 -1, 2 3))'; 

select geomfromtext(@a);
SELECT st_envelope(geomfromtext(@a));

-- st_startpoint
SET @a = 'Point(0 0)';

select geomfromtext(@a);
SELECT st_startpoint(geomfromtext(@a)); 

SET @a = 'MultiPoint(0 0, 1 2)';

select geomfromtext(@a);
SELECT st_startpoint(geomfromtext(@a)); 

SET @a = 'polygon((0 1, 1 0, 1 2, 0 1))';

select geomfromtext(@a);
SELECT st_startpoint(geomfromtext(@a)); 

SET @a = 'polygon((0 1, 1 0, 1 2, 0 1))';

select geomfromtext(@a);
SELECT st_startpoint(geomfromtext(@a)); 

SET @a = 'multilinestring((1 2, 3 4, -1 -6, -3 5), (0 0, -1 -2, 3 -1))';

select geomfromtext(@a);
SELECT st_startpoint(geomfromtext(@a));

SET @a = 'linestring(1 2, 3 4, -1 -6, -3 5)';

select geomfromtext(@a);
SELECT st_startpoint(geomfromtext(@a));

-- st_endpoint
SET @a = 'Point(0 0)';

select geomfromtext(@a);
SELECT st_endpoint(geomfromtext(@a)); 

SET @a = 'linestring(1 2, 3 4, -1 -6, -3 5)';

select geomfromtext(@a);
SELECT st_endpoint(geomfromtext(@a));

-- st_pointn
SET @a = 'linestring(1 2, 3 4, -1 -6, -3 5)';

select geomfromtext(@a);
SELECT st_pointn(geomfromtext(@a), 1);
SELECT st_pointn(geomfromtext(@a), 2);
SELECT st_pointn(geomfromtext(@a), 3);

SET @a = 'polygon((1 2, 3 4, -1 -6, -3 5, 1 2))';

select geomfromtext(@a);
SELECT st_pointn(geomfromtext(@a), 1);

-- st_numpoints
SET @a = 'linestring(1 2, 3 4, -1 -6, -3 5)';

select geomfromtext(@a);
SELECT st_numpoints(geomfromtext(@a));

SET @a = 'linestring(1 2, 3 4, -1 -6, -3 5, 4 6)';

select geomfromtext(@a);
SELECT st_numpoints(geomfromtext(@a));

SET @a = 'linestring(0 0)';

select geomfromtext(@a);
SELECT st_numpoints(geomfromtext(@a));

SET @a = 'linestring(0 0, 0 0)';

select geomfromtext(@a);
SELECT st_numpoints(geomfromtext(@a));
/*
linestring(0 0)으로 입력하면 점 개수가 1개 지만
linestring(0 0, 0 0)으로 입력하면 점 개수가 2개 
*/

-- st_geometryn
SET @a = 'linestring(1 2, 3 4, -1 -6, -3 5, 4 6)';

select geomfromtext(@a);
SELECT st_geometryn(geomfromtext(@a), 1);

SET @a = 'multipoint(1 2, 2 4, -1 -2)';

select geomfromtext(@a);
SELECT st_geometryn(geomfromtext(@a), 2);

SET @a = 'multilinestring((1 2, 3 4, -1 -6, -3 5), (0 0, -1 -2, 3 -1))';

select geomfromtext(@a);
SELECT st_geometryn(geomfromtext(@a), 1);

SET @a = 'multipolygon(((1 2, 3 4, -1 -6, -3 5, 1 2)),
                       ((0 0, -1 -2, 3 -1, 0 0)),
                       ((-1 -2, 0 0, -3 5, -1 -2)))';

select geomfromtext(@a);
SELECT st_geometryn(geomfromtext(@a), 3);

SET @a = 'geometrycollection(polygon((0 1, 1 0, 1 2, 0 1)), 
                             linestring(2 -1, 2 3),
                             multipoint(1 1, 2 2))'; 

select geomfromtext(@a);
SELECT st_geometryn(geomfromtext(@a), 2);

-- st_numgeometries
SET @a = 'geometrycollection(polygon((0 1, 1 0, 1 2, 0 1)), 
                             linestring(2 -1, 2 3),
                             multipoint(1 1, 2 2))'; 

select geomfromtext(@a);
SELECT st_numgeometries(geomfromtext(@a));

SET @a = 'multipolygon(((1 2, 3 4, -1 -6, -3 5, 1 2)),
                       ((0 0, -1 -2, 3 -1, 0 0)),
                       ((-1 -2, 0 0, -3 5, -1 -2)))';

select geomfromtext(@a);
SELECT st_numgeometries(geomfromtext(@a));

-- st_dimension
select geomfromtext(@a);
SELECT st_dimension(geomfromtext(@a));

SET @a = 'Point(0 0)';

select geomfromtext(@a);
SELECT st_dimension(geomfromtext(@a));

SET @a = 'linestring(1 2, 3 4, -1 -6, -3 5, 4 6)';

select geomfromtext(@a);
SELECT st_dimension(geomfromtext(@a));

SET @a = 'polygon((1 2, 3 4, -1 -6, -3 5, 1 2))';

select geomfromtext(@a);
SELECT st_dimension(geomfromtext(@a));

SET @a = 'multipolygon(((1 2, 3 4, -1 -6, -3 5, 1 2)),
                       ((0 0, -1 -2, 3 -1, 0 0)),
                       ((-1 -2, 0 0, -3 5, -1 -2)))';

select geomfromtext(@a);
SELECT st_dimension(geomfromtext(@a));

-- st_geometrytype
SET @a = 'GeometryCollection EMPTY';

select geomfromtext(@a);
SELECT st_geometrytype(geomfromtext(@a));

SET @a = 'Point(0 0)';

select geomfromtext(@a);
SELECT st_geometrytype(geomfromtext(@a));

SET @a = 'linestring(1 2, 3 4, -1 -6, -3 5, 4 6)';

select geomfromtext(@a);
SELECT st_geometrytype(geomfromtext(@a));

SET @a = 'polygon((1 2, 3 4, -1 -6, -3 5, 1 2))';

select geomfromtext(@a);
SELECT st_geometrytype(geomfromtext(@a));

SET @a = 'multipolygon(((1 2, 3 4, -1 -6, -3 5, 1 2)),
                       ((0 0, -1 -2, 3 -1, 0 0)),
                       ((-1 -2, 0 0, -3 5, -1 -2)))';

select geomfromtext(@a);
SELECT st_geometrytype(geomfromtext(@a));

-- st_centroid
SET @a = 'multipoint(1 2, 4 2)';

select geomfromtext(@a);
SELECT st_centroid(geomfromtext(@a));

SET @a = 'linestring(1 2, 4 2)';

select geomfromtext(@a);
SELECT st_centroid(geomfromtext(@a));

SET @a = 'multipolygon(((1 2, 3 4, -1 -6, -3 5, 1 2)),
                       ((0 0, -1 -2, 3 -1, 0 0)),
                       ((-1 -2, 0 0, -3 5, -1 -2)))';

select geomfromtext(@a);
SELECT st_centroid(geomfromtext(@a));
SELECT geometrycollection(geomfromtext(@a), st_centroid(geomfromtext(@a));

SET @a = 'multipolygon(((11 12, 13 14, 9 4, 7 15, 11 12)),
                       ((10 10, 9 8, 13 9, 10 10)),
                       ((9 8, 10 10, 7 15, 9 8)))';

select geomfromtext(@a);
SELECT st_centroid(geomfromtext(@a));
SELECT geometrycollection(geomfromtext(@a), st_centroid(geomfromtext(@a)));

-- st_pointonsurface
SET @a = 'multipoint(1 2, 4 2)';

select geomfromtext(@a);
SELECT st_pointonsurface(geomfromtext(@a));
SELECT st_centroid(geomfromtext(@a));
SELECT geometrycollection(st_pointonsurface(geomfromtext(@a)), geomfromtext(@a));
SELECT geometrycollection(st_centroid(geomfromtext(@a)), geomfromtext(@a));

SET @a = 'linestring(1 2, 4 2)';

select geomfromtext(@a);
SELECT st_pointonsurface(geomfromtext(@a));
SELECT st_centroid(geomfromtext(@a));
SELECT geometrycollection(st_pointonsurface(geomfromtext(@a)), geomfromtext(@a));
SELECT geometrycollection(st_centroid(geomfromtext(@a)), geomfromtext(@a));

SET @a = 'multipolygon(((1 2, 3 4, -1 -6, -3 5, 1 2)),
                       ((0 0, -1 -2, 3 -1, 0 0)),
                       ((-1 -2, 0 0, -3 5, -1 -2)))';

select geomfromtext(@a);
SELECT st_pointonsurface(geomfromtext(@a));
SELECT st_centroid(geomfromtext(@a));
SELECT geometrycollection(st_pointonsurface(geomfromtext(@a)), geomfromtext(@a));
SELECT geometrycollection(st_centroid(geomfromtext(@a)), geomfromtext(@a));

SET @a = 'polygon((1 2, 3 4, -1 -6, -3 5, 1 2))';

select geomfromtext(@a);
SELECT st_pointonsurface(geomfromtext(@a));
SELECT st_centroid(geomfromtext(@a));
SELECT geometrycollection(st_pointonsurface(geomfromtext(@a)), geomfromtext(@a));
SELECT geometrycollection(st_centroid(geomfromtext(@a)), geomfromtext(@a));
/*왜 중심점이 멀리 나올까?? st_pointonsurface는 내부에서만 나오는 것이 아닌가??*/

SET @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';

select geomfromtext(@a);
SELECT st_pointonsurface(geomfromtext(@a));
SELECT st_centroid(geomfromtext(@a));
SELECT geometrycollection(st_pointonsurface(geomfromtext(@a)), geomfromtext(@a));
SELECT geometrycollection(st_centroid(geomfromtext(@a)), geomfromtext(@a));

-- ST_Boundary
SET @a = 'POINT(1 1)';

select geomfromtext(@a);
SELECT ST_Boundary(geomfromtext(@a));

SET @a = 'MULTIPOINT(1 1,2 2) ';

select geomfromtext(@a);
SELECT ST_Boundary(geomfromtext(@a));

SET @a = 'linestring(1 2, 4 2)';

select geomfromtext(@a);
SELECT ST_Boundary(geomfromtext(@a));

SET @a = 'MULTILINESTRING((1 1,2 2),(3 3,4 5))';

select geomfromtext(@a);
SELECT ST_Boundary(geomfromtext(@a));

SET @a = 'POLYGON((1 1,2 1,2 2,1 2,1 1))';

select geomfromtext(@a);
SELECT ST_Boundary(geomfromtext(@a));

SET @a = 'multipolygon(((1 2, 3 4, -1 -6, -3 5, 1 2)),
                       ((0 0, -1 -2, 3 -1, 0 0)),
                       ((-1 -2, 0 0, -3 5, -1 -2)))';

select geomfromtext(@a);
SELECT ST_Boundary(geomfromtext(@a));

# st_exteriorring
SET @a = 'multipolygon(((1 2, 3 4, -1 -6, -3 5, 1 2)),
                       ((0 0, -1 -2, 3 -1, 0 0)),
                       ((-1 -2, 0 0, -3 5, -1 -2)))';

select geomfromtext(@a);
SELECT st_exteriorring(geomfromtext(@a));

SET @a = 'Polygon((0 0,2 0,2 2,0 2, 0 0),
                  (0.14 1.8, 0.6 0.2, 0.2 0.2, 0.14 1.8),
                  (0.1 1.9, 1 0.1, 0.1 0.1, 0.1 1.9), 
                  (1 1.9, 1.9 1.9, 1.9 0.1, 1 1.9))';

select polyfromtext(@a);
select st_exteriorring(polyfromtext(@a));

# st_interiorringn
SET @a = 'Polygon((0 0,0 5,5 0,0 0),(1 1,1 3,3 1,1 1), (0.5 0.5, 4 0.5, 0.5 4, 0.5 0.5))';
SET @a = 'Polygon((0 0,0 5,5 0,0 0), (0.5 0.5, 4 0.5, 0.5 4, 0.5 0.5), (1 1,1 3,3 1,1 1))';
/*순서가 바뀌면 n의 기준도 바뀌게 된다.
  즉, 좌표 입력 순서에 따라 (1 1,1 3,3 1,1 1)는 n이 1이 될수도 2가 될수도 있다.*/

select polyfromtext(@a);
select st_interiorringn(polyfromtext(@a), 1);
/*제일 안쪽에 있는 다각형을 선타입으로 출력*/
select st_interiorringn(polyfromtext(@a), 2);
/*안쪽으로 부터 2번째 다각형을 선타입으로 출력*/
select st_interiorringn(polyfromtext(@a), 3);
/*가장 바깥쪽에 있는 선을 뽑고 싶었는데 null이 나온다.
  아무래도 제일 바깥쪽에 있는 선은 ST_ExteriorRing로 뽑을수 있으니
  st_interiorringn에서는 지원이 안되는 것으로 판단*/

SET @a = 'Polygon((0 0,2 0,2 2,0 2, 0 0),
                  (0.14 1.8, 0.6 0.2, 0.2 0.2, 0.14 1.8),
                  (0.1 1.9, 1 0.1, 0.1 0.1, 0.1 1.9), 
                  (1 1.9, 1.9 1.9, 1.9 0.1, 1 1.9))';

select polyfromtext(@a);
select st_interiorringn(polyfromtext(@a), 1);
select st_interiorringn(polyfromtext(@a), 2);
select st_interiorringn(polyfromtext(@a), 3);

# st_numinteriorrings
SELECT lng_lat_fir, st_numinteriorrings(lng_lat_fir) FROM geotest.geo_tbl;

SET @a = 'Polygon((0 0,0 5,5 0,0 0), (0.5 0.5, 4 0.5, 0.5 4, 0.5 0.5), (1 1,1 3,3 1,1 1))';

select st_numinteriorrings(polyfromtext(@a));
/*내부 링이 2개 이므로 st_interiorringn에서 2번째 인수가 1과 2만 된다.
  if 링개수가 5이면 두번째 인수는 1~5까지 가능*/

SET @a = 'Polygon((0 0,2 0,2 2,0 2, 0 0),
                  (0.14 1.8, 0.6 0.2, 0.2 0.2, 0.14 1.8),
                  (0.1 1.9, 1 0.1, 0.1 0.1, 0.1 1.9), 
                  (1 1.9, 1.9 1.9, 1.9 0.1, 1 1.9))';

select st_numinteriorrings(polyfromtext(@a));

SET @a = 'POLYGON((1 2, 3 4, -1 -6, -3 5, 1 2), (-1 -1, -1 -2, 3 -1, -1 -1), (-1 -2, 0 0, -3 5, -1 -2))';

SELECT polyfromtext(@a);
select st_numinteriorrings(polyfromtext(@a));
select st_interiorringn(polyfromtext(@a), 1);
select st_interiorringn(polyfromtext(@a), 2);

SET @a = 'POLYGON((-1 -1, -1 -2, 3 -1, -1 -1), (-3 -3, -5 -4, -6 -1, -3 -3), (1 2, 3 4, -1 -6, -3 5, 1 2))';

SELECT polyfromtext(@a);
select st_numinteriorrings(polyfromtext(@a));
select st_exteriorring(polyfromtext(@a));
select st_interiorringn(polyfromtext(@a), 1);
select st_interiorringn(polyfromtext(@a), 2);
/*첫번째 폴리곤(-1 -1, -1 -2, 3 -1, -1 -1): exteriorring, 
  두번째 폴리곤(-3 -3, -5 -4, -6 -1, -3 -3): 첫번째 interiorring,
  세번째 폴리곤(1 2, 3 4, -1 -6, -3 5, 1 2): 두번째 interiorring
  모든 polygon이든 동일한 순서대로 exteriorring와 interiorring가 정해짐*/

# st_relate
/*이해 필요*/

# st_srid
SELECT lng_lat_fir, st_srid(lng_lat_fir) FROM geotest.geo_tbl;

# st_length
SELECT lng_lat_fir, st_length(lng_lat_fir) FROM geotest.geo_tbl;

-- multi선 모두 선 길이에 포함되는지 확인 (MULTILINESTRING ((1 2, 3 4, -1 -6, -3 5), (0 0, -1 -2, 3 -1))일 때)
SELECT power(power(2,2)+power(2,2),0.5); -- 2.8284271247461903
SELECT power(power(4,2)+power(10,2),0.5); -- 10.770329614269007 
SELECT power(power(2,2)+power(11,2),0.5); -- 11.180339887498949
SELECT power(power(1,2)+power(2,2),0.5); -- 2.23606797749979
SELECT power(power(4,2)+power(1,2),0.5); -- 4.123105625617661
SELECT 2.8284271247461903 + 
       10.770329614269007 +
       11.180339887498949 +
       2.23606797749979 +
       4.123105625617661; -- 31.1382702296315973

SET @a = 'multipoint(0 0)';

SELECT geomfromtext(@a);
SELECT st_length(geomfromtext(@a));

# st_area
SELECT lng_lat_fir, st_area(lng_lat_fir) FROM geotest.geo_tbl;

/* polygon과 multipolygon의 차이 */
SET @pg = 'Polygon((0 0,0 3,3 0,0 0),(1 1,1 2,2 1,1 1), (0 0, 0 10, 10 10, 10 0, 0 0))';
SET @mpg = 'multiPolygon(((0 0,0 3,3 0,0 0),(1 1,1 2,2 1,1 1)), ((0 0, 0 10, 10 10, 10 0, 0 0)))';

select geomfromtext(@pg);
select st_area(geomfromtext(@pg));
select geomfromtext(@mpg);
select st_area(geomfromtext(@mpg));
/*
지도상 => pg와 mpg의 영역 차이는 없어 보인다.
하지만 영역의 면적을 보면 pg는 96, mpg는 104로
       pg는 10*10의 정사각형에서 짤린 부분이 있고
       mpg는 10*10의 정사각형에서 추가되는 영역이 있다는 의미 
*/

# st_distance
SELECT lng_lat_fir, 
       lng_lat_sec,
       st_distance(lng_lat_fir, lng_lat_sec) "dis",
       st_distance_sphere(st_centroid(lng_lat_fir), st_centroid(lng_lat_sec)) "dis_sp"
FROM geotest.geo_tbl;

SET @a = 'MULTIPOINT(0 0, 0.5 0.5, 1 1)';
SET @b = 'LINESTRING(0.5 0.2, 0.5 1)';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_distance(geomfromtext(@a), geomfromtext(@b));

SET @a = 'MULTIPOINT(0 0, 0.5 0.5, 1 1)';
SET @b = 'LINESTRING(0.7 0.2, 0.7 1)';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select st_distance(geomfromtext(@a), geomfromtext(@b));

# st_distance_sphere
SELECT lng_lat_fir, 
       lng_lat_sec,
       geometrycollection(lng_lat_fir, lng_lat_sec),
       st_distance_sphere(st_centroid(lng_lat_fir), st_centroid(lng_lat_sec))
FROM geotest.geo_tbl;

SET @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
SET @b = 'polygon((5 5, 6 5, 6 6, 5 6, 5 5))';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
select ST_Distance_Sphere(st_centroid(geomfromtext(@a)), st_centroid(geomfromtext(@b)));

# st_x, st_y
SELECT lng_lat_fir, 
       st_x(centroid(lng_lat_fir)) "x(lng)",
       st_y(centroid(lng_lat_fir)) "y(lat)"
FROM geotest.geo_tbl;






# overlaps와 crosses 차이
/*overlaps는 같은 타입 geom일 때 가능하다고 했는데 다른 타입이여도 0과 1값이 나옴*/
SET @a = 'POLYGON((1 1, 2 1, 2 2, 1 2,1 1))';
SET @b = 'POLYGON((1 1, 3 1, 2 2, 1 1))';

select geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_overlaps(geomfromtext(@a), geomfromtext(@b));
SELECT st_crosses(geomfromtext(@a), geomfromtext(@b));


SET @g1 = ST_GEOMFROMTEXT('multipoint(0 0, 1 2, 2 2)');

SET @g2 = ST_GEOMFROMTEXT('linestring(-1 -1, 1 1)');

select geometrycollection(geomfromtext(astext(@g1)), geomfromtext(astext(@g2)));
SELECT ST_CROSSES(@g1,@g2);
SELECT ST_CROSSES(@g2,@g1);
SELECT ST_overlaps(@g1,@g2);
SELECT ST_overlaps(@g2,@g1);

SET @a = 'polygon((0 0, 1 0, 1 1, 0 1, 0 0))';
  SET @b = 'polygon((0 0, 0.5 0.5, 0.2 0.5, 0 0))';

SELECT geometrycollection(geomfromtext(@a), geomfromtext(@b));
SELECT st_intersects(geomfromtext(@a), geomfromtext(@b));
SELECT ST_CROSSES(geomfromtext(@a), geomfromtext(@b));
SELECT ST_overlaps(geomfromtext(@a), geomfromtext(@b));
