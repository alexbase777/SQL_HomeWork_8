-- 1.	Создайте команду для добавления в базу данных таблицы пилотов с названием «pilots» и двумя полями 
--pilot_name (ФИО пилота) и experience (стаж пилота). Поле имени должно быть обязательным для заполнения, 
-- поле стажа – необязательным. Самостоятельно добавьте автоинкрементирующийся первичный ключ к таблице.
CREATE TABLE Pilots
(
	id SERIAL NOT NULL PRIMARY KEY , -- Уникальный идентификатор - первичный ключ, тип SERIAL - автоикремент
	Pilot_name TEXT NOT NULL, -- Имя пилота
	Experience REAL -- Стаж пилота 	
);

--2.	Добавьте в таблицу пилотов четыре записи:
--Иван – 5 лет стажа
--Петр – 2 года стажа
--Павел – 7 лет стажа
--Борис – 1 год стажа
INSERT INTO Pilots(Pilot_name, Experience)
VALUES 
	('Иван', 5),
	('Пётр', 2),
	('Павел', 7),
	('Борис', 1);
SELECT * FROM Pilots;

-- 3.	Добавьте в таблицу пилотов новое поле – phone (номер телефона). 
-- Сделайте это поле обязательным для заполнения. 
-- Добавьте номера телефонов существующим пилотам.
ALTER TABLE Pilots		
ADD COLUMN Phone TEXT DEFAULT 'unknown' NOT NULL;
UPDATE Pilots SET Phone = '123456789' WHERE id = 1;
UPDATE Pilots SET Phone = '789456123' WHERE id = 2;
UPDATE Pilots SET Phone = '321654987' WHERE id = 3;
UPDATE Pilots SET Phone = '987456321' WHERE id = 4;
SELECT * FROM Pilots;

-- 4.	Создайте представление, выбирающее из базы данных код аэропорта 
--(под псевдонимом name), название аэропорта и город. 
--	Сделайте выборку из этого представления.
CREATE VIEW name AS
SELECT airport_code, airport_name, city FROM airports_data;
SELECT * FROM name;

-- 5.	Создайте представление, выбирающее из базы данных все аэропорты в 
-- Новосибирске и Кемерово. Дайте этому представлению название 
-- siberian_airports. Сделайте выборку из этого представления.
CREATE VIEW siberian_airports AS
SELECT * FROM airports_data 
	WHERE airport_code = 'KEJ' OR airport_code = 'OVB';
SELECT * FROM siberian_airports;

-- 6.	Создайте представление, выбирающее все города, в которые можно 
--улететь либо из Москвы, либо из Санкт-Петербурга не используя join. 
--Отсортируйте их в порядке убывания.
CREATE VIEW citys_from_MSK_and_CPB AS
SELECT city FROM airports_data
WHERE airport_code IN 
	(SELECT arrival_airport FROM flights WHERE departure_airport IN ('LED','SVO','VKO','DME'))
	ORDER BY airport_code DESC;
SELECT * FROM citys_from_MSK_and_CPB;

-- 7.	Создайте представление, выбирающее из базы данных количество рейсов, 
--отправляющихся из каждого города. Выведите только город и количество рейсов. 
--Представление назовите fligts_city, а столбец с количеством рейсов 
--count_flights. Сделайте запрос из данного представления, выбирающий только 
--города, начинающиеся на букву «А».
CREATE VIEW fligts_city AS
SELECT DISTINCT departure_airport, COUNT(departure_airport) AS count_flights
	FROM flights
	GROUP BY departure_airport;
SELECT * FROM fligts_city;

-- 8.	Создайте представление, выбирающие имена пассажиров, купивших билет 
--на рейс с отправлением по расписанию от "2017-08-05 11:15:00+05" до 
--"2017-08-05 17:15:00+05" и аэропортом отправления с названием "Домодедово". 
--Выводите имена пассажиров и номера билетов.	
CREATE VIEW pass_names AS
SELECT passenger_name, ticket_no FROM tickets
WHERE book_ref IN (SELECT book_ref FROM bookings 
	WHERE book_date BETWEEN '2017-08-05 11:15:00+05' AND '2017-08-05 17:15:00+05') 
		AND	ticket_no IN (SELECT ticket_no FROM ticket_flights 
		WHERE flight_id IN (SELECT flight_id FROM flights 
		WHERE departure_airport = 'DME')); 
select * FROM pass_names;

--9.	Создайте запрос, выбирающий среднее время полета между Москвой и Казанью. 
-- В ответе должно получится 00:55:00.
SELECT AVG(scheduled_arrival - scheduled_departure) AS Время  
	FROM flights WHERE departure_airport IN ('SVO', 'VKO', 'DME') AND arrival_airport = 'KZN';

--10.	Удалите все созданные в этой работе представления.
DROP VIEW name;
DROP VIEW siberian_airports;
DROP VIEW citys_from_MSK_and_CPB;
DROP VIEW fligts_city;
DROP VIEW pass_names;