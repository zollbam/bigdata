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




set @a = polygonfromtext('polygon((0 0, 2 1, 3 5, 2 4, 0 0))');

set @b = polygonfromtext('polygon((0 0, 0 1, 1 1, 0 -1, 0 0))');

select polygonfromtext('polygon((0 0, 1 2, 1 4, -2 4, 0 0))');

select st_centroid(geomfromtext(ASTEXT((@a))));
select st_pointonsurface(geomfromtext(ASTEXT((@a))));
select geometrycollection(geomfromtext(ASTEXT(@a)),geomfromtext(astext(@b)));
select st_symdifference(geomfromtext(astext(@a)), geomfromtext(astext(@b)));
select st_difference(geomfromtext(astext(@a)), geomfromtext(astext(@b)));

select geomfromtext(astext(@b));

select st_touches(@b, @a);

select st_intersects(@b, @a);

SET @g1 = GEOMFROMTEXT('POINT (0 2)');

SET @g2 = GEOMFROMTEXT('POINT (2 0)');

SELECT geomfromtext(ASTEXT(ST_UNION(@g1,@g2)));


SET @g1 = ST_GEOMFROMTEXT('POINT(1 0)');

SET @g2 = ST_GEOMFROMTEXT('LINESTRING(2 0, 0 2)');

select geomfromtext(astext(@g1));
select geomfromtext(astext(@g2));

select geomfromtext(astext(st_union(@g1, @g2)));

select st_touches(@g1, @g2);



select PolygonFromText('POLYGON((-70.916 42.1002,
                                 -70.9468 42.0946,
                                 -70.9754 42.0875,
                                 -70.9749 42.0879,
                                 -70.9759 42.0897,
                                 -70. 916 42.1002))') "a";
            

select ST_PolyFromText( 'POLYGON((-70.916 42.1002,-70.9468 42.0946,-70.9754 42.0875,-70.9749 42.0879,-70.9759 42.0897,-70 .916 42.1002))');








