/*
db 및 유저 등 서버에 필요한 기본 작업 세팅 파일
작성 일시: 230601
수정 일시: 230629
작 성 자 : 조건영
*/

-- DB 생성 및 사용
CREATE DATABASE db_khb_srv;
USE db_khb_srv;

-- 스키마 생성
CREATE SCHEMA sc_khb_srv;

-- 로그인 유저 생성
/*쿼리문은 mssql_tbl엑셀파일의 "유저"시트의 로그인 유저 열에 존재*/
create login us_khb_adm with password = 'adm!#24', default_database = db_khb_srv;
create login us_khb_com with password = 'com!#24', default_database = db_khb_srv;
create login us_khb_dev with password = 'dev!#24', default_database = db_khb_srv;
create login us_khb_exif with password = 'exif!#24', default_database = db_khb_srv;
create login us_khb_magnt with password = 'magnt!#24', default_database = db_khb_srv;
create login us_khb_mptl with password = 'mptl!#24', default_database = db_khb_srv;
create login us_khb_report with password = 'report!#24', default_database = db_khb_srv;
create login us_khb_agnt with password = 'agnt!#24', default_database = db_khb_srv;

-- 유저 생성
/*쿼리문은 mssql_tbl엑셀파일의 "유저"시트의 유저 열에 존재*/
create user us_khb_adm for login us_khb_adm with default_schema = sc_khb_srv;
create user us_khb_com for login us_khb_com with default_schema = sc_khb_srv;
create user us_khb_dev for login us_khb_dev with default_schema = sc_khb_srv;
create user us_khb_exif for login us_khb_exif with default_schema = sc_khb_srv;
create user us_khb_magnt for login us_khb_magnt with default_schema = sc_khb_srv;
create user us_khb_mptl for login us_khb_mptl with default_schema = sc_khb_srv;
create user us_khb_report for login us_khb_report with default_schema = sc_khb_srv;
create user us_khb_agnt for login us_khb_agnt with default_schema = sc_khb_srv;

-- us_khb_adm에게 스키마에 대한 권한 주기
GRANT SELECT, delete, control ON SCHEMA::sc_khb_srv TO us_khb_adm;

-- us_khb_adm에게 서버 권한 주기
ALTER SERVER ROLE dbcreator ADD MEMBER us_khb_adm;
ALTER SERVER ROLE sysadmin ADD MEMBER us_khb_adm;


-- 삭제
DROP USER us_khb_agent;
DROP LOGIN us_khb_agent;




















