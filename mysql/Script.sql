# 데이터베이스 확인
SHOW DATABASES;
/*
본인이 생성했던 거와 기존에 있던거 모두 보여줌
 */

# 전역변수 내용 확인
SHOW GLOBAL variables LIKE 'c%';

# 데이터베이스 생성
CREATE DATABASE gydb;
SHOW DATABASES;

# 데이터베이스 삭제
DROP DATABASE gytest;
SHOW DATABASES;

# 현재 root사용자 조회
USE mysql;
SELECT USER, host FROM USER;

# 사용자 추가
CREATE USER 'user01'@'%' identified BY '1234'; 
/*
유저이름은 user01이고 비번은 1234
 */

# 외부 접속 허용
GRANT ALL PRIVILEGES ON *.* TO 'user01'@'%';
GRANT GRANT OPTION ON *.* TO 'user01'@'%';
flush PRIVILEGES;
/*
privileges는 특혜, 특권 등의 의미를 지닌 단어
flush는 분출하다, 물로씻어내기다, 넘치는, 홍조의
위의 2줄은 모든 ip주소에서 접근 가능하도록 설정
마지막 쿼리는 변경사항을 적용시켜 줌
 */
























