-- ����Ȯ��
SELECT @@version;

-- ������ geo ���̺�
-- * ���̺� ����
DROP TABLE ex_geo_fun_tbl;

-- * ���ڵ� ����
DELETE FROM ex_geo_fun_tbl WHERE id = 23;

-- *�ڵ� �Է°� �ʱ�ȭ
DBCC CHECKIDENT(ex_geo_fun_tbl, reseed, 22);
SELECT * FROM ex_geo_fun_tbl;

-- * ���̺� ����
CREATE TABLE ex_geo_fun_tbl (
	id int IDENTITY(1,1),
	geomone geometry,
	geomone_desc AS geomone.STAsText(),
	geomtwo geometry,
	geomtwo_desc AS geomtwo.STAsText(),
);
/*���̺� ������ �Լ��� �̿��Ͽ� ���� �ִ� ����� ��� ����*/

-- * ���� ���� �� ���ڵ� �߰�
DECLARE @a geometry = 'MULTILINESTRING ((1 2, 3 2, 4 0), (0 0, 1 1))'
DECLARE @b geometry = 'MULTILINESTRING ((0 0, 1 0, 0 1), (0 0, 4 2))'
INSERT INTO ex_geo_fun_tbl(geomone, geomtwo) VALUES (@a, @b);

-- * ���̺� Ȯ��
SELECT * FROM ex_geo_fun_tbl;

-- geo�Լ� ����
-- * ST[geomtype]From[����Ÿ��]
/*
 - ����Ÿ���� geomtype���� �ٲپ��ִ� ����
   �μ��� srid�� ����� ��
 - ��ȯ Ÿ�� : geometry

1. geomtype
 - Geom
 - Point
 - Line
 - Poly
 - MPoint
 - MLine
 - MPoly
 - GeomColl
2. ����Ÿ��
 - Text
 - WKB
*/

-- * GeomFromGml
/*
 - GML(Geography Markup Language)�� SQL Server ���� ���տ� ǥ���� ������ ��� geometry�� ����
   GeomFromGml(GML_input, SRID)
 - ��ȯ Ÿ�� : geometry
*/
DECLARE @x xml = '<LineString xmlns="http://www.opengis.net/gml"> <posList>100 100 20 180 180 180</posList> </LineString>'  
DECLARE @g geometry = geometry::GeomFromGml(@x, 0)
SELECT @g.ToString();

-- * Parse
/*
 - OGC(Open Geospatial Consortium) WKT(Well-Known Text) ǥ���� geometry �ν��Ͻ��� ��ȯ
   Parse ( 'geometry_tagged_text' ) => �⺻������ srid�� 0���� ���� �Ǿ�
   STGeomAsText()�� srid�� 0�̸� ����� ����
 - ��ȯ Ÿ�� : geometry
*/
DECLARE @g geometry = geometry::Parse('LINESTRING (100 100 1 2, 20 180 3 4, 180 180 -1 -2)')  
SELECT @g.ToString();





-- * STAsBinary
/*
 - geometry�� ���� OGC WKBǥ���� ��ȯ
 - ��ȯ Ÿ�� : varbinary(max)
*/
SELECT geomone_desc ,
       geomone "one_hex",
	   geomone.STAsBinary() "one_varbinary",
	   geomtwo_desc,
       geomtwo "two_hex", 
       geomtwo.STAsBinary() "two_varbinary"
FROM ex_geo_fun_tbl;

-- * AsBinaryZM
/*
 - geometry�� Z(����)�� M(������) ���� ����Ͽ� ������ OGC WKBǥ���� ��ȯ
 - ��ȯ Ÿ�� : varbinary(max)
*/
SELECT geomone_desc ,
       geomone "one_hex",
	   geomone.AsBinaryZM() "one_varbinary",
	   geomtwo_desc,
       geomtwo "two_hex", 
       geomtwo.AsBinaryZM() "two_varbinary"
FROM ex_geo_fun_tbl;

