TRUNCATE TABLE sc_khb_srv.tb_com_error_log;

SELECT * FROM sc_khb_srv.tb_com_error_log;

DROP TABLE chtest;

CREATE TABLE chtest (
	ch1 nvarchar(3) collate chinese_prc_ci_as,
	ch2 varchar(5) COLLATE Latin1_General_100_CI_AS_KS,
	ch3 varchar(6) COLLATE chinese_prc_ci_as
);

INSERT INTO chtest VALUES ('가나다', '가나다', '가나다');
INSERT INTO chtest VALUES ('日', '가나', '가나');
INSERT INTO chtest VALUES ('日', '建泳', '趙建泳');
INSERT INTO chtest VALUES ('將軍', N'mālum', N'手木');
INSERT INTO chtest VALUES (N'將軍', 'disciplína', '電光石火');


SELECT * FROM chtest;
SELECT * FROM fn_helpcollations();
SELECT name FROM sys.fn_helpcollations() WHERE name LIKE '%CS_AS%';
/*
전체는 3887
BIN: binary sort
BIN2: binary code point comparison sort
CI_AI: case-insensitive, accent-insensitive, kanatype-insensitive, width-insensitive
CI_AI_WS: case-insensitive, accent-insensitive, kanatype-insensitive, width-sensitive
CI_AI_KS: case-insensitive, accent-insensitive, kanatype-sensitive, width-insensitive
CI_AI_KS_WS: case-insensitive, accent-insensitive, kanatype-sensitive, width-sensitive
CI_AS: case-insensitive, accent-sensitive, kanatype-insensitive, width-insensitive
CI_AS_WS: case-insensitive, accent-sensitive, kanatype-insensitive, width-sensitive
CI_AS_KS: case-insensitive, accent-sensitive, kanatype-sensitive, width-insensitive
CI_AS_KS_WS: case-insensitive, accent-sensitive, kanatype-sensitive, width-sensitive
CS_AI: case-sensitive, accent-insensitive, kanatype-insensitive, width-insensitive
CS_AI_WS: case-sensitive, accent-insensitive, kanatype-insensitive, width-sensitive
CS_AI_KS: case-sensitive, accent-insensitive, kanatype-sensitive, width-insensitive
CS_AI_KS_WS: case-sensitive, accent-insensitive, kanatype-sensitive, width-sensitive
CS_AS: case-sensitive, accent-sensitive, kanatype-insensitive, width-insensitive
CS_AS_WS: case-sensitive, accent-sensitive, kanatype-insensitive, width-sensitive
CS_AS_KS: case-sensitive, accent-sensitive, kanatype-sensitive, width-insensitive
CS_AS_KS_WS: case-sensitive, accent-sensitive, kanatype-sensitive, width-sensitive
*/


SELECT @@version;
SELECT * from fn_helpcollations() ORDER BY name desc;


-- NVARCHAR column is encoded in UTF-16 because a supplementary character enabled collation is used
CREATE TABLE dbo.MyTable (CharCol NVARCHAR(50) COLLATE Latin1_General_100_CI_AI_SC);

TRUNCATE TABLE MyTable;

INSERT INTO MyTable VALUES 
	('가'),
	('나'),
	('rk가sk나ek다'),
	('リンゴ사과'),
	('リンゴ사과日');



DROP TABLE MyTable_kor;
TRUNCATE TABLE MyTable1;
SELECT * FROM MyTable_latin ORDER BY CharCol;

SELECT * FROM information_SCHEMA.columns;
CREATE TABLE MyTable_kor (CharCol NVARCHAR(50) COLLATE Korean_Wansung_CI_AS);
CREATE TABLE MyTable_latin (CharCol NVARCHAR(50) COLLATE Latin1_General_CS_AI);
CREATE TABLE MyTable_jap(CharCol NVARCHAR(50) COLLATE Japanese_CI_AI_KS);
CREATE TABLE MyTable_chin (CharCol NVARCHAR(50) COLLATE Chinese_PRC_CI_AI_KS_WS);

INSERT INTO MyTable_chin VALUES 
	('가'),
	('나'),
	('rk가sk나ek다'),
	('リンゴ사과'),
	('リンゴ사과日'),
	('電光石火ぎじゅつ발사go');
	










