
-- SELECT COLUMN_NAME "컬럼명", COLUMN_COMMENT "컬럼명", COLUMN_KEY, COLUMN_TYPE, IS_NULLABLE
-- FROM information_schema.columns WHERE TABLE_NAME=LOWER('AGENT_INFO_TMP')
-- 
-- 
-- 
-- SELECT * FROM information_schema.columns WHERE TABLE_NAME=LOWER('GRND_INFO')
-- 
-- 
-- SELECT * FROM information_schema.KEY_COLUMN_USAGE;
-- SELECT * FROM information_schema.columns where data_type='enum';
-- SELECT * FROM information_schema.TABLE_CONSTRAINTS
-- SELECT * FROM information_schema.CHECK_CONSTRAINTS
-- SELECT * FROM information_schema.columns
-- SELECT * FROM information_schema.COLUMN_PRIVILEGES
-- SELECT * FROM information_schema.referential_constraints


SELECT COLUMN_NAME "컬럼명", COLUMN_COMMENT "컬럼명", COLUMN_KEY, COLUMN_TYPE, IS_NULLABLE
FROM information_schema.columns WHERE TABLE_NAME=LOWER('user_info_hp')

-- SELECT COUNT(TABLE_NAME) FROM information_schema.TABLES WHERE TABLE_SCHEMA='hanbang'
-- user_info_hp


-- DESC article_type_ab_info;