-- * AsGml
/*
 - geometry�� GML(Geography Markup Language) ǥ���� ��ȯ
 - ��ȯ Ÿ�� : xml
*/
SELECT geomone_desc, 
       geomone.AsGml() "one_asgml",
	   geomtwo_desc, 
       geomtwo.AsGml() "two_asgml"
FROM ex_geo_fun_tbl;


-- * STAsText
/*
 - geometry�� ���� OGC WKTǥ���� ��ȯ
 - ��ȯ Ÿ�� : nvarchar(max)
*/
SELECT geomone_desc, -- ����ü�� �̹� STAsText�� ���
       geomone,
	   geomtwo_desc, -- ����ü�� �̹� STAsText�� ���
       geomtwo 
FROM ex_geo_fun_tbl;

-- * AsTextZM
/*
 - geometry�� Z(����)�� M(������) ���� ����Ͽ� ������ OGC WKTǥ���� ��ȯ
 - ��ȯ Ÿ�� : nvarchar(max)
*/
SELECT geomone,
       geomone.AsTextZM()
	   geomtwo,
       geomtwo.AsTextZM()
FROM ex_geo_fun_tbl;

DECLARE @g geometry = geometry::STGeomFromText('POINT(1 2 3 4)', 0)
SELECT @g.STAsText() "text", @g.AsTextZM() "textzm";

-- * ToString
/*
 - geometry���� ����� Z(����) �� �� M(������) ���� ����Ͽ� ������ geometry �ν��Ͻ��� OGC WKT�� ��ȯ
 - ��ȯ Ÿ�� : nvarchar(max)
*/
SELECT geomone_desc, 
       geomone.ToString() "one_tostring",
	   geomtwo_desc, 
       geomtwo.ToString() "two_tostring"
FROM ex_geo_fun_tbl;





-- * STDistance
/*
 - �� geometry������ �Ÿ� ��ȯ
 - ��ȯ Ÿ�� : float
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STDistance(geomtwo) "distance"
FROM ex_geo_fun_tbl;

-- * STLength
/*
 - �Էµ� geometry�� ���� ��ȯ
 - ��ȯ Ÿ�� : float
*/
SELECT id, geomone_desc,
	   geomone.STLength() "length"
FROM ex_geo_fun_tbl;

