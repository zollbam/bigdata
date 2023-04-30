# db생성
CREATE database geo;

# db사용
use geo;

# point
CREATE TABLE gis_point  (g POINT);
SHOW FIELDS FROM gis_point;
INSERT INTO gis_point VALUES
    (PointFromText('POINT(10 10)')),
    (PointFromText('POINT(20 10)')),
    (PointFromText('POINT(20 20)')),
    (PointFromWKB(AsWKB(PointFromText('POINT(10 20)'))));

select * from geo.gis_point;

# line
CREATE TABLE gis_line  (g LINESTRING);
SHOW FIELDS FROM gis_line;
INSERT INTO gis_line VALUES
    (LineFromText('LINESTRING(0 0,0 10,10 0)')),
    (LineStringFromText('LINESTRING(10 10,20 10,20 20,10 20,10 10)')),
    (LineStringFromWKB(AsWKB(LineString(Point(10, 10), Point(40, 10)))));

select * from geo.gis_line;

# polygon
CREATE TABLE gis_polygon   (g POLYGON);
SHOW FIELDS FROM gis_polygon;
INSERT INTO gis_polygon VALUES
    (PolygonFromText('POLYGON((10 10,20 10,20 20,10 20,10 10))')),
    (PolyFromText('POLYGON((0 0,50 0,50 50,0 50,0 0), (10 10,20 10,20 20,10 20,10 10))')),
    (PolyFromWKB(AsWKB(Polygon(LineString(Point(0, 0), Point(30, 0), Point(30, 30), Point(0, 0))))))	;

select * from geo.gis_polygon;

# multipoint
CREATE TABLE gis_multi_point (g MULTIPOINT);
SHOW FIELDS FROM gis_multi_point;
INSERT INTO gis_multi_point VALUES
    (MultiPointFromText('MULTIPOINT(0 0,10 10,10 20,20 20)')),
    (MPointFromText('MULTIPOINT(1 1,11 11,11 21,21 21)')),
    (MPointFromWKB(AsWKB(MultiPoint(Point(3, 6), Point(4, 10)))));

select * from geo.gis_multi_point;

# multilinestring
CREATE TABLE gis_multi_line (g MULTILINESTRING);
SHOW FIELDS FROM gis_multi_line;
INSERT INTO gis_multi_line VALUES
    (MultiLineStringFromText('MULTILINESTRING((10 48,10 21,10 0),(16 0,16 23,16 48))')),
    (MLineFromText('MULTILINESTRING((10 48,10 21,10 0))')),
    (MLineFromWKB(AsWKB(MultiLineString(LineString(Point(1, 2), Point(3, 5)), LineString(Point(2, 5), Point(5, 8), Point(21, 7))))));

insert into gis_multi_line values
	(MLineFromWKB(AsWKB(MultiLineString(Point(1, 2), Point(3, 5)), LineString(Point(2, 5), Point(5, 8), Point(21, 7)))));

select MultiLineString(linestring(Point(1, 2), Point(3, 5)));

select MultiLineString(LineString(Point(1, 2), Point(3, 5)), LineString(Point(2, 5), Point(5, 8), Point(21, 7)));

select * from geo.gis_multi_line;
   
# mulpolygon
CREATE TABLE gis_multi_polygon  (g MULTIPOLYGON);
SHOW FIELDS FROM gis_multi_polygon;
INSERT INTO gis_multi_polygon VALUES
    (MultiPolygonFromText('MULTIPOLYGON(((28 26,28 0,84 0,84 42,28 26),(52 18,66 23,73 9,48 6,52 18)),((59 18,67 18,67 13,59 13,59 18)))')),
    (MPolyFromText('MULTIPOLYGON(((28 26,28 0,84 0,84 42,28 26),(52 18,66 23,73 9,48 6,52 18)),((59 18,67 18,67 13,59 13,59 18)))')),
    (MPolyFromWKB(AsWKB(MultiPolygon(Polygon(LineString(Point(0, 3), Point(3, 3), Point(3, 0), Point(0, 3)))))));

select * from geo.gis_multi_polygon;

# geometrycollection
CREATE TABLE gis_geometrycollection  (g GEOMETRYCOLLECTION);
SHOW FIELDS FROM gis_geometrycollection;
INSERT INTO gis_geometrycollection VALUES
    (GeomCollFromText('GEOMETRYCOLLECTION(POINT(0 0), LINESTRING(0 0,10 10))')),
    (GeometryFromWKB(AsWKB(GeometryCollection(Point(44, 6), LineString(Point(3, 6), Point(7, 9)))))),
    (GeomFromText('GeometryCollection()')),
    (GeomFromText('GeometryCollection EMPTY'));

select * from geo.gis_geometrycollection;

# geometry
/*
평면으로된 모든 좌표들을 다 저장 할 수 있다. => point, multipoly이라던지 
*/
drop table gis_geometry;
CREATE TABLE gis_geometry (g GEOMETRY);
SHOW FIELDS FROM gis_geometry;
INSERT into gis_geometry SELECT * FROM gis_point;
INSERT into gis_geometry SELECT * FROM gis_line;
INSERT into gis_geometry SELECT * FROM gis_polygon;
INSERT into gis_geometry SELECT * FROM gis_multi_point;
INSERT into gis_geometry SELECT * FROM gis_multi_line;
INSERT into gis_geometry SELECT * FROM gis_multi_polygon;
INSERT into gis_geometry SELECT * FROM gis_geometrycollection;

select * from geo.gis_geometry;

# polygon과 multipolygon의 차이
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

# 내부 다각형을 linestring으로
SET @a = 'Polygon((0 0,0 5,5 0,0 0),(1 1,1 3,3 1,1 1), (0.5 0.5, 4 0.5, 0.5 4, 0.5 0.5))';

select polyfromtext(@a);

select st_interiorringn(polyfromtext(@a), 1);
/*제일 안쪽에 있는 다각형을 선타입으로 출력*/
select st_interiorringn(polyfromtext(@a), 2);
/*안쪽으로 부터 2번째 다각형을 선타입으로 출력*/
select st_interiorringn(polyfromtext(@a), 3);
/*가장 바깥쪽에 있는 선을 뽑고 싶었는데 null이 나온다.
  아무래도 제일 바깥쪽에 있는 선은 ST_ExteriorRing로 뽑을수 있으니
  st_interiorringn에서는 지원이 안되는 것으로 판단*/

select st_numinteriorrings(polyfromtext(@a));
/*내부 링이 2개 이므로 st_interiorringn에서 2번째 인수가 1과 2만 된다.
  if 링개수가 5이면 두번째 인수는 1~5까지 가능*/

# 이해 안가는 함수 
