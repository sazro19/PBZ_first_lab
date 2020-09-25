CREATE DATABASE first_lab;
USE first_lab;
CREATE TABLE teachers (
   personal_number VARCHAR(4),
   lastname VARCHAR(50),
   position VARCHAR(50),
   department VARCHAR(50),
   specialty VARCHAR(50),
   home_phone INT(3)
) CHARACTER SET utf8
  COLLATE utf8_unicode_CI;
INSERT INTO teachers (personal_number, lastname, position, department, specialty, home_phone)
VALUES ('221Л', 'Фролов', 'Доцент', 'ЭВМ', 'АСОИ, ЭВМ', 487),
       ('222Л',	'Костин', 'Доцент',	'ЭВМ', 'ЭВМ', 543),
	   ('225Л',	'Бойко', 'Профессор', 'АСУ', 'АСОИ, ЭВМ', 112),
       ('430Л',	'Глазов', 'Ассистент', 'ТФ', 'СД', 421),
       ('110Л',	'Петров', 'Ассистент', 'Экономики', 'Международная экономика', 324);
CREATE TABLE lessons (
   lesson_number VARCHAR(4),
   lesson_name VARCHAR(50),
   hours VARCHAR(50),
   specialty VARCHAR(50),
   term INT(3)
) CHARACTER SET utf8
  COLLATE utf8_unicode_CI;
INSERT INTO lessons (lesson_number, lesson_name, hours, specialty, term)
VALUES ('12П', 'Мини ЭВМ', 36, 'ЭВМ', 1),
       ('14П', 'ПЭВМ', 72, 'ЭВМ', 2),
	   ('17П', 'СУБД ПК', 48, 'АСОИ', 4),
       ('18П', 'ВКСС', 52, 'АСОИ', 6),
       ('34П', 'Физика', 30, 'СД', 6),
       ('22П', 'Аудит', 24,	'Бухучета', 3);
CREATE TABLE student_groups (
 group_number VARCHAR(5),
 group_name VARCHAR(50),
 persons_numer INT(5),
 specialty VARCHAR(50),
 headman_lastname VARCHAR(50)
 ) CHARACTER SET utf8
  COLLATE utf8_unicode_CI;
INSERT INTO student_groups (group_number, group_name, persons_number, specialty, headman_lastname)
VALUES ('8Г', 'Э-12', 18, 'ЭВМ', 'Иванова'),
       ('7Г', 'Э-15', 22, 'ЭВМ', 'Сеткин'),
       ('4Г', 'АС-9', 24, 'АСОИ', 'Балабанов'),
       ('3Г', 'АС-8', 20, 'АСОИ', 'Чижов'),
       ('17Г', 'С-14', 29, 'СД', 'Амросов'),
       ('12Г', 'М-6', 16, 'Международная экономика', 'Трубин'),
       ('10Г', 'Б-4', 21, 'Бухучет', 'Зязюткин');
CREATE TABLE classroom_numbers (
 group_number VARCHAR(5),
 lesson_number VARCHAR(5),
 personal_number VARCHAR(5),
 classroom_number INT(5)
 ) CHARACTER SET utf8
  COLLATE utf8_unicode_CI;
INSERT INTO classroom_numbers (group_number, lesson_number, personal_number, classroom_number)
VALUES ('8Г', '12П', '222Л', 112),
	   ('8Г', '14П', '221Л', 220),
       ('8Г', '17П', '222Л', 112),
       ('7Г', '14П', '221Л', 220),
       ('7Г', '17П', '222Л', 241),
       ('7Г', '18П', '225Л', 210),
       ('4Г', '12П', '222Л', 112),
	   ('4Г', '18П', '225Л', 210),
       ('3Г', '12П', '222Л', 112),
       ('3Г', '17П', '221Л', 241),
       ('3Г', '18П', '225Л', 210),
	   ('17Г', '12П', '222Л', 112),
       ('17Г', '22П', '110Л', 220),
       ('17Г', '34П', '430Л', 118),
       ('12Г', '12П', '222Л', 112),
	   ('12Г', '22П', '110Л', 210),
       ('10Г', '12П', '222Л', 210),
       ('10Г', '22П', '110Л', 210);
	   