-- * STCentroid
/*
 - �Ѱ� �̻� �ٰ������� ������ geometry�� ���� ��ǥ
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc,
	   geomone.STCentroid().STAsText() "centroid_desc",
       geomone.STCentroid() "centroid"
FROM ex_geo_fun_tbl;

SELECT geomone_desc,
	   geomone.MakeValid().STCentroid().STAsText() "centroid_desc",
       geomone.MakeValid().STCentroid() "centroid"
FROM ex_geo_fun_tbl;

-- * STPointOnSurface
/*
 - geometry�� ���ο� �ִ� ������ ���� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.STPointOnSurface().STAsText() "pointonsurface_desc",
	   geomone.STPointOnSurface() "pointonsurface"
FROM ex_geo_fun_tbl;

-- * STIntersection
/*
 - 2�� geometry�� �����Ǵ� ���� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc, 
       geomtwo_desc, 
       geomone.STIntersection(geomtwo).STAsText(),
       geomone.STIntersection(geomtwo)
FROM ex_geo_fun_tbl;

-- * STUnion
/*
 - 2���� geometry�� ������ geometry�� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STUnion(geomtwo).STAsText() "union_desc",
	   geomone.STUnion(geomtwo) "union"
FROM ex_geo_fun_tbl;

-- * STDifference
/*
 - �ϳ��� geometry���� �Ǵٸ� geometry�� ��
  => geometry�� �ִ� ������ ���� �ٸ� geometry�� ����
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STDifference(geomtwo).STAsText() "difference_desc",
       geomone.STDifference(geomtwo) "difference"
FROM ex_geo_fun_tbl;

-- * STSymDifference
/*
 - �ϳ��� geometry�� �Ǵٸ� geometry�� union�Ѵ��� ��ġ�� �κи� ��
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STSymDifference(geomtwo).STAsText() "difference_desc",
       geomone.STSymDifference(geomtwo) "difference"
FROM ex_geo_fun_tbl;

-- * STBuffer
/*
 - �ش� geometry�� ������ ��ŭ ������ ����
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone.STAsText(),
	   geomone.STBuffer(5).STAsText(),
       geomtwo.STAsText(), 
       geomtwo.STBuffer(5).STAsText() 
FROM ex_geo_fun_tbl;

-- * BufferWithCurves
/*
 - �Էµ� geometry�� �Ÿ��� distance���� �۰ų� ���� ������� ������ geometry�� ��ȯ
   => A.BufferWithCurves(distance)
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc,
	   geomone.BufferWithCurves(0.05).STAsText() "one_bufferwithcurves_desc",
       geomtwo_desc, 
       geomtwo.BufferWithCurves(0.05).STAsText() "two_bufferwithcurves_desc"
FROM ex_geo_fun_tbl;

-- * BufferWithTolerance
/*
 - ������ ��� ������ ����Ͽ� geometry �ν��Ͻ����� �Ÿ��� ������ ������ �۰ų� ���� ��� �� ���� �������� ��Ÿ���� �������� ��ü�� ��ȯ
   => A.BufferWithTolerance(distance, tolerance, relative)
        distance: �Ÿ��� �����ϴ� float
        tolerance: ���۰Ÿ��� ���� ��� ������ float
        relative: tolerance���� ��������� ���������� �����ϴ� ��Ʈ(0/1)
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc,
	   geomone.BufferWithTolerance(0.05,1.0,0).STAsText() "one_bufferwithtotolerance_desc",
       geomtwo_desc, 
       geomtwo.BufferWithTolerance(0.05,1.0,0).STAsText() "two_bufferwithtotolerance_desc"
FROM ex_geo_fun_tbl;

-- * STArea
/*
 - �������� ���� ���� ���
 - ��ȯ Ÿ�� : float
*/
SELECT geomone.STAsText(),
	   geomone.STArea(),
       geomtwo.STAsText(), 
       geomtwo.STArea() 
FROM ex_geo_fun_tbl;

-- * STBoundary
/*
 - geometry�� ���
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc,
	   geomone.STBoundary().STAsText() "boundary_desc",
       geomone.STBoundary().STGeometryType() "boundary_type",
       geomone.STBoundary() "boundary"
FROM ex_geo_fun_tbl;

-- * STDimension
/*
 - geometry�� Ÿ���� ���� ���·�
   => -1(empty), 0(point), 1(linestring), 2(polygon)
 - ��ȯ Ÿ�� : int
*/
SELECT geomone_desc, 
       geomone.STDimension()
FROM ex_geo_fun_tbl;

-- * STGeometryType
/*
 - geometry�� Ÿ���� ���ڿ� ���·�
   => point, linestring, polygon, MultiLineString ������ ����
   => empty��� ������ �ʰ� GeometryCollection�� ����
 - ��ȯ Ÿ�� : nvarchar(4000)
*/
SELECT geomone_desc, 
       geomone.STGeometryType()
FROM ex_geo_fun_tbl;

-- * STConvexHull
/*
 - geometry�� �������� ����
   => �Էµ� geometry�� ��� �����ϴ� ������ ����
   => �׸� �ɼ��� ���� �ɼ���
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc,
	   geomone.STConvexHull().STAsText() "convexhull_desc",
       geomone.STConvexHull() "convexhull"
FROM ex_geo_fun_tbl;

-- * STEnvelope
/*
 - �Էµ� geometry�� ��� ���Ե� MBR ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.STEnvelope().STAsText() "envelope_desc",
	   geomone.STEnvelope() "envelope"
FROM ex_geo_fun_tbl;

-- * STCurveToLine
/*
 - geometry�� �ٰ��� �ٻ簪
 - ��ȯ Ÿ�� : geometry
*/
SELECT id,
       geomone_desc,
	   geomone.STCurveToLine().STAsText() "curventoline_desc",
       geomone.STCurveToLine() "curventoline"
