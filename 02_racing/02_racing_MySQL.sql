-- =========================================================
-- База данных 2. Автомобильные гонки
-- Файл: 02_racing_MySQL.sql
-- Назначение: полный SQL-скрипт по заданию
--             (создание таблиц, наполнение, решение задач)
-- СУБД: MySQL / MariaDB
-- =========================================================

USE racing_db;

-- =========================================================
-- Удаление таблиц при повторном прогоне
-- =========================================================

DROP TABLE IF EXISTS Results;
DROP TABLE IF EXISTS Races;
DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS Classes;

-- =========================================================
-- Создание таблиц
-- =========================================================

-- Создание таблицы Classes
CREATE TABLE Classes (
    class VARCHAR(100) NOT NULL,
    type ENUM('Racing', 'Street') NOT NULL,
    country VARCHAR(100) NOT NULL,
    numDoors INT NOT NULL,
    engineSize DECIMAL(3, 1) NOT NULL, -- размер двигателя в литрах
    weight INT NOT NULL,                -- вес автомобиля в килограммах
    PRIMARY KEY (class)
);

-- Создание таблицы Cars
CREATE TABLE Cars (
    name VARCHAR(100) NOT NULL,
    class VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (name),
    FOREIGN KEY (class) REFERENCES Classes(class)
);

-- Создание таблицы Races
CREATE TABLE Races (
    name VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (name)
);

-- Создание таблицы Results
CREATE TABLE Results (
    car VARCHAR(100) NOT NULL,
    race VARCHAR(100) NOT NULL,
    position INT NOT NULL,
    PRIMARY KEY (car, race),
    FOREIGN KEY (car) REFERENCES Cars(name),
    FOREIGN KEY (race) REFERENCES Races(name)
);

-- =========================================================
-- Наполнение таблиц данными
-- =========================================================

-- Вставка данных в таблицу Classes
INSERT INTO Classes (class, type, country, numDoors, engineSize, weight) VALUES
('SportsCar', 'Racing', 'USA', 2, 3.5, 1500),
('Sedan', 'Street', 'Germany', 4, 2.0, 1200),
('SUV', 'Street', 'Japan', 4, 2.5, 1800),
('Hatchback', 'Street', 'France', 5, 1.6, 1100),
('Convertible', 'Racing', 'Italy', 2, 3.0, 1300),
('Coupe', 'Street', 'USA', 2, 2.5, 1400),
('Luxury Sedan', 'Street', 'Germany', 4, 3.0, 1600),
('Pickup', 'Street', 'USA', 2, 2.8, 2000);

-- Вставка данных в таблицу Cars
INSERT INTO Cars (name, class, year) VALUES
('Ford Mustang', 'SportsCar', 2020),
('BMW 3 Series', 'Sedan', 2019),
('Toyota RAV4', 'SUV', 2021),
('Renault Clio', 'Hatchback', 2020),
('Ferrari 488', 'Convertible', 2019),
('Chevrolet Camaro', 'Coupe', 2021),
('Mercedes-Benz S-Class', 'Luxury Sedan', 2022),
('Ford F-150', 'Pickup', 2021),
('Audi A4', 'Sedan', 2018),
('Nissan Rogue', 'SUV', 2020);

-- Вставка данных в таблицу Races
INSERT INTO Races (name, date) VALUES
('Indy 500', '2023-05-28'),
('Le Mans', '2023-06-10'),
('Monaco Grand Prix', '2023-05-28'),
('Daytona 500', '2023-02-19'),
('Spa 24 Hours', '2023-07-29'),
('Bathurst 1000', '2023-10-08'),
('Nürburgring 24 Hours', '2023-06-17'),
('Pikes Peak International Hill Climb', '2023-06-25');

-- Вставка данных в таблицу Results
INSERT INTO Results (car, race, position) VALUES
('Ford Mustang', 'Indy 500', 1),
('BMW 3 Series', 'Le Mans', 3),
('Toyota RAV4', 'Monaco Grand Prix', 2),
('Renault Clio', 'Daytona 500', 5),
('Ferrari 488', 'Le Mans', 1),
('Chevrolet Camaro', 'Monaco Grand Prix', 4),
('Mercedes-Benz S-Class', 'Spa 24 Hours', 2),
('Ford F-150', 'Bathurst 1000', 6),
('Audi A4', 'Nürburgring 24 Hours', 8),
('Nissan Rogue', 'Pikes Peak International Hill Climb', 3);

-- =========================================================
-- Задача 1
-- Найти автомобили с лучшей средней позицией в каждом классе
-- =========================================================
SELECT
	t.car_name,
	t.car_class,
	t.average_position,
	t.race_count
FROM
	(
	SELECT
		c.name AS car_name,
		c.class AS car_class,
		AVG(r.position) AS average_position,
		COUNT(*) AS race_count
	FROM
		Cars c
	JOIN Results r ON
		c.name = r.car
	GROUP BY
		c.name,
		c.class
) AS t
JOIN (
	SELECT
		x.car_class,
		MIN(x.avg_pos) AS min_average_position
	FROM
		(
		SELECT
			c.name,
			c.class AS car_class,
			AVG(r.position) AS avg_pos
		FROM
			Cars c
		JOIN Results r ON
			c.name = r.car
		GROUP BY
			c.name,
			c.class
    ) AS x
	GROUP BY
		x.car_class
) AS m
    ON
	t.car_class = m.car_class
	AND t.average_position = m.min_average_position
ORDER BY
	t.average_position, t.car_name;

