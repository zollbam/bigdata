﻿/*
mssql
날짜 23-07-30

전체 텍스트 검색
https://youtu.be/9B3djhQ8QXQ

개념
 - 긴 문장으로 구성된 열의 내용을 검색 할 때 인덱스를 사용해서 빠른 시간에 검색하는 것
 - 긴 문장이 저장된 열의 내용에 포함된 여러 단어에 인덱스가 설정되어서 검색 시에 인덱스를 사용하게 되므로 검색 속도가 월등히 빨라짐

필수 조건
 - SQL SERVER 2016 구성관리자의 SQL SERVER 서비스의 SQL FULL - TEXT FILTER DAEMON LAUNCHER가 실행되어 있어야 한다. 

전체 텍스트 인덱스
 - 테이블당 하나만 생성 가능
 - 데이터를 추가하는 채우기는 일정 예약이나 특별한 요청에 의해서 수행되거나 새로운 데이터를 insert시에 자동으로 수행되도록 할 수 있다.
 - char, varchar, nchar, nvarchar, text, ntext, image, xml, varbinary(max), filestream 등의 열에서 생성 가능
 - 전체 텍스트 인덱스를 생성할 테이블에는 PK나 UK가 존재 해야 한다.

전체 텍스트 인덱스 채우기
 - 전체 텍스트 인덱스를 생성하고 관리하는 것
 1) 전체 채우기
  * 지정한 열의 모든 데이터 행에 대해서 인덱스를 생성하는 것
  * 처음에는 전체 채우기를 수행
 2) 변경 내용 추적 기반 채우기
  * 전체 채우기를 수행한 이후에 변경된 내용을 채우는 것
 3) 증분 타임 스탬프 기반 채우기
  * 마지막 채우기 후 추가, 삭제, 수정된 행에 대해서 전체 텍스트 인덱스를 업데이트
  * 타임 스탬프 데이터 형식의 열이 있어야 함
   => 타임 스탬프 열이 없어도 증분 채우기가 되지만 성능에 부하가 발생


*/

-- 전체 텍스트 인덱스 실습
create database fulltextdb;
go
use fulltextdb;
go
create table fulltexttbl
	(id int identity constraint pk_id primary key, -- 고유번호
	 title nvarchar(15) not null, -- 영화 제목
	 description nvarchar(max)); -- 영화 내용 요약