FROM ex_geo_fun_tbl;
--WHERE geomone_desc != geomone.STCurveToLine().STAsText();

-- * CurveToLineWithTolerance
/*
 - geometry�� �ٰ��� �ٻ簪�� ��ȯ
   => CurveToLineWithTolerance(tolerance, relative)
        tolerance: ���۰Ÿ��� ���� ��� ������ float
        relative: tolerance���� ��������� ���������� �����ϴ� ��Ʈ(0/1)
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc,
	   geomone.CurveToLineWithTolerance(3.0,0).STAsText() "one_curventolinetotolerance_desc",
       geomtwo_desc, 
       geomtwo.CurveToLineWithTolerance(3.0,0).STAsText() "two_curventolinetotolerance_desc"
FROM ex_geo_fun_tbl;

-- * Reduce
/*
 - ������ ���� ���� �ν��Ͻ��� �ٻ簪�� ��ȯ
   �ٻ簪�� ������ �������� ���� �ν��Ͻ����� Douglas-Peucker �˰��� Ȯ���� �����Ͽ� ����
 - Reduce(tolerance)
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc,
	   geomone.Reduce(3.0).STAsText() "one_reduce_desc",
	   geomone.Reduce(3.0) "one_reduce",
       geomtwo_desc,
       geomtwo.Reduce(3.0).STAsText() "two_reduce_desc",
       geomtwo.Reduce(3.0) "two_reduce"
FROM ex_geo_fun_tbl;

-- * ShortestLineTo
/*
 - �� geometry ������ �ִ� �Ÿ��� ��Ÿ���� �� ���� �Բ� LineString�� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.ShortestLineTo(geomtwo).STAsText() "shortestlineto_desc",
	   geomone.ShortestLineTo(geomtwo) "shortestlineto"
FROM ex_geo_fun_tbl;

-- * STStartPoint
/*
 - ������ ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.STStartPoint().STAsText() "startpoint_desc",
	   geomone.STStartPoint() "startpoint"
FROM ex_geo_fun_tbl;

-- * STEndPoint
/*
 - ���� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.STEndPoint().STAsText() "endpoint_desc",
	   geomone.STEndPoint() "endpoint"
FROM ex_geo_fun_tbl;

-- * STPointN
/*
 - geometry�� n��° ���� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.STPointN(1).STAsText() "pointn_desc",
	   geomone.STPointN(1) "pointn"
FROM ex_geo_fun_tbl;

SELECT id, geomone_desc,
	   geomone.STPointN(10).STAsText() "pointn_desc",
	   geomone.STPointN(10) "pointn"
FROM ex_geo_fun_tbl;

-- * STNumPoints
/*
 - geometry�� ���� �� ������ ��ȯ
 - ��ȯ Ÿ�� : int
*/
SELECT id, geomone_desc,
	   geomone.STNumPoints() "numpoints"
FROM ex_geo_fun_tbl;

-- * STExteriorRing
/*
 - �Էµ� geometry�� �ܺ� �� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.STExteriorRing().STAsText() "envelope_desc",
	   geomone.STExteriorRing() "envelope"
FROM ex_geo_fun_tbl;

SELECT id, geomtwo_desc,
	   geomtwo.STExteriorRing().STAsText() "envelope_desc",
	   geomtwo.STExteriorRing() "envelope"
FROM ex_geo_fun_tbl;

-- * STInteriorRingN
/*
 - �Էµ� geometry�� n��° ���θ� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.STInteriorRingN(1).STAsText() "interiorringn_desc",
	   geomone.STInteriorRingN(1) "interiorringn"
FROM ex_geo_fun_tbl;

-- * STNumInteriorRing
/*
 - geometry�� ���� �� ������ ��ȯ
 - ��ȯ Ÿ�� : int
*/
SELECT id, geomone_desc,
	   geomone.STNumInteriorRing() "numinteriorring"
