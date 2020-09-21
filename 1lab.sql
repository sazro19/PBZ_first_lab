DELIMITER //
CREATE PROCEDURE more_than_average ()
  BEGIN
SET @i := 1;
SET @result = '';
WHILE @i < 8 DO
SET @result = (SELECT DISTINCT supplier_id
FROM details_count
WHERE detail_id = 'Д1' AND project_id = CONCAT('ПР', CAST(@i AS CHAR)) AND count_s > (SELECT SUM(count_s) FROM details_count WHERE detail_id = 'Д1' AND project_id = CONCAT('ПР', CAST(@i AS CHAR)))/(SELECT COUNT(*) FROM details_count WHERE detail_id = 'Д1' AND project_id = CONCAT('ПР', CAST(@i AS CHAR))));
SET @i := @i + 1;
END WHILE;
END //