SELECT *
FROM teachers;

SELECT *
FROM student_groups WHERE specialty = 'ЭВМ';

SELECT personal_number, classroom_number
FROM classroom_numbers WHERE lesson_number = '18П';

SELECT DISTINCT lessons.lesson_number, lessons.lesson_name 
FROM lessons 
JOIN classroom_numbers ON classroom_numbers.lesson_number = lessons.lesson_number 
JOIN teachers ON classroom_numbers.personal_number = teachers.personal_number
WHERE teachers.lastname = 'Костин';

SELECT DISTINCT student_groups.group_number 
FROM student_groups
JOIN classroom_numbers ON classroom_numbers.group_number = student_groups.group_number
JOIN teachers ON classroom_numbers.personal_number = teachers.personal_number
WHERE teachers.lastname = 'Фролов';

SELECT * 
FROM lessons WHERE specialty = 'АСОИ';

SELECT *
FROM teachers WHERE specialty REGEXP 'АСОИ';

SELECT DISTINCT teachers.lastname 
FROM teachers
JOIN classroom_numbers ON classroom_numbers.personal_number = teachers.personal_number
WHERE classroom_numbers.classroom_number = 210;

SELECT lessons.lesson_name, student_groups.group_name
FROM classroom_numbers
JOIN lessons ON lessons.lesson_number = classroom_numbers.lesson_number
JOIN student_groups ON student_groups.group_number = classroom_numbers.group_number
WHERE classroom_number 
BETWEEN 100 AND 200;

SELECT DISTINCT s1.group_number, s2.group_number
FROM student_groups s1, student_groups s2
WHERE s1.specialty = s2.specialty AND s1.group_number <> s2.group_number;  

SELECT SUM(persons_number)
FROM student_groups WHERE specialty = 'ЭВМ';

SELECT DISTINCT teachers.personal_number
FROM teachers
JOIN classroom_numbers ON classroom_numbers.personal_number = teachers.personal_number
JOIN student_groups ON student_groups.group_number = classroom_numbers.group_number
WHERE student_groups.specialty = 'ЭВМ';

SELECT DISTINCT lesson_number
FROM classroom_numbers
GROUP BY lesson_number
HAVING count(1) = (SELECT count(1) FROM student_groups);

SELECT DISTINCT lastname 
FROM teachers AS t
JOIN classroom_numbers AS cn ON t.personal_number = cn.personal_number
WHERE cn.personal_number IN (
    SELECT DISTINCT cn.personal_number 
    FROM classroom_numbers
    WHERE lesson_number IN (
        SELECT DISTINCT lesson_number
        FROM classroom_numbers
        WHERE personal_number IN (
            SELECT DISTINCT personal_number 
                FROM classroom_numbers
                WHERE lesson_number = '14П')
    )
);

SELECT DISTINCT *
FROM lessons
JOIN classroom_numbers ON classroom_numbers.lesson_number = lessons.lesson_number
WHERE classroom_numbers.personal_number <> '221П';

SELECT DISTINCT *
FROM lessons
WHERE lessons.lesson_number NOT IN (
SELECT distinct classroom_numbers.lesson_number
FROM classroom_numbers
JOIN student_groups ON student_groups.group_number = classroom_numbers.group_number
WHERE student_groups.group_name = 'М-6');

SELECT DISTINCT *
FROM teachers 
WHERE teachers.position = 'Доцент' AND teachers.personal_number IN (
SELECT DISTINCT classroom_numbers.personal_number 
FROM classroom_numbers
WHERE classroom_numbers.group_number IN ('8Г', '3Г')
);

SELECT DISTINCT classroom_numbers.lesson_number,
                classroom_numbers.personal_number,
				classroom_numbers.group_number
FROM classroom_numbers
JOIN teachers ON teachers.personal_number = classroom_numbers.personal_number
WHERE teachers.department = 'ЭВМ' AND teachers.specialty REGEXP 'АСОИ';

SELECT DISTINCT student_groups.group_number
FROM student_groups
JOIN classroom_numbers ON classroom_numbers.group_number = student_groups.group_number
JOIN teachers ON teachers.personal_number = classroom_numbers.personal_number
WHERE student_groups.specialty = teachers.specialty;

