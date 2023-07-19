/*
작성 일자 : 230717
수정 일자 : -- 
작 성 자 : 조건영
작성 목적 : mssql에서 mssql로 db이관 연습
사용 DB 프로그램 : SQL SERVER 2016

*/

-- DB백업 => 원격서버
BACKUP DATABASE db_khb_srv
    TO DISK = 'D:/khb/Microsoft SQL Server/MSSQL13.HBSERVER/MSSQL/Backup/db_khb_srv.bak';
/*
161번에의 db_khb_srv의 DB를 백업
bak파일이 생성되고는 scp나 filezilla로 내 로컬로 파일 이동
*/

-- DB복원 => 내 로컬
RESTORE DATABASE backupdb FROM DISK = 'C:\hanbang\db_khb_srv.bak';
/*
오류발생
 => 운영 체제 오류 3(지정된 경로를 찾을 수 없습니다.)(으)로 인해 파일 "D:\khb\Microsoft SQL Server\MSSQL13.HBSERVER\MSSQL\Data\db_khb_srv.mdf"에 대한 디렉터리를 조회하지 못했습니다.
 => 백업했던 서버에서는 해당 오류가 나는 경로에 mdf파일과 로그파일이 저장되어 있고 내 로컬에는 서버와 같은 경로가 없기 떄문에 발생하는 오류
*/

-- 백업파일에 포함된 데이터베이스 파일과 로그 파일의 이름 및 위치를 확인
RESTORE FILELISTONLY FROM DISK='C:\hanbang\db_khb_srv.bak';
/*
1. PhysicalName에는 서버에서 사용했던 이름이나 경로를 확인
2. 내 로컬에서 경로를 지정하기 위해 밑에서 쓰는 옵션이 필요
*/

RESTORE DATABASE backupdb 
   FROM DISK = 'D:\test\b.bak'
   WITH MOVE 'db_khb_srv_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\db_khb_srv.mdf',
        MOVE 'db_khb_srv' TO 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\db_khb_srv_log.ldf';
/*
1. CREATE DATABASE 문이 없어도 알아서 DB가 생성
2. 
*/

-- 복원한 DB의 정보 확인
EXEC sp_helpdb 'backupdb';
/*
1. db_khb_srv.bak에서 확인 했던 경로를 쓰는 것이 아닌 내가 지정한 경로에 mdf와 로그 파일이 생성
2. 결과 창이 2개 나와야하는데 디비버에서는 1개만 나와 보기 불편
*/

USE backupdb;
EXEC sp_spaceused 'sc_khb_srv.tb_com_error_log';
/*
해당 db에 접속을 해서 스키마명과 테이블 명을 같이 입력하면 테이블에 대한 이름, 행수, 크기 등을 확인 가능
*/

EXEC sp_spaceused @updateusage = N'TRUE';
/*
unallocated space: 현재 사용중인 DB이름과 데이터베이스 크기, 데이터베이스 개체용으로 예약되지 않는 데이터베이스 공간
*/

-- mdf 파일과 로그 파일
USE master;
EXEC sp_detach_db 'backupdb', 'true';
/*
exec 문이 실행되면 backupdb가 연결이 해제
연결경로 안에 있는 파일 삭제 가능
db_khb_srv의 관련된 mdf와 로그 파일은 20기가
*/



















