-- 버전확인
SELECT @@version;

-- 나만의 geo 테이블
-- * 테이블 삭제
DROP TABLE ex_geo_fun_tbl;

-- * 레코드 삭제
DELETE FROM ex_geo_fun_tbl WHERE id = 23;

-- *자동 입력값 초기화
DBCC CHECKIDENT(ex_geo_fun_tbl, reseed, 22);
SELECT * FROM ex_geo_fun_tbl;

-- * 테이블 생성
CREATE TABLE ex_geo_fun_tbl (
	id int IDENTITY(1,1),
	geomone geometry,
	geomone_desc AS geomone.STAsText(),
	geomtwo geometry,
	geomtwo_desc AS geomtwo.STAsText(),
);
/*테이블 생성시 함수를 이용하여 값을 넣는 방법도 사용 가능*/

-- * 변수 선언 및 레코드 추가
DECLARE @a geometry = 'MULTILINESTRING ((1 2, 3 2, 4 0), (0 0, 1 1))'
DECLARE @b geometry = 'MULTILINESTRING ((0 0, 1 0, 0 1), (0 0, 4 2))'
INSERT INTO ex_geo_fun_tbl(geomone, geomtwo) VALUES (@a, @b);

-- * 테이블 확인
SELECT * FROM ex_geo_fun_tbl;

-- geo함수 예제
-- * ST[geomtype]From[문서타입]
/*
 - 문서타입을 geomtype으로 바꾸어주는 역할
   인수에 srid도 적어야 함
 - 반환 타입 : geometry

1. geomtype
 - Geom
 - Point
 - Line
 - Poly
 - MPoint
 - MLine
 - MPoly
 - GeomColl
2. 문서타입
 - Text
 - WKB
*/

-- * GeomFromGml
/*
 - GML(Geography Markup Language)의 SQL Server 하위 집합에 표현이 지정된 경우 geometry를 생성
   GeomFromGml(GML_input, SRID)
 - 반환 타입 : geometry
*/
DECLARE @x xml = '<LineString xmlns="http://www.opengis.net/gml"> <posList>100 100 20 180 180 180</posList> </LineString>'  
DECLARE @g geometry = geometry::GeomFromGml(@x, 0)
SELECT @g.ToString();

-- * Parse
/*
 - OGC(Open Geospatial Consortium) WKT(Well-Known Text) 표현의 geometry 인스턴스를 반환
   Parse ( 'geometry_tagged_text' ) => 기본적으로 srid가 0으로 가정 되어
   STGeomAsText()의 srid가 0이면 결과는 동일
 - 반환 타입 : geometry
*/
DECLARE @g geometry = geometry::Parse('LINESTRING (100 100 1 2, 20 180 3 4, 180 180 -1 -2)')  
SELECT @g.ToString();





-- * STAsBinary
/*
 - geometry의 값을 OGC WKB표현을 반환
 - 반환 타입 : varbinary(max)
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
 - geometry의 Z(높이)와 M(측정값) 값을 사용하여 보강된 OGC WKB표현을 반환
 - 반환 타입 : varbinary(max)
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
 - geometry의 GML(Geography Markup Language) 표현을 반환
 - 반환 타입 : xml
*/
SELECT geomone_desc, 
       geomone.AsGml() "one_asgml",
	   geomtwo_desc, 
       geomtwo.AsGml() "two_asgml"
FROM ex_geo_fun_tbl;


-- * STAsText
/*
 - geometry의 값을 OGC WKT표현을 반환
 - 반환 타입 : nvarchar(max)
*/
SELECT geomone_desc, -- 열자체에 이미 STAsText를 사용
       geomone,
	   geomtwo_desc, -- 열자체에 이미 STAsText를 사용
       geomtwo 
FROM ex_geo_fun_tbl;