FROM ex_geo_fun_tbl;

-- * STGeometryN
/*
 - �Էµ� geometry�� n��° ���� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.STGeometryN(1).STAsText() "geometryn_desc",
	   geomone.STGeometryN(1) "geometryn"
FROM ex_geo_fun_tbl;

SELECT id, geomone_desc,
	   geomone.STGeometryN(2).STAsText() "geometryn_desc",
	   geomone.STGeometryN(2) "geometryn"
FROM ex_geo_fun_tbl;

-- * STNumGeometries
/*
 - geometry�� ������ ��ȯ
 - ��ȯ Ÿ�� : int
*/
SELECT id, geomone_desc,
	   geomone.STNumGeometries() "numgeometries"
FROM ex_geo_fun_tbl;

-- * STCurveN
/*
 - LineString, CircularString, CompoundCurve�� n���� ���� ���
 - ��ȯ Ÿ�� : geometry
*/
SELECT geomone_desc,
	   geomone.STCurveN(2).STAsText() "curven_desc",
       geomone.STCurveN(2) "curven"
FROM ex_geo_fun_tbl;
WHERE id IN (11, 13, 14);

SELECT geomtwo_desc,
	   geomtwo.STCurveN(2).STAsText() "curven_desc",
       geomtwo.STCurveN(2) "curven"
FROM ex_geo_fun_tbl;

-- * STNumCurves
/*
 - geometry�� � ���� ��ȯ
 - ��ȯ Ÿ�� : float
*/
SELECT id, geomone_desc,
	   geomone.STNumCurves() "numcurves"
FROM ex_geo_fun_tbl;

-- * STSrid
/*
 - geometry�� Spatial Reference Identifier ��ȯ
 - ��ȯ Ÿ�� : int
*/
SELECT id, geomone_desc,
	   geomone.STSrid "srid"
FROM ex_geo_fun_tbl;

-- * STX
/*
 - point�� X��ǥ(�浵) ��ȯ
 - ��ȯ Ÿ�� : float
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STX "one_lng",
       geomtwo.STX "two_lng"
FROM ex_geo_fun_tbl;

-- * STY
/*
 - point�� Y��ǥ(����) ��ȯ
 - ��ȯ Ÿ�� : float
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STY "one_lat",
       geomtwo.STY "two_lat"
FROM ex_geo_fun_tbl;

-- * M
/*
 - geometry�� M(������) ��
 - ��ȯ Ÿ�� : float
*/
SELECT id, geomone_desc,
	   geomone.M "one_M",
	   geomtwo_desc,
       geomtwo.M "two_M"
FROM ex_geo_fun_tbl;

-- * Z
/*
 - geometry�� Z(������) ��
 - ��ȯ Ÿ�� : float
*/
SELECT id, geomone_desc,
	   geomone.Z "one_Z",
	   geomtwo_desc,
       geomtwo.Z "two_Z"
FROM ex_geo_fun_tbl;

-- * IsValidDetailed
/*
 - �ùٸ��� ���� ���� ��ü�� ������ �ĺ��ϴ� �� ������ �Ǵ� �޽����� ��ȯ
     24400: ��ȿ
     24401: ��ȿ���� ������ ������ �� �� �����ϴ�.
     ��� ���� ��ȯ���� ���� ������ �ִ�. => https://learn.microsoft.com/ko-kr/sql/t-sql/spatial-geometry/isvaliddetailed-geometry-datatype?view=sql-server-2016
 - ��ȯ Ÿ�� : nvarchar(max)
*/
SELECT id, geomone_desc,
	   geomone.IsValidDetailed() "one_isvaliddetailed",
	   geomtwo_desc,
       geomtwo.IsValidDetailed() "two_isvaliddetailed"