-- =========================================================
-- Задача 2
-- Найти автомобиль с лучшей средней позицией среди всех
-- =========================================================
SELECT
    t.car_name,
    t.car_class,
    t.average_position,
    t.race_count,
    t.car_country
FROM
(
SELECT
	c.name AS car_name,
	c.class AS car_class,
	AVG(r.position) AS average_position,
	COUNT(*) AS race_count,
	cl.country AS car_country
FROM
	Cars c
JOIN Results r ON
	c.name = r.car
JOIN Classes cl ON
	c.class = cl.class
GROUP BY
	c.name,
	c.class,
	cl.country
) AS t
ORDER BY
t.average_position,
t.car_name
LIMIT 1;

-- =========================================================
-- Задача 3
-- Вывести автомобили из класса с лучшей средней позицией
-- =========================================================
SELECT
	car_stats.car_name,
	car_stats.car_class,
	car_stats.average_position,
	car_stats.race_count,
	car_stats.car_country,
	class_totals.total_races
FROM
	(
	SELECT
		c.name AS car_name,
		c.class AS car_class,
		ROUND(AVG(r.position), 4) AS average_position,
		COUNT(*) AS race_count,
		cl.country AS car_country
	FROM
		Cars c
	JOIN Results r ON
		c.name = r.car
	JOIN Classes cl ON
		c.class = cl.class
	GROUP BY
		c.name,
		c.class,
		cl.country
) AS car_stats
JOIN (
	SELECT
		c.class AS car_class,
		COUNT(*) AS total_races
	FROM
		Cars c
	JOIN Results r ON
		c.name = r.car
	GROUP BY
		c.class
) AS class_totals
    ON
	car_stats.car_class = class_totals.car_class
JOIN (
	SELECT
		class_avg.car_class
	FROM
		(
		SELECT
			c.class AS car_class,
			AVG(r.position) AS avg_class_position
		FROM
			Cars c
		JOIN Results r ON
			c.name = r.car
		GROUP BY
			c.class
    ) AS class_avg
	WHERE
		class_avg.avg_class_position = (
		SELECT
			MIN(min_class.avg_class_position)
		FROM
			(
			SELECT
				c.class AS car_class,
				AVG(r.position) AS avg_class_position
			FROM
				Cars c
			JOIN Results r ON
				c.name = r.car
			GROUP BY
				c.class
        ) AS min_class
    )
) AS best_classes
    ON
	car_stats.car_class = best_classes.car_class
ORDER BY
	car_stats.average_position,
	car_stats.car_name;

-- =========================================================
-- Задача 4
-- Вывести автомобили, чья средняя позиция лучше средней по классу
-- =========================================================
SELECT
	car_stats.car_name,
	car_stats.car_class,
	car_stats.average_position,
	car_stats.race_count,
	car_stats.car_country
FROM
	(
	SELECT
		c.name AS car_name,
		c.class AS car_class,
		ROUND(AVG(r.position), 4) AS average_position,
		COUNT(*) AS race_count,
		cl.country AS car_country
	FROM
		Cars c
	JOIN Results r ON
		c.name = r.car
	JOIN Classes cl ON
		c.class = cl.class
	GROUP BY
		c.name,
		c.class,
		cl.country
) AS car_stats
JOIN (
	SELECT
		class_info.car_class,
		ROUND(AVG(class_info.avg_pos), 4) AS class_average_position,
		COUNT(*) AS car_count
	FROM
		(
		SELECT
			c.name,
			c.class AS car_class,
			AVG(r.position) AS avg_pos
		FROM
			Cars c
		JOIN Results r ON
			c.name = r.car
		GROUP BY
			c.name,
			c.class
    ) AS class_info
	GROUP BY
		class_info.car_class
	HAVING
		COUNT(*) >= 2
) AS class_stats
    ON
	car_stats.car_class = class_stats.car_class
WHERE
	car_stats.average_position < class_stats.class_average_position
ORDER BY
	car_stats.car_class,
	car_stats.average_position;

-- =========================================================
-- Задача 5
-- Вывести автомобили с низкой средней позицией по условиям задания
-- =========================================================
SELECT
    car_stats.car_name,
    car_stats.car_class,
    car_stats.average_position,
    car_stats.race_count,
    car_stats.car_country,
    class_totals.total_races,
    low_class_counts.low_position_count
FROM (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        ROUND(AVG(r.position), 4) AS average_position,
        COUNT(*) AS race_count,
        cl.country AS car_country
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    GROUP BY
        c.name,
        c.class,
        cl.country
    HAVING AVG(r.position) > 3.0
) AS car_stats
JOIN (
    SELECT
        c.class AS car_class,
        COUNT(*) AS total_races
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.class
) AS class_totals
    ON car_stats.car_class = class_totals.car_class
JOIN (
    SELECT
        low_cars.car_class,
        COUNT(*) AS low_position_count
    FROM (
        SELECT
            c.name AS car_name,
            c.class AS car_class,
            AVG(r.position) AS avg_pos
        FROM Cars c
        JOIN Results r ON c.name = r.car
        GROUP BY
            c.name,
            c.class
        HAVING AVG(r.position) > 3.0
    ) AS low_cars
    GROUP BY low_cars.car_class
) AS low_class_counts
    ON car_stats.car_class = low_class_counts.car_class
ORDER BY
    low_class_counts.low_position_count DESC,
    class_totals.total_races DESC,
    car_stats.car_class,
    car_stats.average_position;