-- * AsTextZM
/*
 - geometry의 Z(높이)와 M(측정값) 값을 사용하여 보강된 OGC WKT표현을 반환
 - 반환 타입 : nvarchar(max)
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
 - geometry에서 얻어진 Z(높이) 값 및 M(측정값) 값을 사용하여 보강된 geometry 인스턴스의 OGC WKT을 반환
 - 반환 타입 : nvarchar(max)
*/
SELECT geomone_desc, 
       geomone.ToString() "one_tostring",
	   geomtwo_desc, 
       geomtwo.ToString() "two_tostring"
FROM ex_geo_fun_tbl;





-- * STDistance
/*
 - 두 geometry사이의 거리 반환
 - 반환 타입 : float
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STDistance(geomtwo) "distance"
FROM ex_geo_fun_tbl;

-- * STLength
/*
 - 입력된 geometry의 길이 반환
 - 반환 타입 : float
*/
SELECT id, geomone_desc,
	   geomone.STLength() "length"
FROM ex_geo_fun_tbl;

-- * STCentroid
/*
 - 한개 이상 다각형으로 구성된 geometry의 중점 좌표
 - 반환 타입 : geometry
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
 - geometry의 내부에 있는 임의의 점을 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc,
	   geomone.STPointOnSurface().STAsText() "pointonsurface_desc",
	   geomone.STPointOnSurface() "pointonsurface"
FROM ex_geo_fun_tbl;

-- * STIntersection
/*
 - 2개 geometry의 교차되는 영역 반환
 - 반환 타입 : geometry
*/
SELECT geomone_desc, 
       geomtwo_desc, 
       geomone.STIntersection(geomtwo).STAsText(),
       geomone.STIntersection(geomtwo)
FROM ex_geo_fun_tbl;

-- * STUnion
/*
 - 2개의 geometry의 합집합 geometry을 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STUnion(geomtwo).STAsText() "union_desc",
	   geomone.STUnion(geomtwo) "union"
FROM ex_geo_fun_tbl;

-- * STDifference
/*
 - 하나의 geometry에서 또다른 geometry를 뺌
  => geometry을 넣는 순서에 따라 다른 geometry가 생김
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STDifference(geomtwo).STAsText() "difference_desc",
       geomone.STDifference(geomtwo) "difference"
FROM ex_geo_fun_tbl;

-- * STSymDifference
/*
 - 하나의 geometry와 또다른 geometry를 union한다음 겹치는 부분만 뺌
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STSymDifference(geomtwo).STAsText() "difference_desc",
       geomone.STSymDifference(geomtwo) "difference"
FROM ex_geo_fun_tbl;

-- * STBuffer
/*
 - 해당 geometry의 반지름 반큼 떨어진 영역
 - 반환 타입 : geometry
*/
SELECT geomone.STAsText(),
	   geomone.STBuffer(5).STAsText(),
       geomtwo.STAsText(), 
       geomtwo.STBuffer(5).STAsText() 
FROM ex_geo_fun_tbl;

-- * BufferWithCurves
/*
 - 입력된 geometry와 거리가 distance보다 작거나 같은 모든점의 집합을 geometry로 반환
   => A.BufferWithCurves(distance)
 - 반환 타입 : geometry
*/
SELECT geomone_desc,
	   geomone.BufferWithCurves(0.05).STAsText() "one_bufferwithcurves_desc",
       geomtwo_desc, 
       geomtwo.BufferWithCurves(0.05).STAsText() "two_bufferwithcurves_desc"
FROM ex_geo_fun_tbl;

-- * BufferWithTolerance
/*
 - 지정된 허용 오차를 고려하여 geometry 인스턴스와의 거리가 지정된 값보다 작거나 같은 모든 점 값의 합집합을 나타내는 기하학적 개체를 반환
   => A.BufferWithTolerance(distance, tolerance, relative)
        distance: 거리를 측정하는 float
        tolerance: 버퍼거리에 대한 허용 오차로 float
        relative: tolerance값이 상대적인지 절대적인지 지정하는 비트(0/1)
 - 반환 타입 : geometry
*/
SELECT geomone_desc,
	   geomone.BufferWithTolerance(0.05,1.0,0).STAsText() "one_bufferwithtotolerance_desc",
       geomtwo_desc, 
       geomtwo.BufferWithTolerance(0.05,1.0,0).STAsText() "two_bufferwithtotolerance_desc"