FROM ex_geo_fun_tbl
WHERE id = 23;

-- * MakeValid
/*
 - �߸��� geometry�� ��ȿ�� OGC ������ geometry�� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc,
	   geomone.MakeValid().STAsText() "one_makevalid_desc",
	   geomone.MakeValid() "one_makevalid",
	   geomone.MakeValid().STInteriorRingN(2)
FROM ex_geo_fun_tbl;

-- * MinDbCompatibilityLevel
/*
 - geometry ������ ���� �ν��Ͻ��� �ν��ϴ� �ּ� �����ͺ��̽� ȣȯ�� ������ ��ȯ
     80: SQL Server 2000�� �⺻ ȣȯ�� ����
     90: SQL Server 2005�� �⺻ ȣȯ�� ����
     100: SQL Server 2008 �� 2008 R2�� �⺻ ȣȯ�� ����
     110: SQL Server 2012�� �⺻ ȣȯ�� ����
     120: SQL Server 2014�� �⺻ ȣȯ�� ����
     130: SQL Server 2016�� �⺻ ȣȯ�� ����
     140: SQL Server 2017�� �⺻ ȣȯ�� ����
     150: SQL Server 2019�� �⺻ ȣȯ�� ����
 - ��ȯ Ÿ�� : int
*/
SELECT id, geomone_desc,
	   geomone.MinDbCompatibilityLevel() "one_mindbcompatibilitylevel",
	   geomtwo_desc,
       geomtwo.MinDbCompatibilityLevel()  "two_mindbcompatibilitylevel"
FROM ex_geo_fun_tbl;

-- * CollectionAggregate
/*
 - geometry���� �������κ��� GeometryCollection ����
 - ��ȯ Ÿ�� : geometry
*/
SELECT geometry::CollectionAggregate(geomone) "one_collectionaggregate"
FROM ex_geo_fun_tbl;
/*geomone���� ��� geometry�� ������ GeometryCollection�� ��*/

-- * ConvexHullAggregate
/*
 - ������ geometry ��ü ���տ� ���� ���� ����(convex hull)�� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT geometry::ConvexHullAggregate(geomone) "one_convexhullaggregate"
FROM ex_geo_fun_tbl;

-- * EnvelopeAggregate
/*
 - ������ geometry ��ü ���տ� ���� ��� ���ڸ� ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT geometry::EnvelopeAggregate(geomone) "one_envelopeaggregate"
FROM ex_geo_fun_tbl;

-- * UnionAggregate
/*
 - geometry ��ü ���տ��� ���� ������ ����
 - ��ȯ Ÿ�� : geometry
*/
SELECT geometry::UnionAggregate(geomone) "one_unionaggregate"
FROM ex_geo_fun_tbl;