SELECT DISTINCT teachers.personal_number
FROM teachers
JOIN classroom_numbers ON classroom_numbers.personal_number = teachers.personal_number
JOIN lessons ON lessons.lesson_number = classroom_numbers.lesson_number
WHERE teachers.specialty = 'ЭВМ' AND lessons.specialty IN (
SELECT DISTINCT student_groups.specialty
FROM student_groups);

SELECT DISTINCT student_groups.specialty
FROM student_groups
JOIN classroom_numbers ON classroom_numbers.group_number = student_groups.group_number
JOIN teachers ON teachers.personal_number = classroom_numbers.personal_number
WHERE teachers.department = 'АСУ' AND teachers.specialty REGEXP student_groups.specialty;

SELECT DISTINCT lessons.lesson_number
FROM lessons
JOIN classroom_numbers ON classroom_numbers.lesson_number = lessons.lesson_number
JOIN student_groups ON student_groups.group_number = classroom_numbers.group_number
WHERE student_groups.group_name = 'АС-8';

SELECT DISTINCT student_groups.group_number
FROM student_groups
JOIN classroom_numbers ON classroom_numbers.group_number = student_groups.group_number
WHERE classroom_numbers.lesson_number IN (
SELECT classroom_numbers.lesson_number
FROM classroom_numbers
JOIN student_groups ON student_groups.group_number = classroom_numbers.group_number
WHERE student_groups.group_name = 'АС-8');

SELECT DISTINCT student_groups.group_number
FROM student_groups
JOIN classroom_numbers ON classroom_numbers.group_number = student_groups.group_number
WHERE classroom_numbers.lesson_number NOT IN (
SELECT classroom_numbers.lesson_number
FROM classroom_numbers
JOIN student_groups ON student_groups.group_number = classroom_numbers.group_number
WHERE student_groups.group_name = 'АС-8');

SELECT DISTINCT group_number
FROM classroom_numbers
WHERE lesson_number NOT IN (
SELECT lesson_number
FROM classroom_numbers
WHERE personal_number = '430Л');

SELECT DISTINCT personal_number
FROM classroom_numbers
JOIN student_groups ON student_groups.group_number = classroom_numbers.group_number
WHERE student_groups.group_name = 'Э-15' AND lesson_number NOT IN (
SELECT lesson_number
FROM classroom_numbers
WHERE lesson_number = '12П');

CREATE TABLE suppliers_s (
 id VARCHAR(5),
 name_p VARCHAR(30),
 supplier_status INT(5),
 city VARCHAR(30),
 PRIMARY KEY(id)
 ) CHARACTER SET utf8
  COLLATE utf8_unicode_CI;
  
INSERT INTO suppliers_s (id, name_p, supplier_status, city)
VALUES ('П1', 'Петров', 20,	'Москва'),
       ('П2', 'Синицин', 10, 'Таллинн'),
       ('П3', 'Федоров', 30, 'Таллинн'),
       ('П4', 'Чаянов',	20,	',Минск'),
       ('П5', 'Крюков',	30,	'Киев');
	   
CREATE TABLE details_p (
 id VARCHAR(5),
 name_d VARCHAR(30),
 color VARCHAR(30),
 size INT(5),
 city VARCHAR(30),
 PRIMARY KEY(id)
 ) CHARACTER SET utf8
  COLLATE utf8_unicode_CI;

INSERT INTO details_p (id, name_d, color, size, city)
VALUES ('Д1', 'Болт', 'Красный', 12, 'Москва'),
       ('Д2', 'Гайка', 'Зеленая', 17, 'Минск'),
       ('Д3', 'Диск', 'Черный',	17,	'Вильнюс'),
       ('Д4', 'Диск', 'Черный',	14,	'Москва'),
       ('Д5', 'Корпус',	'Красный', 12, 'Минск'),
       ('Д6', 'Крышки',	'Красный', 19, 'Москва');
	   
CREATE TABLE projects_j (
id VARCHAR(5),
name_pr VARCHAR(30),
city VARCHAR(30),
PRIMARY KEY(id)
);