FROM ex_geo_fun_tbl;

-- * STArea
/*
 - 폴리곤의 영역 넓이 계산
 - 반환 타입 : float
*/
SELECT geomone.STAsText(),
	   geomone.STArea(),
       geomtwo.STAsText(), 
       geomtwo.STArea() 
FROM ex_geo_fun_tbl;

-- * STBoundary
/*
 - geometry의 경계
 - 반환 타입 : geometry
*/
SELECT geomone_desc,
	   geomone.STBoundary().STAsText() "boundary_desc",
       geomone.STBoundary().STGeometryType() "boundary_type",
       geomone.STBoundary() "boundary"
FROM ex_geo_fun_tbl;

-- * STDimension
/*
 - geometry의 타입을 숫자 형태로
   => -1(empty), 0(point), 1(linestring), 2(polygon)
 - 반환 타입 : int
*/
SELECT geomone_desc, 
       geomone.STDimension()
FROM ex_geo_fun_tbl;

-- * STGeometryType
/*
 - geometry의 타입을 문자열 형태로
   => point, linestring, polygon, MultiLineString 등으로 나옴
   => empty라고 나오지 않고 GeometryCollection로 나옴
 - 반환 타입 : nvarchar(4000)
*/
SELECT geomone_desc, 
       geomone.STGeometryType()
FROM ex_geo_fun_tbl;

-- * STConvexHull
/*
 - geometry의 볼록집합 영역
   => 입력된 geometry을 모두 포함하는 영역을 생성
   => 네모가 될수도 원이 될수도
 - 반환 타입 : geometry
*/
SELECT geomone_desc,
	   geomone.STConvexHull().STAsText() "convexhull_desc",
       geomone.STConvexHull() "convexhull"
FROM ex_geo_fun_tbl;

-- * STEnvelope
/*
 - 입력된 geometry가 모두 포함된 MBR 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc,
	   geomone.STEnvelope().STAsText() "envelope_desc",
	   geomone.STEnvelope() "envelope"
FROM ex_geo_fun_tbl;

-- * STCurveToLine
/*
 - geometry의 다각형 근사값
 - 반환 타입 : geometry
*/
SELECT id,
       geomone_desc,
	   geomone.STCurveToLine().STAsText() "curventoline_desc",
       geomone.STCurveToLine() "curventoline"
FROM ex_geo_fun_tbl;
--WHERE geomone_desc != geomone.STCurveToLine().STAsText();

-- * CurveToLineWithTolerance
/*
 - geometry의 다각형 근사값을 반환
   => CurveToLineWithTolerance(tolerance, relative)
        tolerance: 버퍼거리에 대한 허용 오차로 float
        relative: tolerance값이 상대적인지 절대적인지 지정하는 비트(0/1)
 - 반환 타입 : geometry
*/
SELECT geomone_desc,
	   geomone.CurveToLineWithTolerance(3.0,0).STAsText() "one_curventolinetotolerance_desc",
       geomtwo_desc, 
       geomtwo.CurveToLineWithTolerance(3.0,0).STAsText() "two_curventolinetotolerance_desc"
FROM ex_geo_fun_tbl;