-- * STIntersects
/*
 - �ΰ��� geometry���� �Ǹ� 1 ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
       geomone.STIntersects(geomtwo) "stintersects"
FROM ex_geo_fun_tbl;

-- * STDisjoint
/*
 - �ΰ��� geometry���� ���� ������ 1 ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
       geomone.STDisjoint(geomtwo) "disjoint"
FROM ex_geo_fun_tbl;

-- * STEquals
/*
 - �ΰ��� geometry�� ���� �����ϸ� 1 ��ȯ
 - ��ȯ Ÿ�� : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
       geomone.STEquals(geomtwo) "equals"
FROM ex_geo_fun_tbl;

-- * STContains
/*
 - �ϳ��� geometry�� �� �ٸ� geometry�� ���Խ�Ű�� 1, �ƴϸ� 0
   => A.STContains(B)���� A�� B�� ������ �߿�
   => A�� B���� ū �����̿��� ���ϴ� ���� ��� �� �� ����
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomtwo_desc,
	   geomone.STContains(geomtwo) "one - two",
       geomtwo.STContains(geomone) "two - one"
FROM ex_geo_fun_tbl;

-- * STWithin
/*
 - �ϳ��� geometry�� �� �ٸ� geometry�� ���Խ�Ű�� 1, �ƴϸ� 0
   => A.STContains(B)���� A�� B�� ������ �߿�
   => B�� A���� ū �����̿��� ���ϴ� ���� ��� �� �� ����
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomtwo_desc,
	   geomone.STWithin(geomtwo) "one - two",
       geomtwo.STWithin(geomone) "two - one"
FROM ex_geo_fun_tbl;

-- * STCrosses
/*
 - �ϳ��� geometry�� �� �ٸ� geometry�� �����Ǹ� 1
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomtwo_desc,
	   geomone.STCrosses(geomtwo) "crosses"
FROM ex_geo_fun_tbl;

-- * STOverlaps
/*
 - �ϳ��� geometry�� �� �ٸ� geometry�� ��ġ�� 1�� ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomtwo_desc,
	   geomone.STOverlaps(geomtwo) "overlaps"
FROM ex_geo_fun_tbl;

-- * STIsEmpty
/*
 - empty�̸� 1 ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsEmpty() "isempty" 
FROM ex_geo_fun_tbl;

-- * STIsClosed
/*
 - �������� ������ �����ϸ� 1 ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsClosed() "isclosed" 
FROM ex_geo_fun_tbl;

-- * STIsSimple
/*
 - geometry�� �������� �ƴ϶�� 1 ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsSimple() "issimple" 
FROM ex_geo_fun_tbl;

-- * STIsRing
/*
 - STIsSimple�� STIsClosed ��� 1 �̸� 1 ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsRing() "isring" 
FROM ex_geo_fun_tbl;

-- * STIsValid
/*
 - OGC ������ ������� �ùٸ��� �����Ǿ� ������ 1 ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsValid() "isvalid" 
FROM ex_geo_fun_tbl;

-- * STRelate
/*
 - �ϳ��� geometry�� �� �ٸ� geometry�� ��� ������ ������ 1 ��ȯ
   => ex) A.STRelate(B, 'FF*FF****') => disjoint�� ����
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
       geomtwo_desc,
	   geomone.STRelate(geomtwo, 'FF*FF****') "isrelete" 
FROM ex_geo_fun_tbl;

-- * STTouches
/*
 - �ϳ��� geometry�� �� �ٸ� geometry�� ���������� ������ 1 ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
       geomtwo_desc,
	   geomone.STTouches(geomtwo) "touches" 
FROM ex_geo_fun_tbl;

-- * Filter
/*
 - �ε����� ����� �� �ִٰ� �����ϴ� ��� 2���� geometry�� �����ϴ��� Ȯ���ϴ� ���� �ε��� ���� �������� �����ϴ� �޼���
   2���� geometry�� ������ ���ɼ��� ������ 1�� ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
       geomtwo_desc,
	   geomone.Filter(geomtwo) "filter" 
FROM ex_geo_fun_tbl;

-- * HasM
/*
 - ���� ��ü�� M ���� �ϳ� �̻� ���Ե� ��� 1(true)�� ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.HasM "hasm" 
FROM ex_geo_fun_tbl;

-- * HasZ
/*
 - ���� ��ü�� Z ���� �ϳ� �̻� ���Ե� ��� 1(true)�� ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.HasZ "hasz" 
FROM ex_geo_fun_tbl;

-- * InstanceOf
/*
 - geometry�� ������ ������ ���İ� ������ ��� 1�� ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.InstanceOf('point') "one_instanceof_desc",
	   geomtwo_desc,
	   geomtwo.InstanceOf('compoundcurve') "two_instanceof_desc" 
FROM ex_geo_fun_tbl;

-- * IsNull
/*
 - geometry�� Null�̸� 1�� ��ȯ
 - ��ȯ Ÿ�� : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.IsNull "one_isnull_desc",
	   geomtwo_desc,
	   geomtwo.IsNull "two_isnull_desc" 
FROM ex_geo_fun_tbl;
