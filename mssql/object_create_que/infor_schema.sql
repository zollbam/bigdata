USE msdb
go
-- tables : 테이블 정보
SELECT * FROM information_schema.tables;

-- TABLE_CONSTRAINTS : 각 테이블 제약 조건
SELECT * FROM information_schema.TABLE_CONSTRAINTS;

-- TABLE_PRIVILEGES : 테이블 권한
SELECT * FROM information_schema.TABLE_PRIVILEGES;

-- CONSTRAINT_TABLE_USAGE : 제약조건/테이블의 catalog, schema, name만 가지고 있음
/*TABLE_CONSTRAINTS보다 적은 정보를 가짐*/
SELECT * FROM information_schema.CONSTRAINT_TABLE_USAGE;

-- COLUMNS : 컬럼 정보
SELECT * FROM information_schema.COLUMNS;

-- COLUMN_PRIVILEGES : 열 권한
SELECT * FROM information_schema.COLUMN_PRIVILEGES;

-- CONSTRAINT_COLUMN_USAGE : CONSTRAINT_TABLE_USAGE에 컬럼명이 포함
SELECT * FROM information_schema.COLUMN_PRIVILEGES;

-- KEY_COLUMN_USAGE : 제약조건이 key
SELECT * FROM information_schema.KEY_COLUMN_USAGE;

-- referential_constraints : FK
SELECT * FROM information_schema.referential_constraints;

-- check_constraints : CKECK제약조건
SELECT * FROM information_schema.check_constraints;

-- VIEWS : View
SELECT * FROM information_schema.VIEWS;

-- VIEW_TABLE_USAGE : VIEW/TABLE의 CATALOG, SCHEMA, NAME
SELECT * FROM information_schema.VIEW_TABLE_USAGE;

-- VIEW_COLUMN_USAGE : VIEW_TABLE_USAGE + COLUMN_NAME
SELECT * FROM information_schema.VIEW_COLUMN_USAGE;

-- ROUTINES : 프로시저와 함수
SELECT * FROM information_schema.ROUTINES;

-- ROUTINE_COLUMNS : COLUMNS보다 적은 정보를 가짐
SELECT * FROM information_schema.ROUTINE_COLUMNS;

-- PARAMETERS : 사용자 정의 함수 또는 저장 프로시저
SELECT * FROM information_schema.PARAMETERS;

-- DOMAINS : 별칭 데이터
SELECT * FROM information_schema.DOMAINS;

-- COLUMN_DOMAIN_USAGE : 별칭 데이터
SELECT * FROM information_schema.COLUMN_DOMAIN_USAGE;

-- SCHEMATA : 스키마
SELECT * FROM information_schema.SCHEMATA;

-- SEQUENCES: 시퀀스
SELECT * FROM information_schema.SEQUENCES;