-- * Reduce
/*
 - 지정된 기하 도형 인스턴스의 근사값을 반환
   근사값은 지정된 허용오차를 가진 인스턴스에서 Douglas-Peucker 알고리즘 확장을 실행하여 생성
 - Reduce(tolerance)
 - 반환 타입 : geometry
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
 - 두 geometry 사이의 최단 거리를 나타내는 두 점과 함께 LineString를 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.ShortestLineTo(geomtwo).STAsText() "shortestlineto_desc",
	   geomone.ShortestLineTo(geomtwo) "shortestlineto"
FROM ex_geo_fun_tbl;

-- * STStartPoint
/*
 - 시작점 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc,
	   geomone.STStartPoint().STAsText() "startpoint_desc",
	   geomone.STStartPoint() "startpoint"
FROM ex_geo_fun_tbl;

-- * STEndPoint
/*
 - 끝점 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc,
	   geomone.STEndPoint().STAsText() "endpoint_desc",
	   geomone.STEndPoint() "endpoint"
FROM ex_geo_fun_tbl;

-- * STPointN
/*
 - geometry의 n번째 점을 반환
 - 반환 타입 : geometry
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
 - geometry의 점의 총 개수를 반환
 - 반환 타입 : int
*/
SELECT id, geomone_desc,
	   geomone.STNumPoints() "numpoints"
FROM ex_geo_fun_tbl;

-- * STExteriorRing
/*
 - 입력된 geometry의 외부 링 반환
 - 반환 타입 : geometry
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
 - 입력된 geometry의 n번째 내부링 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc,
	   geomone.STInteriorRingN(1).STAsText() "interiorringn_desc",
	   geomone.STInteriorRingN(1) "interiorringn"
FROM ex_geo_fun_tbl;

-- * STNumInteriorRing
/*
 - geometry의 내부 링 개수를 반환
 - 반환 타입 : int
*/
SELECT id, geomone_desc,
	   geomone.STNumInteriorRing() "numinteriorring"
FROM ex_geo_fun_tbl;

-- * STGeometryN
/*
 - 입력된 geometry의 n번째 도형 반환
 - 반환 타입 : geometry
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
 - geometry의 개수를 반환
 - 반환 타입 : int
*/
SELECT id, geomone_desc,
	   geomone.STNumGeometries() "numgeometries"
FROM ex_geo_fun_tbl;

-- * STCurveN
/*
 - LineString, CircularString, CompoundCurve의 n번재 선을 출력
 - 반환 타입 : geometry
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
 - geometry의 곡선 수를 반환
 - 반환 타입 : float
*/
SELECT id, geomone_desc,
	   geomone.STNumCurves() "numcurves"
FROM ex_geo_fun_tbl;

-- * STSrid
/*
 - geometry의 Spatial Reference Identifier 반환
 - 반환 타입 : int
*/
SELECT id, geomone_desc,
	   geomone.STSrid "srid"
FROM ex_geo_fun_tbl;

-- * STX
/*
 - point의 X좌표(경도) 반환
 - 반환 타입 : float
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STX "one_lng",
       geomtwo.STX "two_lng"
FROM ex_geo_fun_tbl;

-- * STY
/*
 - point의 Y좌표(위도) 반환
 - 반환 타입 : float
*/
SELECT id, geomone_desc, geomtwo_desc,
	   geomone.STY "one_lat",
       geomtwo.STY "two_lat"
FROM ex_geo_fun_tbl;

-- * M
/*
 - geometry의 M(측정값) 값
 - 반환 타입 : float
*/
SELECT id, geomone_desc,
	   geomone.M "one_M",
	   geomtwo_desc,
       geomtwo.M "two_M"
FROM ex_geo_fun_tbl;

-- * Z
/*
 - geometry의 Z(측정값) 값
 - 반환 타입 : float
*/
SELECT id, geomone_desc,
	   geomone.Z "one_Z",
	   geomtwo_desc,
       geomtwo.Z "two_Z"
FROM ex_geo_fun_tbl;

-- * IsValidDetailed
/*
 - 올바르지 않은 공간 개체의 문제를 식별하는 데 도움이 되는 메시지를 반환
     24400: 유효
     24401: 유효하지 않으며 이유를 알 수 없습니다.
     등등 여러 반환값에 대한 설명이 있다. => https://learn.microsoft.com/ko-kr/sql/t-sql/spatial-geometry/isvaliddetailed-geometry-datatype?view=sql-server-2016
 - 반환 타입 : nvarchar(max)
*/
SELECT id, geomone_desc,
	   geomone.IsValidDetailed() "one_isvaliddetailed",
	   geomtwo_desc,
       geomtwo.IsValidDetailed() "two_isvaliddetailed"
