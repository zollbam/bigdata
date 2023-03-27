-- 연습문제
-- 1. 지역 동물원의 모든 동물이 담긴 일람표를 작성하기 위한 DB만들기
--    하나의 테이블에는 동물 유형을 기록하고 
--    다른 테이블에는 각 동물에 대한 구체적인 정보를 기록
CREATE TABLE animal_types (
    animal_type_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- 동물 고유 번호
    common_name varchar(50) NOT NULL, -- 동물 이름(=애칭)
    scientific_name varchar(50) NOT NULL, -- 동물의 진짜 이름
    conservation_status varchar(50) NOT NULL, -- 보호 상태
    CONSTRAINT common_name_unique UNIQUE (common_name) -- 애칭은 중복이 될 수 가 없다.
);

CREATE TABLE menagerie (
   menagerie_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- 야생동물 번호
   common_name varchar(50) REFERENCES animal_types (common_name), -- 동물 애칭
   date_acquired date NOT NULL, -- 동물원 들어온 날짜
   gender varchar(50), -- 성별
   acquired_from varchar(50), -- 동물원 이름
   notes varchar(50) -- 추가 설명
);

INSERT INTO animal_types (common_name, scientific_name, conservation_status) VALUES
('Bengal Tiger', 'Panthera tigris tigris', 'Endangered'),
('Arctic Wolf', 'Canis lupus arctos', 'Least Concern');

INSERT INTO menagerie (common_name, date_acquired, gender, acquired_from, notes) VALUES
('Bengal Tiger', '1996-03-12', 'F', 'Dhaka Zoo', 'Healthy coat at last exam.'),
('Arctic Wolf', '2000-09-30', 'F', 'National Zoo', 'Strong appetite.');