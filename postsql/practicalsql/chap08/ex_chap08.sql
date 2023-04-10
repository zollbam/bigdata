-- 연습문제
/*
albums: 디스크 전체 노래 모음에 대한 정보 
create table albums(
	album_id bigint generated always as identity,
	catalog_code text,
	title text,
	artist text,
	release_date date,
	genre text,
	description text
);

songs: 앨범의 각 트랙
create table songs (
	song_id bigint generated always as identity,
	title text,
	composers text,
	album_id bigint
);
*/

-- * 1번
/*
기본 및 외래 키 와 두 테이블에 대한 추가 제약 조건을 포함하도록 create table문을 수정하세요. 
*/
CREATE TABLE albums(
	album_id bigint generated ALWAYS as identity,
	catalog_code TEXT NOT NULL,
	title TEXT NOT NULL,
	artist TEXT NOT NULL,
	release_date date,
	genre TEXT,
	description TEXT,
	CONSTRAINT album_id_key PRIMARY KEY (album_id) -- album_id를 기본키로 설정
);

create table songs (
	song_id bigint generated always as IDENTITY,
	title TEXT NOT NULL,
	composers TEXT NOT NULL,
	album_id bigint references albums(album_id)
);

-- * 2번
/*
albums테이블 안에 있는 열들 중 자연 키로 사용할 만한 것이 있나요??

title과 artist의 복합 기본키로 설정할려고 한다.
하나의 가수가 동일한 이름을 가진 노래를 2개 이상 발매하지는 않을 거라 생각하였습니다.
*/

-- * 3번
/*
쿼리 성능을 높이기 위한 적당한 열이 있나여??

기본키에는 인덱스가 생성되지만 외래키에는 인덱스가 생성되지 않는다.
그러므로 songs에 album_id를 인덱스로 잡거나 title만 알면
노래에 대한 정보를 쉽게 얻을 수 있기 때문에 title을 인덱스로
만들어도 좋아 보입니다.
*/






