FROM ex_geo_fun_tbl
WHERE id = 23;

-- * MakeValid
/*
 - 잘못된 geometry를 유효한 OGC 형식의 geometry로 변환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc,
	   geomone.MakeValid().STAsText() "one_makevalid_desc",
	   geomone.MakeValid() "one_makevalid",
	   geomone.MakeValid().STInteriorRingN(2)
FROM ex_geo_fun_tbl;

-- * MinDbCompatibilityLevel
/*
 - geometry 데이터 형식 인스턴스를 인식하는 최소 데이터베이스 호환성 수준을 반환
     80: SQL Server 2000의 기본 호환성 수준
     90: SQL Server 2005의 기본 호환성 수준
     100: SQL Server 2008 및 2008 R2의 기본 호환성 수준
     110: SQL Server 2012의 기본 호환성 수준
     120: SQL Server 2014의 기본 호환성 수준
     130: SQL Server 2016의 기본 호환성 수준
     140: SQL Server 2017의 기본 호환성 수준
     150: SQL Server 2019의 기본 호환성 수준
 - 반환 타입 : int
*/
SELECT id, geomone_desc,
	   geomone.MinDbCompatibilityLevel() "one_mindbcompatibilitylevel",
	   geomtwo_desc,
       geomtwo.MinDbCompatibilityLevel()  "two_mindbcompatibilitylevel"
FROM ex_geo_fun_tbl;

-- * CollectionAggregate
/*
 - geometry형식 집합으로부터 GeometryCollection 생성
 - 반환 타입 : geometry
*/
SELECT geometry::CollectionAggregate(geomone) "one_collectionaggregate"
FROM ex_geo_fun_tbl;
/*geomone열의 모든 geometry다 합쳐져 GeometryCollection이 됨*/

-- * ConvexHullAggregate
/*
 - 제공된 geometry 개체 집합에 대한 볼록 집합(convex hull)을 반환
 - 반환 타입 : geometry
*/
SELECT geometry::ConvexHullAggregate(geomone) "one_convexhullaggregate"
FROM ex_geo_fun_tbl;

-- * EnvelopeAggregate
/*
 - 지정된 geometry 개체 집합에 대한 경계 상자를 반환
 - 반환 타입 : geometry
*/
SELECT geometry::EnvelopeAggregate(geomone) "one_envelopeaggregate"
FROM ex_geo_fun_tbl;

-- * UnionAggregate
/*
 - geometry 개체 집합에서 통합 연산을 수행
 - 반환 타입 : geometry
*/
SELECT geometry::UnionAggregate(geomone) "one_unionaggregate"
FROM ex_geo_fun_tbl;





-- * STIntersects
/*
 - 두개의 geometry교차 되면 1 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
       geomone.STIntersects(geomtwo) "stintersects"
FROM ex_geo_fun_tbl;

-- * STDisjoint
/*
 - 두개의 geometry교차 되지 않으면 1 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
       geomone.STDisjoint(geomtwo) "disjoint"
FROM ex_geo_fun_tbl;

-- * STEquals
/*
 - 두개의 geometry가 완전 동일하면 1 반환
 - 반환 타입 : geometry
*/
SELECT id, geomone_desc, geomtwo_desc,
       geomone.STEquals(geomtwo) "equals"
FROM ex_geo_fun_tbl;