INSERT INTO projects_j (id, name_pr, city)
VALUES ('ПР1', 'ИПР1', 'Минск'),
       ('ПР2', 'ИПР2', 'Таллинн'),
       ('ПР3', 'ИПР3', 'Псков'),
       ('ПР4', 'ИПР4', 'Псков'),
       ('ПР5', 'ИПР4', 'Москва'),
	   ('ПР6', 'ИПР6', 'Саратов'),
       ('ПР7', 'ИПР7', 'Москва');
	   
CREATE TABLE details_count (
supplier_id VARCHAR(5) REFERENCES suppliers_s(id),
detail_id VARCHAR(5) REFERENCES details_p(id),
project_id VARCHAR(5) REFERENCES projects_pr(id),
count_s INT(5),
PRIMARY KEY (supplier_id, detail_id, project_id)
);

INSERT INTO details_count (supplier_id, detail_id, project_id, count_s)
VALUES ('П1', 'Д1',	'ПР1', 200),
	   ('П1', 'Д1',	'ПР2', 700),
       ('П2', 'Д3',	'ПР1', 400),
       ('П2', 'Д2',	'ПР2', 200),
       ('П2', 'Д3',	'ПР3', 200),
       ('П2', 'Д3',	'ПР4', 500),
       ('П2', 'Д3',	'ПР5', 600),
       ('П2', 'Д3',	'ПР6', 400),
       ('П2', 'Д3',	'ПР7', 800),
       ('П2', 'Д5',	'ПР2', 100),
       ('П3', 'Д3',	'ПР1', 200),
       ('П3', 'Д4',	'ПР2', 500),
       ('П4', 'Д6',	'ПР3', 300),
       ('П4', 'Д6',	'ПР7', 300),
       ('П5', 'Д2',	'ПР2', 200),
       ('П5', 'Д2',	'ПР4', 100),
       ('П5', 'Д5',	'ПР5', 500),
       ('П5', 'Д5',	'ПР7', 100),
       ('П5', 'Д6',	'ПР2', 200),
       ('П5', 'Д1',	'ПР2', 100),
       ('П5', 'Д3',	'ПР4', 200),
       ('П5', 'Д4',	'ПР4', 800),
       ('П5', 'Д5',	'ПР4', 400),
       ('П5', 'Д6',	'ПР4', 500);
	   
-- 24  
SELECT DISTINCT id
FROM suppliers_s
WHERE supplier_status < (
SELECT supplier_status
FROM suppliers_s
WHERE id = 'П1'
);

-- 19
SELECT DISTINCT projects_j.name_pr 
FROM projects_j
JOIN details_count ON details_count.project_id = projects_j.id
WHERE details_count.supplier_id = 'П1';

-- 27
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
END //;
CALL PROCEDURE more_than_average;

--6
SELECT DISTINCT s1.id, s2.id, s3.id
FROM suppliers_s s1, details_p s2, projects_j s3
WHERE s1.city = s2.city AND s2.city = s3.city AND s1.city = s3.city;

--1
SELECT *
FROM projects_j;

--9
SELECT DISTINCT details_p.id
FROM details_p
JOIN details_count ON details_count.detail_id = details_p.id
JOIN suppliers_s ON suppliers_s.id = details_count.suppliers_id
WHERE suppliers_s.city = 'Лондон';

--13
SELECT DISTINCT projects_j.id 
FROM projects_j
JOIN details_count ON details_count.project_id = projects_j.id
JOIN suppliers_s ON suppliers_s.id = details_count.supplier_id
WHERE suppliers_s.city <> projects_j.city; 

--35
SELECT DISTINCT s1.supplier_id, s2.detail_id
FROM details_count AS s1, details_count AS s2
GROUP BY s1.supplier_id, s2.detail_id
HAVING s2.detail_id NOT IN (
SELECT s2.detail_id
FROM details_count AS s2
WHERE s1.supplier_id = s2.supplier_id
);

--18
SELECT detail_id
FROM details_count
GROUP BY detail_id 
HAVING AVG(count_s) > 320;

--33
SELECT DISTINCT suppliers_s.city
FROM suppliers_s
JOIN details_count ON details_count.supplier_id = suppliers_s.id
JOIN details_p ON details_p.id = details_count.detail_id;