insert into fulltexttbl values ('광해, 왕이 된 남자', '왕위를 둘러싼 권력 다툼과 붕당정치로 혼란이 극에 달한 광해군 8년. 자신의 목숨을 노리는 자들에 대한 분노와 두려움으로 점점 난폭해져 가던 왕 ‘광해’는 도승지 ‘허균’에게 자신을 대신하여 위협에 노출될 대역을 찾을 것을 지시한다. 이에 허균은 기방의 취객들 사이에 걸쭉한 만담으로 인기를 끌던 하선을 발견한다. 왕과 똑같은 외모는 물론 타고난 재주와 말솜씨로 왕의 흉내도 완벽하게 내는 하선. 영문도 모른 채 궁에 끌려간 하선은 광해군이 자리를 비운 하룻밤 가슴 조이며 왕의 대역을 하게 된다. 왕이 되어선 안 되는 남자, 조선의 왕이 되다! 그러던 어느 날 광해군이 갑자기 의식을 잃고 쓰러지는 엄청난 사건이 발생하고, 허균은 광해군이 치료를 받는 동안 하선에게 광해군을 대신하여 왕의 대역을 할 것을 명한다. 저잣거리의 한낱 만담꾼에서 하루아침에 조선의 왕이 되어버린 천민 하선. 허균의 지시 하에 말투부터 걸음걸이, 국정을 다스리는 법까지, 함부로 입을 놀려서도 들켜서도 안 되는 위험천만한 왕노릇을 시작한다. 하지만 예민하고 난폭했던 광해와는 달리 따뜻함과 인간미가 느껴지는 달라진 왕의 모습에 궁정이 조금씩 술렁이고, 점점 왕의 대역이 아닌 자신의 목소리를 내기 시작하는 하선의 모습에 허균도 당황하기 시작하는데...');
insert into fulltexttbl values ('간첩', '불법 비아그라를 판매하며 전세금 인상에 시달리는 평범한 가장, 알고 보니 남파 22년차 간첩 리더 암호명 ''김과장'' 살림하랴, 일하랴 하루가 바쁜 억척스러운 동네 부동산 아줌마, 알고 보니 로케이션 전문 여간첩 암호명 ''강대리'' 공무원으로 명퇴 후 탑골 공원에서 시간 때우는 독거노인, 알고 보니 신분세탁 전문 간첩 암호명 ''윤고문'' 소 키우며 FTA반대에 앞장서는 귀농 청년, 알고 보니 해킹 전문 간첩 암호명 ''우대리'' 간첩신고보다 남한의 물가상승이 더 무서운 생활형 간첩들 앞에 피도 눈물도 없는 북한 최고의 암살자 ''최부장''이 나타났다! 그리고 그들에게 떨어진 10년만의 암.살.지.령!! 과연 이들은 작전에 성공할 수 있을까? 먹고 살기도 바쁜 생활형 간첩들의 사상(?) 초월 이중작전이 시작된다!');
insert into fulltexttbl values ('피에타', '끔찍한 방법으로 채무자들의 돈을 뜯어내며 살아가는 남자 ‘강도(이정진)’. 피붙이 하나 없이 외롭게 자라온 그에게 어느 날 ‘엄마’라는 여자(조민수)가 불쑥 찾아 온다. 여자의 정체에 대해 끊임없이 의심하며 혼란을 겪는 강도. 태어나 처음 자신을 찾아온 그녀에게 무섭게 빠져들기 시작한다. 그러던 어느 날 여자는 사라지고, 곧이어 그와 그녀 사이의 잔인한 비밀이 드러나는데… 결코 용서받을 수 없는 두 남녀, 신이시여 이들에게 자비를 베푸소서.');
insert into fulltexttbl values ('레지던트 이블 5', '엄브렐라의 치명적인T-바이러스가 전 세계를 위험에 빠뜨리고, 언데드가 지구를 장악한다. 인류의 마지막 희망인 ''앨리스''(밀라 요보비치)는 엄브렐라의 비밀기지에서 깨어나고 더욱 강하고 악랄해진 악의 존재들과 마주하게 된다. 도쿄와 뉴욕, 워싱턴, 모스크바 등 전세계를 넘나들며 치열한 사투를 벌이던 ‘앨리스’는 서서히 드러나는 자신의 미스테리한 과거를 알게되고, 이제까지 진실이라 믿었던 모든 것을 의심하기 시작한다. 혼란에 빠진 앨리스는 최강 언데드와 더욱 막강해진 엄브렐라에 맞서 인류 최대의 전쟁을 시작하는데...');
insert into fulltexttbl values ('파괴자들', '12살 아들 에반과 함께 살고 있는 싱글맘 르네(누미 라파스). 어느 날, 길을 달리던 르네의 자동차가 고장 나 잠시 내린 사이 낯선 이들에게 납치를 당하고 만다. 납치된 그녀는 의문의 실험실에 감금되고, 극도의 두려움을 자극하는 갖가지 실험들이 자행된다. 그녀는 홀로 남겨진 아들에게 돌아가기 위해 필사의 노력을 다해 탈출을 시도하지만 출구를 찾을 수 없는데…');
insert into fulltexttbl values ('킹콩을 들다', '88올림픽 역도 동메달리스트였지만 부상으로 운동을 그만둔 후 시골여중 역도부 코치로 내려온 이지봉(이범수 분). 역도선수에게 남는 건 부상과 우락부락한 근육뿐이라며 역도에 이골 난 그가 가진 거라곤 힘 밖에 없는 시골소녀들을 만났다. 낫질로 다져진 튼튼한 어깨와 통짜 허리라는 타고난 신체조건의 영자(조안 분), 학교 제일 킹카를 짝사랑하는 빵순이 현정(전보미 분), 하버드 로스쿨에 들어가 FBI가 되겠다는 모범생 수옥(이슬비 분), 아픈 엄마를 위해 역도선수로 성공하고 싶다는 효녀 여순(최문경 분), 힘쓰는 일이 천성인 보영(김민영 분), 섹시한 역도복의 매력에 푹 빠진 S라인 사차원 꽃미녀 민희(이윤회 분). 개성도 외모도 제각각 이지만 끈기와 힘만은 세계 최강인 순수한 시골소녀들의 열정에 감동한 이지봉은 오갈 데 없는 아이들을 위해 합숙소를 만들고, 본격 훈련에 돌입한다. 맨땅에서 대나무 봉으로 시작한 그들은 이지봉의 노력에 힘입어 어느새 역기 하나쯤은 가뿐히 들어올리는 역도선수로 커나가고 마침내 올림픽 금메달에 도전하게 되는데….');
insert into fulltexttbl values ('테드', '''내가 물건이라고?!'' 곰생폼사 욕정곰 테드에게 인권(?)을 허하소서! 왕따에게도 왕따 당하던 8살 존(마크 월버그)의 크리스마스 소원으로 살아 움직이게 된 테드(세스 맥팔레인)! 무적의 썬더 버디로 30년 동안 철없고 끈끈한 우정을 이어가던 둘은 테드가 인간이 아니라 물건(?)이라는 법원의 판결로 멘붕에 빠진다. 빡친 테드는 존과 함께 자신의 인권(?)을 입증하기 위해 승률 99.8% 변호사 사만다(아만다 사이프리드)를 찾아가는데……');
insert into fulltexttbl values ('타이타닉', '"내 인생의 가장 큰 행운은 당신을 만난 거야" 우연한 기회로 티켓을 구해 타이타닉호에 올라탄 자유로운 영혼을 가진 화가 ‘잭’(레오나르도 디카프리오)은 막강한 재력의 약혼자와 함께 1등실에 승선한 ''로즈''(케이트 윈슬렛)에게 한눈에 반한다. 진실한 사랑을 꿈꾸던 ''로즈'' 또한 생애 처음 황홀한 감정에 휩싸이고, 둘은 운명 같은 사랑에 빠지는데… 가장 차가운 곳에서 피어난 뜨거운 사랑! 영원히 가라앉지 않는 세기의 사랑이 펼쳐진다!');
insert into fulltexttbl values ('8월의 크리스마스', '"좋아하는 남자 친구 없어요?" 그 남자 l 한석규 변두리 사진관에서 아버지를 모시고 사는 노총각 ‘정원’. 시한부 인생을 받아들이고 가족, 친구들과 담담한 이별을 준비하던 어느 날, 주차단속요원 ''다림''을 만나게 되고 차츰 평온했던 일상이 흔들리기 시작한다. "아저씨, 왜 나만 보면 웃어요?" 그 여자 l 심은하 밝고 씩씩하지만 무료한 일상에 지쳐가던 스무 살 주차 단속요원 ''다림''. 단속차량 사진의 필름을 맡기기 위해 드나들던 사진관의 주인 정원에게 어느새 특별한 감정을 갖게 되는데... 2013년 가을, 사랑을 간직한 채 떠나갔던 그 사람이 다시 돌아옵니다.');
insert into fulltexttbl values ('늑대와 춤을', '1863년, 모두가 지쳐가는 전쟁의 가운데에서 전투를 승리로 이끌고 영웅이 된 존 J 던바 중위는 동부 전쟁터를 떠나 서부 국경지대로 자원한다. 아무도 없이 홀로 서부 국경지대 세즈윅 요새를 지키게 된 존 J 던바 중위. 전쟁 영웅의 포상으로 받은 말 ''시스코''와 그의 주변을 맴돌기 시작한 늑대''하얀 발''과 평화로운 일상을 보내던 중 인디언 ''수우족 부족''과 마주치고 그들의 삶에 매료되어, 백인의 삶을 버리고 인디언 ''늑대와 춤을''로 다시 태어나게 된다. 한편, 인디언들의 땅을 정복하기 위해 백인 기병대들이 침략을 준비 중인데…');
insert into fulltexttbl values ('국가대표2', '유일무이 정통 아이스하키 선수 출신 에이스 ''지원'' 자존심은 금메달 급, 현실은 쇼트트랙 강제퇴출 ''채경'' 사는 게 심심한 아줌마, 빙판에선 열정의 프로 ''영자'' 시간외 수당이 목표, 아이스하키 협회 경리 출신 ''미란'' 취집으로 인생 반전 꿈꾸는 전직 피겨요정 ''가연'' 주장급 멘탈 보유자, 최연소 국가대표 꿈나무 ''소현'' 말만 번지르르, 주니어 아이스하키 우정상에 빛나는 국대 출신 감독 ''대웅'' 이들이 뭉친 단 하나의 이유는 아오모리 동계 아시안게임 출전! 뭉치면 싸우고 흩어지면 출전불가! 모두가 불가능하다고 믿었던 이들의 뜨거운 도전이 시작된다!');
insert into fulltexttbl values ('쇼생크 탈출', '촉망 받던 은행 부지점장 앤디(팀 로빈슨 分)는 아내와 그 애인을 살해한 혐의로 종신형을 받고 쇼생크 교도소에 수감된다. 강력범들이 수감된 이곳에서 재소자들은 짐승 취급 당하고, 혹여 간수 눈에 잘못 보였다가는 개죽음 당하기 십상이다. 처음엔 적응 못하던 ''앤디''는 교도소 내 모든 물건을 구해주는 ''레드(모건 프리먼 分)''와 친해지며 교도소 생활에 적응하려 하지만, 악질 재소자에게 걸려 강간까지 당한다. 그러던 어느 날, 간수장의 세금 면제를 도와주며 간수들의 비공식 회계사로 일하게 되고, 마침내는 소장의 검은 돈까지 관리해주게 된다. 덕분에 교도소 내 도서관을 열 수 있게 되었을 무렵, 신참내기 ''토미(길 벨로우스 分)''로부터 ''앤디''의 무죄를 입증할 기회를 얻지만, 노튼 소장은 ''앤디''를 독방에 가두고 ''토미''를 무참히 죽여버리는데...');
go
select * from fulltexttbl where description like '%남자%';
/*scan이므로 전체 테이블 다 찾으므로 성능 저하 우려*/
go
/*전체 텍스트 카탈로그 생성*/
create fulltext catalog moviecatalog as default;
/*가상의 공간으로 폴더 개념으로만 알아 두자!!*/
go
create fulltext index on fulltexttbl(description)
	key index pk_id
		on moviecatalog
		with change_tracking auto;
go
/*전체 텍스트 인덱스 조회*/
select * from sys.fulltext_indexes;
/*is_enavled 열에서 1이면 해당 인덱스가 활성화 상태라는 의미*/
go
/*전체 텍스트 인덱스 키워드 확인*/
select * from sys.dm_fts_index_keywords(DB_ID(), object_id('dbo.fulltexttbl'));
/*단어 하나하나로 생성된 키워드 확인 가능*/
go
drop fulltext index on fulltexttbl;
go
/*중지 목록 만들기*/
/*
1. 왼쪽 개체 탐색기
2. 해당 db => 저장소 => 전체 텍스트 중지목록 
3. 새 전체 텍스트 중지 목록
4. 이름 설정하고 시스템 중지 목록에서 만들기를 체크하고 확인
5. 만들어진 중지목록의 속성에 들어가 하나씩 추가하면 됨
*/
go
select * from fulltexttbl where contains(description, '남자');
/*scan에서 seek로 바뀐 것을 확인*/
select * from fulltexttbl where contains(description, '남자 or 여자');
select * from fulltexttbl where contains(description, '남자 or 북한');
select * from fulltexttbl where contains(description, '남자 and 채무자');
go
select 
  f.id
, c.rank "가중치"
, f.title
, f.description
  from fulltexttbl f
       inner join
	   containstable(fulltexttbl, *, '남자') c
		on f.id=c."key"
 order by c.rank desc;
go
drop fulltext index on fulltexttbl;
drop fulltext catalog moviecatalog;
/*카탈로그를 삭제 하려면 면서 텍스트 인덱스 삭제 후 진행 해야함*/