-- * STContains
/*
 - 하나의 geometry이 또 다른 geometry을 포함시키면 1, 아니면 0
   => A.STContains(B)에서 A와 B의 순서가 중요
   => A가 B보다 큰 영역이여야 원하는 값을 출력 할 수 있음
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomtwo_desc,
	   geomone.STContains(geomtwo) "one - two",
       geomtwo.STContains(geomone) "two - one"
FROM ex_geo_fun_tbl;

-- * STWithin
/*
 - 하나의 geometry이 또 다른 geometry을 포함시키면 1, 아니면 0
   => A.STContains(B)에서 A와 B의 순서가 중요
   => B가 A보다 큰 영역이여야 원하는 값을 출력 할 수 있음
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomtwo_desc,
	   geomone.STWithin(geomtwo) "one - two",
       geomtwo.STWithin(geomone) "two - one"
FROM ex_geo_fun_tbl;

-- * STCrosses
/*
 - 하나의 geometry이 또 다른 geometry과 교차되면 1
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomtwo_desc,
	   geomone.STCrosses(geomtwo) "crosses"
FROM ex_geo_fun_tbl;

-- * STOverlaps
/*
 - 하나의 geometry이 또 다른 geometry과 겹치면 1을 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomtwo_desc,
	   geomone.STOverlaps(geomtwo) "overlaps"
FROM ex_geo_fun_tbl;

-- * STIsEmpty
/*
 - empty이면 1 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsEmpty() "isempty" 
FROM ex_geo_fun_tbl;

-- * STIsClosed
/*
 - 시작점과 끝점이 동일하면 1 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsClosed() "isclosed" 
FROM ex_geo_fun_tbl;

-- * STIsSimple
/*
 - geometry이 비정상이 아니라면 1 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsSimple() "issimple" 
FROM ex_geo_fun_tbl;

-- * STIsRing
/*
 - STIsSimple와 STIsClosed 모두 1 이면 1 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsRing() "isring" 
FROM ex_geo_fun_tbl;

-- * STIsValid
/*
 - OGC 형식을 기반으로 올바르게 지정되어 있으면 1 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.STIsValid() "isvalid" 
FROM ex_geo_fun_tbl;

-- * STRelate
/*
 - 하나의 geometry이 또 다른 geometry과 어떠한 연관이 있으면 1 반환
   => ex) A.STRelate(B, 'FF*FF****') => disjoint로 예상
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
       geomtwo_desc,
	   geomone.STRelate(geomtwo, 'FF*FF****') "isrelete" 
FROM ex_geo_fun_tbl;

-- * STTouches
/*
 - 하나의 geometry이 또 다른 geometry과 공간적으로 만나면 1 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
       geomtwo_desc,
	   geomone.STTouches(geomtwo) "touches" 
FROM ex_geo_fun_tbl;

-- * Filter
/*
 - 인덱스를 사용할 수 있다고 가정하는 경우 2개의 geometry가 교차하는지 확인하는 빠른 인덱스 전용 교차법을 제공하는 메서드
   2개의 geometry가 교차할 가능성이 있으면 1을 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
       geomtwo_desc,
	   geomone.Filter(geomtwo) "filter" 
FROM ex_geo_fun_tbl;

-- * HasM
/*
 - 공간 개체에 M 값이 하나 이상 포함된 경우 1(true)을 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.HasM "hasm" 
FROM ex_geo_fun_tbl;

-- * HasZ
/*
 - 공간 개체에 Z 값이 하나 이상 포함된 경우 1(true)을 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.HasZ "hasz" 
FROM ex_geo_fun_tbl;

-- * InstanceOf
/*
 - geometry의 형식이 지정된 형식과 동일한 경우 1을 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.InstanceOf('point') "one_instanceof_desc",
	   geomtwo_desc,
	   geomtwo.InstanceOf('compoundcurve') "two_instanceof_desc" 
FROM ex_geo_fun_tbl;

-- * IsNull
/*
 - geometry가 Null이면 1을 반환
 - 반환 타입 : bit(= 0 or 1)
*/
SELECT geomone_desc,
	   geomone.IsNull "one_isnull_desc",
	   geomtwo_desc,
	   geomtwo.IsNull "two_isnull_desc" 
FROM ex_geo_fun_tbl;
