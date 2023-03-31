-- tbl_avm001: AVM 모형(AVM추정시세)
SELECT column_name, data_type, is_nullable, character_maximum_length, numeric_precision, datetime_precision
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'tbl_avm001';






SELECT DISTINCT st_setsrid(geom, 5174)
FROM avm_base_rtms_apt;
WHERE gojeu = '1';





SELECT DISTINCT fascy
FROM g2022;














































